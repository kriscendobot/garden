Reconfirmed the live daemon remains active at `f6650503`, with socket present and `client.js`/`mail.js` byte-identical to `0eb88836`.

Captured a quiescent rollback snapshot, then tested `0eb88836` against an isolated copy. SQLite opened, the node identity loaded, and 3,635 formulas deserialized, but formula-graph revival failed with `Invalid formula identifier "[undefined]"`: both legacy host formulas lack the newly required `registry` field. No dry-run socket came up, so no names or guests became accessible.

Per authorization, stopped without redeploying or migrating. Both pins, `/opt/endo`, live state, and the reminder shim remain unchanged; production is healthy at `f6650503`. Reported the failure to the maintainer inbox and recorded it in `kriscendobot/minion.town` main commit `c953c03`.

Follow-up: design and review a compatibility migration or legacy-host default for `registry` before retrying.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-reminder-daemon-redeploy-20260916.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 587s

<!-- garden-usage-end -->
