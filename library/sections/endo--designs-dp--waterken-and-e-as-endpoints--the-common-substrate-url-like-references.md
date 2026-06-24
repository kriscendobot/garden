---
title: "The common substrate: URL-like references"
source: designs/daemon-persistence.md
source_repo: endojs/endo
source_branch: kriskowal-doc-formula-persistence
source_commit: aefc1b87da0cebd09184668effa264fe25e1c0b5
source_date: 2026-03-08
source_authors: [Kris Kowal]
source_pr: endojs/endo#3121
source_pr_state: draft
topics: [persistence, capability-security, captp]
status: current
notes: Background framing for the Formula Persistence design. See [[endo--designs-dp--frame-and-position-in-design-space]] for the resulting position in the design space.
parent: endo--designs-dp--waterken-and-e-as-endpoints
---

Both models share the notion of a **URL or URL-like reference**
(sturdy reference, locator) that weakly retains a capability on a peer
and can be redeemed for a live reference.

- In the Waterken model, these references must be persisted
  **indefinitely**, or dependent distributed processes are silently
  corrupted (they wait forever for references that will never return).
- In E, sturdy references and locators are the basis for restoring
  connectivity after partition heals.

In both models, **petname systems are expected to be built on top of
these reference mechanisms.** Formula Persistence's distinctive move
is to invert this layering — petnames become the persistence root, and
the URL-like reference layer is derived from them (see
[[endo--designs-dp--formula-graph-and-cohort-destruction]]).
