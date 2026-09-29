The git.minion.town deploy is live end to end, and all four legs the job asked about checked out, so I filed no fix job. I didn't change DEPLOYMENT.md, because its phase-plan row 13 already reads **DEPLOYED (2026-09-29)**. I recorded the confirmation in a new memory entry instead.

- **CD run:** The merge commit `e922c49` of PR #136 carried `[skip deploy]`, so the push-triggered run was skipped on purpose. The change then shipped through three targeted manual dispatches of the deploy workflow, and all three succeeded:
  - `app`: run 36504820430
  - `git-remote`: run 36505018982
  - `caddy`: run 36505099472
- **systemd unit:** Checked read-only over SSM on `i-0380cd68b90020fad`. `minion-git-remote.service` is active and running as user `minion-git`, started at 00:50:46Z with 0 restarts. It listens on 127.0.0.1:3003 with public base `https://git.minion.town` and the TLS requirement on.
- **Caddy route:** `/etc/caddy/conf.d/git-remote.caddy` contains `git.minion.town { reverse_proxy 127.0.0.1:3003 }`, and Caddy is active.
  - `https://git.minion.town/healthz` returns 200 `{"ok":true}` with a valid certificate.
  - Plain http redirects (308) to https.
  - An unknown capability path returns 404 through Caddy to the app.
  - Plain http on the box's loopback returns 403, as expected with TLS required.
  - Before the `caddy` dispatch finished, the TLS handshake failed; it now serves correctly.
- **Route53 A record:** `git.minion.town` resolves to 13.56.17.18 publicly (dns.google, answered by the Route53 nameserver).

**What changed:** I added the memory entry `minion-town-git-remote-deploy-live.md` and a line for it in `MEMORY.md`. I made no repo commits and changed nothing on the production host.

**Not done or out of scope:**
- **Capability-URL round trip:** The live push/clone test in DEPLOYMENT.md § Validating the git remote after merge, step 7, was not run. It changes production data (create a partition, mint a token, push and clone, then revoke), and this job only covered the deploy legs. It is the natural next check if someone wants it.
- **Endo-directory-binding gap on PR #86:** Not touched, as instructed.
- **Daemon step failing on push deploys:** The last three push-triggered deploys failed at the "Deploy Endo daemon" step: the daemon restart stays in "activating" and the command exits with status 3. That is why #136 merged with `[skip deploy]`. This is a known problem with an open fix, kriscendobot/minion.town#130 ("fix(deploy): avoid daemon health-probe spawn race"). I didn't file a duplicate job, but #130 needs to land before push-triggered deploys work again.

## Manual gauntlet handoff

The completion guard found https://github.com/kriscendobot/minion.town/pull/130 ready without gauntlet coverage. A deduplicated maintainer action was recorded; the PR was not re-drafted and no gauntlet was staged.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/verify-git-minion-town-deploy.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1164808 cached reads)
- Output: 7792 tokens
- Cost: $0.9028816000000001
- Wall-clock: 154s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
