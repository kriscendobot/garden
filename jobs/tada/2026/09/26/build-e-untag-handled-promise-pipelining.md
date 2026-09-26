Implemented and opened draft PR [#8](https://github.com/kriscendobot/endo-but-for-bots/pull/8), pinned to upstream `master-aaf9ea4`.

- Added pipelined `E.untag(value, tag)` / `HandledPromise.untag`.
- Added outbound OCapN `op:untag` handling and removed the raw-wire test helper.
- Added local validation, postponed forwarding, SES permit, tests, and changeset.
- No `untagSendOnly`: untag inherently returns a payload.
- Verified: eventual-send (35), OCapN (260), SES (553; 2 known failures, 2 skipped), and package lint.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-e-untag-handled-promise-pipelining.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 2 host(s) (6 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (6 engagement(s) unpriced)
- Wall-clock: 781s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
