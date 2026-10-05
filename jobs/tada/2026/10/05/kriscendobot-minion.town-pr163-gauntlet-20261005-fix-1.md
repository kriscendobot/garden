Fix round 1 for kriscendobot/minion.town#163 is pushed and CI is green. I applied the panel's must-fix items as one follow-up commit on `fix/caddy-restart-on-env-change` (92ae00d → 80ca7db), pushed with `safe-push-pr-head.sh`.

**What changed, by reviewer:**
- **Assessor and integrator (unconditional restart, pasted block):**
  - The two secret scripts (`deploy-account-endpoint-secret.sh`, `deploy-billing-secrets.sh`) no longer contain the copied validate → restart → is-active block. Both now call a single new helper, `caddy_environment_ensure_if_running <TOKEN>`.
  - The helper restarts caddy (after `caddy validate`) only when the running token's hash differs from its EnvironmentFile. It skips a fresh box where caddy isn't running yet.
  - So re-running a secret script with nothing changed no longer bounces caddy.
- **Integrator (garbled comment):** the half-rewritten ordering comment in `deploy-billing-secrets.sh` now uses the same wording as the account script. The final log lines no longer claim caddy was always restarted.
- **Stylist (abbreviated names):** I spelled out `env` everywhere. The library is now `lib/caddy-environment-sync.sh`, with `CADDY_ENVIRONMENT_{SYNC,SUDO,PAIRS}` and `caddy_environment_{hash_of,in_sync,ensure}`. The doubled name became `caddy_running_environ_path` / `CADDY_ENVIRON_OVERRIDE`, and the loop variable `var` became `token_name`. `common.sh`, `deploy-caddy.sh` and `DEPLOYMENT.md` are updated to match.
- **Corner-prober:**
  - `caddy_environment_in_sync` now returns 2 when a restart can't fix the problem: the file defines an empty value, caddy has no MainPID, or `/proc/<pid>/environ` can't be read. `caddy_environment_ensure` then fails without restarting and names the real cause, instead of blaming the drop-ins.
  - The tests moved to a new `test/caddy-environment-sync.test.ts` (15 tests), with `systemctl`, `caddy` and `sleep` stubbed on PATH.
  - They cover the production MainPID path (MainPID 0, unreadable environ), an empty file value, `=` inside a value, and the last assignment winning. They also check the restart decisions: no restart when in sync, validate before restart, failure when a restart doesn't load the token, and the fresh-box skip.
  - The old test block and its imports were removed from `caddy-account-routes.test.ts`.
- **Pruner:** I removed the per-file bullet tour from the PR body and kept Summary + Tests. The note about the heredoc backticks stays.

**Checks:** the two caddy test files pass locally under vitest (25 tests), along with prettier and `bash -n`. The first CI run went red: an unrelated live-daemon test, `test/endo-daemon-integration.test.ts` (@sites units 1-5), timed out after 120s. The previous head passed that suite, so I re-ran only the failed job once, and it passed. `ci-wait-merge` then returned rc 0, with all three checks green.

**Not done (should-fix or comment-only):**
- Splitting the Prettier reflow into its own commit would mean rewriting the PR head's history.
- A static test that every `caddy.service.d/*-token.conf` drop-in has a matching `CADDY_ENVIRONMENT_PAIRS` entry, so a third gate token can't be half-wired.

Nothing has been run against the live box yet.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr163-gauntlet-20261005-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1513255 cached reads)
- Output: 18633 tokens
- Cost: $1.3322709999999998
- Wall-clock: 679s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
