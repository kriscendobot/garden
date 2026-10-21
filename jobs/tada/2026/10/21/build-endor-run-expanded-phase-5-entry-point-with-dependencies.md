## Phase 5 of `endor run` is already on `llm`, so I opened no PR

I checked first whether Phase 4 had landed, as the job asked. It had, and Phase 5 had too, so there was nothing new to build.

**Phase 4 is on `llm`.** `ingest_entry_point` is at `rust/endo/src/cas_archive.rs:182` and `classify_run_input` is at `rust/endo/src/run_input.rs:51`. Its own PR, #279, is still open, but the code reached `llm` by another route: PR #282 was stacked on it and merged.

**Phase 5 is on `llm` too.** PR #282 ("feat(endor): add node_modules entry walker and fixture-parity ratchet") merged into `llm` on 2026-08-27. It covers both things the job asked for:
- **`package.json` resolution:** `resolve_package_main`, which tries `exports`, then `module`, then `main`, then `index.*`.
- **Walking up through `node_modules`:** `find_node_modules_package`, in `rust/endo/src/entry_walk.rs`.
- **The test the job names** (`app.js` importing from a local `node_modules` package) is `ingest_walks_bare_import_into_separate_compartment`, at `entry_walk.rs:5385`.
- It also added a check against 32 `@endo/compartment-mapper` test fixtures. The design records Phase 5 items 1, 2 and 4 as done, and item 3 (the npm registry lookup) as done through a separate design.

**The one difference from the job's wording is deliberate, so I didn't build it.** The job says to do this "in the XS-hosted mapper". The design chose to write the resolver in Rust instead, and its Status section explains why. Since then two things have made an XS-hosted version of this resolver the wrong target:
- Following the maintainer's direction on PR #282, `endor run <entry.js>` now uses the npm registry-cache resolver by default. The `node_modules` walker is a legacy option behind `--node-modules`, planned for removal once the registry path is shown to resolve the same way.
- Moving package mapping into an XS-hosted JavaScript worker now has its own design, `designs/endor-registry-proxy-worker.md` (merged in PR #944, status Proposed). It targets the registry-cache path, not the legacy `node_modules` walker. Building an XS mapper for the walker here would duplicate that design and contradict the direction on #282.

**I couldn't run the test locally.** The `xsnap` crate won't compile on this host: after I initialized the `c/moddable` submodule, the build failed with 4 compile errors in `xsnap`. The design notes that the `endo` crate isn't in CI. So the only evidence that the test passes is that PR #282 was reviewed and merged. I deleted my cargo build directory afterwards.

**No code changed:** no commits, and nothing changed in the garden or the project repo.

**Follow-up (needs a decision):** whoever produces these jobs may keep posting "Phase 5" builds from this design. If the XS-hosted mapper is still wanted, the job to post is a build of Phase 1 of `designs/endor-registry-proxy-worker.md`, after its status moves past Proposed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endor-run-expanded-phase-5-entry-point-with-dependencies.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (680774 cached reads)
- Output: 4446 tokens
- Cost: $0.6956108000000003
- Wall-clock: 475s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
