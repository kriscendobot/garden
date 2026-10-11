---
title: "ADR 0002 (Python reference kernel, isolated Node tooling): Consequences and validation"
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

> Abstract: The choice reuses OVA's Python contracts with a small inspectable runtime supply chain while contributors still need Node for OpenSpec validation; validation checks the exact pins, private native-prerequisite install, npm confined to the tool directory, Node-independent imports, and dependency-direction tests.

## Consequences

- OVA extraction can reuse its strongest Python contracts and tests with minimal semantic
  translation.
- The framework starts with a small and inspectable runtime supply chain and validates
  dependency evidence against the official CycloneDX 1.7 JSON schema.
- Consumers in other languages can implement the same schemas and ports.
- Contributors still need Node.js for strict OpenSpec validation until a suitably stable
  standalone validator exists.
- Python cannot by itself provide every desired sandbox guarantee; native helpers may be
  added behind audited ports rather than embedded into domain code.

## Validation

- `pyproject.toml` declares Python 3.11+ and exactly pins the CycloneDX library's
  JSON-validation extra.
- the build backend is an exact reviewed pin rather than an unconstrained resolver input.
- `make install` follows [ADR 0032](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0032-tuple-specific-native-install-sboms.md): it
  proves or explicitly installs tuple-specific native prerequisites, then installs the
  package and its pinned Python dependency closure in a private environment.
- `make tools-install` installs npm dependencies only beneath `tools/openspec/`.
- Python import/unit checks run independently of Node.js.
- dependency-direction tests will prevent domain imports of optional adapters/UI/native
  helpers.

Source: [docs/decisions/0002-reference-implementation-ecosystem.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0002-reference-implementation-ecosystem.md) at commit `fcc40bc` (source lines 59–82).
