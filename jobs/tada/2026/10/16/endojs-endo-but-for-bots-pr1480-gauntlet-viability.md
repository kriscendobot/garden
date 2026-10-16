**Viability: proceed.** PR #1480 is open and still in draft, and it has not been superseded. The problem it was written to fix is still present on `llm`.

**Deciding question:** On current `llm`, does OCapN core still run the plaintext `op:start-session` fallback, with no `start-session` adapter extracted, and is there no newer design or implementation that displaces #1480?

**Answer: yes.**

**Evidence:**
- **PR state:** The PR is OPEN, not merged, and still a draft. It was opened 2026-10-16T19:41Z at head `d1c0d55c`. It has no reviews or comments yet. It changes two documentation files: `designs/ocapn-tcp-for-test-extraction.md` and `designs/README.md`.
- **Base is current:** The base is the frozen branch `llm-61cd656`. Comparing `61cd656...llm` shows `ahead_by=0`, so `llm` has not moved since the base was taken. That also means nothing newer has touched the ocapn design or code.
- **The premise still holds:**
  - `packages/ocapn/src/client/handshake.js` still exists on `llm`.
  - The `sendSessionHandshake` hooks are still in `client/index.js`, `client/types.js` and `netlayers/tcp-test-only.js`.
  - No `start-session` adapter exists on `llm`.
- **Overlap with #1430:** Open draft #1430, "design(ocapn): network-owned identity exchange (revise tcp-for-test extraction)", was opened 2026-10-07 and rewrites the same design file in a very similar way. #1480 is the newer of the two and does not mention #1430. #1430's gauntlet halted on 2026-10-07 (its clean stage ran out of retries), and it has had no activity since. So #1430 is the one at risk of being superseded, not #1480.

**Follow-up for the maintainer:** Two open draft PRs now rewrite `designs/ocapn-tcp-for-test-extraction.md`. They will conflict, so one should be closed.
- #1480 is newer and based on current `llm`, which makes #1430 the likely one to close.
- #1430 also carries changes #1480 doesn't: it updates `ocapn-noise-network.md` and its plan for migrating Iroh first. Some of its other edits now overlap open #1479, which also marks `ocapn-tcp-syrup-framing` Complete.

I spent no clean, panel, fix or CI budget, and changed no files.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1480-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (228036 cached reads)
- Output: 2348 tokens
- Cost: $0.4553272
- Wall-clock: 33s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
