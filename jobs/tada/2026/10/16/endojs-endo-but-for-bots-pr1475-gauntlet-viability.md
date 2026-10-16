**Viability report: endojs/endo-but-for-bots PR #1475**

PR #1475 ("docs(designs): OCapN-Noise cryptographic review of the as-built IK handshake") is open, unmerged and a draft. It is a design PR opened 2026-10-16T17:56Z by the designer job `endo-but-for-bots-ocapn-noise-cryptographic-review-design`. Its base is the frozen snapshot `llm-61cd656`, and it changes 3 files under `designs/`. It has no comments and no reviews yet.

Deciding question: Is there still no other review of the as-built OCapN-Noise IK handshake on `llm` or in an open PR, and does the shipped `ocapn-noise` code still use the IK pattern the PR reviews?

Evidence:
- **Nothing has replaced it.** The design doc `designs/ocapn-noise-cryptographic-review.md` was last changed on `llm` on 2026-02-28. That is the stale February XX/IK/XK draft this PR rewrites. No other PR, open or closed, has a title matching this review.
- **The base is still current.** Comparing `61cd656...llm` shows `llm` is 0 commits ahead of the frozen base, so no newer base history has overtaken it.
- **The premise holds.** `Noise_IK_25519` still appears in `packages/ocapn-noise/src/bindings.js`, `packages/ocapn-noise/test/_noise-ik-msg1.js`, `rust/ocapn_noise/src/lib.rs` and both READMEs. The recent ocapn-noise commits (2026-10-01 settlement and shutdown fixes, plus dependabot bumps) do not change the handshake pattern.
- **Related open PRs are follow-ups, not substitutes.** #1476 (op:ping/op:pong heartbeat, session-reconnect Phase 1) and #1072/#683/#684 (transport and session-id fixes) are separate work. None of them reviews the cryptography. The PR's R3 (Rekey rather than Resume) actually informs the reconnect line that #1476 starts.

Decision: proceed. The PR has not been superseded and its motivating need still holds. I spent no clean, panel, fix, CI-wait or un-draft budget and changed nothing.

Follow-up for later stages: the PR body itself says the deliverable needs sign-off from a contributor who knows cryptography, which the fleet cannot provide. It also leaves three questions for the maintainer: Q1 (is XK's initiator identity hiding worth the extra half round trip), Q2 (how to fix R2's `sessionId` problem) and Q3 (when to schedule a post-quantum `np/2`). The panel and un-draft stages should leave those to the maintainer.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1475-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (153322 cached reads)
- Output: 1751 tokens
- Cost: $0.3607563999999999
- Wall-clock: 43s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
