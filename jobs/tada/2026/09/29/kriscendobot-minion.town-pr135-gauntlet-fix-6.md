## Round-6 fixes for kriscendobot/minion.town PR #135: pushed, CI green

I fixed all four round-6 must-fix items and pushed three commits to `build/npm-minion-town-registry` with `safe-push-pr-head.sh` (a3ca6fc → 661a4ee). `ci-wait-merge.sh --no-merge` returned 0 with 3 of 3 checks passing and none failed.

**What changed:**
- **archivist (design references):** `designs/npm-minion-town-registry.md` is not in the repo yet. Every place that cites it now says the design is proposed in draft PR #134 and that its section numbers refer to that draft. That covers `DEPLOYMENT.md`, the README, the Caddy site, the dns/deploy/secret/backup scripts and the systemd unit. The unit's `Documentation=` now points at #134. Commit `c7da717`.
- **prover (schema-version check):** the check in `npm-registry-backup.sh` could never run, because the failing assignment before it already stopped the script under `set -e`. The check is now part of the assignment, so its error message prints. The test now asserts that message. Commit `4e1b971`.
- **engine-realist (60-second readiness limit):** the server verifies its whole store before it starts answering, so start-up gets slower as the store grows. With a fixed 60 s wait, a healthy restore or deploy would eventually be rolled back.
  - Every readiness wait now keeps polling `/-/ping` while the unit stays up. That covers backup, restore, the deploy switch, the deploy rollback and the secret delivery.
  - The ceiling is `NPM_REGISTRY_READY_TIMEOUT`, default 900 s. The wait gives up immediately if the unit fails or systemd restarts it.
  - `common.sh` gained an optional `SSM_POLL_TRIES` (default 120, as before). The deploy and secret scripts raise it to 1200 so their SSM poll outlasts the longer wait.
  - New tests cover a wait longer than a minute and hitting the ceiling. Commits `4e1b971` and `661a4ee`.
- **engine-realist (restore copies never cleaned up):** restore now deletes older rejected and staged copies and keeps the newest of each. Those copies duplicate a backup that still exists.
  - It deliberately keeps every pre-restore generation, because one may hold the only copy of packages published since the last backup.
  - The README says how to retire them: take a fresh backup, then `rm -rf`. A new test covers the cleanup.
- **scribe:** I posted the missing round-5 summary (comment 5882964913) and a round-6 summary (comment 5882965336).

The new vitest suites pass (34 of 34) and `npm run typecheck` is clean. `bash -n` passes on every changed script and on the remote script text they generate. Deploy and secret delivery were checked only for syntax, not run against the box.

**Follow-ups:** these should-fix and comment-only findings are not addressed in this round:
- migrator: check `schema_version` on restore.
- breaker: swap the state directory in through a symlink so the swap is atomic.
- assessor: report a failed restart after a failed backup.
- integrator: rewrite the `## Files` table in the PR body.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr135-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (3822727 cached reads)
- Output: 27122 tokens
- Cost: $2.1995134000000003
- Wall-clock: 637s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
