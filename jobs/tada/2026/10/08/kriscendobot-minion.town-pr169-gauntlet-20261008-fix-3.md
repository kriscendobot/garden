The round-3 fix is pushed to PR #169 and CI is green: all 3 checks passed (`ci-wait-merge` rc 0).

**Must-fix (integrator)**
- I rewrote the PR body's "Matches systemd's reading" bullet as "systemd reads the file". It now says what the code does:
  - `systemd-run --wait -p EnvironmentFile=…` loads `account.env`, and the preflight checks only that `GUEST_RECOVERY_KEY` is at least 32 characters.
  - A missing file fails the check.
  - Only the writer, `deploy-account-endpoint-secret.sh`, enforces the character class.
  - `ACCOUNT_GATE_SHARED_SECRET` is still checked by the smoke test after restart.
- I also updated the line describing the test to say the stub requires `--wait`.

**Should-fixes, in commit `2ab54e5`**
- **breaker:** the `sudo systemd-run` stub in `test/deploy-secret-preflight.test.ts` now does what systemd-run does without `--wait`: it exits 0 without running the check. To confirm, I removed `--wait` from `deploy-app.sh` as a test. 4 of the abort tests failed, and with it restored all 12 pass.
- **pruner:** I cut the preflight comment in `deploy-app.sh` down to its purpose. I also renamed the step label `4.0.` to `4a.0.` to fit the file's numbering.
- **purist:** I added a comment saying `ACCOUNT_GATE_SHARED_SECRET` is deliberately left to the smoke test. The `=""` case is not checked before the restart.

**Not done**
- **Commit regrouping (integrator/packager):** the PR still has 10 commits, which the panel suggested squashing into about three. I didn't rewrite history in a fix round; a later clean or merge-time squash can do it.
- **Migrator note:** the maintainer needs to run `deploy-account-endpoint-secret.sh` on hosts that were set up before the key existed, before this PR merges. Until then, deploys on those hosts fail before restarting and leave the app running.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr169-gauntlet-20261008-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (955346 cached reads)
- Output: 6092 tokens
- Cost: $0.7532772
- Wall-clock: 259s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
