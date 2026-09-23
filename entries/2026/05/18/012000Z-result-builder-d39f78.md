---
ts: 2026-05-18T01:20:00Z
kind: result
role: builder
project: endo-but-for-bots
worktree: dispatches/builder--8ca10c/project
prs:
  - repo: endojs/endo-but-for-bots
    pr: 278
    role: target
    title: "feat(endor): directory input for endor run (Phase 3 of endor-run-expanded)"
refs:
  - entries/2026/05/17/221745Z-result-builder-f651b7.md
---

# Result: builder d39f78 — PR #278 Phase 3 of endor-run-expanded

Draft PR opened: <https://github.com/endojs/endo-but-for-bots/pull/278> against base `llm` on branch `feat/endor-run-directory-input` at head `06d6ad9cf`.

## Base-branch choice

Same reasoning as the prior `endor` builder (`entries/2026/05/17/221745Z-result-builder-f651b7.md`): the entire `rust/endo` crate lives on `llm`, not `master`, so a `master`-base PR would not compile. Phase 3 sits on Phase 1-2 which also live on `llm`. The implementation branches off `llm` and the PR targets `llm`.

## What landed

One commit on top of `4a3dc92ce` (the `llm` HEAD at dispatch time):

| SHA | Subject | Files |
|-----|---------|-------|
| `06d6ad9cf` | `feat(endor): directory input for endor run (Phase 3 of endor-run-expanded)` | `rust/endo/src/cas_archive.rs`, `rust/endo/src/bin/endor.rs`, `designs/endor-run-expanded.md`, `designs/README.md` |

### `cas_archive.rs`

New `ingest_directory(cas, dir)` function that:

1. Refuses fast (`NotFound`) if the path is not a directory.
2. Refuses fast (`InvalidData`) if root `compartment-map.json` is missing, *before* any CAS writes, so a malformed input does not leave a partially populated store.
3. Walks each top-level entry: regular files become root-level blobs (e.g. `compartment-map.json`); subdirectories become per-compartment subtrees populated by `collect_compartment_blobs`.
4. `collect_compartment_blobs` is iterative (explicit stack), so deep nesting doesn't consume Rust call stack. Every regular file under a compartment becomes one CAS blob keyed by its forward-slash-joined path relative to the compartment directory, mirroring `ingest_archive`'s ZIP-key shape so the two functions produce the same root hash for byte-equivalent inputs.
5. Symlinks and other non-regular files are skipped (the walker only follows `is_file()` / `is_dir()`).
6. Loads the resulting archive via `load_archive_from_cas` and returns the same `IngestedArchive` shape Phase 2 uses, so the CLI's downstream `run_xs_archive_loaded` path is shared.

New `encode_manifest_sorted(manifest)` helper that serialises a `TreeManifest` with sorted keys via a `BTreeMap` view. Applied at the four manifest-serialisation sites in `ingest_archive` and `ingest_directory` so the CAS root hash is a pure function of the input contents rather than per-process `HashMap` seed. Without this, two ingestions of the same input would produce different root hashes (caught by the regression-evidence run on `ingest_directory_root_hash_is_deterministic`).

A new `fs_read_dir_sorted` helper centralises the directory-iteration sort so every level of the walk is in stable order (helps reasoning even though `encode_manifest_sorted` already canonicalises the on-disk bytes).

### `endor.rs`

`endor run` now picks the path with `p.is_dir()`: directory paths dispatch to a new `cmd_run_directory_with_cas`, file paths keep the existing ZIP behaviour. `--no-cas` with a directory is rejected at the CLI with exit code 2 and a clear message (directory walking always uses the CAS; there is no in-memory equivalent of an unpacked tree). Help text under `endor help run` covers both forms, the `--cas`/`--no-cas` flags, and the root-hash semantics.

### `designs/endor-run-expanded.md`

Status section advanced to "Phases 1-3 implemented" and the new Phase 3 prose names the file paths that landed and the `encode_manifest_sorted` determinism property. `designs/README.md` row updated to reflect the new `Updated` date (`2026-05-15`); kept `In Progress` because Phases 4-5 remain.

## Test count and regression evidence

Seven new tests in `cas_archive::tests`:

- `encode_manifest_sorted_is_deterministic_across_insertion_orders`
- `ingest_directory_round_trip`
- `ingest_directory_matches_zip_root_hash`
- `ingest_directory_reload_via_load_archive_from_cas`
- `ingest_directory_requires_compartment_map`
- `ingest_directory_rejects_non_directory`
- `ingest_directory_root_hash_is_deterministic`

Total `endo` lib tests now 75 (previously 68); all pass.

Regression evidence per `garden/skills/regression-evidence/SKILL.md` (each break done with `Edit`, observed via `cargo test`, then reverted):

