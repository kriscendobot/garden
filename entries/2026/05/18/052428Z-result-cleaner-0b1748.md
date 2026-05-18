---
ts: 2026-05-18T05:24:28Z
kind: result
role: cleaner
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/18/044846Z-result-builder-d8755f.md
---

# Cleaner pass on PR #282 (endor-run-expanded Phase 5)

Dispatch root: `/home/kris/dispatches/cleaner--0b1748/`.
Branch: `feat/endor-run-entry-point-deps` (stacked on PR #279).

## Commits pushed

- `6095c7e56 style(endo): cargo fmt entry_walk.rs` (1 file, +4 -3).
- `0696e94ed test(endo): adversarial regressions on entry_walk resolution
  cascade` (1 file, +94).

`git push origin HEAD:feat/endor-run-entry-point-deps` succeeded; CI on
the cleaner's HEAD converged to green on all 25 checks (browser-tests,
build, build-wasm, check-action-pins, cover x 2, familiar-bundle, lint x 2,
sandbox-drivers, test, test x 6 across 20.x/22.x/24.x x ubuntu/macos,
test-async-hooks, test-hermes, test-ocapn-python, test-xs, test262 x 2,
viable-release x 2).

## cargo fmt / clippy / test before and after

### Before the cleaner pass

- `rustfmt --check rust/endo/src/entry_walk.rs`: one diff in
  `Walker::handle_import` (a chained `get(...).ok_or_else(...)` that
  rustfmt prefers in dot-aligned form).
- `cargo clippy -p endo --all-targets --all-features`: 25 pre-existing
  warnings, none from the PR's touched files (the only warning at
  `bin/endor.rs:89` is on a line untouched by this PR; the xsnap build
  script's `&PathBuf` lints predate the endor crate entirely). No new
  warnings introduced by `entry_walk.rs`, `cas_archive.rs`, `lib.rs`,
  or `bin/endor.rs`.
- `cargo test -p endo --lib`: 129 pass, 0 fail.

### After

- `rustfmt --check rust/endo/src/entry_walk.rs`: clean.
- `cargo clippy -p endo`: same 25 pre-existing warnings; nothing added.
- `cargo test -p endo --lib`: 132 pass, 0 fail (+3 from the adversarial
  sweep below).
- `cargo test -p ocapn_noise_protocol_facilities`: 0 tests (crate has no
  tests); compiles cleanly.

### Notes on the workspace's other Rust crates

The `xsnap` crate's tests fail when run from a fresh checkout because
three JS-bundle files (`ses_boot.js`, `worker_bootstrap.js`,
`daemon_bootstrap.js`) are gitignored and only produced by the
JavaScript build step in `packages/daemon/scripts/`. The cleaner kept
empty stubs in place locally (per the dispatch's *Build prereqs*
instruction) so the endo crate would compile, but did not run xsnap's
test suite. This PR does not touch xsnap; the bundle-stub requirement
is environmental, not a regression.

## Adversarial tests added

Three `entry_walk::tests` cases, each proven load-bearing by mutating
the smallest unit of the target code path and observing the failure
per `garden/skills/regression-evidence/SKILL.md`. Mutation strings are
quoted in each test's rustdoc.

1. **`load_package_metadata_reads_top_level_exports_string_shorthand`**
   pins the `Value::String` arm of `load_package_metadata`'s `exports`
   reader. The builder covered `{".": "./x"}` and
   `{".":{"default":"./x"}}` shapes; the bare top-level
   `"exports": "./top.js"` shorthand was untested. Bug it catches:
   silently dropping the `Value::String(s)` arm causes the shorthand
   form to fall through to `main` / `index.<ext>`, picking the wrong
   entry. Mutation experiment confirmed:
   `Value::String(_) => None` ⇒
   `left: None, right: Some("./top.js")`.

2. **`ingest_surfaces_missing_package_json_in_node_modules`** pins the
   "partially-installed dependency" failure mode: a
   `node_modules/<pkg>/` directory that exists but has no
   `package.json`. The walker must surface `NotFound` rather than
   crash or emit a successful empty archive. Bug it catches: a
   future refactor that lets `load_package_metadata` swallow the
   read error would push the failure to a downstream
   `load_archive_from_cas` layer (or worse, succeed with an
   inconsistent compartment) and the user would see a confusing
   error far from the actual cause.

