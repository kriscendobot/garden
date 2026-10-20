**Viability: endojs/endo-but-for-bots#1478, session-reconnect Phase 2 (session outbound queue + stall fault injector)**

The PR is still needed and nothing has replaced it, so the gauntlet may begin. I spent nothing on clean, panel, fix, CI-wait or un-draft.

- **PR facts:** open, not merged, draft, `MERGEABLE`. Base is the frozen branch `build/ocapn-noise-session-reconnect-heartbeat-9175a5b`, which is a snapshot of the Phase 1 PR #1476. Head is `build/ocapn-noise-session-queue`.

Deciding question: Is the session-level outbound queue and stall fault injector (Phase 2 of `designs/ocapn-noise-session-reconnect.md`) still missing from `llm`, with no newer PR replacing it, and is that design still the plan the stack follows?

Evidence:
- The design `designs/ocapn-noise-session-reconnect.md` is still on `llm`. It was merged via #252.
- `llm`'s `packages/ocapn-noise/src/network.js` has no session outbound queue, high-water mark, stall handling or `SESSION_TIMEOUT`. Its only queues are the inbound-session queue and the waiter queues. `test/` on `llm` has no `session-queue.test.js` or `_stall-injector.js`.
- The recent `llm` commits under `packages/ocapn-noise` are dependency bumps and the 2026-10-01 settlement and SYN-replay fixes. None of them implements this phase.
- The stack is intact and every PR in it is open: #1476 (Phase 1) → #1478 (Phase 2) → #1481 (Phase 3, whose base is a frozen snapshot of #1478's head) → #1482 (Phase 5). No other open PR does Phase 2.
- No maintainer or other non-bot comments or reviews exist on #1478 or #1476, so nobody has rejected the approach. The only discussion is the bot's own round-1 panel, which found comment-level issues (naming, an optional changeset) and nothing blocking.
- Phase 4 is gated on the open cryptographic-review issue #1475, but that gates the successor's work, not this PR.

For the next stages: the frozen base (`9175a5b`) is older than #1476's current head (`3a1750f`). That calls for a restack or weave during the gauntlet; it doesn't mean the PR has been replaced.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-but-for-bots-pr1478-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (239662 cached reads)
- Output: 2185 tokens
- Cost: $0.47108039999999995
- Wall-clock: 42s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
