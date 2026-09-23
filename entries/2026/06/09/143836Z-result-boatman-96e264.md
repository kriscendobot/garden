---
ts: 2026-06-09T14:38:36Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/09/143457Z-dispatch-liaison-98efa8.md
---

Shape-2 re-ferry of the rebuilt bots#75 onto endojs/endo#3232, maintainer-directed AS-IS (~37-line content divergence from the prior #3232 head: test logic + docs). Recomputed bots#75's 10 commits onto current master and force-pushed #3232.

**Host preconditions met.** `gh auth status` showed `kriskowal` active; `gh api repos/endojs/endo --jq .permissions` showed `push: true, admin: true`.

**Source / target verification.** `git ls-remote origin refs/heads/master` == `4a04d078b` (== dispatch's stated master; not moved). `git fetch .../endo-but-for-bots refs/pull/75/head` FETCH_HEAD == `32cc335ba` (rebuilt bots#75 tip). PR #3232 pre-push: branch `kriskowal-random-chacha20`, head `cc336d40a`, 12 commits, MERGEABLE, APPROVED (gibson042).

**Recompute.** Detached at `4a04d078b`; cherry-picked the full `master..32cc335ba` range (10 commits) clean (source base == current master, so no conflicts; yarn.lock commit `f0b11c2e7` applied cleanly, no regeneration needed). Rewrote author AND committer of all 10 to `Kris Kowal <kriskowal@kriskowal.com>` via `git rebase --exec 'commit --amend --reset-author --no-edit'`. No `(#75)` suffixes and no Co-Authored-By / Generated-with / Refs trailers were present in any body (checked; none leaked from a prior ferry this time).

**Gates.**
- Attribution: all 10 commits Kris Kowal author+committer (`git log master..HEAD --pretty=fuller` confirmed).
- Trailer gate: per-commit `git interpret-trailers --parse` EMPTY for all 10.
- Tree match: `HEAD^{tree}` == `32cc335ba^{tree}` == `2c2d3018c793c4c4cfbcb8e31ac09685abfa2837` (content matches rebuilt bots#75, NOT the old #3232).
- Commit count: 10.

**Force-push.** `git push --force-with-lease=kriskowal-random-chacha20:cc336d40a... origin HEAD:refs/heads/kriskowal-random-chacha20` → `cc336d40a...5cb2ae89a (forced update)`. Lease honored. Re-confirmed `kriskowal` active immediately before push.

**Post-push.** New #3232 head `5cb2ae89afc9a618154c1ec5c24a307d95942316`; 10 commits; MERGEABLE; reviewDecision APPROVED — gibson042's APPROVED **persists** (endo master is not branch-protected, so the force-push did not dismiss the stale review, as the maintainer accepted). No re-review requested, no comment posted on endojs/endo per directive. CI: all four checks (browser-tests, build, test-ocapn-guile-interop, zizmor) pending at report time; did not wait.

**Cross-link.** Edited the existing garden-side comment id `4637494705` on endo-but-for-bots#75 in place to `Mirror of https://github.com/endojs/endo/pull/3232 (head 5cb2ae89a).`. No `message: boatman → steward`, no upstream-side comment.

Self-improvement: nothing this time. The ferry exercised the documented Shape-2 recompute path (clean cherry-pick because source base == current master, no yarn.lock regeneration, no trailer leak) without surfacing a gap in pr-handoff or the boatman role; the maintainer-directed approval-persistence-across-force-push case is already covered by the skill's Approval-persistence note.
