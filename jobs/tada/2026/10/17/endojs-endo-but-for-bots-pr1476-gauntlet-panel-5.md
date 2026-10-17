Panel round 5 on endojs/endo-but-for-bots#1476 came back **must-fix**. `panel.sh` ran in single-round mode, all 34 seats returned, and it exited 0.

- **Setup:** isolated project checkout of `endojs/endo-but-for-bots@build/ocapn-noise-session-reconnect-heartbeat` at head `6ef59e4f32`. The panel ran against the PR's frozen base `llm-61cd656` (`61cd656cb8d9`).
- **Seats asking for changes:**
  - **breaker:** the heartbeat interval keeps running after a transport `reader.next` rejection or a heartbeat `writer.next` rejection. The liveness limit for a consumer that stops reading is also not documented.
  - **pruner:** the PR-body concision check fired (301 words), and some comments and README rationale say the same thing twice.
  - **coverage-auditor:** no test sends `op:ping`/`op:pong` through the OCapN client between a peer with heartbeats on and one with them off. No test covers `writer.return` rejecting while `onClose` still fires.
- **Pre-pass:** the same mechanism drew must-fix findings in the two previous rounds, so the decomplector was asked whether the mechanism is needed. Its answer: keep it, but restructure it as a `makeHeartbeat` factory with a single `close(failure?)` path.
- **Other seats:** six approved (assessor, benchmarker, transplanter, thesaurus, procurer, reexport-auditor). The rest were comment-only.
- **Posted:** comment review https://github.com/endojs/endo-but-for-bots/pull/1476#pullrequestreview-5556232061 on commit `6ef59e4f32`. GitHub doesn't allow requesting changes on a bot-authored PR, so the must-fix verdict is in a comment review, the same as rounds 1–4. The aggregate was over GitHub's review-body limit, so the rest is in the follow-up comment https://github.com/endojs/endo-but-for-bots/pull/1476#issuecomment-6229717157, marked `panel round 5 (cont.)`.
- Following the job's instructions, I made no fixes and did not un-draft the PR.

Follow-up: the decomplector's restructure and breaker's teardown-on-rejection fix overlap, so the next fix-loop should handle them together. This is round 5 of the gauntlet and must-fix findings on the same mechanism keep coming back, so the maintainer may want to look at the PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1476-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1245532 cached reads)
- Output: 5720 tokens
- Cost: $1.2983464000000002
- Wall-clock: 221s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
