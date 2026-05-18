---
ts: 2026-05-18T03:47:42Z
kind: result
role: fixer
project: endo-but-for-bots
worktree: dispatches/fixer--0eecb2/project
prs:
  - repo: endojs/endo-but-for-bots
    pr: 279
    role: target
    title: "feat(endor): entry-point input for endor run (Phase 4 of endor-run-expanded, no-dependency case)"
refs:
  - entries/2026/05/18/033120Z-result-judge-ff46f3.md
  - entries/2026/05/18/030848Z-result-cleaner-8ee44b.md
  - entries/2026/05/18/023600Z-result-builder-bd5771.md
---

# Result: fixer 304e6f — address judge verdict on PR #279

PR: `endojs/endo-but-for-bots#279`, base `llm`, head was `4f5ad6718`, new head `13ee82881`.

## What landed

Two commits on top of `4f5ad6718`:

| SHA | Subject | Files |
|-----|---------|-------|
| `bbf903d00` | `fix(endor): address judge must-fix items on PR #279 entry-point form` | `rust/endo/src/cas_archive.rs` |
| `13ee82881` | `fix(endor): address judge should-fix items on PR #279 CLI help and error wrapping` | `rust/endo/src/bin/endor.rs` |

### Must-fix items addressed (commit `bbf903d00`)

1. **Case-sensitivity divergence between `classify_run_input` and `parser_for_extension`.** Lowercased the extension in `parser_for_extension`. Regression test `ingest_entry_point_uppercase_extension_routes_to_parser` reads the on-disk JSON blob from the CAS and asserts the parser is `mjs` for `Hello.JS`.
2. **JSON escaping in `build_entry_compartment_map_json`.** Every interpolation runs through `serde_json::to_string` via a small `escape` helper. Regression test `ingest_entry_point_escapes_quote_in_file_name` constructs `foo"bar.js`, asserts the synthesised map parses cleanly as `CompartmentMap`, and asserts the source bytes survive the synthesise/store/load round trip.
3. **Validation-before-storage ordering as a deliberate invariant.** Added a comment at the function head naming the invariant. Regression test `cas_is_unchanged_after_rejected_ingest` snapshots the CAS directory before and after two rejection paths (unsupported extension, missing path) and asserts byte-identical state.
4. **`SYNTHETIC_COMPARTMENT_ID` named constant.** Defined at module scope (`pub const SYNTHETIC_COMPARTMENT_ID: &str = "entry-v1.0.0"`) with a comment documenting the placeholder-version convention. The helper and three tests now use the constant.

### Should-fix items addressed

| # | Item | Where |
|---|------|-------|
| 5 | `print_help()` versus `print_subcommand_help("run")` drift on the entry-point form | commit `13ee82881` (`print_help`) |
| 6 | Doubled path context in `cmd_run_entry_point_with_cas` error wrapping | commit `13ee82881` (`cmd_run_entry_point_with_cas`) |
| 7 | `--no-cas` ZIP-only restriction undocumented | commit `13ee82881` (`print_subcommand_help`) |
| 8 | Schema-drift round-trip guard | commit `bbf903d00` (new test `synthesised_map_round_trips_through_compartment_map_schema`); landed with the must-fix commit because the test sits in the same module and naturally shares fixture scaffolding with the four must-fix tests |

### Should-fix item deferred per verdict framing

9. **`RunInput::Missing` conflation.** The verdict body records this as *"Out-of-scope here; recorded for the Phase 5 rebase."* I left it untouched per the verdict's own framing; future Phase 5 work or a follow-up PR can introduce `RunInput::UnrecognisedShape(PathBuf)` to disambiguate the three causes (absent, directory, unrecognised regular file).

## Regression evidence

Per `garden/skills/regression-evidence/SKILL.md`, each of the four new tests was confirmed to fail when the corresponding fix was reverted (break done with `Edit`, observed via `cargo test`, then restored from a backup):

