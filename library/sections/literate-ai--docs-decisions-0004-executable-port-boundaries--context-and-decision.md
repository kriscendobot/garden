---
title: "ADR 0004 (executable ports): Context and decision"
source: docs/decisions/0004-executable-port-boundaries.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Literate AI removes speculative mapping protocols and retains shared ports only where an implemented application service injects a capability with real typed or durable-JSON contracts, at least one adapter, and executable seam tests that reject identity drift or malformed authority-crossing output.

- Status: Accepted for bootstrap
- Date: 2026-08-03
- Decision owners: literate-ai maintainers
- Supersedes: the speculative Python protocol catalog introduced by ADR 0001

## Context

The bootstrap port package declared generic mapping protocols for specifications,
catalogs, source, intelligence, origin verification, resolution, models, validation,
classification, builds, sandboxes, artifacts, publication, events, references,
settings, and workspaces. Most had no application-layer consumer. Several contradicted
the typed APIs already implemented: for example, the generic publication protocol did
not match `PublicationService`, and the generic specification protocol did not match
`OpenSpecProvider`.

An unused interface is not an architecture boundary. It is an untested second design
that can drift independently of both the use case and its adapter.

## Decision

The shared `literate_ai.ports` package contains only protocols injected into an
implemented application service:

- model execution;
- generated-tree validation and classification;
- exact build authorization and building;
- transactional workspace acceptance; and
- lifecycle event persistence.

Readiness remains beside the generation application models because its signature uses
application-specific composition values. `BuildAuthorizer` has one definition in the
shared port package and is re-exported by `literate_ai.application` for import
compatibility. The unused `RouteSelector` protocol is removed; `ModelRouter.select`
already owns that pure decision.

Lifecycle ports continue to exchange canonical JSON because their outputs are durable
event payloads. Those payloads now have explicit typed shapes, and the orchestrator
checks the returned revision, source, classification, request, authorization, tree,
and workspace-reference identities before completing a step. Runtime-checkable
protocol tests prove that the shipped local adapters expose the injected methods.

OpenSpec, source capture, intelligence, storage, settings, and publication keep their
existing typed service APIs. Source-to-specification keeps narrowly typed callable
protocols at its application seam. A capability moves into the shared port package only
when all of the following exist:

1. an application service that receives the capability as a dependency;
2. a signature expressed with real domain or application values, or an explicit durable
   JSON contract;
3. at least one adapter that conforms to it; and
4. a seam test that rejects identity drift or malformed output where authority crosses.

Source: [docs/decisions/0004-executable-port-boundaries.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0004-executable-port-boundaries.md) at commit `fcc40bc` (source lines 1–53).
