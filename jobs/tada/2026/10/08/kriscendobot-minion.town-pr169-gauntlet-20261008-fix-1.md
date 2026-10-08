Fix round 1 for kriscendobot/minion.town PR #169: the panel's one must-fix item is done, the follow-up commit is pushed, and CI is green on the new head (3 of 3 checks).

**Must-fix (pruner).** I rewrote the PR description from 378 words down to 215, under the 300-word budget. The per-file bullets and the `DEPLOYMENT.md` bullet are gone. Following decomplector's note, the "Why" section now says in one sentence what the preflight adds. The existing smoke-and-rollback chain already undoes a bad deploy. The preflight just stops it before the restart, so there is no blip and the error names the cause instead of leaving it in journal output.

**Should-fix items also applied,** in commit `ff76caa`, pushed with `safe-push-pr-head.sh` as a fast-forward from `d3f982c`:
- **saboteur / wire-watcher:** The preflight in `deploy-app.sh` now picks up key lines the way systemd's `EnvironmentFile=` reads them, including indented lines and spaces around `=`. It fails unless the last such line is in the writer's standard form. New tests cover:
  - a valid key followed by an indented short one
  - a valid key followed by a spaced short one
  - an indented line holding a valid key
- **engine-realist / integrator:** A new test reads the `length < 32` minimum from `src/auth/stores/dynamodb.ts` and asserts that both scripts use the same `{32,}`.
- **transplanter:** The two test suites that run shell commands now skip on Windows (`describe.skipIf(win32)`).
- **purist:** The comments in `deploy-account-endpoint-secret.sh` and `minion-mcp.service` now say the gate is disabled by dropping the `ACCOUNT_GATE_SHARED_SECRET` line, not by removing the file.

The test file passes locally (19 of 19).

**Not done:**
- I did not regroup the eight commits into about three, as integrator and packager suggested. That needs a force-push rewrite, and it was not a must-fix item. A squash merge would cover it.
- I left the three comment-only notes as they were: the `4.0` step label, `LC_ALL=C`, and the test helper's `eval`.

I did not re-run the panel; the driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr169-gauntlet-20261008-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (664910 cached reads)
- Output: 6364 tokens
- Cost: $0.718382
- Wall-clock: 402s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
