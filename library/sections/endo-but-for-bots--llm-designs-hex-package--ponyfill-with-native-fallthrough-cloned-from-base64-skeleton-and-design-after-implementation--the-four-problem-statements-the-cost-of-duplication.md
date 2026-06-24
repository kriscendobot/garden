---
source: designs/hex-package.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/hex-package.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - hardened-javascript
  - tooling
status_at_ingest: Complete
genre: §endo-but-for-bots-design §canonical-leaf-package-pattern
cycle: 180
lane: designs
status: current
title: §The-four-problem-statements (the cost of duplication)
parent: endo-but-for-bots--llm-designs-hex-package--ponyfill-with-native-fallthrough-cloned-from-base64-skeleton-and-design-after-implementation
---

The motivation enumerates four independent hex implementations:

| File                                  | Behavior on odd-length input          | Native fast path? |
|---------------------------------------|----------------------------------------|--------|
| `packages/daemon/src/hex.js`          | Silently truncates                     | Yes (TC39 detect) |
| `packages/ocapn/src/buffer-utils.js`  | Throws                                 | No     |
| `packages/relay-server/src/protocol.js` | Truncates                            | No     |
| `Buffer.from(...).toString('hex')`    | Node-only; spec behavior               | N/A (Node) |

§Three-concrete-costs explicitly named: (1) §inconsistent-
semantics (truncate vs throw); (2) §native-fast-paths-only-wired-
up-in-one-package (TC39 `Uint8Array.prototype.toHex` shortcuts
exist only in `daemon/src/hex.js`); (3) §no-canonical-home
(Buffer.from / relative `./hex.js` / inline arithmetic).

§Compare-to-cycle-172-@endo/bytes which had §sixteen-call-sites-
already-in-tree; this design has §eighteen-call-sites with the
same §extract-as-package-then-migrate-incrementally rhythm.
