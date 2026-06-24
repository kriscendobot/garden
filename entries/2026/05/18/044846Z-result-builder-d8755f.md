---
ts: 2026-05-18T04:48:46Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

# Phase 5 of endor-run-expanded — dependency walk + multi-compartment archive

Opened draft PR endojs/endo-but-for-bots#282 (branch `feat/endor-run-entry-point-deps`,
based on `llm` with PR #279 merged on top as a stack per
`skills/stacked-pr-build/SKILL.md`).

## What landed

`rust/endo/src/entry_walk.rs` (new, ~2235 lines including 35 unit tests):
`ingest_entry_point_with_deps(cas, entry_path)` walks the static-import
graph from `entry_path`, classifies each specifier as relative
(same compartment) or bare (resolved via sibling `node_modules` upward
from the importer), and emits a multi-compartment archive whose
compartment-map.json carries one `<unscoped-name>-v<version>` compartment
per resolved package plus the entry compartment (`entry-v1.0.0` when the
entry has no sibling `package.json`, `<pkg>-v<ver>` when it does).
Cross-compartment references use `ModuleDescriptor::Link` so the XS-side
install path (`xsnap::archive::install_archive`) lights up unchanged.

`rust/endo/src/bin/endor.rs`: `cmd_run_entry_point_with_cas` pre-scans
the entry source for static imports and routes to the walker when any
are present; entries without imports stay on the Phase 4 fast path
(`cas_archive::ingest_entry_point`). The Phase 4 regression surface is
unchanged.

`rust/endo/src/cas_archive.rs`: exposes the existing
`parser_for_extension` helper as `pub(crate)` so the walker shares the
same extension-to-parser mapping.

`designs/endor-run-expanded.md`: Status section updated to record the
Phase 5 landing, the Option A vs. Option B trade-off (XS-hosted mapper
still deferred), and the registry-table path still gated on
`endor-npm-registry-proxy` Phase 4.

## Affected paths

- `rust/endo/src/entry_walk.rs` (new, 2235 lines)
- `rust/endo/src/cas_archive.rs` (1 line: `pub(crate) fn parser_for_extension`)
- `rust/endo/src/lib.rs` (1 line: `pub mod entry_walk;`)
- `rust/endo/src/bin/endor.rs` (70 net lines: dispatch + help text)
- `designs/endor-run-expanded.md` (159 lines: Status / Phase 5 section)

Diffstat: 5 files changed, 2419 insertions(+), 48 deletions(-).

## Test count + regression evidence

129 lib tests total (35 new in `entry_walk::tests`, up from 94 after
Phase 4 / 76 before Phase 4). Coverage:

- `scan_static_imports` (5 cases): default / named / namespace /
  side-effect / re-export forms; `import.meta` / `import()` exclusion;
  dedup; empty-source short-circuit.
- `split_bare_specifier` (2): unscoped / scoped / subpath variants;
  empty-string and bare `@` rejection.
- `load_package_metadata` (5): name/version/main reader; conditional
  `exports.default`; `exports["."]` string shorthand; missing-name
  fallback to directory basename; malformed-JSON rejection.
- `find_node_modules_package` (3): upward walk; scoped; absent.
- `resolve_specifier` (8): relative with explicit ext / fall-back /
  directory-index / escape rejection; bare via `main` / `index.js`
  fallback / subpath; missing-bare returns NotFound.
- End-to-end `ingest_entry_point_with_deps` (12): relative imports
  into one compartment; bare import into separate compartment (the
  design's Phase 5 acceptance test); scoped bare; transitive deps;
  relative subdir within compartment; entry with `package.json`;
  shared-dep dedup; missing bare specifier surfaces NotFound;
  CAS round-trip via `load_archive_from_cas`; deterministic root
  hash across runs; rejects unsupported extension; rejects missing
  entry.

Regression evidence (`skills/regression-evidence/SKILL.md`): six
mutation experiments confirmed the new tests are load-bearing.

| Test | Mutation | Result |
|------|----------|--------|
| `scan_extracts_default_named_and_namespace_imports` | `matches_keyword` always false | FAILED |
| `split_unscoped_and_scoped` | `split_bare_specifier` returns `(spec, None)` always | FAILED |
| `ingest_is_deterministic_across_runs` | both `comp_ids.sort()` + `serialize_tree_sorted` sort removed | FAILED |
| `load_package_metadata_reads_name_version_main` | `name` field never read | FAILED |
| `ingest_walks_bare_import_into_separate_compartment` | `handle_import` skips Link insert | FAILED |
| `find_walks_upward_to_node_modules` | `find_node_modules_package` returns `None` | FAILED |

## CI status

Submitted at PR open time; checks queued/in-progress. The XS-required
JS bootstrap bundles (`worker_bootstrap.js`, `daemon_bootstrap.js`,
`ses_boot.js`) are gitignored and produced by the
`packages/daemon/scripts/bundle-bus-daemon-rust-xs.mjs`-shaped JS
toolchain at CI build time; my dispatch env stubbed them locally to get
`cargo check` / `cargo test` to compile.

## Out-of-scope deferrals

The design's Phase 5 lists three sub-items; this PR ships (1)
`package.json` resolution and (2) `node_modules` walking. Item (3) —
registry-table lookup for remote dependencies — depends on
`designs/endor-npm-registry-proxy.md` Phase 4 (compartment-mapper
integration), which is itself blocked on the registry-proxy work; the
walker's `resolve_bare` is set up so the registry-table fall-back is a
localised extension when that lands.

The design's chosen Option B (XS-hosted compartment mapper bundle +
two-machine handshake), which Phase 4 deferred to Phase 5, remains
deferred to a follow-up phase whose acceptance is "conditional
`exports` / dynamic `import()` / subpath patterns / per-condition
exports". For the Phase 5 acceptance test (static ES imports →
relative/bare resolution → `package.json` `exports.default`/`main`/
`index.js` cascade → `node_modules` upward walk), Option A
(Rust-native walk, this PR) and Option B converge on the same
`CompartmentMap` shape and the same on-disk CAS layout. The deferral
note in the design's Status section records the trade-off and names
the features that warrant Option B's bundle later.

## Stack

Branched off `llm` with PR #279 (Phase 4) merged in via `--no-ff` per
`skills/stacked-pr-build/SKILL.md`. Pinned at SHA `13ee82881`. When
#279 lands in `llm`, this PR's stack reduces to a single-PR delta
against the new `llm`; the maintainer can rebase via a weaver dispatch
or merge directly once #279 has landed.

## Self-improvement

Self-improvement: nothing this time. The dispatch brief was crisp
about the Phase 5 scope ("walk dependencies via compartment mapper
rather than producing a one-module synthetic compartment-map") and
flagged the registry-proxy prereq dependency explicitly, which made
the Option-A-vs-Option-B trade-off the only real scoping decision.
The Phase 4 design's pre-existing "deferred to Phase 5" note for the
XS-hosted mapper provided the template for the deviation pattern I
applied here. `skills/stacked-pr-build/SKILL.md` was directly
applicable as written and the per-cycle stack-maintenance section
gave the framing for "when #279 lands, this PR's stack reduces".
