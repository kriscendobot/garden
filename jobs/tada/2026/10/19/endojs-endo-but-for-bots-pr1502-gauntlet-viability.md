**Viability gate for endojs/endo-but-for-bots#1502: overtaken.** I spent nothing on the clean, panel, fix or un-draft stages.

**Deciding question:** Is #1502 the only live implementation of Phase 1 of `designs/ocapn-noise-session-reconnect.md` (the `op:ping`/`op:pong` heartbeat), so that no earlier PR has already taken that slice?

**Answer: No.**

**Evidence:**
- **The PR:** #1502 is open and still a draft, with no reviews or comments. Its head is `llm-ocapn-session-heartbeat` at `e8e42fbe` and its base is `llm-330cf99`, which has no commits that `llm` lacks and lacks none of `llm`'s.
- **How it was opened:** job `build-ocapn-noise-session-reconnect-open-pr` opened it on 2026-10-19. Its duplicate check only looked for that job's own marker and head branch, so it never noticed an existing PR for the same phase.
- **The earlier PR:** #1476, "feat(ocapn,ocapn-noise): op:ping/op:pong heartbeat for Noise sessions (session-reconnect Phase 1)", was opened 2026-10-16 by job `endo-but-for-bots-ocapn-noise-session-reconnect-build`. It is still open as a draft. It implements the same wire operations in the same files (`codecs/operations.js`, `client/ocapn.js`, the codec tests and snapshot), puts the heartbeat in `ocapn-noise/src/network.js`, and its ledger marks Phase 1 as satisfied.
- **Later phases build on #1476:** #1478 (Phase 2) is based on #1476's head, and #1481 (Phase 3), #1482 (Phase 5) and #1483 (heartbeat capability bit, default on) follow in a chain, each based on the one before. Taking #1502 instead would produce a second, incompatible Phase 1: its heartbeat lives in the CapTP client rather than in `ocapn-noise`, so the existing Phase 2–5 PRs could not sit on it.
- **The premise still holds:** session liveness is still wanted, as the design and the #1476 stack show. But the slice #1502 delivers is already in flight, and it is the base the later phases depend on.

Option: close as superseded

**Follow-ups for the maintainer:**
- Close #1502 as a duplicate of #1476. If you want the heartbeat in the CapTP client, as #1502 does, rather than in the network layer, raise that as a review comment on #1476.
- The duplicate happened because the build job's duplicate check didn't catch #1476. It may be worth hardening that check.

I made no garden or project commits.

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1502-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (364527 cached reads)
- Output: 2809 tokens
- Cost: $0.5358294
- Wall-clock: 43s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
