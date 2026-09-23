Implemented and pushed to `main2`:

- `3b536fd4e8ee27d72c83e0921ce15476132c6f0b` — comment acknowledgment latency monitor, probe, heartbeats, systemd units, tests, and docs.
- `2dabc3e1ca15338b695a6aaa070c5986d7226621` — repository ShellCheck repairs.

Built thresholds: on-time 240s/300s by watcher cadence; never-acked at 900s; stale heartbeat 270s/360s; stuck cooldown/offline 1200s; 300s checker cadence; 6h lookback. Alerts page on the first qualifying offense. No synthetic canary was added pending maintainer approval.

Required tests passed: latency scenarios; comment watcher 373/373; mention watcher 36/36; issue inbox watcher 43/43. ShellCheck, syntax, and systemd verification passed. Repository-wide CI still reports unrelated pre-existing failures in four focused suites; the watcher-specific gates are green. No deployment was run.

Read-only live probe: `kriscendobot/garden` had one qualifying acknowledgment at 102s (p50/p95 102s). No qualifying samples existed for `endojs/endo-but-for-bots`, `kriscendobot/{cosgov,endo,endo-but-for-bots,finbot,list,minion.town,moddable,ocapn,oros-ckm-data-readiness,proposal-compartments,test262,vattr97,ymax-e2e,ymax-stdio-mcp}`.

Follow-up: formal PR-review bodies remain unmeasurable because GitHub exposes no reaction endpoint for them; reactable issue, conversation, and inline-review comments are covered.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-comment-latency-watch.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 82 tokens (4947972 cached reads)
- Output: 43823 tokens
- Cost: $5.102595 (1 engagement(s) unpriced)
- Wall-clock: 3511s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
