---
title: Framework premise assessment: seven critical implementation findings
source: docs/architecture/framework-premise-assessment.md
source_repo: jordanhubbard/literate-ai
source_commit: 08ff70273a5462cf4d205b730f445a296cb3f067
source_date: 2026-10-03
source_authors: [jkh]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: At snapshot 8e4ebdb the assessment reports: source-free promotion was false and qualification could transfer authority on an assert-True test; Component composition flattened into one prompt and one tree; a fresh project could not run the golden path; inverse coverage was circular over model-declared surfaces; a v1 wire schema was broken in place; operational proof trailed the docs; and scope had outrun proof.

Findings as stated at the reviewed snapshot (line references are to that snapshot):

1. **Source-free promotion was false, and qualification transferred authority too cheaply.** Coding-mode acceptance persisted raw source excerpts and complete prompts in `.literate/source-translation.json`, and promotion copied the accepted tree into the root Component, yet qualification hard-coded `source_excluded_from_generation` as true although every coding-agent isolation profile is non-hermetic. Qualification counted successful shell commands rather than parsed test cases, and its own unit test transferred spec authority with a generated test containing only `assert True`. Called the most serious correctness issue: qualification must reuse the forced-rebuild lifecycle, consume typed generated-test and verifier evidence, map probes to required surfaces, and keep raw translation journals outside the generatable closure.
2. **Composition was metadata, not executable.** The recursive Component graph was resolved and then every dependency's documents concatenated into one `GenerationRecipe` and one source tree: deep graphs become giant prompts, a leaf change regenerates the root, cache reuse is not per Component, children are not independently built or linked, and Bazel cannot deliver Component-level incremental economics. The lifecycle needs a real DAG that generates, caches, and builds each Component and links exact artifacts.
3. **A newly initialized project could not run the golden path.** `init` created neither a lifecycle driver nor a test-receipt policy, which `rebuild` requires. The only complete lifecycle was a 5,408-line sample runner importing private CLI helpers, contradicting the domain ← application ← ports ← adapters ← CLI direction; the golden-path application service was not extracted.
4. **Source-to-specification coverage was circular.** The model's observations defined the behavioral surfaces and coverage was computed only over them, so omitted behavior is undetectable. Also: over-budget evidence silently dropped while the request still claimed full inventory; four-language parity accepted 13 of 16 keyword groups; only Python was fully promoted, regenerated, and qualified; recovered graph nodes lacked component-kind and entrypoint semantics yet all became runnable applications. Recommended framing: working alpha source-to-spec authoring with Python as reference, not semantic inverse equivalence.
5. **Versioned-contract discipline was violated.** Twelve commits and about 99,876 lines past v0.1.1 with versions unchanged, and `component_graph_draft` added as a required field to the existing `urn:literate-ai:schema:v1:source-to-specification-result` schema, so the official v1 wire schema rejects previously valid documents; a release-blocking defect for an immutable-contract framework (preserve v1 or mint a new identity plus migration).
6. **Operational proof trailed documentation.** The configured `verification/current.json` did not exist; CI ran no authenticated samples, round trips, remote fan-out, release-check, or receipt validation; repository-source acquisition was still ports plus test doubles; samples were mostly dependency-free bounded JSON programs. Coding-agent execution and native builds run non-hermetically as the current user after authorization: honest for an alpha, not an enterprise containment boundary.
7. **Scope outran proof.** About 101,967 Python lines, 26 JSON schemas, several 1,500-4,500-line modules, and the 5,408-line runner, for a four-day-old implementation still lacking a reusable lifecycle; the lockfile split, bounded repair loop, standard driver, and one realistic application are judged more valuable than further schemas or record types.

Source: [docs/architecture/framework-premise-assessment.md](https://github.com/jordanhubbard/literate-ai/blob/08ff70273a5462cf4d205b730f445a296cb3f067/docs/architecture/framework-premise-assessment.md) at commit `08ff702`.
