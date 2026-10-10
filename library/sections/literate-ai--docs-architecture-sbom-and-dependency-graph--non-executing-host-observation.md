---
title: "CycloneDX SBOM and dependency graph: non-executing host observation"
source: docs/architecture/sbom-and-dependency-graph.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [software-supply-chain, agentic-sdlc]
status: current
---

> Abstract: Resolved dependency discovery inspects Mach-O, ELF, PE, npm launcher, and Python distribution closures without executing generated binaries or opaque wrappers, binding every inspector and helper by exact path, version, digest, arguments, and bounded output.

Binary dependency discovery must not launch an untrusted generated executable. The
reference lifecycle recursively observes each selected host format:

| Host | Reference observation |
| --- | --- |
| macOS | Resolve `dyld_info` through exact `xcrun`, then inspect Mach-O UUIDs, linked images, and `LC_RPATH` recursively. |
| Linux | Use `readelf` plus exact `ldconfig` loader-cache and declared search-root evidence to inspect ELF interpreter, `NEEDED`, `RPATH`, and `RUNPATH`; `ldd` is forbidden for untrusted binaries. |
| Windows | Select `dumpbin` or `llvm-readobj --coff-imports`, resolve direct and delay-load PE imports through bounded roots, and resolve API-set contracts through the exact parsed `apisetschema.dll` namespace. |

An npm package graph is not an execution graph. Bazel autodiscovery never executes PATH
Bazelisk: it selects and directly probes a Bazel binary from Bazelisk's SHA-256-addressed
cache and verifies that the binary digest matches its cache directory. Package-backed
source-graph indexers receive no launcher exception. The resolver locates the exact npm
owner, requires its installed current-platform optional bundle, bypasses npm shims and
shell scripts, and invokes the bundle-owned Node and entrypoint directly. It records the
package-to-bundle-to-entrypoint graph and includes Node's native closure. Missing or
mismatched bundles fail closed.

Package traversal is bounded to manifest-declared reachable dependencies with npm-name,
containment, identity, link/junction, file-count, and byte limits. Orphan packages remain
excluded, and native helper files do not become false direct root edges. The self-hosting
Python observer similarly begins from exact project dependencies, evaluates markers and
extras for the bound host, follows installed distribution metadata recursively, and
excludes installed-but-unreachable distributions.

Every inspector, launcher helper, and argument/output contract is bound and rechecked.
Missing or changed tools, ambiguous libraries, malformed or oversized output, unsupported
binaries, and incomplete package graphs stop resolution before tests. Canonical UTF-8
documents omit timestamps and random serials. The post-build document preserves every
pre-build reference, edge, and relationship record; it may narrow an external range to an
exact version and add observed transitive nodes, but removal, reparenting, relabeling, or
alternate-reference substitution fails.

Source: [docs/architecture/sbom-and-dependency-graph.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/sbom-and-dependency-graph.md) at commit `fcc40bc` (source lines 241–319).
