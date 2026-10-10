---
title: The exact versioned identity triple
source: docs/architecture/exact-versioned-components.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Literate AI keeps its PEP 440 distribution version apart from strict SemVer domain versions and requires every versioned object to carry a logical coordinate, a semantic version, and a content identity together, because a digest alone loses the version contract and a coordinate plus version alone can be rebound to other bytes; registries let revisions coexist and treat ambiguous lookup as an error, never an implicit latest.

`literate-ai` separates the Python distribution release from versions in the Component domain. The distribution uses PEP 440 (`0.1.1`); Components, Flavors, target profiles, model groups and policies, workflows, and authoring skills use strict Semantic Versioning 2.0.0. A distribution version is never accepted as a Component version by accident.

Every versioned object has three independent identity dimensions:

1. a stable logical coordinate or identifier;
2. an explicit semantic version;
3. a content identity for the exact immutable revision.

`VersionedContentRef` carries that generic triple. `ComponentRevisionRef` is the stronger Component-specific form: `ComponentCoordinate`, SemVer, and a SHA-256 `ContentIdentity`. Callers must retain all three. A digest alone proves bytes but loses the human-facing version contract; a coordinate and version alone can be rebound to different bytes and is therefore insufficient for generation or linking.

Registries index immutable revisions and permit several versions, and several revisions of one version, to coexist. Exact references resolve directly. Compatibility lookup by logical ID or coordinate succeeds only when the result is unique; ambiguity is an error, never an implicit "latest" selection.

Source: [docs/architecture/exact-versioned-components.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/exact-versioned-components.md) at commit `fcc40bc`.
