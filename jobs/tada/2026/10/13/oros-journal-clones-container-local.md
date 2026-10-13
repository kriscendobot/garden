Implemented and pushed commit `f4a9a985645` to `main2`.

- Added optional `GARDEN_JOURNAL_CLONE_BASE`, preserving existing defaults.
- Worker and producer clones can now live on container-local storage and reseed automatically when empty.
- Clone locks and durable state remain under `$GARDEN_STATE`.
- Forwarded the knob through the container launcher and systemd environment handoff.
- Added operator documentation and regression coverage.

Verification passed: clone-base tests 8/8, environment-handoff tests 9/9, repository-lock tests, journal reseeding tests 18/18, stale-lock tests 9/9, and all 13 checks suites.

Follow-up: after deployment, rebuild/recreate oros-studio with `GARDEN_JOURNAL_CLONE_BASE=/var/tmp/garden-journal-clones` to activate local placement.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-journal-clones-container-local.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 646s

<!-- garden-usage-end -->
