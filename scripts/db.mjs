#!/usr/bin/env node
// SQL and migrations for the hosted Supabase project over the Management API (HTTPS), so nothing needs the SQL
// editor, a database password or CI. Authentication comes from the environment: in the Claude Code cloud session the
// proxy adds the api.supabase.com credential; elsewhere set SUPABASE_ACCESS_TOKEN (a personal access token).
//
//   node scripts/db.mjs sql "select count(*) from beta_signups"   run one query, print the rows as JSON
//   node scripts/db.mjs status                                     local migration files vs the project's history
//   node scripts/db.mjs migrate [--dry-run]                        apply pending files in order, recording each in history
//   node scripts/db.mjs print <file>                               show the SQL `migrate` would send for one file
//
// Each migration runs in one transaction together with its supabase_migrations.schema_migrations row, so the history
// and the schema never disagree. File names are <version>_<name>.sql, the same convention as `supabase db push`.
import { readdirSync, readFileSync } from 'node:fs';
import { basename, join } from 'node:path';

const REF = process.env.SUPABASE_PROJECT_REF || 'qlzlnsjkacjqagvxlbvq';
const API = `https://api.supabase.com/v1/projects/${REF}/database/query`;
const DIR = new URL('../supabase/migrations/', import.meta.url).pathname;

async function sql(query) {
  const headers = { 'Content-Type': 'application/json' };
  if (process.env.SUPABASE_ACCESS_TOKEN) headers.Authorization = 'Bearer ' + process.env.SUPABASE_ACCESS_TOKEN;
  const res = await fetch(API, { method: 'POST', headers, body: JSON.stringify({ query }) });
  const text = await res.text();
  if (!res.ok) {
    const hint = res.status === 401 ? ' (the api.supabase.com credential is missing or invalid: see CLAUDE.md → Database)' : '';
    throw new Error(`HTTP ${res.status}${hint}: ${text.slice(0, 500)}`);
  }
  return text ? JSON.parse(text) : [];
}

const files = () => readdirSync(DIR).filter((f) => /^\d+_.+\.sql$/.test(f)).sort();
const versionOf = (f) => f.split('_')[0];
const nameOf = (f) => basename(f, '.sql').slice(versionOf(f).length + 1);

/** Dollar-quote with a tag that does not occur in the text. */
function dollar(text) {
  let tag = 'mig';
  while (text.includes('$' + tag + '$')) tag += 'x';
  return `$${tag}$${text}$${tag}$`;
}

function migrationSql(file) {
  const body = readFileSync(join(DIR, file), 'utf8');
  return `begin;\n${body}\n;\ninsert into supabase_migrations.schema_migrations (version, name, statements)\nvalues ('${versionOf(file)}', ${dollar(nameOf(file))}, array[${dollar(body)}]);\ncommit;`;
}

async function applied() {
  const rows = await sql('select version from supabase_migrations.schema_migrations');
  return new Set(rows.map((r) => r.version));
}

const [cmd, ...args] = process.argv.slice(2);
try {
  if (cmd === 'sql') {
    if (!args[0]) throw new Error('usage: node scripts/db.mjs sql "<query>"');
    console.log(JSON.stringify(await sql(args.join(' ')), null, 2));
  } else if (cmd === 'status') {
    const done = await applied();
    for (const f of files()) console.log((done.has(versionOf(f)) ? 'applied  ' : 'PENDING  ') + f);
    const local = new Set(files().map(versionOf));
    for (const v of [...done].sort()) if (!local.has(v)) console.log('REMOTE ONLY  ' + v + ' (in history, no local file)');
  } else if (cmd === 'migrate') {
    const dry = args.includes('--dry-run');
    const done = await applied();
    const pending = files().filter((f) => !done.has(versionOf(f)));
    if (!pending.length) console.log('Up to date: every file in supabase/migrations is in the history.');
    for (const f of pending) {
      if (dry) { console.log('would apply ' + f); continue; }
      process.stdout.write('applying ' + f + ' … ');
      await sql(migrationSql(f));
      console.log('done');
    }
  } else if (cmd === 'print') {
    if (!args[0]) throw new Error('usage: node scripts/db.mjs print <file>');
    console.log(migrationSql(basename(args[0])));
  } else {
    console.log(readFileSync(new URL(import.meta.url), 'utf8').split('\n').slice(1, 12).map((l) => l.replace(/^\/\/ ?/, '')).join('\n'));
    process.exitCode = cmd ? 1 : 0;
  }
} catch (e) {
  console.error(String(e.message || e));
  process.exitCode = 1;
}
