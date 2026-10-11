---
title: "ADR 0002 (Python reference kernel, isolated Node tooling): Context and decision"
source: docs/decisions/0002-reference-implementation-ecosystem.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: A root-level npm scaffold that only pinned the OpenSpec CLI made the framework look Node-based and blurred tooling into the runtime supply chain, so the kernel is Python 3.11+ with one pinned CycloneDX validation dependency, Node is never needed at runtime, and portable JSON Schemas stay language-neutral.

- Status: Accepted; amended for CycloneDX validation
- Date: 2026-08-02
- Decision owners: literate-ai maintainers
- Supersedes: the ambiguous root-level npm scaffold

## Context

The first architecture commit placed `package.json` and `package-lock.json` at the
repository root solely to pin and execute the OpenSpec CLI. That layout made the
repository look like a Node.js framework even though the domain design proposed Python
for OVA-compatible extraction. It also made a contributor-only npm dependency tree look
like part of the framework's runtime supply chain.

literate-ai needs a conservative implementation ecosystem. OVA's reusable vertical
slice, schemas, orchestration, tests, and compatibility boundary are Python. The portable
value lies in versioned wire contracts and lifecycle semantics, not in requiring every
consumer to run one language runtime.

## Decision

The initial reference kernel SHALL be a Python 3.11+ distribution named `literate-ai`
with import package `literate_ai`. It admits one exactly pinned runtime capability:
`cyclonedx-python-lib` with its strict JSON-validation extra, behind the dependency
adapter. This implements the standards boundary for every generated source and resolved
SBOM without teaching the neutral domain about a Python library. Future runtime
dependencies require an explicit decision covering maintenance health,
security history, release cadence, license, transitive size, replacement strategy, and
which architectural port contains them.

Node.js SHALL NOT be required to install, import, or run the framework kernel. The pinned
OpenSpec CLI remains contributor tooling under `tools/openspec/`, with its own private
package manifest, lockfile, installation target, and ignored `node_modules`. Repository
validation may require this tool; framework runtime does not.

Portable schemas use JSON Schema and canonical serialization independently of Python.
Optional TypeScript may implement a future console/presentation adapter. Security-sensitive
CAS, sandbox, or execution helpers may later use Rust or platform-native code behind
versioned ports. Neither choice changes domain or wire-contract ownership.

Source: [docs/decisions/0002-reference-implementation-ecosystem.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0002-reference-implementation-ecosystem.md) at commit `fcc40bc` (source lines 1–40).
