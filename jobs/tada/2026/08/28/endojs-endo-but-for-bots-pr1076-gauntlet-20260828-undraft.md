PR #1076 is now ready for review.

## Completion report

**Job:** Gauntlet UNDRAFT stage for endojs/endo-but-for-bots PR #1076 ("test(hardened262): pin %ThrowTypeError% intrinsic metadata"), iteration 6, panel passed.

**What I did:**
1. **Idempotence check** — `gh pr view` confirmed the PR was OPEN and `isDraft: true`, so this was not a no-op; proceeded.
2. **Advisory appellate pass** (advisory only, non-gating) — reviewed the diff: a new test262-style `test/intrinsics/ThrowTypeError/intrinsic-metadata.js` plus consistent baseline `passed`/`skipped` entries across all 24 sesNode/sesXs/xs scenarios. The skip note correctly documents the harness-wide module/lockdownModule-only property (`agentRunsScenario` in `scripts/test.js` drives only those scenarios). Nothing the panel systematically missed; no blocking concerns.
3. **Un-draft** — `gh pr ready` succeeded; PR now `isDraft: false`, `state: OPEN`.

**Changed:** PR #1076 draft → ready for review.

**Follow-ups:** None. This was the final gauntlet stage.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1076-gauntlet-20260828-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (161405 cached reads)
- Output: 1395 tokens
- Cost: $0.5190855
- Wall-clock: 28s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
