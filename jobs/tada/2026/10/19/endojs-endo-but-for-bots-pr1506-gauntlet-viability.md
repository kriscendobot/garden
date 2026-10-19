Viability check for endojs/endo-but-for-bots PR #1506: **proceed**. The PR is still open and still needed, so the gauntlet can begin.

**PR facts:** The PR is open and unmerged, and still a draft. Its title is "fix(ocapn-noise): bind np sessionId to the Noise handshake hash (R2)". It was created 2026-10-19 and has no comments or reviews yet. It takes base `llm-330cf99` and head `build/ocapn-noise-session-id-r2` at `9298cd9`.

Deciding question: Does the base code (`llm` and the frozen `llm-330cf99`) still compute the `np` `sessionId` from the two peer keys alone, with no newer PR and no maintainer decision on #1475 Q2 (option 2) replacing this R2 fix?

Evidence:
- **The premise still holds.** On both `llm` and `llm-330cf99`, `packages/ocapn/src/cryptography.js:77` is `makeSessionId(peerIdOne, peerIdTwo)` and hashes only the sorted peer ids. That means every connection between the same two peers gets the same id, which is the cross-connection handoff replay window this PR closes.
- **Nothing newer touches this code.** The latest change to `cryptography.js` on `llm` is #475 (2026-08-30), a byte-handling refactor. The latest changes to `ocapn-noise/src/network.js` (2026-10-01) are settlement and shutdown fixes, none of them about the session id.
- **Nothing supersedes it.** Searching the repo for PRs mentioning `sessionId` turns up only #1506 itself and its siblings:
  - #1475 is the design review. It is open and its only review is a panel comment.
  - #1487 covers R1, R3 and R4. It is open and complements this PR rather than replacing it.
- **Q2 is still unanswered.** #1475 has no maintainer comments, so the option this PR provisionally took has not been overruled. The PR body says it should be closed if kriskowal picks option 2 instead. Nothing has triggered that yet, but it is worth keeping in mind during the panel.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1506-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (153660 cached reads)
- Output: 1784 tokens
- Cost: $0.37317999999999996
- Wall-clock: 31s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
