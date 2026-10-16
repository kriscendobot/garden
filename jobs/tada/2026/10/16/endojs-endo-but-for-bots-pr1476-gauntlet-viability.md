PR #1476 can go into the gauntlet. It is still open and needed: nothing on the current base implements this, and the design it builds on has not been replaced.

Deciding question: Does the `llm` base already have Noise-session heartbeat liveness (`op:ping`/`op:pong`), or has a newer PR or design replaced Phase 1 of `designs/ocapn-noise-session-reconnect.md`?

Answer: no.

Evidence:
- **PR state:** #1476 is OPEN, a draft and not merged. It was opened on 2026-10-16 by the build job `endo-but-for-bots-ocapn-noise-session-reconnect-build`. It has no reviews or comments yet.
- **Base is current:** the PR's base is `llm-61cd656`, and `llm` has no commits beyond 61cd656. No newer base history could have replaced it.
- **Feature is absent on `llm`:** `packages/ocapn/src/codecs/operations.js` has no ping or pong operations, and `packages/ocapn-noise/src/network.js` has no heartbeat code. The last changes to `network.js` (2026-10-01) are handshake and settlement fixes, not session liveness.
- **Design still applies:** design PR #252 was merged on 2026-05-20. `designs/ocapn-noise-session-reconnect.md` on `llm` is still "Status: Proposed" and nothing replaces it. The problem it describes (TCP keepalive is too coarse to show whether a long-lived CapTP session is alive) still holds.
- **No competing PR:** searching the repo's PRs for heartbeat / ocapn-noise finds only #1476 and the design PR #252.

I spent no clean, panel, fix, CI-wait or un-draft budget.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1476-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (156505 cached reads)
- Output: 1707 tokens
- Cost: $0.373241
- Wall-clock: 34s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
