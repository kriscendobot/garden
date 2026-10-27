The probe-then-rebuild fix is on `main2` as `fd441b03005`. A worktree that gets a native module built for the wrong Node ABI is now detected and rebuilt inside that worktree only; the shared cache is never written.

**Why the existing ABI stamp wasn't enough:** warm caches were already keyed and stamped by Node module ABI (earlier commits `f8dd428`, `894f267`), yet the `claude-api-p1-registry` mismatch still happened. A prebuilt download or an install run under a different Node can put the wrong binary into a correctly labelled entry. So the stamp stays, and the fix is to actually load the module after provisioning.

**What `scripts/jobs/ensure-project-worktree.sh` does now:**
- **When it probes:** on a warm cache hit, after the existing reconcile step (the reconcile is what lets `yarn rebuild` run). On a cold build, before the result is copied into the cache, so a broken build is fixed first or never cached.
- **What it probes:** `better-sqlite3` first, by opening an in-memory database and running a query. Then any other package that has `binding.gyp` and a built `.node` file. This works on Endo's layout, where `better-sqlite3` is linked from workspace `node_modules` into the shared store.
- **Why construction matters:** I checked against a real cache entry on this host (built for ABI 137, host Node is 127). A plain `require('better-sqlite3')` succeeds, and only opening a database fails with the `NODE_MODULE_VERSION 137 … requires 127` error from the incident.
- **On mismatch or a missing binding:** the package directory is first copied off its links into the cache, then rebuilt in place with `yarn|pnpm|npm rebuild <pkg>`. A directory that resolves outside the worktree is refused.
- **Fallback:** only if that rebuild fails with EMLINK or a native-build abort does it reinstall with `YARN_ENABLE_SCRIPTS=0 YARN_NODE_LINKER=node-modules YARN_NM_MODE=classic` and then run an explicit rebuild. A cold build that still fails its probe, or needed this fallback, is not cached.
- **Skipped:** botanist (scripts-disabled) installs, since a rebuild would run install scripts. `GARDEN_SKIP_NATIVE_PROBE=1` also skips it.
- **Log lines:** `NATIVE-PROBE ok|mismatch|missing|inconclusive|skip`, `NATIVE-REBUILD ok|classic-fallback` and `WARN: NATIVE-REBUILD FAILED`. They are documented in a new "Native probe" section of the script header, with a dated note in `skills/local-verify/field-notes.md`.

**Tests:** `project-worktree-isolation-test.sh` has six new checks: matching ABI (cold and warm, no rebuild, links to the cache kept), mismatch from 137 to 333 rebuilt in the worktree with the cache unchanged, the EMLINK fallback order, an unrecoverable rebuild that warns and still hands back the worktree, and a cold build repaired before it is cached. I confirmed they catch regressions: disabling the copy-before-rebuild step, or the probe itself, makes them fail. The suite passes 64/0, local-verify 103/0, botany 7/0.

**Other problems I found and fixed:**
- **Three test suites were already broken on `main2`:** the isolation, botany and local-verify tests. Their fixtures predate `common.sh` needing `bin/` and `budget-road.sh`; the isolation test was failing 41 checks before I started.
- **Test pollution:** those same suites inherited the worker's `GARDEN_STATE` and were writing fake caches into the host's real `.garden-state/dep-cache`. I pinned them to their own fixture directories. I also deleted the leftover test-only directories (`endojs-abi-cache`, `endojs-npm-ci`, `endojs-pinned-abi-cache`, `endojs-warm`, `endojs-warm-cache`, `endojs-warm-fail`); no real clone uses those names.

**Follow-ups:**
- Repeated `NATIVE-PROBE mismatch` lines on hits from the same cache entry mean that entry holds a wrong-ABI binary. Delete its directory and the next fresh worktree rebuilds it. As the job asked, the fix never touches the cache automatically.
- The real Endo entry `000393cab6…-nodeabi-137` loads only under an ABI-137 Node. That's fine as long as the repository-pinned runtime is selected.
- Other test suites may also inherit `GARDEN_STATE` from the worker; I only audited the three that run `ensure-project-worktree.sh` with a fake garden root.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-project-worktree-native-abi-cache.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (4207837 cached reads)
- Output: 36003 tokens
- Cost: $2.5514194
- Wall-clock: 543s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
