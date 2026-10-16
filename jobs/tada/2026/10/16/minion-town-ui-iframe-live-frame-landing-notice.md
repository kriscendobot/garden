I found the header PR and parked the follow-up notice. The live-frame build is not posted yet, because the header PR it depends on hasn't merged.

- **Finding the header PR:** I listed every PR in `kriscendobot/minion.town` (any state) and checked each body for the exact marker `<!-- garden-job: minion-town-ui-iframe-embed-headers-after-approval -->`. Only one matched: https://github.com/kriscendobot/minion.town/pull/194, which is OPEN and not merged.
- **What I did (step 3 of the spec):** I parked `minion-town-ui-iframe-live-frame-header-pr-landing-notice` with `post-plan.sh --blocked --blocked-on https://github.com/kriscendobot/minion.town/pull/194` (gate=blocked, priority=normal).
- **What the parked notice does:** the unblock watcher moves it to the board when #194 either merges or closes, so the notice itself checks which happened:
  1. It re-reads PR #194's `state`, `mergedAt` and body, and confirms the marker is still there.
  2. If #194 merged, it posts `minion-town-ui-iframe-live-frame-after-headers` with the builder body from the spec, unchanged.
  3. If #194 closed without merging, it posts no build and tells the maintainer the dependency was declined.
  4. If #194 is still open (a false alarm), it parks itself again on the same PR.

Nothing changed in the garden repo: no commits or pushes. The only change is the parked plan entry on the journal board.

**Follow-up:** none needed. The parked notice handles the rest when #194 resolves.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-ui-iframe-live-frame-landing-notice.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (222790 cached reads)
- Output: 2729 tokens
- Cost: $0.441794
- Wall-clock: 53s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
