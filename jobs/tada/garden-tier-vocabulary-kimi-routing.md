Implemented and landed `2311255c4602c7a9b18a7f6d3b2d607901a84107` on `main2`.

- Added closed executable model inventory and four-tier mapping.
- Enforced automatic mentor/Kimi routing with non-Claude Codex fallback.
- Made Fable/mentat manual-only via `post-manual-job.sh`.
- Added queued-job migration script and regression coverage.
- Verified tier-routing regression test and shell syntax.

Deployment on leader:

```sh
scripts/jobs/drain-fleet.sh on "deploy mentor/Kimi routing"
scripts/jobs/deploy-garden.sh
scripts/jobs/migrate-model-tier-routing.sh
scripts/jobs/drain-fleet.sh off
```

Follow-up: legacy model-routing/worker-spine tests still encode the superseded Claude-default policy and should be updated when the broader suite is next reconciled.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-tier-vocabulary-kimi-routing.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 366s

<!-- garden-usage-end -->
