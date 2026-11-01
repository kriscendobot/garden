PR #1478 is still viable: nothing newer has replaced it, and the reason for it still holds. The gauntlet can begin.

**PR state:** open, draft, not merged, mergeable. Head is `750929d3b5`. The PR is stacked on `build/ocapn-noise-session-reconnect-heartbeat-9175a5b`, which is the head of PR #1476 (Phase 1). #1476 is still open and not merged.

**Deciding question:** Does the `llm` branch already have a session-level outbound queue with stall handling for Noise sessions, or has the maintainer moved Phase 2 somewhere other than the `ocapn-noise` network layer? The answer is no.

**Evidence:**
- **Nothing on `llm` covers this work yet.**
  - The design, `designs/ocapn-noise-session-reconnect.md` (#252), was merged in May and has not changed since, apart from a file rename in August.
  - The last change to `packages/ocapn-noise/src/network.js` on `llm` was the settlement and handshake fixes of 2026-10-01. None of them adds a queue, heartbeat or reconnect.
  - `packages/ocapn-noise/test/` on `llm` has no session-queue or stall tests.
  - The recent commits to the `packages/ocapn/src/client` directory on `llm` are unrelated (garbage-collection batching and thixotrope).
- **There is a competing Phase 2, but it hasn't replaced this one.**
  - #1511, "feat(ocapn): session send queue and epoch", is a parallel Phase 2 in the CapTP client layer (`packages/ocapn`). It is stacked on #1502, a separate Phase 1, which is itself duplicated by #1508.
  - All of #1511, #1502 and #1508 are open drafts, and none has merged.
  - The maintainer's review of the design (#252, 2026-05-19) said: "We should implement this provisionally and use it only in the Noise Protocol netlayer." That favours where #1478 puts the queue (in `ocapn-noise`) over #1511's placement in the client.
  - The protocol and build-breakdown design PR #1512 is written against this stack (#1476 → #1478 → #1481 → #1482 → #1483) and treats #1478 as the live Phase 2.
- **The need still holds.** Phases 3–5 (#1481, #1482, #1483) need a queue that keeps accepted plaintext frames so they can be resent over a new transport after a reconnect. #1478 provides that, and nothing else on `llm` does.
- **No maintainer comments or reviews** on #1476, #1478, #1481, #1502, #1508, #1511 or #1512. All activity there is from the bot.

**History:** a previous gauntlet on this PR stopped with "review-budget-reached" after 6 rounds with CI green, and a later one halted at panel round 2. These reflect review budget, not whether the PR is still worth doing.

**Follow-up for the maintainer:** there are two competing session-reconnect stacks. One is in the `ocapn-noise` network layer (#1476 → #1478 → #1481 → #1482 → #1483). The other is in the `ocapn` client layer (#1502 or #1508 → #1511). Running gauntlets on both duplicates review spend, so the maintainer should pick one stack and close the other's PRs. Your design comment points to the `ocapn-noise` one. #1478 also can't merge until #1476 does.

I made no changes to the repository.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1478-gauntlet-20261101-750929d3-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (248977 cached reads)
- Output: 3187 tokens
- Cost: $0.5499754
- Wall-clock: 58s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
