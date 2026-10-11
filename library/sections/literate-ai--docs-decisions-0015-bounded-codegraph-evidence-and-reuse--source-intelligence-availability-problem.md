---
title: "ADR 0015: Source-intelligence availability problem"
source: docs/decisions/0015-bounded-codegraph-evidence-and-reuse.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing, software-supply-chain]
status: current
---

> Abstract: Repeated CodeGraph initialization over content-identical disposable trees made a derived evidence provider an excessive cross-platform availability dependency even though compilation, acceptance, source manifests, SBOMs, and tree identities were healthy.

Literate AI uses CodeGraph at project-maintenance and generated-source boundaries to
bind an exact source tree to an executable and runtime, a frozen SQLite artifact,
declarations, references, call relationships, and bounded counts. Release qualification
then exposed repeated failures on disposable replicas, especially on path-sensitive
Windows runs, while the sanitized runner discarded the diagnostic stderr.

The ADR rejects both extremes: removing the evidence would weaken generated-source
admission, while re-running an unchanged fallible provider at every replica would add
availability cost without stronger evidence. Because the change alters when a mandatory
provider runs and when captured evidence can satisfy the gate, the maintainers treat it
as governed release scope.

Source: [docs/decisions/0015-bounded-codegraph-evidence-and-reuse.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0015-bounded-codegraph-evidence-and-reuse.md) at commit `fcc40bc6`.
