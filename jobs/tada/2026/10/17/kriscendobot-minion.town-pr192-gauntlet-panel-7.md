Panel round 7 on PR #192 ended **must-fix**. `panel.sh` exited 0, so this is a real verdict and not an infrastructure error.

I ran it in single-round mode against `kriscendobot/minion.town` branch `fix/node-install-root-ownership`, with the PR's base pinned to SHA `30a4c62acd1b`. I did not fix anything or un-draft the PR.

- **Must-fix (archivist):** `DEPLOYMENT.md:1333-1336` says every deploy touching `/usr/local` calls `reclaim_usr_local`. `deploy/aws/ci-runner/host/bootstrap.sh:69-70` writes `/usr/local/sbin/ci-runner-controller` without it, and `ci-runner-controller.sh:249` puts `/usr/local/sbin` first on PATH. Either cover that host or narrow the sentence to the Node-era hosts.
- **Should-fix, main items:**
  - The first deploy deletes the old `/usr/local/bin/node` while units that haven't been redeployed still use it.
  - The `sudo()` wrapper looks unnecessary next to absolute paths plus `secure_path`.
  - The Node and system PATH is repeated in many places.
  - `reclaim_usr_local` runs on every deploy but is a one-time migration.
  - `system-path.sh:105` has a bare `dir` that should be `directory`.
- **Other should-fix:** there are more from other seats that I did not copy into the review. They cover the test suite's gaps, the PR description no longer matching the PR, and the PR body missing the project's template form.

The review is posted as a comment, not a request-changes review. GitHub refuses request-changes on the bot's own PR. The posted review summarises the must-fix and the main should-fix items. The full per-seat aggregate is about 82 KB, too long for a review body, so it stays in the run directory `/home/kris/garden/scratch/tmpexec/garden-panel-project-wt-kriscen-36baea616913-c3f661ac-192/round-1.md`.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr192-gauntlet-panel-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (518610 cached reads)
- Output: 2864 tokens
- Cost: $0.28808899999999993
- Wall-clock: 168s

<!-- garden-usage-end -->
