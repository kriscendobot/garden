## Panel round 4: kriscendobot/minion.town PR #183

Round 4 returned **must-fix**. I posted the verdict to the PR as a COMMENT review, because GitHub doesn't let the bot request changes on its own PR. The round-3 review had the same COMMENT shape.

**What I did**
- Made an isolated checkout of `kriscendobot/minion.town@build/inference-phase3-secrets` at head `8faa77a0e2d6`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh … 183 main-bc11010`. All 34 seats came back and the exit code was 0. The pre-pass seated the decomplector and forced its is-it-needed question; its answer was that both the prompt-origin gate and the `@secrets` vault are needed.
- Posted the review: https://github.com/kriscendobot/minion.town/pull/183#pullrequestreview-5499267763. It has a summary of must-fix items, selected should-fix items and one refuted finding, plus the full bodies of the request-changes seats. The other seats' bodies were left out to stay under GitHub's size limit, which the full panel output (90 KB) exceeds.

**The verdict**
- **Seats:** five request changes (typist, stylist, archivist, purist, pruner), eight approve, and the rest are comment-only.
- **Round-3 must-fix items:** these appear resolved, and no seat raised them again.
- **This round's only must-fix (stylist):** rename the new `tmp` local to something like `daemonTemporary` in the new "secrets" test in `test/endo-daemon-integration.test.ts:700`.
- **Should-fix items:**
  - In `types.ts`, `PromptOrigin` sits between `InferResult` and its JSDoc, so the old doc comment now attaches to the wrong type.
  - In `secrets-credential-vault.ts`, an exemption gives "`@endo/sha256` is not published" as its reason, which the purist rules don't accept.
  - In `cli-deployment.ts`, a connection-closed handler is added on every vault call instead of once.
  - When a `@secrets` call times out, the per-subject queue is released while the call may still be running.
  - `readState` still runs a migration and write as part of a read.
  - Some test gaps, and some comments that repeat DEPLOYMENT.md.
- **Refuted:** the archivist said DEPLOYMENT.md contradicts the code. I checked: it mixed up the root operator's MCP `infer` (`guest-tools.ts:640`) with the `/_internal/claude/infer` path. That path calls `agent.infer` (`wiring.ts:789`), so the docs are correct.

Nothing was changed on the PR branch or on main2, and there are no follow-ups beyond the gauntlet's next stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr183-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1336536 cached reads)
- Output: 7273 tokens
- Cost: $0.9710392000000003
- Wall-clock: 269s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
