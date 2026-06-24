---
ts: 2026-06-04T05:32:25Z
kind: dispatch
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/03/055712Z-dispatch-liaison-4d496e.md
---

Dispatched boatman (dispatch-root `dispatches/boatman--c85206`) to re-ferry ("ferry #244 back") the re-rebased endo-but-for-bots#244 onto endojs/endo#3263. Shape-2 recompute, **base-freshen** (content byte-identical).

State: bots#244 was force-pushed again onto a newer frozen base `master-07aff33` (= endo master `07aff334e`), head `6757edc8f`, 2 commits (migration `10c2bb92e` + yarn.lock `6757edc8f`, endolinbot). #3263 (head `eef8f2fc9`, 2 commits Kris Kowal, MERGEABLE, REVIEW_REQUIRED, no approval) is the prior ferry on the older base `ba26f4cdb` (now 2 commits behind master). Verified: the migration is IDENTICAL (eslint-plugin subtree `96b0538d6` both sides; net-diff content byte-identical; yarn.lock blob `d4bb4268` identical). The ONLY difference is the base: #3263 is 2 behind current master; bots#244 is on current master. So this re-ferry freshens #3263's base to 07aff334e, matching the rebased mirror; #3263's net content does not change.

Boatman brief: fetch origin (verify master = `07aff334e` via exact refs/heads/master; bots#244's base equals it -> clean); detach at origin/master; cherry-pick bots#244's 2 commits (`10c2bb92e` then `6757edc8f`) - bases match, clean; normalize author+committer of both to `Kris Kowal <kriskowal@kriskowal.com>`; RUN `interpret-trailers --parse` EMPTY; strip `(#244)` suffixes; verify net diff byte-identical to #3263's current (only the base/commit-SHAs change); force-with-lease against `eef8f2fc9` to `kriskowal-eslint-numeric-separators-style`; confirm MERGEABLE; edit cross-link 4579718869 to the new head. `identity_switch_authorized: true`.

Expected report: new #3263 head, force-with-lease confirmation, both-commits Kris Kowal + trailers-empty, base-freshen confirmation (net content unchanged), mergeable, CI, edited cross-link.
