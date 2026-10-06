Gauntlet fix round 6 for kriscendobot/minion.town PR #163 is done: I pushed one follow-up commit (`7c172b0`) to `fix/caddy-restart-on-env-change`, and CI is green on it (3 of 3 checks).

**The must-fix item (raised by breaker, engine-realist and integrator):** the deploy lock lived at `/run/minion-town/caddy-environment.lock`, but `/run/minion-town` is `minion-mcp`'s `RuntimeDirectory=`. On the live box, root doesn't own that directory, so the lock was never actually taken. And whenever the app restarts, systemd deletes the directory, which throws away a lock another script is holding.
- **New lock path:** the lock is now `/run/minion-town-deploy/caddy-environment.lock`, a directory no systemd unit owns.
- **Loud warning:** if the lock directory exists but belongs to another user, the helper now prints a `WARNING:` instead of the quiet "note: cannot lock".
- **New tests:**
  - the default lock path must stay outside every unit's `RuntimeDirectory=`, `StateDirectory=` and `ReadWritePaths=` under `deploy/aws/systemd/`;
  - a lock directory owned by another user triggers the warning. This test is skipped when the suite runs as root.

**Should-fix items and comments I also applied:**
- Both secret scripts (`deploy-billing-secrets.sh` step 4b, `deploy-account-endpoint-secret.sh` step 3b) now take the lock before writing caddy's environment file and drop-in. That stops a concurrent `deploy-caddy.sh` from checking caddy before the drop-in is loaded. The script-ordering test now checks this.
- A non-numeric `CADDY_ENVIRONMENT_RESTART_WAIT` now falls back to 30 seconds, with a note, instead of skipping the wait.
- The helper's header now says that `/proc/<pid>/environ` only shows the environment from when caddy started, which stops being true if caddy is ever run with `--envfile`.
- I rewrapped the over-long line in `DEPLOYMENT.md` and corrected its lock-path paragraph.
- I rewrote the PR body: shorter incident summary, the operator-behavior bullet cut down to a pointer to `DEPLOYMENT.md`, the corrected lock claim, and a concrete test statement. I kept a one-line post-merge check on the live box, which the pruner seat had asked to cut, because nothing has been verified against the live box yet.

The 42 tests in `test/caddy-environment-sync.test.ts` passed locally before I added the last two (non-numeric wait, lock outside unit directories). After adding them I only ran Prettier; CI ran the suite and passed. Shellcheck still reports two warnings in the helper (no shebang line, and `mkdir -p -m` applying the mode only to the last directory); I didn't change either.

**Decision for you:** I did not regroup the 8 earlier commits into 4 logical ones, as the integrator seat suggested. This stage only adds follow-up commits on top of the PR head; regrouping means rewriting the branch's history. If you want it before merge, it needs a retcon job.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr163-gauntlet-20261005-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1175978 cached reads)
- Output: 11735 tokens
- Cost: $1.1052636
- Wall-clock: 475s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
