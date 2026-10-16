---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Diagnose and fix test-thixotrope-ironhorse timeouts on the Parcel stack's frozen base (maintainer: fix the base first)

Context: the Parcel restacks for endojs/endo-but-for-bots PRs #1397 and #1398 halted because `test-thixotrope-ironhorse` exceeds its 20-minute limit with repeated two-minute Thixotrope reachability/reliability timeouts. The `ci` stage reran it once, then showed the frozen base commit `609821f7118d0633132a5df973ae1f789f696066` (branch `build/sturdyref-captp-construct-609821f`) fails identically in its own CI run, so the failure is inherited from the base. See the report of job `endojs-endo-but-for-bots-pr1397-parcel-restack-ci-20261016` (tada, 2026/10/16). Authorization: kriskowal, liaison session 2026-10-16: fix the base first; hold the restacks until then.

Do: (1) Diagnose first: does the same test fail on the live `llm` head, on `609821f7`, and on an older base? Establish whether this is a real regression (which commit), a CI-resource flake, or a test that hangs. Read the failing logs; do not guess. (2) If it is a real, local defect, fix it with the smallest change, run the CI-equivalent checks locally, and open a DRAFT PR on endojs/endo-but-for-bots targeting `llm` (Endo changes keep maintainer review: do NOT merge, un-draft, or ferry). (3) If it is infrastructure or an external flake, report the evidence and a recommendation instead of changing code. (4) Report: root cause, evidence, the PR or recommendation, and which of the halted restack stages (#1397 `summary`, #1398 `summary`) can resume once the base is green. Do not resume or re-post the restack stages yourself.
