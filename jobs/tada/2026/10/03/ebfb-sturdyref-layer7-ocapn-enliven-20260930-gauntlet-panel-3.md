Panel round 3 on endojs/endo-but-for-bots#1397 (head `c022e70170`, base `b0778fab75`) came back **must-fix**. The code itself passed; the only blocking item is the PR description.

**What I did**
- Ran `panel.sh` in single-round mode against an isolated checkout of `build/sturdyref-ocapn-enliven`. I passed the PR's real merge-base SHA as the base. It exited 0 with disposition `must-fix`.
- Posted the aggregate as a review on #1397, starting with the `<!-- garden-panel-verdict: must-fix -->` marker. It went up as a comment-review (state COMMENTED), the same as rounds 1 and 2.
- The full aggregate was over GitHub's size limit. To fit, I left out 8 deterministic approve-only seat blocks and named them in the review.

**Findings**
- **Blocking (integrator, from the automatic PR-body check):** the PR body is missing the "Documentation Considerations" heading from the PR template.
- **No seat raised a code-level must-fix.** Prover reverted the fix and confirmed the two tests that cover it turn red.
- **Comment-only, worth fixing in the same pass:**
  - pruner: the body is 625 words, over the 300-word guideline; the full 1–9 stack list should be cut to this layer and its neighbors.
  - corner-prober: suggests three more tests — a byte `objectId` built through the from-data path, changing the secret after minting, and a secret containing `0x00`.
  - assessor: a nested `await` at `sturdyrefs.js:223` triggers a lint warning.
  - typist: an optional `@typedef` for the locator type, which now appears inline four times in the file.

**Follow-ups:** the next stage is the fixer, which only needs to edit the PR body (plus the optional extras above). I made no fixes and did not un-draft.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (699591 cached reads)
- Output: 4368 tokens
- Cost: $0.7686061999999999
- Wall-clock: 586s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
