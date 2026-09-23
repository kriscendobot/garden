---
ts: 2026-05-29T14:18:48Z
kind: dispatch
role: liaison
repo: endojs/endo
project: endo
refs: []
---

Dispatched boatman (dispatch-root `dispatches/boatman--b2e87a`) to re-ferry the bot-side mirror endojs/endo-but-for-bots#351 back to its upstream origin endojs/endo#2422.

Source: endojs/endo-but-for-bots#351, branch `mirror/2422-host-module-exits`, head `fd214c1fc545e47c8051db3e80efd4cfde0af891`, 13 commits (mix of `Kris Kowal <kris@agoric.com>` and `endolinbot`). The PR is the un-drafted, gamut-refined mirror of endojs/endo#2422 ("feat(compartment-mapper): Host module exits"). Note endo-but-for-bots is NOT a git fork of endo (separate repo, default branch `llm`); the mirror was built by cherry-picking the upstream commits onto endo-but-for-bots@master and reworking them, so the diffs apply patch-wise onto endo/master.

Upstream: endojs/endo#2422, existing branch `kriskowal-ponyfill-host-module`, current head `1bf012f0b` (8 commits). State OPEN, non-draft, **APPROVED** by dckc (2024-08-27) and boneskull (2025-10-13). endojs/endo `master` is NOT branch-protected, so a force-push does not auto-dismiss those approvals (they persist on the record); boatman verifies post-push per pr-handoff Shape 2.

Shape: **Shape 2 (re-ferry, recompute-from-master, force-push)**. The mirror was rebased onto today's master and the commit set reworked (dropped obsolete NEWS.md + Yarn-4-lint-script commits, added a changeset and 7 panel/fixer refinement commits), so the upstream head is not an ancestor of the new shape and a fast-forward append is not possible.

Human attribution: `Kris Kowal <kriskowal@kriskowal.com>` for every commit (author+committer); strip `(#351)` subject suffixes and any bot trailers. `identity_switch_authorized: true` (maintainer-directed; session holds kriskowal authority).

Host: kmkmbp2026; kriskowal authenticated, push:true (admin) on endojs/endo, verified in the prior ferry this session. No prior `Mirror of` cross-link exists on #351; boatman creates the garden-side cross-link and hands the upstream-side to steward.

Expected report: upstream PR #2422 post-push head SHA, force-push confirmation, post-push approval-persistence check (dckc + boneskull should remain), attribution/trailer verification, CI status, garden-side mirror cross-link comment ID on #351.
