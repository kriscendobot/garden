---
ts: 2026-05-18T02:36:00Z
kind: result
role: builder
project: endo-but-for-bots
worktree: dispatches/builder--2d463b/project
prs:
  - repo: endojs/endo-but-for-bots
    pr: 279
    role: target
    title: "feat(endor): entry-point input for endor run (Phase 4 of endor-run-expanded, no-dependency case)"
refs:
  - entries/2026/05/18/012000Z-result-builder-d39f78.md
---

# Result: builder bd5771 — PR #279 Phase 4 of endor-run-expanded

Draft PR opened: <https://github.com/endojs/endo-but-for-bots/pull/279> against base `llm` on branch `feat/endor-run-entry-point` at head `abaa5632d`.

## Base-branch choice

Same reasoning as the Phase 2 and Phase 3 `endor` builders (`entries/2026/05/17/221745Z-result-builder-f651b7.md`, `entries/2026/05/18/012000Z-result-builder-d39f78.md`): the entire `rust/endo` crate lives on `llm`, not `master`, so a `master`-base PR would not compile. Phase 4 sits on Phase 1-2 which also live on `llm`. The implementation branches off `llm` and the PR targets `llm`.

## Cross-PR coordination with PR #278 (Phase 3)

PR #278 (Phase 3 directory input) was still OPEN at this dispatch's start. I branched off `llm` (not off Phase 3's branch) and implemented Phase 4 independently: `ingest_entry_point` and `ingest_directory` touch non-overlapping regions of `cas_archive.rs`; the CLI dispatch in `endor.rs` adds a new `RunInput::EntryPoint` arm that will sit alongside Phase 3's eventual `RunInput::Directory` arm. The PR body's *Cross-PR coordination with Phase 3* section records both directions of the rebase. A weaver dispatch on whichever PR lands second is the mechanical follow-up.

## Scope decision: Rust-side synthesis vs. XS-hosted mapper

The design's Phase 4 plan picks Option B (XS-hosted compartment mapper bundled into a JS file `xsnap` loads). For Phase 4's stated acceptance test (`endor run hello.js` with a simple module that has no dependencies), the mapper would walk an empty `package.json` and produce exactly the one-compartment, one-module shape `ingest_entry_point` synthesises directly. I chose the Rust-side synthesis because:

1. Builder norm: "Implement the smallest change that satisfies the acceptance criteria." The XS-hosted mapper requires bundling `@endo/compartment-mapper` for XS with appropriate fs/CAS host powers, wiring the two-machine handshake, and stand-up work that is mostly load-bearing for Phase 5's dependency-walk case, not Phase 4's no-dep case.
2. The deviation is invisible at Phase 4's test boundary (both approaches produce the same `compartment-map.json` and the same CAS layout for a no-dependency entry).
3. The XS-hosted mapper becomes load-bearing in Phase 5, where the dependency walk and `package.json` resolution make it materially different from Rust-side synthesis. Phase 5 can either keep `ingest_entry_point` as a fast path for the no-dep case or replace it with a single mapper invocation with an empty resolver. The design's Status section records the deviation; the Phase 4 plan section in the design is updated to reflect it.

## What landed

One commit on top of `68246ad92` (the `llm` HEAD at dispatch time):

| SHA | Subject | Files |
|-----|---------|-------|
| `abaa5632d` | `feat(endor): entry-point input for endor run (Phase 4 of endor-run-expanded, no-dependency case)` | `rust/endo/src/cas_archive.rs`, `rust/endo/src/bin/endor.rs`, `designs/endor-run-expanded.md`, `designs/README.md` |

### `cas_archive.rs`

New `ingest_entry_point(cas, entry_path)` function that:

1. Refuses fast (`NotFound`) if the path is not a regular file (before any CAS writes).
2. Refuses fast (`InvalidData`) if the file extension is not one of `.js`, `.mjs`, `.cjs`, `.json`.
3. Reads the entry source bytes and synthesises a `compartment-map.json` with one compartment (`entry-v1.0.0`) and one module (specifier `./<filename>`, location `<filename>`, parser derived from the extension).
4. Stores both the synthesised map and the entry source as CAS blobs; builds the compartment sub-tree (one blob entry) and the root tree (compartment-map blob + compartment subtree) so the on-disk layout mirrors `ingest_archive`'s output for ZIP inputs.
5. Loads the resulting archive via the shared `load_archive_from_cas` reader and returns an `IngestedArchive`, so the downstream `run_xs_archive_loaded` path is identical to the ZIP path.

Helper functions:

