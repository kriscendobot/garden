---
order: serial
children: endojs-endo-but-for-bots-pr701-restack-pr737-line endojs-endo-but-for-bots-pr702-restack-pr737-line endojs-endo-but-for-bots-pr703-restack-pr737-line endojs-endo-but-for-bots-pr704-restack-pr737-line
on-child-failure: halt
state: running
created_by: endo-sturdyref-press-20260722-160501
created_at: 2026-07-22T16:10:18Z
---

# Orchestration: cascade-restack SturdyRef bridge cuts 3–6 (#701→#704) onto the arbitrated #737 line

Completes the 2026-07-22 arbitrated restack (kriskowal on #737): the #541/#698/#700
restack landed ~14:35Z, leaving bridge cuts 3–6 stale on the pre-restack line.
Serial, halt on child failure: each cut rebases onto its moved predecessor
(#701 onto restacked #700 head, then #702, #703, #704 in turn), reconciling toward
the arbitrated shapes (`@endo/sturdyref` shim home, `getSturdyRefLocator`,
camelCase `sturdyRef`, marshal prefix `l`) and keeping the confinement suites green.
Target stack: llm ← #774 ← #737 ← #541 ← #698 ← #700 ← #701 ← #702 ← #703 ← #704.
