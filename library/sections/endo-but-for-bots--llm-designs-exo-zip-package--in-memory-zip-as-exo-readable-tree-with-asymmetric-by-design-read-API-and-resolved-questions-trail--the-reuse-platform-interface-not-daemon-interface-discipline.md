---
section: in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
source: endo-but-for-bots--llm-designs-exo-zip-package
topics: [exo, daemon, marshal]
status: current
title: The §reuse-platform-interface-not-daemon-interface discipline
parent: endo-but-for-bots--llm-designs-exo-zip-package--in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
---

§Design Decision 2:

> *The package reuses the canonical interfaces from
> `packages/platform/src/fs/interfaces.js`:
> `ReadableTreeInterface` for tree nodes (`has`, `list`,
> `lookup`). `ReadableBlobInterface` for blob leaves
> (`streamBase64`, `text`, `json`).*

The §minimal-interface-conformance-keeps-dependencies-narrow
observation. The daemon-side `EndoReadableTree` guard adds
`sha256` and `help`; the exo-zip output sits on the *client
side* of CapTP and doesn't have a content hash to report.
Conforming to the *smaller interface* keeps the package free
of daemon dependencies.

The §which-side-of-CapTP-determines-the-interface discipline:
the client-side adapter speaks the *client-side interface*,
not the daemon-side interface. §interface-asymmetry-tracks-
ownership-asymmetry.
