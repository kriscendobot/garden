Both review directives were already resolved by peer commit `ae0929f48d` (the current PR HEAD); I verified each against the live PR head and closed the loop on the body-level ask.

## Completion report

**Job:** Review directive on endojs/endo-but-for-bots PR #1227 (review 5273072032 by kriskowal, CHANGES_REQUESTED). Design-only PR: `designs/daemon-guest-bot-incarnation.md` + a `designs/README.md` row.

**Asks enumerated (2, both from this review):**
1. **Review body:** "revise this to reflect the features landed in Endo for provisioning wake-on-message pins for guests."
2. **Inline comment** on `daemon-guest-bot-incarnation.md`: prefer "append-only" over "immutable" — a formula once written can't be modified, but the graph grows and collects unreachable nodes.

**Preflight:** `pr-feedback-preflight.sh` returned exit 2 (HINT — correlated resolution present). I corroborated each ask against the live PR head (not the hint) before treating as a no-op.

**Resolution artifacts (verified on PR HEAD `ae0929f48d`):**
- **Ask 1 —** commit `ae0929f48d` ("docs(daemon): align guest bot design with landed pins (#1227)") wholesale re-aligned the design to the landed pin mechanism: `provideGuest(..., { pins })`/`@pins`, best-effort `reincarnateMailboxPins` on every delivery, the host-only pin directory, and `guestPins`/`hostPins` formula fields — explicitly retiring the original `GuestFormula.bot`/`EndoBot.start` protocol. Status set to **Implemented**, pointing at landed PR #1306. Verified in the fetched file at branch head (lines 10–27, 40–42, 59–67, 76–221).
- **Ask 2 —** same commit, lines 46–49: "Endo's persistent state is an append-only **formula graph**. A formula, once written, cannot be modified. The graph itself can grow… unreachable formulas can be collected, so describing the graph as immutable would be too strong." Peer also replied on the inline thread (comment id `4067898149`) citing `ae0929f48`.

**Action taken:** No design change was needed (both asks already satisfied). The inline thread had a reply but the review-body ask had no direct acknowledgment, so I posted one closing-the-loop comment naming the commit and the specific landed features: https://github.com/endojs/endo-but-for-bots/pull/1227#issuecomment-5770344783

**Garden repo:** No changes; nothing to commit/push to main2.

**Follow-ups:** None. The PR is CHANGES_REQUESTED pending kriskowal's re-review; both directives are demonstrably addressed on the head branch.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1227-review-5194e7b0.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 22 tokens (526200 cached reads)
- Output: 6789 tokens
- Cost: $0.9064369999999999 (1 engagement(s) unpriced)
- Wall-clock: 6317s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
