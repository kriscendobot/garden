---
ts: 2026-06-06T15:26:01Z
kind: dispatch
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/06/051150Z-dispatch-liaison-a1ec64.md
---

Dispatched boatman (dispatch-root `dispatches/boatman--545616`) for a **Shape-3 fast-forward append** of bots#75's 2 new tip commits onto endojs/endo#3232. No force-push.

State: bots#75 was rebuilt (12 commits, re-timestamped, new SHAs, base 4a04d078b) but its commit-10 tree is BYTE-IDENTICAL to #3232's head tree (`a870465cd`) - so despite the rebuild, the only new content is the 2 tip commits. #3232 head `46e330a2b`, 10 commits, MERGEABLE, REVIEW_REQUIRED (no approval). Append:
- `11824965c style(random,chacha12): apply unicorn/numeric-separators-style autofix` (6 files: chacha12 + random source/tests)
- `1da07c358 fix(random,chacha12): sync SECURITY.md to packages/skel canonical` (2 SECURITY.md files)
Both trailer-clean. Since bots#75~2 tree == #3232 head tree, the cherry-picks apply cleanly (true fast-forward).

Boatman brief (pr-handoff § Shape 3): fetch #3232 head `46e330a2b` (branch `kriskowal-random-chacha20`) and bots#75 tip via `refs/pull/75/head` (verify FETCH_HEAD == `1da07c358`); detach at `46e330a2b` (NOT master); cherry-pick `11824965c` then `1da07c358`; rewrite both to author+committer `Kris Kowal <kriskowal@kriskowal.com>`; RUN `interpret-trailers --parse` EMPTY; strip any `(#75)` suffix; pre-flight `merge-base --is-ancestor origin/kriskowal-random-chacha20 HEAD`; push WITHOUT force (remote must read `46e330a2b..<new>`, no `+`); confirm MERGEABLE; find-or-create the garden-side cross-link on bots#75 (likely existing comment 4637494705 -> edit to new head; else create). `identity_switch_authorized: true`.

Expected report: new #3232 head, fast-forward (no `+`) confirmation, both commits Kris Kowal + trailers-empty, 2-commit/8-file scope, mergeable, CI, cross-link id.
