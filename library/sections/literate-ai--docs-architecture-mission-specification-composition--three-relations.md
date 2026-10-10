---
title: Mission specifications: three relations that must not collapse
source: docs/architecture/mission-specification-composition.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Using the Virtual Factory Initiative (VFI) structure proposal as a stress test, Literate AI separates three relations a large application needs: a specification-node hierarchy (local reading context inside one Component), explicit node references (imported behavioral or interface statements), and Component capability edges (between independently generated, built, tested, cached, versioned, and published units, where only the public interface crosses the agent context boundary).

The VFI structure proposal stress-tests Literate AI. A large application needs narrow human-readable documents, reusable cross-cutting guidance, independently generatable Components, explicit interfaces, and enough structure for an agent to assemble the right context without flattening the whole product into one prompt.

Literate AI supports that goal through three different relations, which must not be collapsed into one directory tree:

- A **specification-node hierarchy** supplies local reading context inside one Component. It does not create a build, cache, or publication unit.
- An **explicit node reference** imports another local behavioral or interface statement. It does not select an OS, language, toolchain, package, or implementation method.
- A **Component capability edge** connects independently generated, built, tested, cached, versioned, and published units. Only the dependency's public interface crosses the coding-agent context boundary.

The source diagram shows a root specification node as context parent of backend, frontend, and protocol parts (with backend and frontend explicitly referencing protocol) inside one Component. Across Components, an application Component requires a feature Component's capability, which requires a core Component's public interface. Pinned skills (conversion technique) and selected Flavors (OS, language, build) feed the feature Component from outside.

Source: [docs/architecture/mission-specification-composition.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/mission-specification-composition.md) at commit `fcc40bc`.
