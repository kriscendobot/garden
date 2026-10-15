I fixed the panel-1 must-fix items on PR #187, pushed one follow-up commit (`5d75e85`) to its head, and CI is green.

**Must-fix items and how each was handled**
- **The test only checked a substring (prover, saboteur, packager, corner-prober).** I replaced that assertion with a behavioral test. It runs the new helper with only stub `sudo`, `apt-get` and `setfacl` on the PATH and covers five cases:
  - `setfacl` present: no apt calls at all.
  - `setfacl` missing: `update` and then `install`, both run non-interactively with the dpkg lock timeout.
  - Index refresh fails: it falls back to the cached package lists and still succeeds.
  - Install fails: it exits non-zero.
  - No `apt-get` on the host: it exits non-zero and names the package to install.
  
  The test also checks that each installer calls `ensure_setfacl` inside the endo-gateway-gc grant guard, before the first `setfacl -m`.
- **Only `apt-get`, with no guard (transplanter, migrator).** The helper now checks that `apt-get` exists and says the deploy host is Ubuntu 24.04 (per `DEPLOYMENT.md`). Any other host fails with a clear message naming the `acl` package.
- **No non-interactive mode or dpkg lock timeout (saboteur, transplanter, breaker, corner-prober).** apt now runs as `sudo env DEBIAN_FRONTEND=noninteractive apt-get -o DPkg::Lock::Timeout=120 …`.
- **The install block was copied into both deploy scripts (packager).** It is now one shared helper, `deploy/aws/scripts/lib/ensure-setfacl.sh`. `common.sh` loads it as `$ENSURE_SETFACL` and both scripts paste it into their remote scripts, the same way `install_secret` already works.

**Doc and PR-body items**
- `DEPLOYMENT.md` now says that either deploy installs `acl` when `setfacl` is missing, and that this needs sudo and access to the package mirror (archivist).
- I rewrote the PR body: I removed the bullet that restated the diff and the line counting gate stages (pruner), stated the Ubuntu/apt assumption (gateway), and pointed the Verification section at the targeted test.

**Checks**
- The targeted test file passes (6 tests). `tsc --noEmit` is clean, and both scripts plus their rendered remote scripts pass `bash -n`.
- I also ran the neighboring deploy-secret and caddy-environment-sync test files, but my output cut off their pass/fail line, so I can't confirm their result.
- `ci-wait-merge` exited 0: 1 of 1 Actions runs, 0 failed. As on earlier runs, this bot token can't read the PR's combined status checks, so the script fell back to the Actions runs API. Commit statuses and checks from outside Actions weren't visible to it.

**Follow-ups**
- The shell this host's gardeners use sources a startup file that resets PATH. The test handles this by setting PATH again inside the shell.
- I did not add the optional extra wording to the in-script comments.
- No coverage report exists for coverage-auditor; that is unchanged.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr187-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1787891 cached reads)
- Output: 15753 tokens
- Cost: $1.3145582
- Wall-clock: 1262s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