- `parser_for_extension(ext)` maps file extensions to compartment-map parser names (`mjs` for `.js`/`.mjs`, `cjs`, `json`). Returns `None` for unrecognised extensions; the helper is the single source of truth.
- `build_entry_compartment_map_json(compartment_id, specifier, file_name, parser)` hand-builds the JSON text. Takes the parser as an argument (rather than re-deriving it from the file name) so the pre-flight validation and the on-disk serialisation cannot disagree. I caught this disagreement during regression-evidence experiments: the initial cut had `build_entry_compartment_map_json` re-derive the parser from the file name independently of `parser_for_extension`, which made the parser-selection test pass when I broke `parser_for_extension`'s mapping. The refactor unified the two sites; the test is now load-bearing.

### `endor.rs`

New `RunInput` enum (`ZipArchive`, `EntryPoint`, `Missing`) and `classify_run_input(p)` discriminator. The classifier rule follows the design's "input form detection by file type, not flags":

1. If `p.is_file()` is false, return `Missing`.
2. Extension-first: `.zip` → ZIP; `.js`/`.mjs`/`.cjs`/`.json` → EntryPoint.
3. Magic-byte fallback for extension-less files: read four bytes, match `PK\x03\x04` → ZIP.
4. Otherwise → `Missing` (the file exists but is not a recognised form, so the CLI surfaces a clear error rather than guessing).

`endor run <entry.js>` routes via the new `RunInput::EntryPoint` arm to a new `cmd_run_entry_point_with_cas`. `--no-cas` with an entry-point input is rejected at the CLI with exit code 2 (the entry-point form always uses the CAS). Help text (`endor help run`) covers both the ZIP and entry-point forms, the recognised extensions, and the `--cas`/`--no-cas` flag semantics. The module-level doc comment grows a line for the entry-point form.

When PR #278 lands first, the CLI's `RunInput::Directory` arm slots in alongside the existing two; the discriminator gains a `p.is_dir()` precheck above the file-type lookup. The PR body records this rebase direction (and the mirror direction if PR #279 lands first).

### `designs/endor-run-expanded.md`

Status section advanced: Phases 1-2 plus Phase 4 (no-dep case) implemented; Phase 3 noted as in review on PR #278; Phase 5 remains. New *Deviation from the design's Option B (deferred to Phase 5)* note explains the Rust-side synthesis choice and why it matches Phase 4's acceptance criterion. New *Cross-PR coordination with Phase 3* section records both rebase directions.

The Phase 4 plan section in *Implementation phases* is updated to mark the design-step substitution explicitly: bundling the XS-hosted mapper and the two-phase flow are now annotated "(Deferred to Phase 5)"; the Rust-side synthesis step replaces them. The test goal is unchanged.

`designs/README.md` row updated to reflect the new `Updated` date (`2026-05-18`); kept `In Progress` because Phase 5 remains.

## Test count and regression evidence

Eight new tests in `cas_archive::tests`:

- `ingest_entry_point_synthesises_one_compartment_archive`
- `ingest_entry_point_root_tree_layout`
- `ingest_entry_point_reload_via_load_archive_from_cas`
- `ingest_entry_point_rejects_unsupported_extension`
- `ingest_entry_point_rejects_missing_path`
- `ingest_entry_point_rejects_directory_input`
- `ingest_entry_point_parser_selection_by_extension`
- `ingest_entry_point_run_path_matches_zip_run_path`

Total `endo` lib tests now 76 (previously 68); all pass.

Regression evidence per `garden/skills/regression-evidence/SKILL.md` (each break done with `Edit`, observed via `cargo test`, then reverted):

| Test(s) | Break | Observed failure | After restore |
|---------|-------|------------------|---------------|
| `ingest_entry_point_synthesises_one_compartment_archive`, `ingest_entry_point_root_tree_layout`, `ingest_entry_point_reload_via_load_archive_from_cas` | Changed `compartment_id` to `"BROKEN-COMPARTMENT-ID"` | All three FAILED (entry compartment mismatch; root tree missing `entry-v1.0.0`; reload mismatch) | All three PASS |
| `ingest_entry_point_rejects_unsupported_extension` | Replaced parser-check `ok_or_else` with `unwrap_or("mjs")` | FAILED: expected error not raised (helper happily produced an archive with parser `mjs` for `.txt`) | PASS |
| `ingest_entry_point_rejects_directory_input` | Removed the `is_file()` precheck | FAILED: error kind became `InvalidData` (from the parser check on an extensionless path) instead of `NotFound`; the test's dir-vs-missing discrimination was lost | PASS |
| `ingest_entry_point_parser_selection_by_extension` | Flipped `"js" \| "mjs" => Some("mjs")` to `Some("json")` in `parser_for_extension` (after the refactor unifying the two parser-derivation sites) | FAILED: `a.js: expected parser mjs in {... "parser":"json" ...}`; the failure is observed at the on-disk JSON blob in the CAS, not just in a Rust-side struct | PASS |
| `ingest_entry_point_synthesises_one_compartment_archive`, `ingest_entry_point_reload_via_load_archive_from_cas`, `ingest_entry_point_run_path_matches_zip_run_path` | Replaced `let source_bytes = std::fs::read(entry_path)?` with a literal byte string | All three FAILED: stored source differed from expected source text | All three PASS |