3. **`scan_ignores_imports_inside_comments`** pins the block-comment
   skip in `scan_static_imports`. The crucial construction is a
   multi-line block-comment body whose interior contains an `import`
   keyword at the **start** of a line (no leading `*` decoration).
   Bug it catches: dropping the `/* ... */` skip branch lets the
   parser's `at_stmt_start` tracking treat the comment's interior
   `import` as a real statement start and emit a phantom specifier.
   Mutation experiment confirmed:
   `if false && c == b'/' && bytes[i+1] == b'*' { ... }` ⇒
   `left: ["phantom-block-multiline", "real"], right: ["real"]`.

## Cleanup nits

No nits found:

- No `dbg!`, `todo!`, `FIXME`, `XXX`, ownerless TODO comments in the
  PR's diff.
- All `eprintln!` additions in `bin/endor.rs` are legitimate CLI help
  text in `print_help` / `print_subcommand_help`.
- No dead imports or redundant `pub` in `entry_walk.rs`. The
  `pub(crate) parser_for_extension` widening in `cas_archive.rs` is
  intentional (needed by `entry_walk.rs`).

## Drift between design and implementation

One drift item, not blocking the cleaner pass but worth surfacing for
the judge / fixer chain.

**Test-count mismatch in the design's Status section.**
`designs/endor-run-expanded.md` § Phase 5 item 4 (line 483-484) reads:

> 35 new `entry_walk::tests` cases (164 lib tests total, up from 129
> after Phase 4)

The actual numbers, confirmed by `cargo test -p endo --lib` on the
builder's commit (`afdf008fe`), are:

- 35 new `entry_walk::tests` cases — correct.
- **129** lib tests total post-Phase-5 (not 164).
- **94** lib tests after Phase 4 (not 129).

The PR's commit body has the correct numbers ("129 lib tests total,
up from 94 after Phase 4 and 76 before"). The design's status prose
appears to double-count: it pasted the post-Phase-5 figure (129) into
the "after Phase 4" slot and synthesised a new larger number (164)
for the post-Phase-5 slot. A one-line fix to the design's Status
section closes the drift. I did not fix it in the cleaner pass
because doing so widens the PR's scope into the design-document
narrative, which is the gardener's surface, not the cleaner's; the
judge's design-panel jurors (if the panel is dispatched) will flag
it on their own pass, or a follow-up commit can correct it before
ferry.

## Out-of-scope items I did not pursue

Per the dispatch's *Out of scope* clause: no architecture changes to
the Option A choice, no resolver expansion to subpath patterns or
conditional exports beyond `default`, nothing from Phase 6+. The
walker's `resolve_bare` is already shaped so a registry-table fall-back
is a localised extension when `endor-npm-registry-proxy` Phase 4 lands.

## Cargo fmt drift in the wider crate

`cargo fmt --manifest-path rust/endo/Cargo.toml --check` reports fmt
diffs in `util.rs`, `cas.rs`, `codec.rs` benches, and `xsnap/src/lib.rs`.
None of those files are touched by this PR; they were already drifted
on `llm` before Phase 5 began. The cleaner does **not** widen the PR
to fix unrelated drift; a separate sweep is the right surface.

## Self-improvement

`roles/cleaner/AGENT.md` says to format the workspace if needed in
deliverable (1), but the build prereqs for the Rust crate (Moddable
submodule + three gitignored JS-bundle stubs) are not mentioned in
the role brief or in `skills/pre-pr-checklist/SKILL.md`. The dispatch
prompt mentioned them, which is what saved a wasted cycle, but in
the autonomous form (steward dispatching a cleaner without prompt
hand-holding) the cleaner would discover the prereqs by parsing
`xsnap/build.rs`'s panic message. A short *Build prereqs* row in the
endo project README at `journal/projects/endo/README.md` (currently
that file may not exist; I did not check from the dispatch root) or
in a per-project skill `skills/build-prereqs-endor/SKILL.md` would
let the cleaner walk into a fresh dispatch root and prepare the
environment without trial-and-error. I am not landing that change
from the cleaner dispatch (the cleaner does not commit role / skill
changes); routing as a `message` to `liaison` if the maintainer
wants it.

Self-improvement: a per-project *Build prereqs* note for the
endor crate (Moddable submodule + xsnap JS-bundle stubs) would
shorten the cleaner's first cycle on a fresh dispatch from
trial-and-error to a single check; the dispatch prompt handled it
this time but autonomous dispatches will hit it cold.
