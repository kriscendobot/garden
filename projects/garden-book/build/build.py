#!/usr/bin/env python3
"""Assemble journal/projects/garden-book/*.md into one static HTML book."""
import glob, html, os, posixpath, re, sys
from markdown_it import MarkdownIt
from mdit_py_plugins.anchors import anchors_plugin

SRC = sys.argv[1]
OUT = sys.argv[2]
GH = "https://github.com/kriscendobot/garden/blob/main2/"
BOOK_DIR = "journal/projects/garden-book"  # the chapters' own location


def gh_slug(s):
    s = s.strip().lower()
    s = re.sub(r"[^\w\- ]", "", s)
    return s.replace(" ", "-")


def split_front(text):
    meta = {}
    if text.startswith("---\n"):
        end = text.index("\n---\n", 4)
        for line in text[4:end].splitlines():
            if ":" in line:
                k, v = line.split(":", 1)
                meta[k.strip()] = v.strip()
        text = text[end + 5:]
    return meta, text


def chapter_key(path):
    m = re.match(r"ch(\d+)-(.*?)(?:-part(\d+))?\.md$", os.path.basename(path))
    return (int(m.group(1)), int(m.group(3) or 1))


files = sorted(glob.glob(os.path.join(SRC, "ch*.md")), key=chapter_key)
chapters = []
for f in files:
    meta, body = split_front(open(f, encoding="utf-8").read())
    n, part = chapter_key(f)
    chapters.append(dict(file=os.path.basename(f), n=n, part=part, meta=meta, body=body,
                         prefix=f"ch{n}" + (f"p{part}" if part > 1 else "")))

# In-book targets for role and skill references (chapter 5 and 6 headings).
role_anchor, skill_anchor = {}, {}
for c in chapters:
    for line in c["body"].splitlines():
        m = re.match(r"^(#{2,4}) (.*`([a-z0-9-]+)`.*)$", line)
        if not m:
            continue
        slug = c["prefix"] + "-" + gh_slug(m.group(2))
        if c["n"] == 5:
            role_anchor.setdefault(m.group(3), slug)
        elif c["n"] == 6:
            skill_anchor.setdefault(m.group(3), slug)


def resolve_href(href, prefix):
    if href.startswith("#"):
        return f"#{prefix}-{href[1:]}"
    if re.match(r"^[a-z]+:", href):
        return href
    path, _, frag = href.partition("#")
    # Relative links were written from the chapter's journal location, but every
    # one of them names a main2 path (../../roles, ../../skills, ...) or a
    # sibling role/skill (../shepherd/AGENT.md), so resolve against the repo root.
    if path.startswith("../../"):
        rel = path[6:]
    elif path.startswith("../"):
        rel = ("roles/" if path.endswith("AGENT.md") else "skills/") + path[3:]
    else:
        rel = path
    rel = posixpath.normpath(rel)
    m = re.match(r"^roles/([a-z0-9-]+)/AGENT\.md$", rel)
    if m and m.group(1) in role_anchor and not frag:
        return "#" + role_anchor[m.group(1)]
    m = re.match(r"^skills/([a-z0-9-]+)/SKILL\.md$", rel)
    if m and m.group(1) in skill_anchor and not frag:
        return "#" + skill_anchor[m.group(1)]
    return GH + rel + (("#" + frag) if frag else "")


toc = []
sections = []
for c in chapters:
    md = MarkdownIt("commonmark", {"html": False, "typographer": False}).enable(["table", "strikethrough"])
    md.use(anchors_plugin, min_level=1, max_level=4, slug_func=lambda s, p=c["prefix"]: f"{p}-{gh_slug(s)}")
    env = {}
    tokens = md.parse(c["body"], env)
    heads = []
    for i, t in enumerate(tokens):
        if t.type == "heading_open" and t.tag in ("h1", "h2"):
            heads.append((t.tag, t.attrs.get("id"), tokens[i + 1].content))
        if t.type == "inline":
            for ch in t.children or []:
                if ch.type == "link_open":
                    ch.attrs["href"] = resolve_href(ch.attrs["href"], c["prefix"])
                    if ch.attrs["href"].startswith("http"):
                        ch.attrs["rel"] = "noopener"
    body_html = md.renderer.render(tokens, md.options, env)
    # Demote chapter headings one level so the book title owns <h1>.
    body_html = re.sub(r"<(/?)h([1-5])", lambda m: f"<{m.group(1)}h{int(m.group(2)) + 1}", body_html)
    title = next((h[2] for h in heads if h[0] == "h1"), c["file"])
    title = re.sub(r"`", "", title)
    cid = next((h[1] for h in heads if h[0] == "h1"), c["prefix"])
    subs = [(h[1], re.sub(r"`", "", h[2])) for h in heads if h[0] == "h2" and h[2] != "Contents"]
    toc.append((cid, title, subs))
    prov = []
    if c["meta"].get("author"):
        prov.append("Written by " + c["meta"]["author"])
    if c["meta"].get("grounded-on"):
        prov.append("grounded on " + c["meta"]["grounded-on"])
    prov_html = (f'<p class="provenance">{html.escape("; ".join(prov))}. Source: '
                 f'<code>{BOOK_DIR}/{c["file"]}</code> on <code>journal2</code>.</p>')
    body_html = body_html.replace("</h2>", "</h2>\n" + prov_html, 1)
    sections.append(f'<section class="chapter" aria-labelledby="{cid}">\n{body_html}\n'
                    f'<p class="back"><a href="#toc">&uarr; Table of contents</a></p>\n</section>')

nav = ['<nav class="sidebar" aria-label="Table of contents"><p class="nav-title"><a href="#top">The Garden</a></p><ol>']
toc_main = ['<ol class="toc">']
for cid, title, subs in toc:
    nav.append(f'<li><a href="#{cid}">{html.escape(title)}</a></li>')
    toc_main.append(f'<li><a href="#{cid}">{html.escape(title)}</a><ol>')
    for sid, st in subs:
        toc_main.append(f'<li><a href="#{sid}">{html.escape(st)}</a></li>')
    toc_main.append("</ol></li>")
nav.append("</ol></nav>")
toc_main.append("</ol>")

included = ", ".join(c["file"] for c in chapters)
intro = open(os.path.join(os.path.dirname(__file__), "intro.html"), encoding="utf-8").read()
intro = intro.replace("{{INCLUDED}}", html.escape(included))

page = f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>The Garden: a book about an agent fleet</title>
<link rel="stylesheet" href="styles.css">
</head>
<body>
{''.join(nav)}
<main>
<header id="top" class="titlepage">
{intro}
</header>
<section id="toc" class="contents"><h2>Contents</h2>
{''.join(toc_main)}
</section>
{''.join(sections)}
<footer><p>Assembled 2026-09-30 by the garden job <code>garden-book-assemble-publish</code> from the chapters under <code>{BOOK_DIR}/</code>.</p></footer>
</main>
</body>
</html>
"""
os.makedirs(OUT, exist_ok=True)
open(os.path.join(OUT, "index.html"), "w", encoding="utf-8").write(page)
print(f"{len(chapters)} files, {len(page)} bytes; roles={len(role_anchor)} skills={len(skill_anchor)}")
