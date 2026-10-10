---
title: First-class authority and evidence
source: README.md
source_repo: jordanhubbard/literate-ai
source_commit: 76f498a824f74ec94ee7d03500913025579fb15f
source_date: 2026-10-04
source_authors: [jkh]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: The harness makes Components, assets, Flavors, skills, provenance, dependency inventories, and tests first-class, content-bound inputs or evidence; changing an authoritative input changes generation identity, while deleting a cache changes cost but not meaning.

Components carry behavior, composition, and acceptance contracts. Flavors select replaceable policy such as language, operating system, build system, runtime, and packaging. Skills bind planning and implementation technique. Assets are resolved and locked as exact bytes, while model context receives metadata instead of permission to rewrite those bytes.

Provenance binds accepted source and builds to their inputs, CycloneDX SBOMs cover managed and transitive dependencies, and compact passing receipts preserve current test evidence in Git. Reuse is conditional on identity: a specification, Flavor, skill, model route, or dependency change invalidates the generation key, while removal of source or object caches merely forces reconstruction.

Source: [README.md](https://github.com/jordanhubbard/literate-ai/blob/76f498a824f74ec94ee7d03500913025579fb15f/README.md) at commit `76f498a`.
