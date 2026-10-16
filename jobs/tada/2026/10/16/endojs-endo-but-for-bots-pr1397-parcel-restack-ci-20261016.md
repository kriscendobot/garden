---
orchestration-failed: true
---
Final head: `8f3d80100ff5354d82e4108c788a2a1c883a7552`, based on `build/sturdyref-captp-construct-609821f` at `609821f7118d0633132a5df973ae1f789f696066`.

CI settled with 19 successful, 15 skipped, and one cancelled check. GitHub reports no explicitly required checks, but the overall rollup remains unstable because `test-thixotrope-ironhorse` exceeded its 20-minute limit.

I reran the failed CI run once (attempt 3). It reproduced multiple two-minute Thixotrope reachability/reliability timeouts and was cancelled at the job limit. The base commit’s concurrent CI run reproduced the same tests, timeouts, and cancellation, establishing that this failure is inherited from the frozen base rather than attributable to PR #1397.

No project changes or pushes were made, avoiding unrelated Thixotrope changes in this OCapN PR. Gated all-green CI could not be achieved while the selected base itself has the identical failure.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1397-parcel-restack-ci-20261016.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1325s

<!-- garden-usage-end -->
