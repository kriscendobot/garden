---
kind: dispatch
role: boatman
host: kmkmbp2026
posture: liaison
short_id: c71c32
dispatch_root: dispatches/boatman--c71c32
project: endo
repo: endojs/endo-but-for-bots
source_pr: 719
source_branch: feat/hardened-url-vetted-shim
source_head: c909775f3491680539ee1a73021f0f9c7c5b3757
upstream: endojs/endo
upstream_pr: 3332
upstream_branch: kriskowal-hardened-url-shim
upstream_prior_head: 6c50a5fadbb1570e1579ba94511134bac49290a4
human: Kris Kowal <kriskowal@kriskowal.com>
identity_switch_authorized: true
model: sonnet
refs: [b2c7c1, c4e1a2]
---

Re-ferry endo-but-for-bots#719 to endojs/endo#3332 — **Shape 3 (fast-forward
append)**. The garden prepared the lint fix (tick c4e1a2): rebased #719 onto
current master (`master-fb9cef4`) and appended ONE new commit,
`c909775f3 fix(ses): drop redundant globalThis global directive`, which removes
the `/* global globalThis */` directives from the three url test files that
failed upstream lint (no-redeclare).

The source's first 6 commits are byte-identical SHAs to the upstream branch
(`e4333775f … 6c50a5fad`); upstream head `6c50a5fad` is a direct ancestor of
the new source head `c909775f3`. So this is a clean fast-forward append: cherry
-pick ONLY `c909775f3` onto the upstream branch tip, rewrite its author+
committer to Kris Kowal (currently kriscendobot-authored), verify
`merge-base --is-ancestor`, and push WITHOUT force.

Preconditions verified: `gh auth status` → kriskowal active (kmkmbp2026);
`gh api repos/endojs/endo --jq .permissions` → push:true (admin). Bot-side #719
CI fully green including lint. New commit touches only the 3 url test files;
message is clean (no bot trailers). #3332 reviewDecision REVIEW_REQUIRED (no
approval to preserve). Existing garden-side cross-link comment id 5079090390
(currently "head 6c50a5fad") to be edited in place.

Attribution: `Kris Kowal <kriskowal@kriskowal.com>` (consistent with the ferry).

Expected report: shape used + ancestor-check result, upstream head SHA after
push (must show `6c50a5fad..<new>` with no `+`), per-commit attribution+trailer
verification, upstream CI status, and the edited cross-link comment id.
