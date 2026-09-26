Review posted (COMMENTED — GitHub blocks request-changes on the bot's own PR, so the **must-fix** disposition is carried explicitly in the review header and body). The single panel round is complete; per this stage's contract I stop here — no fix, no un-draft, no loop.

## Completion report

**Job:** endojs-endo-but-for-bots-pr1084-gauntlet-panel-1 — gauntlet PANEL stage, round 1, PR #1084 (`docs: Design adaptive exo-stream pacing and buffer control`, draft, base `llm`).

**What I did:**
1. Resolved PR head → `endojs/endo-but-for-bots` @ `design/exo-stream-adaptive-pacing`; set up an isolated project worktree at HEAD `68face71c`. Panel base ref: the merge base `059e18d07`.
2. Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode. It fanned the **design panel** (7 seats: critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice) and aggregated to disposition **must-fix**.
3. Posted the aggregate as a `gh pr review` on #1084. Request-changes is impossible (GitHub forbids it on the author-bot's own PR), so it went in as a COMMENTED review with the **must-fix** disposition stated in the header and body.

**Panel verdict:** must-fix. Recurring request-changes themes:
- **critic/skeptic/pedant:** `readableblob-lines.md` is cited 4x but does not exist in the tree (fabricated/dangling provenance); `outstanding` counts arrival not consumption, undermining the central memory-bound claim; no cold-start value for `W`; no multi-stream/shared-CapTP fairness story; no end-to-end `lines()` verification.
- **ergonomist/decomplector:** the `buffer` "discriminated union" never names the discriminant for its object branches; `CreditController` contract unspecified; `makeCodelBuffer`/return-type noun mismatch; `alpha` co-scales two orthogonal axes.
- **copyeditor/pedant:** typist-hostile code points (`→ ⇒ ≤ ≥ × − · ∈ ∞`) and 14 em-dashes throughout; first-person "our" voice slip; list-capitalization inconsistency.

**Changed:** no code/garden changes — this is a review stage. One PR review comment added to #1084.

**Follow-ups:** the gauntlet's next stage (fix-loop) owns addressing the must-fix findings; not my stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1084-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 27 tokens (693546 cached reads)
- Output: 4362 tokens
- Cost: $0.9060710000000001
- Wall-clock: 340s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
