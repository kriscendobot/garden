**viability=proceed.** PR #1476 is still the main Phase 1 heartbeat implementation. Nothing newer has replaced it, and the problem it solves is still open on `llm`.

**PR facts:** #1476 is OPEN and draft, and `gh` reports it mergeable. Base is `llm-4ae452c`; head is `e530cc47c626`, a test commit pushed 2026-11-02T01:59Z. An earlier gauntlet ran 6 panel rounds and ended in pass (round 6, head `3a1750f7`). It was held as draft only because of the phase ledger (orchestrated-slice; successor `endo-but-for-bots-ocapn-noise-session-reconnect-phases-3-5`).

**Deciding question:** Is #1476 still the live Phase 1 implementation, with `llm` still lacking the session-liveness heartbeat it adds?

**Evidence:**
- **Premise still holds.** On `llm`, `packages/ocapn/src/codecs/operations.js` and `packages/ocapn-noise/src/network.js` contain no `heartbeat`, `op:ping`, `op:pong` or liveness code. `designs/ocapn-noise-session-reconnect.md` still has Status "Proposed". `llm` is only 4 commits past the PR's base, and the only ocapn-related file among them is `packages/ocapn-iroh/package.json`.
- **Not replaced.** A whole open draft stack is built on #1476's head: #1478 (Phase 2), #1481 (Phase 3), #1482 (Phase 5) and #1483 (capability bit and default-on, which says "Refs: #252, #1476, #1478"). Work was pushed to the PR today.
- **Two later duplicates exist and should be resolved.** #1502 (2026-10-19, which also has Phase 2 #1511 on top of it) and #1508 (2026-10-19) both implement Phase 1 again, putting the heartbeat in `@endo/ocapn`'s `client/heartbeat.js` rather than in the Noise network. Neither has landed. #1502's own gauntlet stopped when its viability stage reported an overtaken premise. These two are the redundant ones; they don't make #1476 obsolete.

**Follow-up for the maintainer:** choose one Phase 1 line. The #1476 line is the earliest and goes furthest (through Phase 5 plus default-on). If you keep it, #1502, #1508 and #1511 are candidates to close as duplicates. I changed nothing and posted no job.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1476-gauntlet-20261102-e530cc47c626-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (319354 cached reads)
- Output: 2810 tokens
- Cost: $0.5689748
- Wall-clock: 57s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
