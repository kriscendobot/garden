**Gauntlet viability report: endojs/endo-but-for-bots#1483**

I only read state. I did not run clean, panel, fix, CI-wait or un-draft.

- **PR facts:** The PR is open, unmerged and still a draft. It was opened 2026-10-16T20:01Z with head `build/ocapn-noise-heartbeat-capability` @ `9cc41693a6`. Its base is the frozen Phase 5 head `build/ocapn-noise-session-reconnect-crossed-hellos-9376e7e`. It has no comments or reviews yet.
- **Scope:** It adds a heartbeat capability bit (bit 0 of the `op:session-hello` features), turns heartbeats on by default with a fallback to off, and has the daemon's OCapN-Noise network pass `heartbeat: {}`. It covers § Upgrade Considerations of `designs/ocapn-noise-session-reconnect.md`.

Deciding question: Has `llm` or any other PR already delivered heartbeat negotiation by capability bit, or dropped the design's "negotiate the heartbeat capability" requirement? If neither, this PR is still needed and not superseded.

Evidence:
- **The rest of the stack is open and unmerged.** #1476 (Phase 1), #1478 (Phase 2), #1481 (Phase 3) and #1482 (Phase 5) are all open drafts, and #1483 stacks on #1482. Nothing in the chain has landed.
- **`llm` has no heartbeat code.** `packages/ocapn-noise/src/network.js` on `llm` contains no `heartbeat` or `features` code. The last commits there (2026-10-01) are unrelated settlement and shutdown fixes.
- **No competing PR exists.** A title search for "heartbeat" finds only #1476 (its own Phase 1) and older iroh work (#452 merged, #453 closed), which covers a different transport.
- **The design still asks for this.** The design on `llm` (line 748 onward) still says sessions "would need to negotiate the heartbeat capability", and that the handshake on `llm` does not yet carry a capability-flag field. This PR adds exactly that field.
- **It isn't stale.** The PR is about an hour old and is the planned successor slice of orchestration `endo-but-for-bots-ocapn-noise-session-reconnect-phases-3-5`.

Phase 4 (Resume) stays deferred on Open question C1. That limits how much of the design's acceptance criteria this PR can satisfy, but it doesn't undercut the PR's own scope.

The answer to the deciding question is no on both counts, so the gauntlet may proceed. Because #1483 stacks on #1482, it can only merge after the rest of the stack (#1476 through #1482) lands.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1483-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (172598 cached reads)
- Output: 1758 tokens
- Cost: $0.4142476
- Wall-clock: 41s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