| Test(s) | Break | Observed failure | After restore |
|---------|-------|------------------|---------------|
| `ingest_directory_round_trip`, `ingest_directory_matches_zip_root_hash`, `ingest_directory_reload_via_load_archive_from_cas` | Commented out the compartment sub-tree assembly loop in `ingest_directory` (kept the `let _ = &compartment_trees;` to satisfy the borrow checker without semantic effect) | All three FAILED: root tree missing `app-v1.0.0` entry, hash divergence, `Option::unwrap()` on the missing compartment | All three PASS |
| `ingest_directory_requires_compartment_map` | Removed the pre-flight `compartment-map.json` check | FAILED: error kind became `NotFound` (raised later by `load_archive_from_cas` looking for the absent map) instead of the pre-flight's `InvalidData`, and the post-call empty-CAS assertion would have caught the half-populated store on a more complex fixture | PASS |
| `ingest_directory_matches_zip_root_hash` | Prefixed every compartment-blob key in `collect_compartment_blobs` with `BAD_` so the directory layout no longer matches the ZIP layout | FAILED: directory and ZIP root hashes differ | PASS |
| `encode_manifest_sorted_is_deterministic_across_insertion_orders`, `ingest_directory_matches_zip_root_hash`, `ingest_directory_root_hash_is_deterministic` | Reverted `encode_manifest_sorted` to plain `serde_json::to_vec(&TreeManifest)` (unsorted `HashMap` iteration) | All three FAILED: byte sequences differed (literal byte-array diff in the deterministic-order test) and root hashes drifted between independent ingestions of the same input | All three PASS |

End-to-end smoke test on the bot host: a Python-built ZIP of `/tmp/endor-smoketest/` and the same `/tmp/endor-smoketest/` directory both report `endor[run]: archive root 7d306e45e15b9dff15e7941cbc631795248f96efa06d8ba5b9309fede72e8cf5` when run through `target/debug/endor run`. A subsequent `endor run --cas 7d306e45...` against a fresh CAS reproduces the same execution. Missing `compartment-map.json` reports the pre-flight error with exit 1; `--no-cas` with a directory reports the incompatibility with exit 2.

## CI status

CI is queued at PR-open time (head `06d6ad9cf`). The existing CI surface is JS-side (lint, ava, browser-tests, test262, etc.) plus the `build-wasm` row that builds `rust/ocapn_noise` only. The `rust/endo` crate has no CI workflow row of its own, so the new tests are not exercised by upstream CI. Adding a `rust/endo` CI row remains a natural follow-up (the prior Phase 2 builder flagged it too; out of scope here).

## Local build environment note

Same workaround as the prior `endor` builder (entry `221745Z-result-builder-f651b7`):

- `rustup` toolchain stable was already in place (`rustc 1.95.0`); installed `clippy` and `rustfmt` components on first use.
- `git submodule update --init c/moddable` to populate the Moddable XS C sources `xsnap`'s `build.rs` needs.
- Stubbed `rust/endo/xsnap/src/{ses_boot,worker_bootstrap,daemon_bootstrap}.js` with empty files so `include_str!` macro calls in `xsnap/src/lib.rs` resolve. These three paths are in the project `.gitignore` and are not part of the PR.

## Changeset

None. The change is Rust-only (`rust/endo/*` plus design metadata) and does not affect any published JavaScript package; changesets here govern npm release notes only.

## Out-of-scope deferrals

- Phase 4 (XS-hosted compartment mapper for entry-point input) and Phase 5 (entry-point with dependency resolution). Mentioned in the Status section.
- A `cargo test -p endo --lib` CI row. Out of scope for Phase 3; raised by Phase 2's builder too.
- A determinism guarantee on the CAS *blob*-level layout for files whose contents change. Blob hashes are already pure functions of bytes; this PR only fixes the tree-manifest serialisation drift.
- Updating any pre-existing root hashes anyone may have recorded against the old non-deterministic `ingest_archive`. The PR body's *Compatibility Considerations* documents the re-ingest requirement; no on-disk migration is needed because blob hashes are unchanged.

Self-improvement: a small lesson for `roles/builder/AGENT.md`. The norm calls for matching the precedent shape (single-level compartment trees mirroring `ingest_archive`), but the precedent itself relied on `HashMap` iteration order for tree-manifest serialisation, which is non-deterministic across runs. A literal "match the precedent" reading would have inherited the bug; the right reading is "match the precedent's *public contract* (root hash converges for byte-equivalent inputs) and fix the precedent when the contract is not actually delivered". The norm in `roles/builder/AGENT.md` § *Implement the smallest change that satisfies the acceptance criteria* explicitly says "Do not refactor adjacent code unless the task calls for it", which can be read either way; today's task did call for fixing the precedent because the new test the design implied (Form 2 equivalent to Form 1) would not have been load-bearing without the fix. Below the standalone-skill threshold (it's a refinement, not a new skill), but worth surfacing as a one-line addition to the norm: "When implementing a phase that introduces a new equivalence claim with a sibling phase, fix any latent non-determinism in the sibling that would prevent the equivalence from holding rather than working around it in the new code only."