The `rejects_missing_path` test is intentionally an overlap with `std::fs::read`'s own `NotFound` behaviour: when the `is_file()` precheck is removed, `std::fs::read` still raises `NotFound`, so the test passes either way. The test stays as the canonical contract assertion (a missing entry path produces a `NotFound`-shaped error and never a panic or partial CAS write); the `rejects_directory_input` test is the load-bearing discriminator that requires the precheck.

End-to-end smoke test on the bot host (`endolinbot`): `endor run /tmp/endor-phase4-test/hello.js` prints `endor[run]: archive root <hash>` to stderr, then the XS machine executes the entry's `trace(...)` call. A subsequent `endor run --cas <hash>` against the same CAS reproduces the execution. The same behaviour holds for `.mjs` and `.cjs` extensions. Unrecognised extensions (`hello.txt`) are caught by the CLI's `classify_run_input` and reported as `input not found` (because the classifier returns `Missing` for any file it cannot route). The `--no-cas` flag with an entry-point input is rejected at the CLI with exit code 2.

## CI status

CI is queued / in_progress at PR-open time (head `abaa5632d`). The existing CI surface is JS-side (lint, ava, browser-tests, test262, etc.) plus the `build-wasm` row that builds `rust/ocapn_noise` only. The `rust/endo` crate has no CI workflow row of its own, so the new tests are not exercised by upstream CI. Adding a `rust/endo` CI row remains a natural follow-up (Phase 2 and Phase 3 builders flagged it too; out of scope here).

## Local build environment note

Same workaround as the prior `endor` builders (the bot host's per-dispatch worktree triple starts clean):

- `rustup` toolchain stable was already in place (`rustc 1.95.0`).
- `git submodule update --init c/moddable` to populate the Moddable XS C sources `xsnap`'s `build.rs` needs.
- Stubbed `rust/endo/xsnap/src/{ses_boot,worker_bootstrap,daemon_bootstrap}.js` with empty files so `include_str!` calls in `xsnap/src/lib.rs` resolve. These three paths are in the project `.gitignore` and are not part of the PR.

The dispatch prompt's claim that these prereqs were "already set up from prior dispatches" is true for long-lived standing worktrees but not for the per-dispatch worktree triple, which is freshly prepared from the bare clone. Flagging in case the dispatch prompt's wording confuses a future builder.

## Changeset

None. The change is Rust-only (`rust/endo/*` plus design metadata) and does not affect any published JavaScript package; changesets here govern npm release notes only.

## Pre-PR checklist

- `cargo build --bin endor`: clean.
- `cargo test --lib`: 76 passed, 0 failed.
- `cargo fmt --check`: pre-existing drift in untouched files (cargo fmt run on the whole workspace reformatted 13 unrelated files; I reverted those and kept only the four intentionally-touched files in the PR). The two files I authored are formatted.
- `cargo clippy --lib`: 23 pre-existing warnings in untouched code; zero warnings on the new code.
- End-to-end smoke: `endor run hello.js` produces a CAS root hash and the XS machine executes the entry's `trace(...)` call.

## Out-of-scope deferrals

- Phase 5 (entry-point with dependency resolution): the XS-hosted compartment mapper bundle, `package.json` walk, `node_modules` resolution, registry-table integration with `endor-npm-registry-proxy`. Tracked by the design's Phase 5 plan section.
- A `cargo test -p endo --lib` CI row.
- Adopting Phase 3's `encode_manifest_sorted` determinism helper for `ingest_entry_point` (rebase follow-up; not required by Phase 4's tests).
- Phase 3 rebase to add the `RunInput::Directory` arm to my CLI dispatch (mechanical merge).

Self-improvement: a small lesson for `garden/skills/regression-evidence/SKILL.md` Notes-from-the-field. During the parser-selection regression experiment I observed that `parser_for_extension`'s mapping break did NOT cause the test to fail on the first run, because the test reads the on-disk `compartment-map.json` blob and the implementation had two independent parser-derivation sites (`parser_for_extension` at the top of `ingest_entry_point`, and a duplicate `match` inside `build_entry_compartment_map_json`). The test was looking at the wrong derivation site. The regression experiment surfaced the duplication; the fix was to refactor `build_entry_compartment_map_json` to take the parser as an argument so both sites read from `parser_for_extension`. The lesson: a regression-evidence experiment that *fails to fail* is itself diagnostic — it means either the test does not exercise the path it claims to (the standard interpretation), OR the production code has two implementations of the same logic and only one is broken. The fix in the second case is to consolidate the implementations and re-run the experiment. Below the standalone-skill threshold; worth a one-line addition to the regression-evidence Notes-from-the-field as a complement to the "Existing test already covers this area" pitfall already on the skill. The lesson is in the form: "If your regression break fails to fail, check for a duplicate implementation site the test misses; consolidate before re-running the experiment."
