# Gauntlet FIX round 4: kriscendobot/minion.town PR #192

I applied the panel-4 must-fix items and pushed two follow-up commits to `fix/node-install-root-ownership` (efab329 → 0a9b72b → 46ef5fc). CI is green on the new head: `ci-wait-merge.sh` returned rc 0, and the run for each commit passed.

## What changed
- **Commands come only from system directories** (locksmith, saboteur, wire-watcher):
  - The three remote deploy scripts (`deploy-app.sh`, `deploy-endo-daemon.sh`, `deploy-npm-registry.sh`) now set `PATH=/usr/sbin:/usr/bin:/sbin:/bin` before anything else runs.
  - `ssm_invoke` starts the remote script through `/usr/bin/base64 -d | /bin/bash`.
  - `install_node22` sets that PATH again before `flock`. Tests can override it with `INSTALL_NODE22_PATH`.
  - The installer no longer calls `sudo`. Root already runs it, and `sudo` looks commands up through a path that lists `/usr/local/bin` first.
  - The key check that runs before the install now calls `sudo /usr/bin/systemd-run`.
- **Stamp read safely** (breaker): the installer reads the stamp only after every other check passes, and only if it is a regular file, not a symlink. A FIFO or symlink there now triggers a reinstall instead of hanging the deploy.
- **Failed `find` stops the deploy** (engine-realist): every traversal's exit status is checked, including the symlink scan.
- **Default ACLs removed too** (saboteur): every `setfacl -b` is now `setfacl -b -k`.
- **Renames** (stylist): `userIdentifier` → `trustedUserNumericIdentifier`; the test helpers `run`/`calls` → `runNodeInstaller`/`readCallLog`.
- **Linux only** (transplanter): the installer test suite now runs only on Linux.
- **New tests**: commands planted ahead of the system path (with and without the override), FIFO and symlinked stamps, a failing `find` at each of its three call sites, a real default ACL. Two also cover the panel's summary-fix items: a two-process concurrency test (corner-prober) and a 100-run fast-check property for relative escaping symlinks (fast-checker).
- **Other tests updated** for the new PATH and absolute paths: `test/deploy-secret-preflight.test.ts` and `test/git-remote-partition-script.test.ts`.
- **Docs**: the DEPLOYMENT.md "Node ownership" bullet is updated.
- **PR body redrafted** (integrator, pruner): it now describes the final behavior and the security rule, drops the file tour and the "Step 2" paragraph, points to CI for verification, and lists what is out of scope.

## Notes
- **Local test failures specific to this host**: 3 installer tests fail here: "keeps a stamped install", "locks the directories…" and the new concurrency test. The first two also fail on the unmodified PR head on this host. This host's virtiofs filesystem makes the test prefix root-owned, so a trusted install can't be kept. CI on Linux passes all of them.
- **Still open (the PR body lists these as out of scope)**:
  - After the install, the deploy scripts' remaining `sudo <command>` calls still look commands up through sudo's path, which lists `/usr/local/bin` first.
  - The installer leaves alone any file in `/usr/local/bin` that isn't part of Node.
  - `ensure_setfacl` still runs `sudo env apt-get`, though only when `setfacl` is missing.
  - The installer still checks a fixed list of Node files instead of a manifest from the tarball (spec-keeper's should-fix).

  Panel-5 may raise these again.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr192-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 122 tokens (7196806 cached reads)
- Output: 48773 tokens
- Cost: $3.5882291999999993
- Wall-clock: 2825s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
