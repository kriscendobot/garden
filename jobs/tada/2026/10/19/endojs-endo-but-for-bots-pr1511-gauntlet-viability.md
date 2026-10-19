**Gauntlet viability report: endojs/endo-but-for-bots#1511**

The gauntlet can start. PR #1511 is open and unmerged, nothing newer has replaced it, and the reason it was built still holds.

Deciding question: Is #1511 still the only implementation of Phase 2 of `designs/ocapn-noise-session-reconnect.md` (the session epoch and send queue), with that design still active on `llm` and its Phase 1 parent #1502 still open, unmerged and not replaced?

Evidence:
- **PR state:** open and in draft, with no merge conflicts. It was opened on 2026-10-19T22:42Z, a few minutes before this check. The head is `llm-ocapn-session-send-queue` at `df210891a8`. The base is the frozen `llm-ocapn-session-heartbeat-e8e42fb`, so it is stacked on #1502. It has no comments or reviews, so nobody has asked to close or redirect it.
- **Parent PR:** #1502 (the Phase 1 `op:ping`/`op:pong` heartbeat) is open and unmerged in draft, with base `llm-330cf99`. The stack is intact and the parent has not been replaced either.
- **Current `llm`:** `packages/ocapn/src/client/` has no `send-queue.js` and no epoch or queue code. The newest commit touching that directory is `3acee4a566` (#475, 2026-08-30), a byte-handling refactor that has nothing to do with this work. Searching PR titles for "send queue" finds only #1511.
- **Design:** `designs/ocapn-noise-session-reconnect.md` on `llm` is still marked "Proposed". Its last change was a rename on 2026-08-09. Its Phase 2 section (line 645) describes exactly what this PR delivers: the session-level epoch and queue, plus the simulated-stall fault test as its own consumer.

Note for later stages: #1511 is stacked on #1502, so it can only land after #1502 does, or once it is rebased onto a new frozen base. This doesn't block the gauntlet.

No clean, panel, fix, CI-wait or un-draft budget was spent, and no repository was changed.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1511-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (177623 cached reads)
- Output: 1647 tokens
- Cost: $0.42564859999999993
- Wall-clock: 35s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
