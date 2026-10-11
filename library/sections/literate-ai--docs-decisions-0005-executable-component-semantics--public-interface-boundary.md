---
title: "ADR 0005: Generation sees public interfaces, not dependency internals"
source: docs/decisions/0005-executable-component-semantics.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Consumer generation sees only an identity-bearing `PublicInterfaceContract` with API semantics and intentional direct-dependency re-exports; exact provider revisions live in separate bindings, and private specifications, source, skills, workflows, oracles, and verifier facts never cross the authority boundary as a fallback.

`PublicInterfaceContract` is the complete and only dependency material visible while a
consumer is generated. It contains stable API semantics:

- one provided capability and semantic version;
- exported types and protocols;
- behavioral preconditions, postconditions, and typed errors;
- a compatibility promise;
- its canonical content identity; and
- exact, intentional re-exports of a direct dependency interface and named symbols.

It deliberately does not contain a provider or dependency Component revision. An exact
`ComponentInterfaceBinding` separately associates one provider revision and capability
with one interface identity. A private provider change therefore creates a new binding
without changing the semantic interface identity or a consumer's generation key. The
planner validates the binding against the provider's declared capability and validates
each re-export against one of the provider's direct generation dependencies.

It contains no implementation instructions, source, private specifications, private
skills, workflow/routing material, acceptance oracles, or verifier-only facts. Those
remain in the provider's authority boundary. A transitive interface is invisible unless
a direct dependency deliberately re-exports it as part of its own public contract. A
re-export therefore changes the direct dependency's interface identity and invalidates
its consumers.

A missing, ambiguous, or incompatible public interface is a planning error. Injecting
the provider's full specification or source is not a fallback.

Source: [docs/decisions/0005-executable-component-semantics.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0005-executable-component-semantics.md) at commit `fcc40bc` (source lines 36–63).
