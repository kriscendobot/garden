---
ts: 2026-06-03T00:18:16Z
kind: dispatch
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/02/224510Z-result-liaison-bc057f.md
---

Dispatched boatman (dispatch-root `dispatches/boatman--e78c11`) to re-sync endojs/endo#3294 to the LIVE bot mirror via another surgical tip-only amend (the maintainer's "referry bots#387").

State: the mirror endo-but-for-bots#387 advanced again to `a179d5aa8` (2-commit clean shape, base master-814dfa1). The ONLY PR-scope change vs #3294 `4150060dd` is `packages/benchmark/install-engines.sh` (+7/-3): the v8 launcher is now relocatable (relative `$0` traversal + quoted heredoc instead of baking in `$HOME`). README.md / run-tests.sh / hex already match. The other 27 differing files are the standing endo-master vs bots-master base divergence and stay untouched. Target benchmark subtree: `98060f1ec122844e323a759864577e83eab4444a`.

Heightened stakes: **#3294 is now APPROVED by gibson042** (2026-06-02T23:07Z, after their shell feedback was addressed). endo master is NOT branch-protected, so the tip amend's force-with-lease does NOT dismiss the approval (verified no dismiss_stale_reviews). Chose the surgical amend over a Shape-2 recompute precisely to preserve the approval, the 0xPatrick separate-commit credit, and the 3-commit structure; a full recompute would discard all three.

Boatman brief: detach at #3294 head `4150060dd`; `git checkout a179d5aa8 -- packages/benchmark/install-engines.sh`; confirm ONLY that file changed and `HEAD:packages/benchmark` == `98060f1e...`; `git commit --amend` keeping Kris Kowal author+committer and the `Feedback responses` subject; verify parents unchanged (`HEAD~1`==`d6dc75964`, `HEAD~2`==`4afa6af31` 0xPatrick); trailers empty; force-with-lease against `4150060dd`; verify #3294 still MERGEABLE and **gibson042 APPROVED persists**; update cross-link 4599031642 to the new head. `identity_switch_authorized: true`.

Flag for maintainer: gibson042's approval was granted against `4150060dd` and will now predate the relocatable-launcher one-file refinement. Approval persists formally; whether to re-request gibson042's review for the launcher tweak is the maintainer's call.

Expected report: new head SHA, only-tip-changed confirmation (parents intact, 0xPatrick author preserved), benchmark subtree == 98060f1e, force-with-lease confirmation, MERGEABLE + APPROVED-persists check, CI status, edited cross-link.
