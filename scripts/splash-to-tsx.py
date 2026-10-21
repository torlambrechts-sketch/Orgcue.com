#!/usr/bin/env python3
"""Turn the splash design files (design/splash-handoff/.../Splash/*.dc.html) into React server components.

Inline styles are kept as written; style-hover / style-active become generated classes in
src/components/splash/splash-hover.css. Run again after the design changes:

    python3 -I scripts/splash-to-tsx.py
"""
import hashlib
import json
import re
from html.parser import HTMLParser
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / 'design/splash-handoff/ai-instructions-application-layouts/project/Splash'
OUT = ROOT / 'src/components/splash/pages'
CSS_OUT = ROOT / 'src/components/splash/splash-hover.css'
PAGES = ['Home', 'Plan', 'Collect', 'Decide', 'Deliver', 'Platform']
ROUTES = {'Home.dc.html': '/', 'Plan.dc.html': '/plan', 'Collect.dc.html': '/collect', 'Decide.dc.html': '/decide', 'Deliver.dc.html': '/deliver', 'Platform.dc.html': '/platform'}
APP_DEMO = '../App/Requirements Interviews.dc.html'   # the prototype app: replaced by the beta list
APP_MAP = '../App/LLM Instruction Map.dc.html'        # not part of the site: link dropped
VOID = {'img', 'br', 'input', 'meta', 'hr', 'link'}
FONTS = [("'Instrument Serif',serif", 'var(--font-instrument),serif'), ("'Figtree',system-ui,sans-serif", 'var(--font-figtree),system-ui,sans-serif')]
# Copy changes: the site invites people to the beta instead of opening a demo.
TEXT = {
    'Open the CRM example': 'Become a beta user',
    'Prototype · demo data · no sign-up': 'Private beta · join the list, no account needed',
}

# The last page's band invited people to open the demo; it now points at the beta like the others.
FOOTER = {
    'Open the Northwind CRM example.': ('PRIVATE BETA', 'Run it on your own project.', 'Join the private beta and we’ll invite you as places open, starting with teams that have a first AI project in mind.'),
}

# Responsive classes the inline styles can't express (see splash.css): on phones the hero's floating cards would sit
# off-screen and the app mockup would be squeezed to half the width.
RESPONSIVE = [('calc(50% + min(320px,27%)', 'sp-hide-sm'), ('width:min(640px,54%)', 'sp-mock')]

hover_rules: dict[str, str] = {}


def decls(css: str) -> list[tuple[str, str]]:
    out, depth, cur = [], 0, ''
    for ch in css:
        depth += ch == '('
        depth -= ch == ')'
        if ch == ';' and depth == 0:
            out.append(cur); cur = ''
        else:
            cur += ch
    out.append(cur)
    res = []
    for d in out:
        if ':' not in d:
            continue
        k, v = d.split(':', 1)
        k, v = k.strip(), v.strip()
        for a, b in FONTS:
            v = v.replace(a, b)
        res.append((k, v))
    return res


def camel(prop: str) -> str:
    if prop.startswith('-'):
        prop = prop[1:]
        parts = prop.split('-')
        return parts[0].capitalize() + ''.join(p.capitalize() for p in parts[1:])
    parts = prop.split('-')
    return parts[0] + ''.join(p.capitalize() for p in parts[1:])


def style_obj(css: str, outer: bool) -> str:
    items = []
    for k, v in decls(css):
        if outer and k == 'overflow' and v == 'hidden':
            v = 'clip'  # keeps the sticky header working; clips the background glows the same way
        items.append(f'{camel(k)}: {json.dumps(v, ensure_ascii=False)}')
    return '{{ ' + ', '.join(items) + ' }}'


def state_class(kind: str, css: str) -> str:
    body = ';'.join(f'{k}:{v} !important' for k, v in decls(css))
    name = ('sh-' if kind == 'hover' else 'sa-') + hashlib.sha1(body.encode()).hexdigest()[:6]
    sel = f'.{name}:hover,.{name}:focus-visible' if kind == 'hover' else f'.{name}:active'
    hover_rules[name] = f'{sel}{{{body}}}'
    return name


def text_jsx(t: str, pre: bool) -> str:
    if pre:
        return '{' + json.dumps(t, ensure_ascii=False) + '}'
    if not t.strip():
        return '{" "}' if t else ''
    t = re.sub(r'\s+', ' ', t)
    t = TEXT.get(t.strip(), t) if t.strip() in TEXT else t
    if re.search(r'[{}<>&"\']', t) or t != t.strip():
        return '{' + json.dumps(t, ensure_ascii=False) + '}'
    return t


