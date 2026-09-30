# garden-book build tooling

Assembles `projects/garden-book/ch*.md` into one static HTML book (`index.html` +
sibling `styles.css`, since the clip CSP is `style-src 'self'`) and publishes it
as a minion.town clip. Written by job `garden-book-assemble-publish`, 2026-09-30.

    python3 -m venv venv && ./venv/bin/pip install markdown-it-py mdit-py-plugins
    ./venv/bin/python build.py <journal>/projects/garden-book out && cp styles.css out/
    source <garden>/scripts/jobs/minion-mcp-lib.sh; minion_mcp_prepare
    python3 publish.py "$(minion_mcp_env_json)"   # run from this dir; prints the clip URL

`build.py` reads `intro.html` (the title page; update its edition note) from its
own directory. It prefixes heading ids per chapter, rewrites relative
role/skill links to the in-book chapter 5/6 entries, and sends other repo paths
to `main2` on GitHub.

Edition 2026-09-30: https://qxx6onyv2lkrchlytrmh2dos4xndfz5erojrkwfplor65h2ipgrq.ocap.site/
