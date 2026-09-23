---
title: §Four-row Affected packages list
source-slug: endo-but-for-bots--llm-designs-daemon-weblet-application
section-slug: canonical-template-instantiation-and-five-deliverables-at-top-and-eight-security-considerations-and-two-gateway-isolation-modes-and-additive-template-extension
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-weblet-application.md
source-repo: endojs/endo-but-for-bots
source-path: designs/daemon-weblet-application.md
source-author: Kris Kowal (prompted)
total-lines: 985
ingest-cycle: 275
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
parent: endo-but-for-bots--llm-designs-daemon-weblet-application--canonical-template-instantiation-and-five-deliverables-at-top-and-eight-security-considerations-and-two-gateway-isolation-modes-and-additive-template-extension
---

Lines 814-826 carry §four-affected-packages list:

1. `packages/daemon` — new formula types + zip extraction.
2. `packages/daemon/src/web-server-node.js` — gateway static file serving.
3. `packages/cli` — `mkweblet` + `open` commands.
4. `packages/chat` — `/mkweblet` + `/open` commands + weblet pane.
5. `packages/zip` — dependency (needs `kriskowal-zip-compression` merge).

§First-explicit-observation in library: **§explicit-Affected-packages-section-listing-which-packages-must-change — §the-design-NAMES-the-implementation-blast-radius + §the-reader-can-estimate-effort-by-counting-packages + §sibling-pattern to many engineering-doc conventions**.
