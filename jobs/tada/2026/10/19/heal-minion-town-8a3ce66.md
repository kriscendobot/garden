Production is restored. Merge 8a3ce66 (PR #204) didn't cause the deploy failure, so I fixed it forward with PR #209 rather than reverting.

**Root cause:** the deploy failed at "Deploy npm development registry". The production box's root disk had 1018 MiB free, just below the registry preflight's 1 GiB minimum. So the service restart failed and `npm-minion-registry` crash-looped (restart counter about 900), and `npm.minion.town` returned 502. That same 502 also broke main's Claude-harness image builds in `test.yml`. PR #204 only changed CI test gating. The previous successful deploy (13:14Z) shipped the same endo pin, 8e53cc0f89a4. The space was taken by the systemd journal (1.4G) and unused Docker build cache (1.2G), both of which grow with no limit.

**What I did:**
- **Production:** over AWS SSM I vacuumed the journal to 500M, ran `apt-get clean` and `docker builder prune -f`, then restarted the registry. Free space is now 3.4G, the service is active, the loopback ping succeeds, and `https://npm.minion.town/@endo%2fcancel` returns 200. I left images, containers and release directories alone.
- **Forward-fix PR:** https://github.com/kriscendobot/minion.town/pull/209 (draft, base `main`, carries the `garden-heal: 8a3ce66…` marker). `deploy/aws/scripts/deploy-npm-registry.sh` now does the same cache cleanup on the box before restarting the unit whenever less than 3 GiB is free. I checked the shell syntax of the script and of the script it sends to the box; the change hasn't run in a real deploy yet. I opened the PR with `GARDEN_ALLOW_FLOATING_BASE=1` because the job requires base `main`, as earlier heal PRs #187 and #206 did.
- **Gauntlet:** staged as `kriscendobot-minion.town-pr209-gauntlet`.

**Follow-ups (not done):**
- The box needs a persistent journald `SystemMaxUse` cap and regular build-cache pruning. Without them the disk will fill up again.
- About 1.5G more could be freed by removing `/opt/*.failed`, `/opt/*.old` and `/opt/endo-revival-dry-run-20260916`. I left them because they may be wanted for debugging.
- Main's `test.yml` harness jobs and deploy should go green on the next push to main, or on a re-run now that the registry is back.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/heal-minion-town-8a3ce66.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1477471 cached reads)
- Output: 10204 tokens
- Cost: $1.0619021999999998
- Wall-clock: 240s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
