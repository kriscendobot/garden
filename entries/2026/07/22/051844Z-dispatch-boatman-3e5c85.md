---
kind: dispatch
role: boatman
host: kmkmbp2026
posture: liaison
short_id: 3e5c85
dispatch_root: dispatches/boatman--3e5c85
project: endo
repo: endojs/endo-but-for-bots
source_pr: 259
source_branch: feat/hardened-text-codecs-shim
source_head: 42eb1b61a28a71c49c86f1e6d61f7a19bd540f12
upstream: endojs/endo
upstream_pr: 3322
upstream_branch: kriskowal-hardened-text-codecs-shim
upstream_prior_head: 2587b0f8cb19497368d513d30f67e791898a1ac1
human: Kris Kowal <kriskowal@kriskowal.com>
identity_switch_authorized: true
model: sonnet
---

Re-ferry endo-but-for-bots#259 to endojs/endo#3322. The source has advanced
since the 2026-07-15 first-time ferry (a7d440): 3 commits → 5, rebased onto
frozen base `master-46d4edf`, new head `42eb1b61a`.

Prior upstream (3 commits @ 2587b0f8c): feat / test / fix(tolerate undeletable
arguments|caller). New source (5 commits @ 42eb1b61a):

  5acec4b9c feat(ses): permit TextEncoder and TextDecoder as universal intrinsics
  260c0fe73 test(ses): cover ignoreBOM, @@toStringTag, constructor reverse-link, …
  0b7ab7590 fix(ses): tolerate undeletable arguments/caller on native function …
  fa2c5d023 Revert "fix(ses): tolerate undeletable arguments/caller …"
  42eb1b61a fix(ses): drop redundant globalThis global directive

Commits 3 and 4 cancel (fix + its revert); commit 5 is the replacement fix.
Prior upstream head 2587b0f8c is NOT an ancestor of the new shape (that fix is
reverted) → **Shape 2 (recompute-from-master, force-push)** to the same
upstream branch. Fast-forward append (Shape 3) is impossible.

Preconditions verified before dispatch: `gh auth status` → kriskowal active
(kmkmbp2026); `gh api repos/endojs/endo --jq .permissions` → push:true (admin).

Attribution: `Kris Kowal <kriskowal@kriskowal.com>` — same as the first ferry,
for consistency on the same upstream branch.

Note for the boatman: #3322 is currently APPROVED. A force-push may dismiss the
approval if branch protection has dismiss_stale_reviews; record the post-push
approval state in the result. Present a clean upstream series per the One-voice
norm (the fix+revert pair nets to nothing — collapse the noise if the net diff
is preserved).

Expected report: upstream head SHA after force-push, per-commit attribution +
trailer verification, post-push approval state, upstream CI status, and the
edited-in-place garden-side cross-link comment ID.
