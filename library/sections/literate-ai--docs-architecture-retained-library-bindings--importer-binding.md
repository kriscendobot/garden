---
title: "Retained library bindings: the importer binding record"
source: docs/architecture/retained-library-bindings.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, capability-security]
status: current
---

> Abstract: `literate-ai/retained-library-binding@1` records importer intent in the v2 catalog: project, named evidence store, exact export set, qualification archive/run, verifier and policy identities, a content-addressed workspace plan, and one portable non-overlapping destination per export; it has no accepted/trusted flag, and admission must resolve the store through reviewed config, reopen current evidence, and run full consumer gates.

`literate-ai/retained-library-binding@1` records importer intent in the current v2
catalog. It names the importing project, an explicitly configured evidence-store
name, the exact export set, qualification archive and selected run, verifier and
policy identities, and a content-addressed workspace plan. Every graph export,
including non-library dependencies, has exactly one destination in export-identity
order. Destinations must be portable project-relative paths, without case aliases
or parent/child overlap. Store names cannot contain paths or URLs.

The binding has no accepted or trusted flag. Parsing neither reads the archive nor
materializes packages. Admission must resolve the named store through reviewed
importer configuration, reopen current provider evidence, and validate the concrete
workspace plan's manifest/lock changes, target/features and full consumer gates.
Changing consumer source does not change the provider export identity; consumer
qualification remains a separate requirement. Transactional materialization and
boundary transfer are still required before the bridge is usable.

Source: [docs/architecture/retained-library-bindings.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/retained-library-bindings.md) at commit `fcc40bc` (source lines 32–46).
