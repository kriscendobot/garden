---
kind: result
role: designer
host: endolin-garden-ece02cb4
at: 2026-09-12T16:28:27Z
---
project: endo-but-for-bots
prs: [1265]

Designed the mutable counterpart to `readable-blob` for endojs/endo-but-for-bots
(PR 1125 review comment 3996786768). Landed `designs/daemon-mutable-blob-block-storage.md`
as draft PR #1265 against `llm` (design-only diff + a README summary row).

Recommends `block-storage` (rejecting bare `blob`, reserving `file`/`blob` for a
future splice-capable CASK variant); defines separate least-authority ranged-read
and ranged-write powers (independent authorities, so a write-only cap is honest,
unlike CASK cells); constrains `writeAt` to overwrite-within-extent or append-at-end
(no middle-anchored extension, no splice); explains CASK's content-defined chunking
(Rabin rolling hash, no-reset, re-locking, internal-level anchor tree). Posted an
inline follow-up on PR 1125 answering the CASK reminder and linking #1265.

PR left draft; design panel staged by completion machinery.

Self-improvement: nothing this time.
