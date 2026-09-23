---
source: packages/remote-iterables/README.md
source_kind: repo
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/remote-iterables/README.md
source_branch: main
source_commit: 903fe9d20c4b9b8f8286fe304fd36af08379b7b4
source_date: 2025-08-19
source_authors: [Erik Marks]
ingested: 2026-06-27
ingested_by: scholar
section_count: 1
status: current
notes: |
  Per-package-README cluster, sixth ocap-kernel ingest. Pure
  boilerplate stub. Notable: the @ocap/ private-namespace
  prefix, and that ocap-kernel separates "remotable iterable
  objects" (this package) from "SES-compatible streams" (the
  streams package) where Endo tends to fold both into
  @endo/stream.
---

> Abstract: the README of `@ocap/remote-iterables` ("Remotable iterable
> objects, i.e. iterators and generators"), a pure boilerplate stub. Two
> reference facts: the `@ocap/` prefix marks it **private** (the public/private
> namespace split the overview flagged), and it makes iterators/generators
> *remotable* — passable across a capability boundary — separating that
> concern from the `streams` package's SES-compatible stream abstraction.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [remotable-iterable-objects-package-purpose](../sections/metamask-ocap-kernel--packages-remote-iterables-readme--remotable-iterable-objects-package-purpose.md) | streams, exo | current |

## Provenance

- Fetched 2026-06-27 from `worktrees/metamask-ocap-kernel.git`
  (`MetaMask/ocap-kernel`, `main` HEAD `a3eff0efb`). File-specific
  commit `903fe9d` (2025-08-19, Erik Marks).
- License: dual Apache-2.0 + MIT.
- Per-package-README cluster, sixth ocap-kernel ingest.
- Sibling-implementation genre: read for reference, not imported.
