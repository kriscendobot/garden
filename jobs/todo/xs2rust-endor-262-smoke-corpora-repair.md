---
model: opus
---
# Repair endor-compile corpus smoke tests broken by the corpora→cases retirement (PR #600)

**Repo:** `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600 — keep DRAFT). The Rust
workspace is `rust/engine`, NOT the repo root (the root Cargo.toml is a different workspace whose
xsnap crate does not build; run all cargo commands from `rust/engine`). Get your isolated checkout
with `scripts/jobs/ensure-project-worktree.sh <your-base> endojs/endo-but-for-bots xs2rust-endor`
and sync to the REAL remote tip before working.

**Context.** Convergence child 2/5 (commit `39665c235d`) retired the curated corpus dir
`rust/engine/endor-262/corpora/*.js` into the test262-shaped `endor-262/cases/` tree. Each
converted case preserves its original one-line program VERBATIM in an `info: Source: <program>`
frontmatter line, and endor-262's `corpora_programs()` (`endor-262/src/compile_diff.rs:417`, with
helper `case_source_line`) was repointed to read `cases/` — but TWO endor-compile tests were
missed and still `read_dir` the deleted directory, so `cargo test --workspace` now FAILS
(EXIT=101, "read corpus dir .../endor-262/corpora: No such file or directory"):

- `rust/engine/endor-compile/tests/corpus_parse_smoke.rs` (`corpus_dir()` → `../endor-262/corpora`)
- `rust/engine/endor-compile/tests/corpus_scope_smoke.rs:16` (same path)

**Task (tests only — NO compiler/runtime source changes).** Repoint both smoke tests at the
surviving programs: walk `../endor-262/cases/**/*.js` and extract each case's `info: Source:`
frontmatter line. endor-compile cannot depend on endor-262 (endor-262 depends on endor-compile —
circular), so carry a small local extraction helper inside the tests (mirror
`case_source_line`'s logic; a shared `tests/` helper module included by both files is fine).
The repaired tests must cover the SAME 1,711 programs the corpus carried (assert the count so a
future cases/ regression is caught), preserve their existing per-program assertions unchanged,
and keep their names/intent (parse smoke, scope smoke).

**Verify (evidence in your report, not assertions):**
1. From `rust/engine`: `cargo test --workspace -- --test-threads=1` captured to a FILE and `$?`
   checked directly (a pipe to `tail` masks the exit code) → **EXIT=0**, all `test result:` lines
   0 failed. This requires the oracle: populate `c/moddable` at pin `23b4d6b0a65f` (moddable
   8.3.1) per `rust/engine/README.md` § Building the oracle (seed from a sibling
   `project-wt-*/c/moddable` checkout under the scratch dir if GitHub is slow; NEVER `git add`
   c/moddable). `cargo` is at `$HOME/.cargo/bin`.
2. Quote the two repaired binaries' program counts (expect 1,711 each).

**Land:** commit ONLY the test files (explicit pathspecs), push `origin HEAD:xs2rust-endor` with
a rebase-CAS loop, verify the push by git EXIT CODE. Keep the PR DRAFT; no PR comment; no
maintainer messages. Report via your tada completion report ONLY — do NOT inbox-send the
supervisor (a send to a parked supervisor dead-letters into a noise job).

**Sizing:** fits one 2400s invocation; if the workspace test build threatens the budget, land the
fix + the two repaired binaries' green runs and report the workspace run as far as it got.
