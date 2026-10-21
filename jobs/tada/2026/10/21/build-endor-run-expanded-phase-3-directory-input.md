I opened draft PR endojs/endo-but-for-bots#1521, which implements Phase 3 of `endor-run-expanded`: `endor run <dir/>` now accepts an unpacked compartment-map directory. The new tests pass locally, but I did not run `endor run dir/` end to end.

**Earlier attempt:** Phase 3 already had a PR, #278 (May 2026). It conflicted with current `llm` in every file, and its gauntlet had halted because it wasn't on a pinned base. So I rebuilt the work on the pinned base `llm-f02cd81` rather than reviving it. I commented on #278 that #1521 supersedes it and recommended closing it; the maintainer needs to do that.

**What changed:**
- **`cas_archive.rs`:** a new `ingest_directory` stores the directory in the CAS with the same layout the ZIP path uses. A directory and a ZIP with the same files get the same root hash, so `endor run --cas <hash>` works whichever form was ingested.
  - Symbolic links are not followed.
  - A missing or symlinked `compartment-map.json` is rejected before anything is written to the CAS.
  - Non-UTF-8 file names are rejected, and empty directories are skipped, as they are in ZIPs.
- **`run_input.rs`:** any directory is now classified as a directory input.
- **`bin/endor.rs`:** `endor run` handles directory input, and `--no-cas` with a directory exits 2 with a message. The help text documents the `dir/` form.
- **Dropped helper:** #278's sorted-manifest helper is gone, because the manifest type on `llm` already serializes in sorted order.
- **Design doc:** `designs/endor-run-expanded.md` now records Phase 3 as implemented.

**Tests and CI:**
- **Local tests:** I added nine Rust tests. They cover the round trip, matching hashes between a ZIP and a directory, the tree layout, determinism, empty directories, a missing map, non-directory paths, and symlinks. `cargo test --lib -- cas_archive run_input` passed all 38 tests.
- **Local build:** to build, I had to fetch the `c/moddable` submodule by hand and use empty placeholder files for the XS bootstrap bundles. Those placeholders are why I didn't run the end-to-end check.
- **CI:** at report time 13 checks had passed, including `build-xsnap` and `lint`. Four JS `test` matrix jobs were still pending; this Rust-only change doesn't touch them.

**Follow-ups:**
- Phases 4–5 (entry point with the compartment mapper) are out of scope, as the job asked.
- A file nested in a subdirectory of a compartment is stored under a flat `a/b.js` key. `ContentStore::fetch_from_tree` splits paths on `/`, so that module's source is not reloaded. The ZIP path has the same limitation; I noted it in the PR as a separate fix.
- The PR-body check in `ensure-pr.sh` rejected a GitHub URL pointing at a design doc, because it read the URL as a repo path. Naming the doc as a bare `designs/...` path got through. This is worth fixing in the garden scripts.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endor-run-expanded-phase-3-directory-input.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (3544136 cached reads)
- Output: 23340 tokens
- Cost: $2.0418351999999995
- Wall-clock: 2058s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
