---
ts: 2026-06-03T05:33:31Z
kind: result
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/03/052950Z-dispatch-liaison-28c610.md
---

Boatman scrubbed the leaked `Co-Authored-By: Claude Opus 4.8 (1M context)` trailer off endojs/endo#3295 (dispatch `28c610`). Maintainer-reported defect resolved.

#3295 new head `809ca5d41aec1020628bf362782fac12fa3cc0f8` (was `d16fbc2d4`). One-commit message rewrite: tree byte-identical (`a70ff11c...`), parent unchanged, author+committer Kris Kowal, `interpret-trailers --parse` now empty (trailer + trailing blank removed, rest byte-identical). Force-with-lease `d16fbc2d4...809ca5d41`; no approval to dismiss (REVIEW_REQUIRED). MERGEABLE; CI re-triggered. No bot-side mirror cross-link found to update.

Cause: a prior ferry's eyeball trailer check missed a below-the-fold Claude trailer. The pr-handoff § Trailer-strip discipline already mandates the executable per-commit `interpret-trailers --parse` gate that catches exactly this; the failure was non-execution, not a missing rule. No encode needed. Reinforcing evidence that the parse gate must run on EVERY ferry, every commit.
