---
section: monorepo-survey-with-SwingSet-derived-kernel-vat-architecture-and-Ken-protocol-substrate
source: metamask-ocap-kernel--overview
topics: [daemon, captp, persistence]
status: current
title: The §package-naming-convention `@metamask/` vs `@ocap/`
parent: metamask-ocap-kernel--overview--monorepo-survey-with-SwingSet-derived-kernel-vat-architecture-and-Ken-protocol-substrate
---

> *Published packages are prefixed with `@metamask/`, private
> packages with `@ocap/`.*

The §public-private-namespace-split discipline. The published
surface (`@metamask/ocap-kernel`, `@metamask/kernel-utils`,
`@metamask/streams`, etc.) is *what downstream consumers
import*. The `@ocap/` namespace is project-internal
(`@ocap/extension`, `@ocap/repo-tools`, `@ocap/test-utils`).

The §two-namespace-split clarifies *what's API-stable* vs
*what's project-internal*. Endo doesn't have this split —
everything in `@endo/` is published; project-internal helpers
must live in a different namespace or be in `packages/x/test/`.