class Conv(HTMLParser):
    def __init__(self, page: str):
        super().__init__(convert_charrefs=True)
        self.page = page
        self.out: list[str] = []
        self.depth_in_xdc = False
        self.skip = 0          # inside <helmet>, <script>, a dropped element
        self.pre = 0
        self.stack: list[str] = []
        self.first_div = True
        self.imports: list[dict] = []

    def handle_starttag(self, tag, attrs):
        a = dict(attrs)
        if tag == 'x-dc':
            self.depth_in_xdc = True; return
        if not self.depth_in_xdc:
            return
        if self.skip:
            if tag not in VOID:
                self.skip += 1
            return
        if tag in ('helmet', 'script', 'style'):
            self.skip = 1; return
        if tag == 'a' and a.get('href') == APP_MAP:
            self.skip = 1; return
        if tag == 'dc-import':
            self.imports.append(a)
            if a['name'] == 'SplashNav':
                dark = ' dark' if a.get('dark') else ''
                self.out.append(f'<SplashNav active="{a["active"]}"{dark} />')
            else:
                if a['title'] in FOOTER:
                    a['eyebrow'], a['title'], a['sub'] = FOOTER[a['title']]
                props = ' '.join(f'{k}={json.dumps(a[src], ensure_ascii=False)}' for k, src in [('eyebrow', 'eyebrow'), ('title', 'title'), ('sub', 'sub'), ('nextL', 'next-l')]) + f' nextHref="{ROUTES[a["next-href"]]}" source="{self.page}"'
                self.out.append(f'<SplashFooter {props} />')
            self.stack.append('dc-import')
            return
        jsx_tag = tag
        parts = []
        classes = []
        for k, v in attrs:
            if k.startswith('hint-'):
                continue
            if k == 'style':
                classes.extend(c for frag, c in RESPONSIVE if frag in v)
                parts.append(f'style={style_obj(v, self.first_div and tag == "div")}')
            elif k == 'style-hover':
                classes.append(state_class('hover', v))
            elif k == 'style-active':
                classes.append(state_class('active', v))
            elif k == 'class':
                classes.extend(v.split())
            elif k == 'href':
                if v == APP_DEMO:
                    v = '#beta'
                elif v in ROUTES:
                    v = ROUTES[v]
                    jsx_tag = 'Link'
                parts.append(f'href={json.dumps(v)}')
            elif k == 'src':
                parts.append(f'src={json.dumps(v.replace("../assets/", "/"))}')
            elif k in ('width', 'height'):
                parts.append(f'{k}={{{v}}}')
            else:
                parts.append(f'{k}={json.dumps(v if v is not None else True)}')
        if tag == 'div' and self.first_div:
            self.first_div = False
        if classes:
            parts.insert(0, f'className="{" ".join(classes)}"')
        if tag == 'pre':
            self.pre += 1
        attr = (' ' + ' '.join(parts)) if parts else ''
        if tag in VOID:
            self.out.append(f'<{jsx_tag}{attr} />')
        else:
            self.out.append(f'<{jsx_tag}{attr}>')
            self.stack.append(jsx_tag)

    def handle_startendtag(self, tag, attrs):
        self.handle_starttag(tag, attrs)
        if tag not in VOID and tag != 'dc-import' and self.depth_in_xdc and not self.skip:
            self.handle_endtag(tag)

    def handle_endtag(self, tag):
        if tag == 'x-dc':
            self.depth_in_xdc = False; return
        if not self.depth_in_xdc or tag in VOID:
            return
        if self.skip:
            self.skip -= 1; return
        t = self.stack.pop()
        if t == 'dc-import':
            return
        if tag == 'pre':
            self.pre -= 1
        self.out.append(f'</{t}>')

    def handle_data(self, data):
        if not self.depth_in_xdc or self.skip or not self.stack and not data.strip():
            return
        if self.stack and self.stack[-1] == 'dc-import':
            return
        self.out.append(text_jsx(data, self.pre > 0))


def convert(name: str) -> str:
    c = Conv(name.lower())
    c.feed((SRC / f'{name}.dc.html').read_text())
    jsx = ''.join(c.out)
    jsx = re.sub(r'(\{" "\})+', '{" "}', jsx)
    uses_link = '<Link ' in jsx
    head = [f'// Generated from design/splash-handoff/.../Splash/{name}.dc.html by scripts/splash-to-tsx.py. Do not edit by hand.']
    if '<img ' in jsx:
        head.append('/* eslint-disable @next/next/no-img-element */')
    if uses_link:
        head.append("import Link from 'next/link';")
    head.append("import { SplashFooter, SplashNav } from '@/components/splash/SplashChrome';")
    return '\n'.join(head) + f'\n\nexport default function {name}Page() {{\n  return (\n    {jsx}\n  );\n}}\n'


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    for p in PAGES:
        (OUT / f'{p}.tsx').write_text(convert(p))
    CSS_OUT.write_text('/* Generated by scripts/splash-to-tsx.py: hover, focus and press states from the splash design. */\n' + '\n'.join(sorted(hover_rules.values())) + '\n')
    print('wrote', len(PAGES), 'pages,', len(hover_rules), 'state classes')


if __name__ == '__main__':
    main()
