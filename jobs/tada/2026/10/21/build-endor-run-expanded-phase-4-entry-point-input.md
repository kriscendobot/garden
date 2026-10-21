---
handed-off: build-endor-run-expanded-phase-4-entry-point-input-open-pr
deliverable-complete: false
---
# build-endor-run-expanded-phase-4-entry-point-input: completion report

Phase 4 is built and pushed, and the nested-path fix is in the same change. The draft PR is **not open yet**: this host's bot token gets a 403 on `createPullRequest` for endojs. I posted successor job `build-endor-run-expanded-phase-4-entry-point-input-open-pr`, pinned to `requires: host=endolin-garden-ece02cb4`, to open it. That job carries the full PR body.

**Branches on `endojs/endo-but-for-bots`:**
- **Head:** `feat/endor-run-entry-point-xs-mapper`, tip `d2d616e6b4`, two commits.
- **Base:** the frozen `endor-e0322c4`, at `e0322c405`. That is the `endor` branch tip, where Phase 3 landed.

## What changed

- **`endor run <entry.js>` works, using the XS-hosted compartment mapper (the design's Option B).**
  - A short-lived XS machine runs `mapNodeModules` and `captureFromMap` from `@endo/compartment-mapper` (`xsnap::mapper::map_entry_point`).
  - Its only write power, `endorRunWriteFile`, stores each archive file straight into the CAS.
  - The program then runs in a fresh XS machine through the same CAS-backed loading as the ZIP and directory forms.
  - Inputs are detected as the design says: a `.zip` extension or ZIP magic bytes means an archive, a directory means an unpacked archive, and anything else is an entry module.
  - An entry with no `package.json` above it is treated as ESM.
  - `--no-cas` with an entry module exits 2.
- **The mapper bundle.** The entry and its shims are new files in `packages/daemon/src/`. A new script, `packages/daemon/scripts/bundle-endor-run-mapper-xs.mjs`, builds them with the `xs` condition into `rust/endo/xsnap/src/endor_run_mapper.js`. That file is generated and gitignored, like the other XS bundles, and is about 850 KB.
- **Nested-path fix.** A new `ArchiveTreeBuilder` in `cas_archive.rs` replaces the flat `ingest_files` body. Every path component now becomes a nested CAS tree, so `app-v1.0.0/lib/util.js` loads from both ZIP and directory inputs. It rejects a path that is both a file and a directory.
- **SES fix (`ses` patch, changeset included).** The XS `Compartment` adapter had no `load()`, which the compartment mapper needs to walk a module graph without running it. Shim compartments now delegate `load()` to the shim loader.
- **Two choices that need review attention:**
  - The mapper machine does not lock down. Lockdown would freeze `ModuleSource.prototype` before `@endo/module-source` can add its accessors, and the mapper never runs application code.
  - The text-codec bootstrap in `lib.rs` moved into a shared `NATIVE_TEXT_CODEC` constant so both machines install it the same way.
- **Docs.** The design's Status section now records Phase 4 and the nested-path fix, and `rust/endo/README.md` and `endor help run` are updated.

## Verification

- **Tests:** `cargo test --lib` in `rust/endo` passed 81 of 81 on three runs. There are eight new tests.
- **Regression evidence:**
  - Both nested-path tests fail on the old code: the nested source comes back `None`, and the tree has `["lib/util.js"]` where `["lib"]` is expected.
  - The entry-point test fails with `TypeError: call: not a function` when the bundle is built without the SES `load()` adapter.
- **By hand:**
  - `endor run hello.js` (which imports `./lib/greet.js`) printed `hello from entry point`.
  - Running it again gave the same root hash, and `endor run --cas <hash>` re-ran it.
  - A directory and an extension-less ZIP, each with a nested module, both ran.
  - An entry with an ESM `node_modules` dependency ran.
  - A missing entry gives an error that names the path.
- **Pre-push gates:** all pass except `yarn lint:fix`. That failure is the repo's own script: Yarn 4 passes the literal `--` through, so ESLint reads `--fix` as a file pattern. It isn't caused by this change, and ESLint and Prettier are clean on the files I touched.
- **Not run:**
  - The xsnap crate's own test suite.
  - The build used placeholder `ses_boot.js`, `worker_bootstrap.js`, and `daemon_bootstrap.js`. Their bundler isn't in this tree, and none of them are on the `endor run` path.
- **Test setup:** the XS-backed tests share a mutex. XS's quiesce loop reads one process-global pending-jobs flag, so parallel machines made them flaky. That flag predates this change.

## Follow-ups

1. **Open the PR.** The successor job above does this. Naming the PR in its report stages the gauntlet.
2. **Phase 5.** CommonJS modules are captured into the archive, but the archive runner doesn't execute them yet, and it fails silently. Registry-table resolution is also still missing.
3. **Older Phase 4 PR.** #279 (on `llm`) is a separate Phase 4 attempt that builds the archive in Rust instead of running the mapper in XS. The maintainer may want to close it or reconcile it with this one.
4. **Hash change for deep archives.** Archives with files more than one level deep now ingest to a different, correct root hash, so a hash recorded earlier for such an archive won't match a fresh ingest.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endor-run-expanded-phase-4-entry-point-input.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 260 tokens (21894662 cached reads)
- Output: 87894 tokens
- Cost: $8.118308400000002
- Wall-clock: 3838s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
