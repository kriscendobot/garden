# Gauntlet fix round 2: kriscendobot/minion.town PR #135

I fixed every must-fix item from the round-2 panel review and pushed the fixes. CI is green on the new head `a79aa0f` (3 of 3 checks passed).

**Must-fix items:**
- **Port clash (integrator):** git.minion.town (kriscendobot/minion.town#136) already uses port 3003 on the same machine. The registry now uses 3004, which nothing on current `main` uses. That covers the unit, the Caddy upstream, the deploy/secret/backup health checks, and the README.
- **Rollback lost on re-run (breaker):** re-running a deploy with the same pin used to delete the only release you could roll back to. Each deploy now records that release in `/opt/npm-minion-registry/previous`, and a same-pin re-run keeps it. I simulated deploying A → B → B → C → C → A, and each time exactly the active and previous releases were kept.
- **Abbreviated names (stylist):** renamed `stateDir` to `stateDirectory`, the loop variable `dir` to `directory`, and `shimDir` to `shimDirectory`.
- **Missing summary comment (scribe):** posted a top-level comment covering both fix rounds, what was declined and why, and how it was verified: https://github.com/kriscendobot/minion.town/pull/135#issuecomment-5882137533

**Should-fix items I also fixed:**
- **Restore safety:** a restore is now rolled back unless the service both starts and passes its ready check. Before, a failed start with the new state in place was not rolled back.
- **Backups:**
  - The database is read as the service user, so no root-owned SQLite side files are left in the state directory.
  - The stored packages are copied into root-owned files instead of hard links, so a compromised service can't alter old backups.
- **Deploy script:**
  - On a first deploy, the script can no longer "roll back" by pointing `current` at itself.
  - A built release is reused only if both the pin and the Node version it was built for match.
  - The cleanup trap for the secret script is set before the upload, so an interrupted upload can't leave the token in S3.
- **Preflight script:**
  - It now also works on macOS `stat`.
  - It rejects a non-numeric free-space limit with one clear message and says so when the state path isn't a directory.
  - Three new tests cover these cases and the exact-limit case.

**Verification:** the preflight tests pass (7 of 7), every changed script passes a bash syntax check, and Prettier is clean. The provisioning scripts themselves haven't run anywhere, because this phase is still not live.

**Declined or deferred (reasons are in the PR comment):**
- A separate build user with no access to the live state. It should be done across all the deploy scripts at once, since `deploy-endo-daemon.sh` has the same problem.
- Yarn's `YARN_ENABLE_IMMUTABLE_INSTALLS=true`. It may break the `workspaces focus` install and can't be tested off the box, so it waits for the first live run.
- Confirming that the registry's `verify` command never migrates the database. That belongs in endojs/endo-but-for-bots#1362.
- A checksum check for the Node download. The existing deploy scripts all lack it, so it needs a separate pass over all of them.
- Regrouping the commits, which can happen at merge.

**Follow-up:** the design PR kriscendobot/minion.town#134 still says port 3003 in §§ 3–4. It should be updated to 3004 and ideally merged before this PR. I didn't touch it because it is a separate PR.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr135-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2275953 cached reads)
- Output: 19354 tokens
- Cost: $1.5899746
- Wall-clock: 499s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
