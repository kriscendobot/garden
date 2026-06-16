---
title: Body
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
parent: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find
---

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

Source: [packages/eventual-send/src/handled-promise.js](https://github.com/endojs/endo/blob/ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2/packages/eventual-send/src/handled-promise.js#L67-L111) at commit `ec42cb7b`.
