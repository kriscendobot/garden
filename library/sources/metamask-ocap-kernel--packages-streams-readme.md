---
source: packages/streams/README.md
source_kind: repo
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/streams/README.md
source_branch: main
source_commit: d5a703d3f3ebcf5ba7034b51ab4572d4f3355def
source_date: 2025-05-02
source_authors: [Erik Marks]
ingested: 2026-06-27
ingested_by: scholar
section_count: 1
status: current
notes: |
  Per-package-README cluster, sixth ocap-kernel ingest. Stub
  README, but the one description line is high-value: declares
  the package "in the lineage of gtor and @endo/stream" — the
  same two ancestors as Endo's own stream package.
  BaseDuplexStream.ts is the comment-fragment follow-on target.
---

> Abstract: the README of `@metamask/streams`, a one-paragraph stub whose lone
> description line is the cross-comparable payload: "SES-compatible streams, in
> the lineage of [gtor](https://github.com/kriskowal/gtor) and `@endo/stream`."
> ocap-kernel's stream abstraction shares ancestry with Endo's own
> `@endo/stream` rather than importing it, and adds `BaseDuplexStream.ts` (no
> direct `@endo/stream` analog) — a sibling-implementation divergence flagged
> for the comment-fragment follow-on.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [ses-compatible-streams-gtor-endo-stream-lineage](../sections/metamask-ocap-kernel--packages-streams-readme--ses-compatible-streams-gtor-endo-stream-lineage.md) | streams, hardened-javascript | current |

## Provenance

- Fetched 2026-06-27 from `worktrees/metamask-ocap-kernel.git`
  (`MetaMask/ocap-kernel`, `main` HEAD `a3eff0efb`). File-specific
  commit `d5a703d` (2025-05-02, Erik Marks).
- License: dual Apache-2.0 + MIT.
- Per-package-README cluster, sixth ocap-kernel ingest.
- Sibling-implementation genre: read for reference, not imported.
