---
title: "Retained library bindings: test runtime environment capture"
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

> Abstract: Test binaries run in their package directory with captured compiler runtime libraries (file symlinks bound only in the compiler directory, at most 64 links), generated and build-script link-search directories prepended to the loader path, package-scoped `rustc-env` projection, and fully captured build-script `OUT_DIR` trees, all under explicit entry/byte bounds and rechecked at every process boundary; complete loader-path and external build-input authority remains required before public admission.

This path executes each binary in its package directory with `CARGO_MANIFEST_DIR`.
It queries the measured compiler for the reviewed target's runtime library directory
and captures those files before compilation. Before test execution it also captures
the generated base/dependency directories and in-output build-script link-search
directories, then prepends these paths to the platform's loader environment variable.
Every immediate file, directory entry and physical replacement is rechecked around
test processes; the executable authority binds the runtime capture identity.
Compiler runtime capture explicitly permits file symlinks only in its selected
compiler directory, including when captured alongside generated directories. This
includes distro links to libraries outside the reported directory. It binds each link's text and physical
identity, all traversed ordinary parent directories, the resolved regular file and
its bytes. Cycles, more than 64 links, directory aliases, dangling targets and
interior parent traversal refuse; leading relative parents support distro layouts.
Alias and parent records share the 10,000-entry budget, and target bytes retain the
128 MiB per-file and 512 MiB aggregate limits. Re-observation rejects retargeting,
same-byte file replacement and parent replacement. Generated runtime directories
continue to reject symlinks. This capture is not independent compiler admission.
The native fixture passes all seven standard-harness targets with dynamic Rust
runtime linkage and rejects runtime-file drift.

The checked compilation stream also supplies package-specific `rustc-env` values
for direct test processes, matching Cargo's
[documented runtime projection](https://doc.rust-lang.org/cargo/reference/build-scripts.html#rustc-env).
The projection binds to executable authority and stays within the emitting package;
it preserves empty values and values containing `=`. Unknown package IDs, malformed
entries, duplicate keys and conflicting host/target build outputs refuse. Bounds are
4,096 script records, 256 variables per record, 128 characters per name, 65,536 per
value and 1 MiB of aggregate UTF-8 name/value bytes. A script cannot redirect the
package's `CARGO_MANIFEST_DIR`; existing consumer guards still reject changes to
reviewed external roots, Cargo home, compiler and output selection. Loader paths
are composed after the package overlay. The native seven-target fixture includes a
runtime variable lookup checked against its compile-time value.

Every `build-script-executed` record must name a known package and an `out_dir`
strictly beneath the fresh compilation root. Before tests run, the runner captures
every nested file and directory in these output trees, including empty directories,
and the physical parent chain. Each executable authority binds the output capture;
each process boundary rechecks its bytes, entries and parent identity. Missing or
overlapping output trees, symlinks, hardlinks and file replacement refuse. The
capture allows at most 128 output roots, 10,000 total entries (including captured
parents), 16 MiB per file and 256 MiB overall. Limits are shared across all output
trees. The native fixture reads nested generated data through `env!("OUT_DIR")`;
changing that data after discovery stops execution.

These are bounded captures: at most 128 search directories, 10,000 entries, 128 MiB
per file and 512 MiB overall. Nested directories need their own selected search path.
Cargo's [documented loader-path behavior](https://doc.rust-lang.org/cargo/reference/environment-variables.html#dynamic-library-paths)
also includes caller paths and platform defaults. Complete authority for those paths,
system/shared-cache loaders, other paths named by build-script environment values
and arbitrary external build-script inputs remains required
before public admission. The internal
observations do not finalize a durable consumer receipt or provide containment.

Source: [docs/architecture/retained-library-bindings.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/retained-library-bindings.md) at commit `fcc40bc` (source lines 545–596).
