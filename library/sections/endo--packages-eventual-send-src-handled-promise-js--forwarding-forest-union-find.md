---
title: The forwarding graph as a union-find forest with path-splitting
source: packages/eventual-send/src/handled-promise.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/eventual-send/src/handled-promise.js
source_line_range: "67-111"
source_commit: ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2
comment_subject: "Forwarding-forest invariant + the shorten() walk that amortizes resolution lookups"
ingested: 2026-05-15
ingested_by: scholar
topics: [eventual-send, persistence]
status: current
---

## Abstract

When a `HandledPromise` is resolved to *another* `HandledPromise`,
the shim does not eagerly rewrite every reference holding the older
promise. Instead, it records a single forwarding edge in a
`WeakMap` called `forwardedPromiseToPromise`. Over many such
resolutions, a forest emerges whose roots are unresolved
`HandledPromise`s (or non-promise final values) and whose interior
nodes are forwarded handled promises pointing at their resolution
target. The `shorten(target)` walk finds the most-resolved value
for `target` and, on the way back, **rewrites every interior
node it touched to point directly at the new root**. This is the
"Path splitting" variant of the Find operation from the classic
union-find data structure. The shim's choice of path-splitting (over
path-compression or path-halving) gives amortized near-constant-time
lookup without recursive call stacks, which matters because
`shorten` runs synchronously inside resolution callbacks that the
host's promise machinery already constrains to short, allocation-light
work.

## Body

### The invariant the comment names

The file-level explanation (lines 67-83 in the captured commit) is
the canonical statement of the data structure:

> You can imagine a forest of trees in which the roots of each
> tree is an unresolved HandledPromise or a non-Promise, and each
> node's parent is the HandledPromise to which it was forwarded.
> We maintain that mapping of forwarded HandledPromise to its
> resolution in `forwardedPromiseToPromise`.

The forest is realised across three `WeakMap`s:

- `forwardedPromiseToPromise`: child → parent edges in the forest.
- `promiseToPendingHandler`: an unresolved root's pending handler
  (the *root* invariant: a node has a pending handler iff it is
  still unresolved, i.e. is a forest root).
- `promiseToPresence`: a settled root's final presence (the
  *terminal* invariant: a root with a presence is a *final* settled
  state, not pending).

The comment refers explicitly to Wikipedia's *Disjoint-set data
structure* article for the path-splitting algorithm. The shim's
choice is deliberate: path-splitting performs the same amortized
optimization as union-by-rank, but operates by *direct rewrite*
during a `Find` traversal, which composes naturally with WeakMap
mutation and does not require a separate rank table.

### The shorten() walk

`shorten` follows the forwarding chain from `target` up to a root.
On its way back down, it splits the path so that each visited node
now points directly at the root. There are two branches in the
implementation that the comment distinguishes:

1. **Root resolves to a final presence.** Each rewritten node has
   its presence copied in (a `promiseToPresence.set` call) and its
   pending handler removed. After this walk, querying any visited
   node for its presence is O(1).

2. **Root is still pending (or is a non-presence forwarded chain).**
   Each rewritten node has its parent edge re-pointed at the root
   and its (now obsolete) pending handler removed. After this
   walk, querying any visited node for its forwarding target is
   O(1).

The cleanup of `promiseToPendingHandler` along the way is essential
to prevent **handler revival**: once a node has been short-circuited
to point at a presence (or at a different pending root), its old
pending handler is no longer authoritative; leaving it in the map
would later route operations to a dispatcher whose target promise
has already been resolved or forwarded. The comment captures this
as a one-line aside ("Remove stale pending handlers, set to
canonical form").

### Why this matters beyond performance

The data structure has two correctness consequences that the
performance framing buries:

- **Cycle prevention.** The resolution code uses `shorten` before
  installing any new forwarding edge, and refuses to create an edge
  that would point a node at itself (the `targetP && !objectIs(targetP, handledP)`
  check). Path-splitting before edge insertion means cycles can
  only form if the *new* edge would close one, which the explicit
  identity guard then rejects. Without path-splitting, an
  intermediate edge could mask the eventual cycle until it became
  expensive to detect.
- **WeakMap GC interaction.** Path-splitting collapses long chains
  into shallow trees, which means intermediate `HandledPromise`
  instances become eligible for garbage collection as soon as their
  last externally-held reference is dropped. A non-splitting
  implementation would keep intermediate nodes alive through the
  chain even when nothing outside the shim holds them, defeating
  the WeakMap-based memory model.

## Implications

- The `shorten` walk is **the only place** in the shim that mutates
  `forwardedPromiseToPromise` along non-trivial paths. The other
  mutation sites (initial resolution, validation guards) write
  exactly one edge. Reviewers of changes touching forwarding
  semantics should treat `shorten` as the invariant guardian.
- A handler implementer (e.g., a CapTP author writing a
  remote-presence handler) never observes the forwarding forest
  directly. The forest is internal to the local shim; from the
  handler's perspective, the local shim presents already-shortened
  targets via `dispatchToHandler`.
- The "non-Promise root" leg of the comment's invariant is what
  lets the shim treat a plain JS value as a degenerate one-node
  forest. When a `HandledPromise` resolves to a non-promise `value`,
  the only entry recorded is the (presence → promise) mapping in
  `presenceToPromise`; there is no separate forwarding edge because
  there is nothing to forward to.

## See also

- [[caretaker-pattern]] — the forwarding-forest is a low-level
  caretaker-of-sorts: the original `HandledPromise` is the
  *action-shaped* reference held by callers, and `shorten` is the
  bookkeeping that lets the *control* (resolution) of that
  reference be exercised in any order without breaking the
  caller-side action surface.
- [`endo--pkg-eventual-send-readme--handled-promise`](endo--pkg-eventual-send-readme--handled-promise.md) — the
  user-facing description of HandledPromise; this section is the
  internal data-structure rationale that the README intentionally
  hides.
- [`papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model`](papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model.md) — the paper introduces the
  *eventual reference* abstraction; this section documents the
  data structure Endo uses to make eventual-reference resolution
  cheap when resolution chains accumulate during pipelined work.

Source: [packages/eventual-send/src/handled-promise.js](https://github.com/endojs/endo/blob/ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2/packages/eventual-send/src/handled-promise.js#L67-L111) at commit `ec42cb7b`.
