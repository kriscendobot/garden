# Research: FRB operators for Endo/Exo collections with query + subscriber facilities

Investigate **potential uses of operators in FRB** (Functional Reactive Bindings;
upstream `kriskowal/frb`, now forked under the bot) to construct **Endo and Exo
collections** that provide **query** and **subscriber** facilities for **synchronization
between agents**. This is a research-and-design investigation — read the real
libraries and recent work, do not theorize from memory. Deliverable is a design/
investigation report.

## What the maintainer wants explored

- **FRB operators** as the basis for reactive collections: survey FRB's operator/
  observer/binding model (sorted, map, filter, range, window operators, etc.) and how
  they compose into incremental, observable transformations.
- **Layering:** the implementation should exist at the **Endo level** and be **lifted
  to passable at the Exo layer** — i.e. plain Endo modules implement the reactive
  collection machinery; Exo exposes them as passable/remotable exo objects. Spell out
  what lives where and how the lift works (passable representations, remotable facets).
- **Hardened modules:** these must be **hardened** (SES `harden`, no ambient
  authority, defensive against untrusted callers). Note the hardening constraints on
  reactive/observer code (no leaks via subscriptions, GC/teardown of watchers).
- **The specific structure of interest:** a **splay tree backed by a sorted array**
  (or a **sorted-array-set interface**) and **operators thereon that produce topics
  watching a sliding window of an arbitrary other ordered collection** — i.e. given an
  ordered collection, an operator yields a topic/subscription over a sliding window
  (range) into it, kept in sync incrementally. Explore the interface, the operators,
  and how a window-topic stays consistent as the underlying collection mutates.
- **Query + subscriber (pubsub) facilities for agent synchronization:** how these
  collections expose queries and subscriptions so agents synchronize state — and how
  that relates to **recent pubsub-topics work** (find it in `endojs/endo-but-for-bots`,
  e.g. recent `topic`/pubsub designs and PRs) and to **propagators** (constraint/
  dataflow propagation). Cite the actual recent work.

## Deliverable

A design/investigation report covering: the FRB operator survey; the Endo-implements /
Exo-lifts-to-passable layering; the splay-tree / sorted-array-set interface and its
sliding-window-topic operators; the query+subscriber model for agent sync; and the
relationships to propagators and the recent pubsub-topics work — with a concrete
proposed module shape and the open questions. Ground every claim about FRB / Endo /
Exo / the recent pubsub work in the actual source (the forked `frb`, the endo
packages, the recent endo-but-for-bots designs/PRs); cite what you read. Write it as a
design under the appropriate place (e.g. a draft design for maintainer review) and
report where it lives. If a key relationship can't be verified from the source, say so.

Posted by the liaison on behalf of the maintainer.
