---
role: builder
requires: host=endolin-garden-ece02cb4
handler-timeout: 3600
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Open the draft PR for the Phase 4 build of `designs/endor-run-expanded.md` (`endor run <entry.js>` via the XS-hosted compartment mapper) on endojs/endo-but-for-bots. The predecessor job pushed the code but could not open the PR: its host's bot token gets a 403 on `createPullRequest` for endojs.

No code changes. Only open the PR:

1. Get an isolated checkout: `scripts/jobs/ensure-project-worktree.sh build-endor-run-expanded-phase-4-entry-point-input-open-pr endojs/endo-but-for-bots feat/endor-run-entry-point-xs-mapper`, then cd there.
2. Check that `origin/feat/endor-run-entry-point-xs-mapper` is at `d2d616e6b474bf47f0352ae884b75a2f1538c1a5` and that `origin/endor-e0322c4` is at `e0322c405d9470a1850766b74d06513d50846da3` (the frozen base). If the head moved, stop and report rather than opening.
3. Write the PR body between the markers below to a file, verbatim, and run from the project checkout:
   `scripts/jobs/gardening/ensure-pr.sh build-endor-run-expanded-phase-4-entry-point-input-open-pr endojs/endo-but-for-bots feat/endor-run-entry-point-xs-mapper endor-e0322c4 --title 'feat(endor): endor run accepts an entry-point module' --body-file <file>`
   The PR must be a draft. Name the PR number in the completion report, which stages its gauntlet.

----- PR BODY BEGIN -----
Refs: `designs/endor-run-expanded.md` (Phase 4)

## Description

`endor run <entry.js>` now runs an application from its entry-point module. It no longer needs a pre-built archive. The compartment mapper runs inside XS, as the design's Option B proposes. A short-lived XS machine runs `@endo/compartment-mapper` (`mapNodeModules` + `captureFromMap`) over the entry module. That machine has one write power, `endorRunWriteFile(path, bytes)`, which stores each archive file (`compartment-map.json`, then every captured module source) straight into the CAS. The program then runs in a fresh XS machine through the same CAS-backed loading as the ZIP and directory forms. The root hash is printed, and `endor run --cas <hash>` replays the run.

The same change fixes the nested-path gap left by Phase 2 and Phase 3. The tree builder stored a file more than one level inside a compartment (`app-v1.0.0/lib/util.js`) under the single key `lib/util.js`. `fetch_from_tree` could not reach that key, so the module silently failed to load from both ZIP and directory inputs. Every path component now becomes a nested CAS tree.

Files most worth reviewing:

- `rust/endo/src/cas_archive.rs`: `ArchiveTreeBuilder`, which stores blobs as they arrive and builds nested trees bottom-up. It replaces the flat `ingest_files` body and rejects a path that is both a file and a directory. Also `ingest_entry_point`, and `is_zip_archive` for the design's form detection: a `.zip` extension or `PK\x03\x04` magic means an archive, a directory means an unpacked archive, and anything else is an entry module.
- `rust/endo/xsnap/src/mapper.rs`: `map_entry_point`, which evaluates the mapper bundle and forwards each file to a caller-supplied sink. The mapper machine never executes application code.
- `packages/daemon/src/endor-run-mapper-xs.js` and `endor-run-mapper-xs-shims.js`: the mapper entry, read powers over the host file system, and a `file:` URL polyfill. `packages/daemon/scripts/bundle-endor-run-mapper-xs.mjs` bundles them with the `xs` condition into `rust/endo/xsnap/src/endor_run_mapper.js`. That file is generated and gitignored, like the other XS bundles.
- `packages/ses/src-xs/compartment-shim.js`: the XS `Compartment` adapter gains `load()`, delegating to the shim loader as `import()` and `importNow()` already do. Without it, the compartment mapper cannot walk a module graph on XS without executing it (`TypeError: call: not a function`). A changeset is included.

Two choices are worth a look:

