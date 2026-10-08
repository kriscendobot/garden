I applied the panel's one blocking fix to PR #94 and pushed it. CI never ran, though: GitHub Actions refused to start the jobs because of the account's payment/spending limit. So this fix is not CI-verified, and the result is `fix=ci-billing-blocked`. The maintainer has already been alerted.

**The fix (commit `1b0e652`, pushed on top of `e8518a2`).** The round-1 panel's only blocking finding (from the decomplector seat) was about how three deploy scripts handle secrets. `deploy-account-endpoint-secret.sh`, `deploy-billing-secrets.sh` and `deploy-oauth2-proxy.sh` each saved downloaded secrets to a temporary directory under `/tmp`, guarded by `umask 077`, `mktemp -d`, a cleanup `trap` and `rm`. I removed all of that. The scripts now use the pattern already in `deploy-npm-registry-secret.sh`:
- **Streaming:** `curl … | sudo install -m 0600 -o root -g root /dev/stdin <dest>.new`, then `mv` into place. No secret is ever written to `/tmp`.
- **No empty installs:** `pipefail` is on, so a failed download cannot install an empty file and replace a working one. In the oauth2-proxy script it is switched on only around that block, because later status pipes would break under it.
- **oauth2-proxy client secret:** it is now read from the env file already installed at `/etc/oauth2-proxy/oauth2-proxy.env`. It streams into a 0400 file owned by `oauth2-proxy`, is checked non-empty with `sudo test -s`, then moved into place.
- **Directories:** with umask gone, the PR's `install -d -m 0755` workaround is no longer needed, so they're back to the original `mkdir -p`.
- **Side benefit:** removing the cleanup `trap` also clears the panel's worry that it could overwrite a trap set by the caddy lock helper.

**Tests.** In `test/caddy-environment-sync.test.ts` I pointed the existing ordering check at the new install line. I also added a test that none of the three scripts saves a secret under `/tmp`, uses the old temp directory, or skips `pipefail`.

**Checks:**
- **Shell:** all three scripts pass `bash -n`, both as files and with the remote script they send to the server filled in.
- **Changed test file:** 43 of 43 pass.
- **Full `npm test` suite:** 946 pass and 1 fails. The failure is `test/git-remote/capability.test.ts`, "propagates a git failure rather than reporting the ref absent". That file is outside this PR's changes, and it is a known failure caused by this host's environment.

**Not done here:** the panel's non-blocking suggestions:
- the two Basic-auth parsers disagree on scheme case;
- `+` is decoded wrongly per RFC 6749 § 2.3.1;
- 401s lack a `WWW-Authenticate` header;
- a request sending credentials both ways is accepted;
- `secretsEqual` is duplicated in two places;
- `/token` logs nothing when Secrets Manager fails;
- squashing the fixup commits before merge;
- confirming every relying party sends client credentials before deploy.

I left all of these out because this stage applies only must-fix items. Once Actions billing is fixed, CI needs to run on `1b0e652`.

<!-- gauntlet-stage-result: fix=ci-billing-blocked -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr94-screen-e8518a2f-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1402106 cached reads)
- Output: 9883 tokens
- Cost: $1.0389291999999999
- Wall-clock: 196s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
