Clean stage for endojs/endo-but-for-bots#1477 (`feat/ocapn-np-identity-location-id` → `llm-61cd656`, draft): nothing needed doing, so I pushed nothing.

- **CI:** green at the current head `7f52fa6e`: 20 checks passed, 15 skipped, none pending or failed. I read this from the PR's check summary and did not run `ci-wait-merge.sh`, because nothing was waiting on CI.
- **Coverage:** I reviewed the diff rather than running a coverage tool. The new `locationNetworkId` helper and both branches of the `np`-ignores-hints rule in `locationToLocationId` are tested in the new `packages/ocapn/test/location-id.test.js`. That file covers the `network`-over-`transport` choice, hints being dropped for `np`, different designators giving different IDs, other networks keeping their sorted hints, and `network` winning over a conflicting `transport`. The tcp and WebSocket netlayer edits just switch to the new helper; the existing netlayer tests run them and they pass in CI.
- **Dead code:** none left behind. The two inline `network ?? transport` copies were replaced by the helper, not left unused.

One small gap I left alone: the WebSocket netlayer's "Unsupported network" rejection when the networks don't match has no direct test. It's a one-line guard that matches the tcp netlayer, so it isn't worth a follow-up commit here.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1477-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (172825 cached reads)
- Output: 1473 tokens
- Cost: $0.4196889999999999
- Wall-clock: 32s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
