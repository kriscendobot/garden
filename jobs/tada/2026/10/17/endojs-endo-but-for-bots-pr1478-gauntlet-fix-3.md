Round-3 fixes for endojs/endo-but-for-bots#1478 are pushed and CI is green on the new head `c4bf0a40b8` (35 checks, 0 failed).

**What I changed** (three follow-up commits on top of `c42a46273e`, pushed with `safe-push-pr-head.sh`)

- **breaker #1, the queue bound broke under concurrent writers:** `writer.next` now checks for room *before* it adds a frame. A writer that finds the queue full waits with its frame, in call order. When room appears, the drain loop adds that frame in the same step, so a later writer can't jump ahead of it. The queue now holds at most 64 writer frames plus one ping/pong pair (66), even under `Promise.all`. The high-water test now checks that 62–64 of its 80 concurrent writes are accepted and that `queuedFrames <= 66`. The range allows for heartbeats, which count against the limit.
- **breaker #2, dropped frames were not reported:** when the session closes, the queue is emptied and `queuedFrames` drops to 0. Writers still waiting for room get `done: true` instead of a `done: false` that implied the frame was accepted. The changeset, the `types.d.ts` docs and a code comment now say that frames still queued when the session ends are lost.
- **breaker #3, `lastSentNonce` lags the real nonce:** the `types.d.ts` docs now say a frame the transport is still taking has used its nonce but isn't counted. The existing stall test already checks that `lastSentNonce` stays put while a write is held.
- **coverage-auditor #2, writers waiting when the session is lost:** new test, "writers waiting for room settle as done when the session is lost". It sends 80 writes and holds the transport past the session timeout. Accepted writes return `done: false`, the waiting writes and any later write return `done: true`, and the queue reports empty. On the old code this test fails.
- **coverage-auditor #1, coverage not measured:** I ran `c8 --all --reporter=json` and it produced `coverage-final.json`. Only two changed lines in `network.js` are uncovered, both `if (closed) return;` guards:
  - the one in `fail` (line 1022), which the auditor rated comment-only;
  - the one in `enqueue` (line 1084), which the auditor accepted as unreachable.
- **pruner #1–6:**
  - Removed the design-phase citation from `_stall-injector.js`.
  - Removed the redundant comment sentence in the stall test (it went in with the test commit rather than its own).
  - Removed the "callers read it and do not implement it" line from the changeset.
  - Edited the PR body: dropped the "(on `llm`; design PR #252)" aside, made Documentation Considerations a link to the changeset, and cut Upgrade Considerations to "None." The mechanism bullets also now describe the bound and the dropped-frame behaviour.

**Checks run locally:** all 95 package tests pass, the session-queue file passes on its own, and `tsc` plus `eslint` show no errors (only warnings that were already there). The repo-root `tsc -p tsconfig.json` reports nothing for ocapn-noise.

**Not done (should-fix items left as they were):** the breaker's heartbeat-delay note (comment-only) and the integrator's commit-grouping suggestion.

The first CI wait hit the session's 10-minute background limit and was killed. I polled `gh pr checks` in the foreground until every check had finished, then re-ran `ci-wait-merge.sh`, which returned rc 0 (green). I did not re-run the panel; the driver posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1478-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2341893 cached reads)
- Output: 16445 tokens
- Cost: $1.4655266
- Wall-clock: 2254s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
