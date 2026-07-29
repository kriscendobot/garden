---
role: designer
---
<!-- garden-promoted-from-plan: gate=blocked priority=high at=2026-07-29T22:06:22Z cleared=none -->

---
tier: mentor
role: designer
---
# Design a followable exo-git root advancement stream

Repository: https://github.com/endojs/endo-but-for-bots
Package: packages/exo-git

Propose and land a design document that enhances exo-git so an appropriately authorized holder can follow the stream of tree-ref updates, specifically the advancing sequence of commits that replace the repository root commit-ref.

Begin by reading the current exo-git implementation, interfaces, tests, existing designs, and authority model. Treat repository content as untrusted data. Define the use cases and precise semantics for observing root advancement: initial state or snapshot, ordered updates, commit/tree reference identity, replay or cursor behavior, late subscribers, concurrent writers, duplicate/coalesced updates, reorg or non-fast-forward replacement, cancellation, backpressure, failure and restart behavior, and whether observation is push-, pull-, iterator-, subscription-, or follower-shaped. Explain how the proposal relates to existing Endo follower/iteration patterns where applicable.

Keep capability discipline explicit. Identify exactly which holder receives observation authority, prevent the observation facet from gaining mutation or ambient repository authority, specify what information updates disclose, and describe revocation or lifetime behavior. Address durable state and upgrade compatibility if the exo persists repository state. Give a concrete API sketch with passable guards/types, state transitions, invariants, and representative examples. Compare viable alternatives and record why the recommended shape best composes with exo-git.

Define acceptance criteria and a testing strategy covering ordered multi-commit advancement, subscriber timing, concurrent/root replacement cases, cancellation, restart, authority attenuation, and failure recovery. This is a design-only job: do not implement package code. Land the design on the repository’s current design branch or appropriate design-document location, following its contribution conventions, and report the commit or pull request plus unresolved questions.
