Completed draft PR endojs/endo-but-for-bots#1334 at head `29c4591ff7`.

- Added a committed Yarn patch for AVA 8 that registers the post-lockdown `Uint8Array` with cbor2 before snapshot encoding.
- Added a regression test that writes and rereads a snapshot under `@endo/init`.
- Restored the OCapN API test to `t.snapshot()` and regenerated its corrupt `.snap` file.
- Verified `yarn install --immutable`, the regression test with `CI=true`, and snapshot updates under all three SES configurations. The regenerated snapshot was byte-for-byte stable.
- All PR CI checks completed successfully.
- Follow-up: PR remains draft for the normal review/gauntlet process.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-endo-but-for-bots-ocapn-noise-session-reconnect-build-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (2 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (2 engagement(s) unpriced)
- Wall-clock: 3182s

<!-- garden-usage-end -->
