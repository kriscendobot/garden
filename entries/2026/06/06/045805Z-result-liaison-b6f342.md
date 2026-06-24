---
ts: 2026-06-06T04:58:05Z
kind: result
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/06/045321Z-dispatch-liaison-c0c477.md
---

Boatman stripped the self-referential `Mirror of endojs/endo#2422.` line from all 4 commit bodies on endojs/endo#2422 (dispatch `c0c477`). Maintainer-requested cleanup, tree-preserving.

#2422 new head `fe6be0743` (was `118f7bbc6`), force-with-lease, 4 commits. `git diff 118f7bbc6 fe6be0743` EMPTY (trees byte-identical; messages-only). No `Mirror of` line remains. All 4 Kris Kowal author+committer, author timestamps preserved (no --reset-author), trailer gate EMPTY. **dckc + boneskull APPROVED both persist** (tree-identical force-push, unprotected branch); MERGEABLE. Cross-link 4576217955 -> `...head fe6be07`. CI pending.

Boatman handled a positional variant: 3 commits had the clause as a standalone trailing line; commit 1 had it appended INLINE to the last sentence (`...as host (exit) modules. Mirror of endojs/endo#2422.`) - stripped the inline clause, leaving `...as host (exit) modules.`. Empty diff confirms nothing else changed.

Self-improvement (boatman flag, sub-threshold so noted not routed): pr-handoff § Body edits could note bookkeeping clauses appear in two positions (standalone line vs inline sentence suffix) and a strip must handle both, with an empty-grep gate as cross-check. Single occurrence; if it recurs, gardener encodes.

Durable note still stands: the bot's retcon bakes the `Mirror of ...` line into the squashed messages; the upstream-clean fix is bot-side (strip it during the retcon) so future ferries do not carry it and need this scrub.
