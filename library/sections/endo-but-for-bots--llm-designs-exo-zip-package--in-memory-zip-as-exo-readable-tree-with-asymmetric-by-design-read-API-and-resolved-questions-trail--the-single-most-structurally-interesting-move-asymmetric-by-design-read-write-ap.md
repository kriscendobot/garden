---
section: in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
source: endo-but-for-bots--llm-designs-exo-zip-package
topics: [exo, daemon, marshal]
status: current
title: The §single most structurally interesting move — §asymmetric-by-design read/write API
parent: endo-but-for-bots--llm-designs-exo-zip-package--in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
---

The most distinctive structural move is the *deliberately
asymmetric* API. §Symmetric-write-path section opens:

> *There is a symmetry argument for a sibling
> `makeExoWritableZip()` that exposes a `WritableTree`-
> flavoured exo backed by an in-memory `ZipWriter`, but the
> asymmetry is real and load-bearing.*

The §asymmetry-is-real-and-load-bearing observation. Why?

**Read side** (`checkin -z`):
- Daemon's `storeTree` consumes a `ReadableTree` over CapTP.
- The CLI must hand it a *remotable*.
- An exo adapter is the *only way* to bridge in-memory bytes
  to `storeTree`.

**Write side** (`checkout -z`):
- The CLI has direct access to the daemon's `readable-tree`
  exo and *can walk it* with `list` / `lookup` /
  `streamBase64` against the daemon over CapTP.
- *No `WritableTree` interface exists* in
  `platform/src/fs/interfaces.js`.
- The natural shape is: walk the remote tree client-side,
  accumulate into a local `ZipWriter`, snapshot, write.

The §don't-invent-WritableTree-just-for-symmetry discipline:
the *interface that would be needed* for symmetry doesn't
exist; *inventing it* would be a separate (and larger) design.

The §write-side-no-WritableTree-interface observation: the
asymmetry is *forced by what exists*, not chosen for taste.

§Design Decision 4 codifies this:

> *Asymmetric read/write API; walker stays inline at the
> consumer. `makeExoZip` (exo) on the read side; the dual
> write-side walker stays inline in `checkout.js` for now.*
