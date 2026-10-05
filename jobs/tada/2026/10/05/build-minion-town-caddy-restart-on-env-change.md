**Done:** draft PR https://github.com/kriscendobot/minion.town/pull/163 is open (head `fix/caddy-restart-on-env-change`, base frozen at `main-9ac858d`). All CI checks pass: `test` and both Claude harness checks. It has not been run against the live box.

**What changed:**
- **The two secret scripts** (`deploy-account-endpoint-secret.sh` and `deploy-billing-secrets.sh`): after writing `/etc/caddy/*.env` and the drop-in, they now run `caddy validate` and then **restart** caddy, instead of the old `reload || true`. If caddy isn't running yet, the restart is skipped. I also fixed the comments that claimed a reload picks up the new `{$VAR}`.
- **New `deploy/aws/scripts/lib/caddy-env-sync.sh`**: `common.sh` loads it into `$CADDY_ENV_SYNC` so it can be inlined into the SSM scripts. It has two helpers:
  - `caddy_env_in_sync` compares the SHA-256 of `ACCOUNT_GATE_TOKEN` and `BILLING_GATE_TOKEN` in the running caddy's `/proc/<MainPID>/environ` with the value in each env file. It skips a gate whose file is absent and never prints the secret.
  - `caddy_env_ensure` validates and restarts caddy when the hashes differ. If a restart still doesn't load the token (for example, a missing drop-in), it fails loudly.
- **`deploy-caddy.sh`**: runs `caddy_env_ensure` after the reload. This also covers item 3: an unauthenticated probe only ever sees the 302, so the hash compare is what catches an empty gate header.
- **Extra bug fixed in `deploy-caddy.sh`**: a comment inside the remote script had backticks, so the deploy host was running `caddy adapt` locally (`caddy: command not found`). I removed the backticks. My first draft of the secret-script comments had the same mistake, including a `{$…}` that would have failed under `set -u` on the deploy host; that was caught and fixed before committing.
- **Docs**: added a "Reload vs restart (gate tokens)" note to `DEPLOYMENT.md`, and updated its deploy-order text and the `deploy/aws/README.md` table.
- **Tests**: `test/caddy-account-routes.test.ts` now runs the helper against fake files for four cases: tokens match, token empty in the running process (the incident), token rotated, and file absent. Each test also checks that the secret never appears in the output. Further checks confirm the scripts validate, then restart, then verify, and that `deploy-caddy.sh` verifies after its reload. `shellcheck` is clean on the helper, and the generated remote scripts pass `bash -n`.

**Follow-up:**
- The first `deploy-caddy.sh` run after merge should print `ACCOUNT_GATE_TOKEN: running caddy matches /etc/caddy/account.env`.
- The secret scripts now restart caddy instead of reloading it, which causes a brief drop in service each time they run.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-caddy-restart-on-env-change.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1713844 cached reads)
- Output: 19426 tokens
- Cost: $1.3255448
- Wall-clock: 498s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
