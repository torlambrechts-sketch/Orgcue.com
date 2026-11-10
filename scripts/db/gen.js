// Generates the database from the app's own table declarations.
// usage: node gen.js <page.html> <outdir>
//   writes <outdir>/02_data_tables.sql   tables, keys, indexes, data dictionary
//          <outdir>/03_demo_seed.sql      demo company (workspace scope) and product content (product scope)
//          <outdir>/tables.json, rows.json, erd.md
const { chromium } = require('playwright'); const fs = require('fs'); const path = require('path');
const [page, outdir] = process.argv.slice(2);
const DEMO = '00000000-0000-4000-8000-000000000001', PRODUCT = '00000000-0000-4000-8000-000000000002';
const TYPE = { text: 'text', int: 'integer', num: 'numeric', bool: 'boolean', date: 'date', jsonb: 'jsonb' };
const q = s => '"' + String(s).replace(/"/g, '""') + '"';
const lit = s => s == null ? 'null' : "'" + String(s).replace(/'/g, "''") + "'";
(async () => {
  const b = await chromium.launch(); const p = await b.newPage(); const errs = []; p.on('pageerror', e => errs.push(e.message));
  await p.goto('file://' + path.resolve(page)); await p.evaluate(() => localStorage.clear()); await p.reload(); await p.waitForTimeout(800);
  const { tables, rows, check, err } = await p.evaluate(() => ({ tables: window.__db.tables(), rows: window.__db.dump(), check: window.__db.check(), err: window.__db.err() }));
  await b.close();
  if (errs.length || err || check.length) { console.log('page errors: ' + errs.join(' | ') + '\nload errors: ' + (err || '') + '\nschema problems: ' + check.slice(0, 20).join('; ')); if (check.length) process.exit(1) }
  fs.mkdirSync(outdir, { recursive: true });
  const names = Object.keys(tables); const order = names.slice().sort((a, b) => (tables[a].domain + a).localeCompare(tables[b].domain + b));
  // ---------- tables ----------
  let sql = '-- Data tables, generated from the table declarations in the page (node gen.js). Do not edit by hand.\n\n';
  const fks = [], idx = [], meta = [];
  order.forEach((n, i) => {
    const t = tables[n], scope = t.opts.scope === 'product' ? 'product' : 'workspace';
    const cols = t.cols.map(c => {
      const ref = c[2] ? String(c[2]).replace(/!$/, '') : null, enforced = !!(c[2] && /!$/.test(c[2]));
      if (!TYPE[c[1]]) throw new Error(n + '.' + c[0] + ': unknown type ' + c[1]);
      if (ref && !tables[ref]) throw new Error(n + '.' + c[0] + ': references unknown table ' + ref);
      if (ref) { if (enforced) fks.push(`alter table public.${q(n)} add constraint ${q(n + '_' + c[0] + '_fkey')} foreign key (workspace_id, ${q(c[0])}) references public.${q(ref)} (workspace_id, id) on delete cascade deferrable initially deferred;`);
        idx.push(`create index ${q(n + '_' + c[0] + '_idx')} on public.${q(n)} (workspace_id, ${q(c[0])});`) }
      return { name: c[0], type: c[1], ref, enforced };
    });
    sql += `create table public.${q(n)} (\n  workspace_id uuid not null references public.workspaces (id) on delete cascade,\n  id text not null,\n  sort integer,\n` +
      cols.map(c => `  ${q(c.name)} ${TYPE[c.type]},\n`).join('') + `  extra jsonb,\n  updated_at timestamptz not null default now(),\n  primary key (workspace_id, id)\n);\n`;
    sql += `comment on table public.${q(n)} is ${lit((t.opts.title || n) + (t.opts.desc ? ': ' + t.opts.desc : ''))};\n`;
    sql += `alter table public.${q(n)} enable row level security;\nrevoke all on public.${q(n)} from anon, authenticated;\n\n`;
    meta.push(`(${lit(n)}, ${lit(t.domain)}, ${lit(scope)}, ${lit(t.opts.title || null)}, ${lit(t.opts.desc || null)}, ${lit(JSON.stringify(cols))}::jsonb, ${i})`);
  });
  sql += '-- parent-child links: enforced, cascading, checked at commit\n' + fks.join('\n') + '\n\n-- every reference is indexed\n' + idx.join('\n') + '\n\n';
  sql += '-- data dictionary used by the access functions\ndelete from public.orgcue_tables;\ninsert into public.orgcue_tables (name, domain, scope, title, description, columns, sort) values\n  ' + meta.join(',\n  ') + ';\n';
  fs.writeFileSync(path.join(outdir, '02_data_tables.sql'), sql);
  // ---------- demo and product rows ----------
  let seed = '-- Demo company and product content, generated from the demo data (node gen.js). Do not edit by hand.\nset constraints all deferred;\n';
  order.forEach(n => {
    const r = rows[n] || []; if (!r.length) return; const scope = tables[n].opts.scope === 'product' ? PRODUCT : DEMO;
    const cols = ['id', 'sort'].concat(tables[n].cols.map(c => c[0])).concat(['extra']).map(q).join(', ');
    const tag = '$r' + Math.random().toString(36).slice(2, 8) + '$';
    seed += `delete from public.${q(n)} where workspace_id = '${scope}';\ninsert into public.${q(n)} (workspace_id, ${cols})\nselect '${scope}', ${cols} from jsonb_populate_recordset(null::public.${q(n)}, ${tag}${JSON.stringify(r)}${tag}::jsonb);\n`;
  });
  fs.writeFileSync(path.join(outdir, '03_demo_seed.sql'), seed);
  fs.writeFileSync(path.join(outdir, 'tables.json'), JSON.stringify(tables, null, 1)); fs.writeFileSync(path.join(outdir, 'rows.json'), JSON.stringify(rows));
  // ---------- entity relationship summary ----------
  let erd = '';
  const byDomain = {}; order.forEach(n => (byDomain[tables[n].domain] = byDomain[tables[n].domain] || []).push(n));
  for (const d in byDomain) {
    erd += `\n### ${d[0].toUpperCase() + d.slice(1)}\n\n\`\`\`mermaid\nerDiagram\n`;
    byDomain[d].forEach(n => { erd += `  ${n} {\n    text id PK\n` + tables[n].cols.map(c => `    ${c[1]} ${c[0]}${c[2] ? ' FK' : ''}`).join('\n') + '\n  }\n' });
    byDomain[d].forEach(n => tables[n].cols.forEach(c => { if (c[2]) { const ref = c[2].replace(/!$/, ''); erd += `  ${ref} ${/!$/.test(c[2]) ? '||--o{' : '|o..o{'} ${n} : "${c[0]}"\n` } }));
    erd += '```\n';
  }
  fs.writeFileSync(path.join(outdir, 'erd.md'), erd);
  const total = Object.values(rows).reduce((s, r) => s + r.length, 0);
  console.log(`tables ${names.length} (${names.filter(n => tables[n].opts.scope === 'product').length} product), enforced keys ${fks.length}, indexed references ${idx.length}, rows ${total}`);
})();
