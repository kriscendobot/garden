I opened draft PR **endojs/endo-but-for-bots#1590**, which adds Phase 3 of `daemon-worker-import-from-mount`. It stacks on #1559, and the new daemon and CLI tests pass locally.

**What changed**
- **Daemon (`@endo/daemon`):** a new `EndoHost.makeFromMount` checks the mount's root once. A `compartment-map.json` sends it to `makeFromTree`, and a `package.json` sends it to `makeFromPackage`. When both are present, the compartment map wins. A root with neither is refused, and so are the package-only options (entry, registry, offline) on a compartment-map root. It has an interface guard and type, and the daemon tests for it went from 4 to 10.
- **CLI (`@endo/cli`):** `endo run` and `endo make` take `-m,--mount <name> [entry]`, plus `--registry <name>` and `--offline`, which both require `--mount`. The shared logic is in the new `packages/cli/src/mount-caplet.js`.
- **CLI tests:** the new `packages/cli/test/run-mount.test.js` has 13 tests against a private daemon and a local test registry. They cover the four tests the design lists for Phase 3: `endo run` on a mount, `endo make` on a mount, `--offline` after the registry has the packages, and `--offline` failing cleanly when a dependency is missing.
- **Also:** two changesets, the design's Phase 3 status note, the date in `designs/README.md`, `@endo/tar` added as a dev dependency, and a separate `chore: Update yarn.lock` commit.

**Where I departed from the design** (both are in the PR body and the design note)
- **The mount is a flag, not a bare argument.** The design shows `endo run <mount-pet-name>`, but that argument already means a file path for the existing form, and a pet name can't be told apart from a path.
- **The root check runs in the host, not in a worker.** The host already holds the source, and both downstream methods check their own root shape.
- **I renamed `run`'s `args` parameter to `programArguments`.** The new code reads it, and the pre-push gate rejects the abbreviation on added lines.

**Checks**
- **Passed:** both new test files, `yarn lint` for `cli` and `daemon`, the repo-root `tsc -p tsconfig.json` (it needed an 8 GB heap locally), the pre-push gates, the phase-evidence gate, and the related-design gate (clear for #241 and #1117).
- **Not run as a suite:** the existing CLI demo tests. Their daemon socket path is 110 characters in this checkout, over the ~104 limit. I checked the `endo run runlet.js a b c` case by hand after the rename and the output matched.
- **Not waited for:** CI.

**Things to know**
- `ensure-pr.sh` required a fixed base, so I pushed a snapshot branch `daemon-worker-import-from-mount-6d40c78` and the PR targets it. If #1559's head changes during its fix loop, #1590 will need restacking.
- Local environment: the shared `better-sqlite3` native module was built for a different Node version. I put a Node 22 prebuild into this worktree's own copy; the shared one is untouched.
- Out of scope: snapshotting a live mount before import is Phase 4.

The gauntlet should be staged automatically when this job completes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-worker-import-from-mount-phase-three-cli.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 190 tokens (13644667 cached reads)
- Output: 54542 tokens
- Cost: $5.383405400000001
- Wall-clock: 2714s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
