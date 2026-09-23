---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-08-09T16:27:32Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/923
  - https://github.com/endojs/endo-but-for-bots/pull/867
  - https://github.com/endojs/endo-but-for-bots/pull/868
  - https://github.com/endojs/endo-but-for-bots/pull/912
  - https://github.com/endojs/endo-but-for-bots/pull/913
  - https://github.com/endojs/endo-but-for-bots/pull/914
  - https://github.com/endojs/endo-but-for-bots/pull/915
  - https://github.com/endojs/endo-but-for-bots/pull/916

# Dependabotany ledger: endojs/endo-but-for-bots — 2026-08-09 daily backstop sweep

Daily backstop job `dependabotany-recheck-endo-but-for-bots-20260809-162001`.
Recovered the cumulative ledger with the case-insensitive heading match and
reconciled every open row against live GitHub, registry, advisory, source, and CI
state. The open Dependabot set remains exactly the eight ledgered rows. No row is
due for a new terminal disposition today.

## Open embargo row: PR #923 holds, with new advisory detail

- Verdict remains **EMBARGO-2026-08-10**. Head
  `d2635dcead1f15a4e3909a0559c0b01f9bc04b76` is unchanged from the reviewed
  2026-08-05 head, so the 124 added resolved artifacts across the 36 grouped
  direct updates and the existing source review remain the applicable evidence.
  A fresh scripts-disabled immutable install completed through the botanist warm
  cache builder (`YARN_ENABLE_SCRIPTS=false`, WARM-CACHE built); it confirmed the
  locked artifacts remain available and checksum-valid.
- The maturity floor remains **2026-08-10T20:37:45.880Z**, from the freshest
  moved version `ws@8.21.2` (published `2026-08-03T20:37:45.880Z`) plus seven
  days. Live npm metadata still serves `ws@8.21.2` with the locked integrity;
  OSV and GitHub's advisory API return no advisory for that version. At this
  sweep the floor is about 28 hours away, so terminal conversion is not due.
- Live base census found the group remains a genuine forward update at nearly
  every call site, but `packages/agentry/package.json` has advanced
  `@earendil-works/pi-agent-core` and `@earendil-works/pi-ai` to `^0.84.0` while
  this stale head proposes `^0.82.1`. The PR is 122 commits behind / 2 ahead and
  `CONFLICTING/DIRTY`; merging it as-is could partially revert those two sites.
  The due recheck must regenerate/rebase or reject the stale shape, then
  re-enumerate the moved lock set and maturity floor. The repo's exact-pin update
  automation is not a remedy for these npm manifest ranges.
- Existing CI on this unchanged head is still terminal green: 24 checks, zero
  pending and zero failed. CI does not override the maturity or stale-base gates.
- A fresh recursive Yarn audit exposed four advisories on moved transitive
  `dompurify@3.4.8` (bundled by `monaco-editor@0.56.0`):
  `GHSA-c2j3-45gr-mqc4`, `GHSA-cmwh-pvxp-8882`,
  `GHSA-vxr8-fq34-vvx9`, and the 2026-08-07
  `GHSA-55q2-fjhq-7xh7`. This is directionally better than outgoing
  `dompurify@3.2.7`, for which OSV reports those four plus fourteen additional
  advisories, and the consumed Monaco path cannot reach the four residual
  predicates: Monaco passes per-call string sanitizer configuration, never
  enables `CUSTOM_ELEMENT_HANDLING`, never calls `setConfig()` or `clearConfig()`,
  never supplies a custom Trusted Types policy, and never uses `IN_PLACE`;
  its only hook is `afterSanitizeAttributes` plus optional per-call
  `uponSanitizeElement`/`uponSanitizeAttribute`, followed by `removeAllHooks()`.
  Therefore the directional advisory exception remains supportable, but the due
  verdict must disclose these residuals; a claim that the incoming moved set is
  advisory-clean would be incorrect. Current `dompurify@3.4.13` clears all four,
  so a regenerated lockfile should be checked for whether Monaco still pins
  3.4.8 exactly.
- Precise one-shot remains active for **2026-08-10T21:15:00Z** and the daily
  backstop remains active (`last_dispatched: 2026-08-09T16:20:01Z`).

## Seven terminal MERGE-NOW rows remain approval-held

Ran each terminal row through the full conductor spine
`scripts/jobs/gardening/ci-wait-merge.sh --merge`. Every PR was terminal green,
then failed closed at the current-head maintainer-approval gate (exit 1); no merge
or auto-merge was issued. Post-run GitHub verification shows all remain OPEN with
`autoMergeRequest=null` and unchanged heads.

- https://github.com/endojs/endo-but-for-bots/pull/867 — 25 checks green,
  `057f7e26819a889fdb735b76aefef059556501b4`, clean.
- https://github.com/endojs/endo-but-for-bots/pull/868 — 24 checks green,
  `d48bde2fbbcc789cdd36264abe79b55c997126e2`, conflicting/dirty; still needs a
  weave after approval.
- https://github.com/endojs/endo-but-for-bots/pull/912 — 26 checks green,
  `6cc9687c8f325698d5740eb1b07c23138d680c89`, clean.
- https://github.com/endojs/endo-but-for-bots/pull/913 — 23 checks green,
  `5879e4634aa3f8d107e83beca2f0f2cd13e81e90`, clean.
- https://github.com/endojs/endo-but-for-bots/pull/914 — 24 checks green,
  `2a655a0d51ce983b1e87b94330f5a85906ec5907`, clean.
- https://github.com/endojs/endo-but-for-bots/pull/915 — 23 checks green,
  `718c297115b269337ee29465d72deb7268bdbc16`, clean.
- https://github.com/endojs/endo-but-for-bots/pull/916 — 23 checks green,
  `352196b8b9ce2a557d2b41d672f474247107600f`, clean.

All seven lack a current APPROVED review on their current heads. They remain
terminal MERGE-NOW rows awaiting human approval; approval is not a schedulable
maturity recheck.

Self-improvement: nothing this time.
