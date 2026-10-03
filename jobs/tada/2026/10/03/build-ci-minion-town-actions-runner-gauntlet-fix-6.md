Fix round 6 for kriscendobot/minion.town PR #145 is pushed as `31577bd` on `ci-minion-town-runner`, and CI is green on that head (`ci-wait-merge` rc 0, 3/3 checks). The new scrub has not run on the live CI host yet; only a local sandbox simulation exercised it.

**Must-fix and should-fix items from the panel-6 review (5399973642):**
- **Scrub trusted root ownership (assessor, saboteur, breaker):** `ci-runner-controller.sh` no longer uses an entry's owner or name as proof it is legitimate.
  - A new `snapshot_spared()` records every root-owned top-level entry in the scrubbed directories and everything beneath it, each with its inode, type, mode and owner.
  - The snapshot is taken once per boot, before the first job. It comes after the controller's first `aws` call, so the snap's private `/tmp` is recorded rather than deleted later.
  - Each scrub removes anything missing from the snapshot or no longer matching it, including anything new inside `/tmp/.X11-unix` or inside a root-owned 0700 directory.
  - A `systemd-private-$BOOT_ID-<unit>-*` directory survives only while a process in that unit's own cgroup has its `tmp` mounted, and only that `tmp` is kept.
  - There is a transitional path: if an older controller's `spared-entries` file exists, only its top-level entries are trusted.
- **Selftest coverage:** `ci-runner-selftest.yml` now uses docker to plant a root-owned file inside `/tmp/.X11-unix` and a root-owned `systemd-private-$BOOT_ID-…` directory, and `verify` checks that neither survives.
- **Type of the `gh` option (typist):** narrowed from bare `Function` to `(token: string, method: string, path: string, body?: object) => Promise<object | undefined>`.
- **Secrets table (integrator):** DEPLOYMENT.md's "Maintainer must create first" table now lists `minion/ci-runner-github-token`.
- **Summary comment (scribe):** posted at https://github.com/kriscendobot/minion.town/pull/145#issuecomment-5969901976, mapping this push to each item.

**Comment-only items also taken:**
- The `prune` and `tokenFromSecret` comments now describe what the code actually does.
- `tokenFromSecret` now rejects a token that isn't a string.
- New tests cover the exactly-100-runner pagination boundary, both sides of the year-2000 `mintedAt` boundary, and number, object and array tokens. All 16 minter tests pass, and shellcheck reports no warnings.
- DEPLOYMENT.md's CI runner section now explains the two name prefixes, says this host runs one job at a time so jobs queue, and says to check the host first when CI looks stuck across the repo.
- The PR body no longer tells the story of the red first run, and its rollout steps now include a reboot.

**Checks run:**
- I ran the scrub logic in a local sandbox with my own user standing in for root. Planted files, a newline-named file, a fake systemd private directory and a chmodded kept directory were all removed, and the snapshotted entries were kept.
- The live-mount check for a real running service could not be tested without root.

**Follow-ups:**
- **Live host rollout (maintainer):** to put this on the host, redeploy the minter Lambda first, then re-converge the host, reboot it so the scrub takes a fresh snapshot, and run the selftest.
- **Not taken:** fast-checker's property tests, spec-keeper's ECMA-262 citations and duality-auditor's cross-reference note were not done this round. Coverage still can't be measured because the minter has no c8 setup.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ci-minion-town-actions-runner-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2713456 cached reads)
- Output: 31027 tokens
- Cost: $2.0901672
- Wall-clock: 987s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
