---
ts: 2026-06-10T23:02:29Z
kind: dispatch
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/08/024025Z-dispatch-liaison-ed1f4c.md
---

Dispatched boatman (dispatch-root `dispatches/boatman--762a09`) to re-ferry the rebuilt bots#401 onto endojs/endo#3300 (shellcheck CI). Shape-2 recompute: carries a new commit + freshens the base.

State: bots#401 rebuilt to 4 commits (all endolinbot, base `master-4a04d07`, head `85ebc883a`): `42c39b0c6` fix(scripts) cleanups + `cda73098c` add shellcheck script+workflow + `fe73a4740` fix(scripts) argv-limit + `85ebc883a` chore(shellcheck): adopt die idiom (NEW; 3 .sh files, the 16-line delta). #3300 head `3efeaf8b3` (2 commits, Kris Kowal, MERGEABLE, REVIEW_REQUIRED, no approval; my prior ferry was a26f747 - it moved). endo master now `b2fa365ae` (bots#401 base 4a04d07 lags it).

Boatman brief (Shape 2): detach at current endo master `b2fa365ae`; cherry-pick bots#401's 4 commits via `refs/pull/401/head`; SQUASH `cda73098c`+`fe73a4740` (script-add + its argv-limit fix, one logical change, as in the prior #3300 ferry) into `chore(shellcheck): add yarn shellcheck script and CI workflow`, keeping `fix(scripts): shellcheck cleanups` and `chore(shellcheck): adopt die idiom for early termination` separate -> 3 commits; the .sh-cleanup/die-idiom commits may conflict from the 4a04d07->b2fa365ae base gap (resolve mechanically / re-derive via shellcheck; STOP if ambiguous); author+committer `Kris Kowal <kriskowal@kriskowal.com>`; strip (#)/Co-Authored-By/Generated-with/Refs trailers; RUN `interpret-trailers --parse` EMPTY (watch for Claude trailers); verify net diff matches bots#401 (incl the die-idiom changes); no yarn.lock change expected (shell-only); force-with-lease against `3efeaf8b3` to `kriskowal-shellcheck-ci`; keep DRAFT (no change); confirm MERGEABLE; edit cross-link 4645026707 to new head. `identity_switch_authorized: true`.

Expected report: new #3300 head, force-with-lease, squash + conflict outcome, Kris Kowal + trailers-empty, net-diff-matches-bots#401, mergeable, CI, edited cross-link.
