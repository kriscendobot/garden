I finished the rename on [PR #1594](https://github.com/endojs/endo-but-for-bots/pull/1594) (head `c13ac3d27a`, still a draft). GitHub reports it mergeable with no conflicts, and all 18 CI checks that ran on the final head passed (18 more were skipped by the path filter). The ledger now says `Disposition: deliverable`. I did not post a new gauntlet: one is already running on this PR, and it covers the rest of review.

**What I changed** (on top of the runtime slice, commit `5c55ded255`):
- **Tests and fixtures:** all 19 daemon test files that used the old names now use `makeManager`, `makeManagerPowers`, `makeManagerControlPowers`, `makeManagerDatabase`, `ManagerDatabase`, `workerManagerFacet` and `WorkerFacetForManagerInterface`. The two stand-in facet names follow suit. The interface rename also fixed two eslint `import/named` errors in `xs-worker-facet.test.js` that the runtime slice had left behind.
- **Comments and messages:** everywhere that named the old file names now names the `manager-*.js` / `bus-manager-*.js` files. That covers the daemon source and test comments, the startup usage error messages, the XS bundler script, the `@endo/daemon-cas` README and comments, the `go/engo` comments, `docs/daemon-binary-spec.md` and `packages/daemon/AGENTS.md`.
- **Changesets and design:** I added a changeset recording the rename and what stays the same: the `@endo/daemon` package, the `endo`/`endod` binaries, `ENDO_DAEMON_PATH`, and the on-disk state format. I updated the type names in five pending changesets. The design header and its three rows in `designs/README.md` now say Implemented.
- **Repository-wide search:** the PR description lists every remaining match and why it stays:
  - older design documents, which the design says not to edit after the fact, and released CHANGELOGs;
  - names for the OS process and the Rust interface (`killDaemonProcess`, `hostGetDaemonHandle`, `bench-daemon.js`, the legacy bundle name);
  - unrelated "daemon" names in other packages: agent-tools `makeDaemonEvaluate`, familiar `makeDaemonManager`, the thixotrope test helpers and the eslint `daemon` config.

**Verification:**
- **Local checks:**
  - Type check in `packages/daemon`: passed.
  - eslint in `packages/daemon`: 0 errors.
  - Type check from the repo root: 0 errors.
  - Formatting check: clean.
  - Daemon tests: 144 passed, 4 skipped, 0 failed.
- **One test file did not run locally:** `content-store-gc-invariants`, where I only changed a comment. The worktree path makes the `endo.sock` socket path too long; CI ran it.
- **CI on `c13ac3d27a`:** the main run passed after I reran one failed job, `sandbox-drivers`. Its bwrap "process group survived bounded cleanup" failure is the known flake that #1566 fixes, and it passed on the rerun.

**Two edits I took back out:** my comment fixes in `rust/endo/README.md`, `rust/endo/xsnap/src/host_aliases.js` and `.github/workflows/ci.yml`. Touching those files makes CI run the `test-ironhorse-oracle` job, which already fails on this base for unrelated reasons (the same 2 of 1711 cases fail on the build/endo-gateway PR). The design puts the Rust side out of scope anyway. Those three stale mentions plus the `endor.rs` "legacy Node.js daemon child" comment are now a small separate follow-up, noted in the PR. The PR history includes the two commits that revert them.

**Review:** the gauntlet `endojs-endo-but-for-bots-pr1594-gauntlet` was started when the runtime slice finished, and its clean step is currently in progress. Re-posting under the same name would do nothing. The gauntlet reads the ledger again after the panel review, so with `deliverable` set it will go on to take the PR out of draft. I messaged the clean-step job that the head branch moved.

**Follow-ups:**
- A small Rust-side comment pass, ideally after `test-ironhorse-oracle` is green on the base again.
- Pre-existing and left alone: `manager-webextension.js` imports a file that doesn't exist (`./daemon-webextension-powers.js`), and a comment in `_multiplayer-suite.js` mentions `guestDaemonNode`, which no longer exists.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-rename-to-manager-surface.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 180 tokens (10096422 cached reads)
- Output: 38410 tokens
- Cost: $3.9013964000000008
- Wall-clock: 6416s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
