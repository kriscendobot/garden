---
title: "Retained library bindings: consumer execution inputs and the reviewed test inventory"
source: docs/architecture/retained-library-bindings.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [testing, tooling]
status: current
---

> Abstract: Native consumer execution requires `RetainedCargoExecutionInputs` captured from consumer files, verified package trees, and an explicit `CARGO_HOME` (Git-pack hard-link groups and `CACHEDIR.TAG` timestamp rewrites are narrowly tolerated); a test-observation adapter matches `cargo test --no-run` JSON to every reviewed target and each libtest case exactly once; `RetainedCargoTestInventory` is the importing maintainer's versioned expectation, and the runner rechecks binaries, inventory, tools, and inputs at every list/run boundary.

Internal native execution requires `RetainedCargoExecutionInputs`, captured from
local consumer files, verified package trees and an explicit `CARGO_HOME`. The
capture includes provisioned registry/Git files and both Cargo configuration names
in the Cargo home and external ancestors, including guarded absences. The execution
environment must match the capture, and gate/tool environment overlays cannot select
another Cargo home. Metadata before and after gates must name captured manifests
and target sources. A caller-supplied identity callback is no longer accepted.

Cargo hard-links Git pack files between its database and checkout metadata. That
cache tree permits a hard-link group only when every alias is captured beneath the
same Git root. Link counts, physical identity and bytes are rechecked; an external
alias, replacement or mutation invalidates custody. Consumer source, registry files
and materialized packages retain their stricter no-hard-link rules. Cargo's mutable
home-level usage/lock metadata is outside the source trees and is not source evidence.
For the root `git/CACHEDIR.TAG` and `registry/CACHEDIR.TAG` backup markers, capture
retains exact bytes, device, inode, mode, size and link count while allowing timestamp
rewrites. [Older Cargo writes these markers on access](https://github.com/rust-lang/cargo/blob/0.76.0/crates/cargo-util/src/paths.rs#L675).
Changed bytes, replacements, additions and removals still invalidate custody;
markers inside package source trees receive no timestamp exception.
Arbitrary extra paths selected by configuration or build scripts still require
reviewed authority; this capture does not by itself complete consumer admission.

The internal Cargo test-observation adapter matches the JSON artifact stream from
`cargo test --workspace --all-targets --no-run --message-format=json` to every
selected reviewed target, accounting for required features and excluding build
scripts. It requires the complete target set, successful compilation, distinct
executables under the selected output root and matching package/target fields.
The metadata `test` flag is not a selection filter for explicit `--all-targets`;
see the [Cargo test target-selection rules](https://doc.rust-lang.org/cargo/commands/cargo-test.html#target-selection).

For each guarded libtest binary, the checker compares terse discovery with reviewed
case names and requires each name exactly once in the passing pretty-format result.
Ignored, filtered, missing, duplicated or unrecognized results refuse. Identical
case names in different binaries remain separate observations. Empty targets are
represented explicitly; a receipt still requires positive tests overall. These
parsers do not run or authenticate binaries, finalize receipts, or establish custom
harness semantics. The runner must bind measured compilation, current input and
binary custody, original gates and retained logs before admission.

`RetainedCargoTestInventory` is the versioned importing-maintainer expectation.
It binds the importer project, exact workspace-plan identity and gate-policy identity
to sorted, unique target keys and case names. Its target set must equal the shared
workspace/all-targets selection. Empty targets are explicit, while total expected
cases must be positive and bounded. The artifact matcher and inventory checker
share target selection and case-name validation.

`read_retained_cargo_test_authority` requires an independently reviewed inventory
blob reference, pins its exact bytes and size, and compares all three authority
bindings before returning a guarded reader. A changed case list requires new review;
binary discovery cannot silently rewrite expectations. Missing/foreign targets,
wrong project/plan/policy identities, duplicate or malformed fields, path aliases and
symlinked files refuse. This reader does not execute tests or finalize a receipt.

Internal consumer execution can take the matching `RetainedCargoTestAuthority`.
After every original reviewed gate, it compiles the full workspace target set with
locked dependencies and the reviewed target/features into a fresh owned directory.
It retains that directory on success and failure. Before any test process, every
selected binary is captured under bounded byte custody with physical file and
parent-directory observations. Each list/run boundary rechecks the entire binary
set, inventory, measured tools and consumer inputs. Per-command observations bind
the executable authority and retain stdout/stderr, including failed results.

Source: [docs/architecture/retained-library-bindings.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/retained-library-bindings.md) at commit `fcc40bc` (source lines 483–543).
