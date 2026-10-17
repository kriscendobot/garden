Panel round 8 on kriscendobot/minion.town#192 came back **must-fix**.

**What I did**
- Checked out the PR head `fix/node-install-root-ownership` (at `e33f970`) in an isolated worktree, `scratch/project-wt-kriscen-1195e8e90203-c3f661ac`.
- Ran `panel.sh` in single-round mode against base `origin/main-30a4c62`. It exited 0 with the verdict `must-fix`. All 34 seats returned a report.
- Posted the review on #192 as a comment (2026-10-17T02:22:18Z). GitHub won't let the bot request changes on its own PR, so this has the same shape as rounds 6 and 7: a must-fix heading plus a `garden-panel-verdict: must-fix` marker. I didn't fix anything or un-draft the PR.

**Findings**
- **Nine seats requested changes:** archivist, engine-realist, integrator, locksmith, migrator, saboteur, decomplector, purist and pruner.
- **The same mechanism keeps failing.** Rounds 6, 7 and 8 all raised must-fixes against `system-path.sh`, `install-node22.sh` and the `sudo` wrapper. The decomplector recommends deleting the `sudo()` wrapper and calling `reclaim_usr_local` once in the shared prelude, instead of at four call sites.
- **The must-fix list:**
  - **Node binary deleted too early:** `reclaim_usr_local` removes `/usr/local/bin/node` before the gateway, git-remote and gc units are rewritten. Any restart in that window fails. `deploy-oauth2-proxy.sh` also runs the cleanup without checking that the new Node exists.
  - **One service left behind:** `endo-ocapn-daemon.service` is installed by hand and no deploy reinstalls it, so its next restart takes `wss://minion.town/ocapn` down.
  - **Security:** the recursive `chown` to root makes any file the build user planted look trusted. That includes `/usr/local/bin/oauth2-proxy`, which the deploy then runs as root.
  - **Missing checks:** four other scripts and one runbook use `/opt/node/current` without checking that it exists.
  - **Docs out of date:** `DEPLOYMENT.md` and the PR description contradict the code. The description still calls the `/usr/local` cleanup a manual step, but the diff does it automatically.

**Follow-ups**
- The next fix loop should consider the decomplector's simplification rather than another round of patches, given the repeated must-fixes.
- Two design docs outside this PR still show `/usr/local/bin/node`: `designs/mcp-endo-guest.md:91` and `designs/ocapn-iroh-validation-lane.md:163`. A cleanup job could be filed separately.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr192-gauntlet-panel-8.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (873392 cached reads)
- Output: 6170 tokens
- Cost: $0.7566704
- Wall-clock: 333s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