- **The mapper machine does not lock down.** SES-for-XS installs its Compartment adapter when it is imported. Lockdown would freeze `ModuleSource.prototype` before `@endo/module-source` can add its `imports` accessors. The mapper machine only loads and analyzes sources, and the program runs in a separate machine. For the same reason, the mapper machine skips the `harden` polyfill, which would make SES refuse to lock down. The shared text-codec bootstrap moved into `NATIVE_TEXT_CODEC` so both machines install it the same way.
- **An entry module with no `package.json` above it is ESM.** The read powers answer for a synthetic `{"type": "module"}` descriptor beside the entry, so `mapNodeModules` has a package root. The synthetic descriptor is never stored. With a real `package.json`, the package's own `type` applies.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `designs/endor-run-expanded.md`
Disposition: deliverable
Phase 1: satisfied | standalone `ContentStore` (`rust/endo/src/cas.rs`) is on `endor`
Phase 2: satisfied | ZIP ingestion and `--cas <hash>` replay are on `endor`; this PR fixes the nested-path gap in its tree builder
Phase 3: satisfied | directory input landed on `endor` at e0322c405
Phase 4: satisfied | this PR: the compartment mapper bundled for XS, a map-in-XS then execute-in-a-fresh-XS flow, and CAS writes during mapping
Phase 5: not-applicable | a later phase, not a prerequisite of Phase 4; dependency resolution through `package.json` and the registry table belongs to its own change
Acceptance: satisfied | `endor run hello.js` (no dependencies, importing `./lib/greet.js`) printed `hello from entry point`; a second run printed the same root hash; `endor run --cas <hash>` re-ran it; covered by `entry_point_maps_module_graph_into_cas` and `entry_point_is_deterministic`
<!-- /garden-phase-evidence-ledger -->

### Security Considerations

The mapper machine reads the file system through the existing `root` file-system powers, which is the same authority `endor run` already grants archive endowments. It cannot write files. Its only output is `endorRunWriteFile`, which stores bytes in the CAS under an archive-relative path, and it never evaluates application code. The program runs in a separate machine exactly as the ZIP and directory forms do. A tree path that is both a file and a directory is rejected rather than shadowed.

### Scaling Considerations

Each run starts one extra XS machine for mapping. The mapper bundle is about 850 KB and adds that much to the binary. Blobs are written to the CAS as the mapper reports them, and tree manifests are built once at the end.

### Documentation Considerations

`endor help run` describes the entry-point form and the ESM default. `rust/endo/README.md` lists the new bundle and the command that generates it. The design's Status section records Phase 4 and the nested-path fix.

### Testing Considerations

New `cas_archive` tests:

- `nested_module_loads_from_cas` and `nested_files_become_nested_trees`: both fail against the previous tree builder (`None` for the nested source, and `["lib/util.js"]` where `["lib"]` is expected).
- `tree_builder_rejects_file_directory_conflict`.
- `zip_detection_by_extension_and_magic`.
- `entry_point_maps_module_graph_into_cas`: fails with `TypeError: call: not a function` when the bundle is built without the SES `load()` adapter.
- `entry_point_without_package_json_is_esm`.
- `entry_point_is_deterministic`.
- `entry_point_reports_unresolvable_import`.

The XS-backed tests share a mutex, because XS's quiesce loop reads a process-global pending-jobs flag that a machine on another test thread can consume. That flag predates this change.

`cargo test --lib` in `rust/endo` passes 81 of 81. By hand, I also ran `endor run` on:

- an extension-less ZIP and a directory, each with a nested module
- an entry with an ESM `node_modules` dependency
- a missing entry, which gives a path-qualified error
- `--no-cas` with an entry module, which exits 2

The build used placeholder `ses_boot.js`, `worker_bootstrap.js`, and `daemon_bootstrap.js` because their bundler is not in this tree. None of those are on the `endor run` path. I did not run the xsnap crate's own test suite.

### Compatibility Considerations

A non-directory input that is neither named `.zip` nor starts with ZIP magic used to be handed to the ZIP reader, which failed. It is now treated as an entry-point module. Archives with files nested more than one level deep now ingest to a different, correct root hash, so a hash recorded before this change will not match a fresh ingest of the same archive. Shallow archives keep their hashes. CommonJS modules are captured into the archive, but the archive runner does not yet execute them. That is left for Phase 5.

### Upgrade Considerations

Building `endor` now also requires `node packages/daemon/scripts/bundle-endor-run-mapper-xs.mjs`, alongside the existing XS bundles.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- PR BODY END -----
