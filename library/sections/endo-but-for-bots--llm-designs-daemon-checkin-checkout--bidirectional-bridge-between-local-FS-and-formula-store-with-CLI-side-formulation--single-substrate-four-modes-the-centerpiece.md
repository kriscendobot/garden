---
source: designs/daemon-checkin-checkout.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-checkin-checkout.md
source_path: designs/daemon-checkin-checkout.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
  - capability-security
genre: §endo-but-for-bots-design
cycle: 168
lane: designs
status: current
title: §Single-substrate-four-modes (the centerpiece)
parent: endo-but-for-bots--llm-designs-daemon-checkin-checkout--bidirectional-bridge-between-local-FS-and-formula-store-with-CLI-side-formulation
---

> *Whether the input is a directory or a zip file, the
> result is the same `readable-tree` / `readable-blob`
> hierarchy.*

Four modes share one implementation:

| Mode | Input | Output |
|------|-------|--------|
| `endo ci <dir>` | Local directory | `readable-tree` |
| `endo ci -z <zip>` | Zip archive (file) | `readable-tree` |
| `endo ci -z --stdin` | Zip from stdin | `readable-tree` |
| `endo co <name> <dir>` | `readable-tree` | Local directory |
| `endo co -z <name> <zip>` | `readable-tree` | Zip file |
| `endo co -z --stdout` | `readable-tree` | Zip to stdout |

§Six-modes-from-four-axes: input-or-output × dir-or-zip ×
file-or-stream. §Same-formula-tree-from-two-input-sources
(Design Decision 4): `endo ci ./dist -n app` and
`endo ci -z dist.zip -n app` produce *structurally
identical formula trees* given identical content.

§Zip-is-just-serialization. §Don't-design-two-systems-when-
one-substrate-suffices.
