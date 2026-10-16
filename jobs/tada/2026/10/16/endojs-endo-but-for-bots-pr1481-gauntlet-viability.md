**PR #1481 viability report: endojs/endo-but-for-bots, "transparent session reconnect with Rekey" (session-reconnect Phase 3)**

PR #1481 has not been superseded and the reason for it still holds, so the gauntlet may begin. Per the stage rules I spent no clean, panel, fix, CI-wait or un-draft budget.

**PR facts:** The PR is OPEN and a draft, not merged. It was created 2026-10-16T20:01Z and has no comments or reviews yet. Head is `build/ocapn-noise-session-reconnect-rekey`. Base is `build/ocapn-noise-session-queue-2a16357`, which is the frozen head of Phase 2 (#1478).

Deciding question: Does `llm` (or any other open or merged PR) already implement transparent Noise session reconnect with Rekey (`op:session-hello` / `op:session-end`, epoch-advancing redial, exactly-once replay)? And is the design that motivates it still current?

Evidence:
- **Nothing on `llm` does this yet.** `packages/ocapn-noise/src/network.js` on `llm` has no `session-hello`, epoch or heartbeat machinery. Its only "reconnect" matches are comments about stale or unclaimed session handling. The latest `ocapn-noise` commits on `llm` are dependency bumps (2026-10-04 and 2026-10-11) and three settlement-deadline fixes (2026-10-01). None of them adds reconnect.
- **The design still calls for this work.** Design PR #252 is MERGED, and `designs/ocapn-noise-session-reconnect.md` on `llm` still has status "Proposed" with Phase 3 ("Reconnect with Rekey") listed as planned.
- **Nothing newer replaces it.** A search for reconnect / ocapn-noise PRs turns up only this PR's own stack, all opened 2026-10-16 by the same orchestrated job:
  - #1476: Phase 1, heartbeat
  - #1478: Phase 2, outbound queue
  - #1482: Phase 5, crossed-hellos, stacked on this PR
  - #1483: heartbeat capability negotiation
  - #1475: cryptographic review
- **The premise holds.** Phase 4 (Resume) is deferred pending the crypto review, and Rekey is the design's chosen path that doesn't need it. The phase ledger matches the design's phasing.

Caveat for later stages: this PR is stacked on #1478, which is stacked on #1476, and both are still open drafts. The gauntlet runs against the frozen Phase 2 base. Merging this PR depends on its predecessors landing first, but that does not affect viability.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1481-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (174637 cached reads)
- Output: 1910 tokens
- Cost: $0.4342154000000001
- Wall-clock: 29s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
