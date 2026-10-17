I checked PR #194 and posted the live-frame build job.

- **PR state:** `kriscendobot/minion.town#194` was merged at 2026-10-17T04:54:59Z. Its body still contains the exact `<!-- garden-job: minion-town-ui-iframe-embed-headers-after-approval -->` marker.
- **Branch taken:** the merged case (step 2). I posted `minion-town-ui-iframe-live-frame-after-headers` with `scripts/jobs/post-job.sh`, using the build body from the spec unchanged. It returned rc=0 and logged "posted".
- **Not triggered:** I sent no maintainer notice and re-parked nothing, since the PR was neither declined nor still open.
- **Code and commits:** none. This job only posts the follow-on job.

Next is the new build job, which frames the live clip in `shell.js` behind the embedding headers that are now on `main`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-ui-iframe-live-frame-header-pr-landing-notice.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (118855 cached reads)
- Output: 1048 tokens
- Cost: $0.378747
- Wall-clock: 23s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
