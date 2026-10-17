I ran panel round 5 on PR #1478. The verdict is **must-fix**, posted as review 5555941139 against head `dc57f6fc62`.

- **Run:** I ran `panel.sh` in single-round mode on an isolated checkout of `endojs/endo-but-for-bots@build/ocapn-noise-session-queue`, with base `build/ocapn-noise-session-reconnect-heartbeat-9175a5b`. It exited 0 and returned `must-fix`.
- **First attempt killed:** my first launch would have been cut off by the 10-minute background limit. I killed it and its orphaned seat processes, then reran it detached and waited on it in the foreground. The rerun is the one that produced the verdict.
- **Seats:** all 34 seats ran without error: 5 request changes, 18 comment-only, 11 approve. The ones requesting changes are breaker, spec-keeper, engine-realist, pruner and decomplector.
- **Main findings:**
  - `enqueueFrame` does not actually copy a Node `Buffer`, even though its comment says it does.
  - The decomplector's "is it needed?" check fired because the same mechanism drew must-fix in rounds 3 and 4. It says the outbound queue may be speculative, suggests a simpler promise-chain design, and recommends checking with the maintainer before another hardening round.
  - Smaller items: a duplicate `countSentNonces` counter, and the new public `SessionLiveness` fields `queuedFrames` and `lastSentNonce` exposing queue internals.
  - The PR description is 393 words, over the 300-word limit.
- **Review format:** it is a comment review, not "request changes", because GitHub won't let the bot request changes on its own PR. This matches rounds 1–4. Request-changes seats come first. To stay under GitHub's length limit I left out 15 seats (mostly approvals) and listed their names at the end.
- **Repo changes:** none. This stage doesn't fix or un-draft.

This is the fifth must-fix in a row. Before running another fix pass, the maintainer may want to answer the decomplector's question about whether the queue is needed at all.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1478-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1574591 cached reads)
- Output: 7265 tokens
- Cost: $0.9919381999999999
- Wall-clock: 229s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
