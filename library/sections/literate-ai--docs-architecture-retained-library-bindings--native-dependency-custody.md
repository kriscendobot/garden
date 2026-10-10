---
title: "Retained library bindings: native dependency observation and file custody"
source: docs/architecture/retained-library-bindings.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [capability-security, testing]
status: current
---

> Abstract: The portable ELF/PE/Mach-O dependency observer accepts explicit native library roots, a supplied Windows environment, and an explicit `artifact_files` selection; `capture_retained_native_files` binds materialized graph files by SHA-256 and physical identity (a 608-component macOS graph, 81 MB across nine files), and `observe_retained_native_dependencies` re-observes the whole native graph at every execution boundary so a changed system image or edge refuses, which the Cargo test runner now applies per test binary.

The existing `PortableHostDependencyObserver` accepts explicit native library roots
and forwards them to ELF, PE and Mach-O observation. Mach-O `@rpath` and bare runtime
names can resolve through these roots; multiple valid images still refuse as
ambiguous. This allows the Cargo runtime fixture's generated library and Rust
standard library to join the same recursively observed graph as system/shared-cache
images. The portable observer can also take `windows_environment`; PE observation
copies and normalizes its case-insensitive keys, then resolves system/API-set files
and PATH directories from those supplied values. Missing explicit SystemRoot,
ambiguous keys, relative paths and empty search-path elements refuse. Omitting the
argument preserves observation-time host lookup for existing callers. This does not
change how independently measured inspector tools are selected.

Native observers also accept an explicit `artifact_files` selection (1–4,096
unique absolute paths). Every selected file must remain a regular native-format
file beneath the artifact root with a safe parent path. Missing files, links,
directory selections and format mismatches refuse. Omitting the selection preserves
whole-tree discovery. This lets the consumer supply its reviewed test binaries at
their original paths without copying them or treating unrelated Cargo object files
as runtime seeds. The caller still owns selection completeness and process-time
custody; explicit selection is not a complete-directory SBOM claim.

The 608-component macOS diagnostic graph is locally verified. Composition with
process-time custody and complete execution-environment resolution on every host is
still required before it becomes consumer admission evidence.
The same native diagnostic now observes the original Cargo binary in place and
retains 608 components and 7,162 edges, including that exact binary path, its
generated provider library and the Rust standard library. Its graph and byte
identities were verified independently after observation.

`capture_retained_native_files` binds the materialized portion of that observation
to current files. It snapshots the graph bytes, requires each recognized native or
inspector path to match its recorded SHA-256, and captures the physical file and
parent identities. Materialized Mach-O records also require the observed loader
path, resolved file and complete symbolic-link chain to agree. Rechecks reject
byte drift, same-byte file replacement, parent replacement and link replacement.
Duplicate component references to one file share its captured byte budget. Limits
are 10,000 components/physical nodes, 128 MiB per file, 256 MiB of file bytes and
16 MiB of observation JSON.

The native probe captures 81,483,752 bytes across nine distinct files, 42 physical
path nodes and nine loader paths. Its 597 unmaterialized components remain
explicit in the result. This is file custody for a supplied observation; it does
not authenticate a supplied graph or qualify shared-cache/system-image authority.
Consumer integration must bind current native observation, these guards and the
remaining host authority around execution before issuing admission evidence.

`observe_retained_native_dependencies` composes native observation and file custody.
It freezes the artifact files, library roots, Windows observation environment, host
platform and graph root reference. It re-observes the entire native graph after
capture and at each requested execution boundary, with materialized-file checks
before and after inspection. A changed system-image record or dependency edge
refuses even when every captured file still matches. Inspector discovery and native
graph construction run again; a stored graph is not used as a substitute for that
current observation. This deliberately incurs native-inspection work at each check.

The internal Cargo test runner now creates a native guard for each exact test
binary at its original path, using the captured generated/compiler library roots.
On Windows it supplies that target's composed process environment to PE
observation; on macOS it projects the same composed environment through the explicit
library/framework path controls. Each list/run process checks the binary/input guards, re-observes the
native graph and checks file custody again; a graph change stops execution before
accepting test results. The process executable authority includes the native guard
identity. This does not yet make the generated/compiler roots a complete model of
all caller loader overrides or arbitrary dynamic imports, and it does not issue a
durable importer admission receipt.

The native Rust diagnostic passes both dynamic sum/overflow cases with graph checks
around list/run and exact libtest verification. Consumer execution must still bind
the complete reviewed selection, actual loader environment, input/tool guards and
durable results to this primitive. It does not independently establish arbitrary
dynamic imports or a production containment boundary.

Source: [docs/architecture/retained-library-bindings.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/retained-library-bindings.md) at commit `fcc40bc` (source lines 598–668).
