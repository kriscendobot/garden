---
ts: 2026-07-07T22:46:24Z
kind: result
role: designer
project: endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/631
refs:
  - jobs (board): design-endo-thesis-translation
---

Designed the modernized edition of Mark S. Miller's 2006 dissertation *Robust
Composition* for publication under docs/thesis/ at docs.endojs.org/thesis/.
Landed `designs/thesis-translation.md` plus the designs/README.md plan sync
(summary row, M10 parallel-track bucket, per-design estimate; no totals change,
off critical path) on branch `design/thesis-translation`; draft PR #631 against
`llm`. Key design content: chapter-by-chapter treatment inventory extracted
from the actual PDF TOC (27 chapters, 5 parts; PDF verified via the
papers.agoric.com mirror since erights.org is down); normative E-to-Jessie
mapping (E() from @endo/far, E.when for when-catch, makers/facets as hardened
closures and exos, @endo/patterns for guards, makePromiseKit, Compartment for
the loader; no-clean-equivalent rule keeps original E with a translator's
note); Pluribus/CapTP-to-OCapN mapping grounded in packages/ocapn, with
chapter 19 (E-ORDER) explicitly labeled normative ancestry rather than a
current OCapN guarantee; TypeDoc-native routing (projectDocuments child tree,
category Annex, /thesis/ redirect via posttypedoc.sh); fidelity contract
(verbatim prose, flagged code substitutions, originals in collapsed blocks);
and a hard publication gate: the thesis title-page grant covers verbatim
copies and cited excerpts only, so every phase stays draft until erights
records permission (asked directly on the PR; he is maintainer-authority on
this fork). Five phased builder PRs planned, phase 1 builder-ready, base
master. Library writeback: new concept page robust-composition-thesis plus
keyword shortcuts. A peer (translate-distributed-confinement-to-docs) asked
for these conventions mid-job; the reply was dead-lettered (their job had
completed) and will be promoted by garden-deadmail.

Self-improvement: nothing this time.
