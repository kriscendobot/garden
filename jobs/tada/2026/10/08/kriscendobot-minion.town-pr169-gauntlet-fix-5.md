Fix round 5 for kriscendobot/minion.town PR #169 is done. I pushed both must-fix items as one follow-up commit, `6ac8c2a`, and CI is green.

The first CI run went red on `test/endo-daemon-integration.test.ts` › "reincarnates a guest-pinned Claude inbox responder after restart" (`expected true to be false`). That test is about the live Endo daemon and none of this PR's files touch it. It passed on all five earlier heads of this PR. I re-ran the failed job once and it passed, so I'm treating it as a flake. CI on `6ac8c2a` is green, with 0 of 3 checks failing.

**decomplector (drop the shared helper):**
- Removed `lib/guest-recovery-helpers.sh`, the `$GUEST_RECOVERY_HELPERS` loader in `common.sh` (the file is now back to its base content), and the `eval` in `deploy-account-endpoint-secret.sh`.
- `deploy-app.sh` now runs one inline check as its first remote action: `sudo grep '^GUEST_RECOVERY_KEY=' /etc/minion-mcp/account.env | tail -n 1 | grep -Eq '^GUEST_RECOVERY_KEY=[A-Za-z0-9_+/=-]{32,}$'`. If it fails, the script prints FATAL and exits. It never prints the key.
- The writer (`deploy-account-endpoint-secret.sh`) now only checks that the key is at least 32 characters. It no longer applies the character-class pattern.

**migrator (unconditional prerequisite):**
- The shipped `minion-mcp.service` sets `ACCOUNT_STORE=dynamodb`, so every CD host needs the key anyway. I chose to document that rather than gate the check on it.
- `DEPLOYMENT.md` now says `account.env` with a valid key is an unconditional CD prerequisite. It gives the one-time step for a fresh host: run `deploy-account-endpoint-secret.sh`, then re-run the deploy. It also notes that the existing `ACCOUNT_GATE_SHARED_SECRET` check reads the same file but only applies while Claude production is required.

**Should-fix items also handled:**
- The `minion-mcp.service` comment no longer suggests `account.env` is optional for CD.
- The test's `sudo` stub now fails if the script reads any path other than `/etc/minion-mcp/account.env`.
- The original 4a–4e step labels are back; the new preflight is labelled `4.0`.
- The writer-side test gap goes away, since the shared pattern no longer exists.

The 11 tests in `test/deploy-secret-preflight.test.ts` pass locally, and `bash -n` and prettier are clean.

**Not done:**
- The integrator/packager suggestion to squash the history (the add-then-remove commit arc) is still open. The job asked for follow-up commits, so I didn't rewrite history. It could be squashed before merge.
- The migrator suggestion to confirm that the live `minion/guest-recovery-key` matches the character class still needs an operator check. The risk is lower now that the writer only checks length, but the deploy-time preflight still enforces the class.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr169-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1468591 cached reads)
- Output: 11622 tokens
- Cost: $1.1632302
- Wall-clock: 833s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
