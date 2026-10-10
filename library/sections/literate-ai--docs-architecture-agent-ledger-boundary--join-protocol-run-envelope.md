---
title: The derivation-run envelope join protocol
source: docs/architecture/agent-ledger-boundary.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, agent-fleet-orchestration]
status: current
---

> Abstract: A future derivation-run envelope carries semantic content identities (request, input closure, selected Component/spec/Flavor/skill/route/model/tool, prompt and response blobs, decisions, generated-tree and evidence identities, outcome, journal) rather than host paths; task and correlation IDs join records across systems but are excluded from every derivation, cache, and artifact identity.

One future `derivation-run` envelope should carry semantic identities rather than host paths or mutable URLs:

- the request identity plus parent task/correlation metadata;
- the complete Literate AI input closure;
- selected Component, specification, Flavor, skill, workflow, route, model, and tool identities;
- framework-visible prompt and response blob identities for every model call;
- typed decision records and approval identities;
- generated-tree, source/resolved CycloneDX graph, build, test, package, and publication identities; and
- terminal outcome plus an identity for the complete journal.

Large blobs belong in an immutable content-addressed store. Each system stores the identities and typed relations it owns, so MAC can register Literate AI results as artifact and evidence records without copying source or learning build internals.

Task and correlation identifiers join records across systems but are not semantic generation inputs. They stay in envelope metadata and are excluded from derivation, source-cache, build-cache, and artifact identities: retrying the same exact derivation under another task must not manufacture different content.

The sequence: the user requests or iterates at the ledger; the ledger starts an exact derivation request; Literate AI stores prompts, responses, decisions, trees, and evidence in the artifact store and receives content identities; Literate AI returns a signed run envelope and result identities; the ledger presents status, approvals, and a customer explanation.

Source: [docs/architecture/agent-ledger-boundary.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/agent-ledger-boundary.md) at commit `fcc40bc`.
