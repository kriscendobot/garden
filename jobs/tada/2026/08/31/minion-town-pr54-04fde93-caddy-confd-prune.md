Implemented and pushed commit `bef738f` in draft PR #70.

- Caddy deploy now prunes orphaned `conf.d/*.caddy` before validation.
- `deploy-www.sh` now reconciles renamed/removed static assets.
- Added documentation and regression tests.
- Live SSM check confirmed the stale file and validation failure; removed it, validated successfully, and reloaded active Caddy.
- Full suite: 289 passed, 5 skipped; typecheck and CI passed.
- Self-improvement: nothing this time.

Follow-up: normal PR review and merge.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr54-04fde93-caddy-confd-prune.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 341s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
