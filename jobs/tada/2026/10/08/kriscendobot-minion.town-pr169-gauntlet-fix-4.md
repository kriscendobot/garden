I applied both round-4 must-fix items and the naming should-fixes to kriscendobot/minion.town PR #169. The new commit `6a12eb1` is pushed and CI is green (3/3 checks, `ci-wait-merge` rc 0).

**Must-fix items:**
- **integrator:** I renamed the PR to `fix(deploy): preflight GUEST_RECOVERY_KEY before deploy-app restarts minion-mcp`, so the merge-commit title no longer mentions the CD writer that was removed.
- **pruner:** In the PR body, the "Preflight only, no CD writer" history is now one line. The test checklist is now one sentence linking `test/deploy-secret-preflight.test.ts`. The body also now states that `ACCOUNT_GATE_SHARED_SECRET` is still checked only after restart, which was the decomplector's comment.

**Should-fixes, in follow-up commit `6a12eb1`:**
- **stylist, names:** `minion_mcp_secret_preflight` is now `guest_recovery_key_preflight`, and `MINION_MCP_SECRET_FILE` is now `ACCOUNT_ENVIRONMENT_FILE`. The log, error and comment text now name `GUEST_RECOVERY_KEY` instead of a generic "startup secret".
- **decomplector:** I removed the leftover `minion_mcp_secret_fetch` helper, whose "Tests redefine it" comment was false, and put `sudo cat` in its place. The tests already stub `sudo`, so they are unaffected.
- **stylist, tests:** `KEY_32` and `KEY_31` are now `VALID_KEY` and `TOO_SHORT_KEY`, and the expected strings match the new messages.
- **typist:** The `→` in the touched `# 4b.` comment in `deploy-app.sh` is now `->`.

`vitest test/deploy-secret-preflight.test.ts` passes 11/11, `bash -n` finds no syntax errors, and prettier passes on the test file.

**Not done:** I did not squash the earlier add-then-remove writer commits (`c37488c` through `8040303`), which the integrator listed as non-blocking. This stage pushes follow-up commits only, so that history can be squashed at merge if wanted. As instructed, I did not re-run the panel.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr169-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (930518 cached reads)
- Output: 6489 tokens
- Cost: $0.7808196
- Wall-clock: 381s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