| Test | Break | Observed failure | After restore |
|------|-------|------------------|---------------|
| `ingest_entry_point_uppercase_extension_routes_to_parser` | Reverted `to_ascii_lowercase()` | FAILED: `Err: unsupported entry-point extension: ...Hello.JS` | PASS |
| `ingest_entry_point_escapes_quote_in_file_name` | Reverted to raw `{specifier}` / `{file_name}` interpolation | FAILED: `Err: invalid map: expected ',' or '}' at line 1 column 56` | PASS |
| `cas_is_unchanged_after_rejected_ingest` | Inserted `cas.store(b"BREAK-orphan-marker", "blob")` above the parser check | FAILED: snapshot grew from `[]` to one blob hash on the rejection path | PASS |
| `synthesised_map_round_trips_through_compartment_map_schema` | `Some("mjs")` → `Some("BROKEN-PARSER")` | FAILED: `parser` field on parsed CompartmentMap was `BROKEN-PARSER` not `mjs` | PASS |

The four new tests are load-bearing.

## Pre-PR checklist

- `cargo build --bin endor`: clean (one pre-existing warning in untouched `xsnap`).
- `cargo test -p endo --lib`: **94 passed, 0 failed** (90 prior + 4 new must-fix-related tests; the schema-drift test counts as the fifth new test, bringing the total new from 4 to 5).
- `cargo fmt`: clean on touched files (cargo fmt on the whole `-p endo` reformatted 13 unrelated files per the prior builder's note; I reverted those and kept only the two intentionally-touched files in the PR).
- `cargo clippy -p endo --lib`: zero warnings on touched lines.
- End-to-end smoke: `endor --help` shows the expanded entry-point line listing all four recognised extensions plus the magic-byte fallback; `endor help run` shows the `--no-cas` restriction.

## Top-level summary comment

Posted at `https://github.com/endojs/endo-but-for-bots/pull/279#issuecomment-4474093691`. Lists the items by SHA, includes the regression-evidence table, and surfaces item 9 as deferred-per-verdict-framing.

## CI status

CI is `pending` across the matrix at push time of `13ee82881`. The new tests (Rust-side `cargo test -p endo --lib`) are not covered by upstream CI (no `rust/endo` workflow row exists; carried over from Phases 2, 3, 4 builders), so the matrix's verdict turns on JavaScript-side lint/build/test rows that should be unaffected by the Rust-only diff.

## Next stage owed

Per the dispatch's framing and `skills/pr-creation-flow/SKILL.md` § Jury-fixer loop: **judge re-dispatch on PR #279** after CI is green. The judge re-runs the panel internally; the loop terminates when the panel surfaces no further in-scope must-fix items (the judge then un-drafts via `gh pr ready`).

## Build environment note (carried over)

Same Rust-build prereqs as the Phase 2, 3, 4 builders and the prior cleaner:

- `git submodule update --init c/moddable` to populate the Moddable XS C sources `xsnap`'s `build.rs` needs.
- Stub `rust/endo/xsnap/src/{ses_boot,worker_bootstrap,daemon_bootstrap}.js` with empty files (gitignored, not part of the PR).

These are not "already set up" in a fresh per-dispatch worktree triple; flagging again so the next per-dispatch worker does not re-discover the gap.

## Per-action authorizations exercised

Per the dispatch's forwarded authorization (commits + pushes implicit; top-level summary comment OK): two commits pushed to `feat/endor-run-entry-point`, one top-level summary comment posted on PR #279. No inline thread replies (the verdict was delivered as a top-level `--comment` per the self-PR fallback; there are no inline threads to reply on). No re-request-review (the judge re-dispatch is the next stage; re-requesting maintainer review is downstream of the panel's un-draft).

Self-improvement: noted that the four new must-fix tests landed in one commit alongside the four implementation fixes (per `garden/skills/retcon/SKILL.md`'s framing of implementation+tests as a co-shipped unit), with the fifth test (the schema-drift round-trip guard for should-fix #8) folded into the same commit rather than the should-fix commit because it sits in the same test module and shares fixture scaffolding with the must-fix tests. The line between "must-fix commit" and "should-fix commit" turned on per-file diff topology (cas_archive.rs vs bin/endor.rs) rather than on must/should taxonomy, which kept the two commits clean and reviewable independently. The fixer role file's *one commit per concern* skill (`review-feedback-followup-commits`) admits this kind of cross-cutting when the per-file grouping is the more reviewable split; below the threshold for a separate message to liaison, but worth surfacing as a one-line note for the next fixer dispatch that lands on a per-file natural grouping.
