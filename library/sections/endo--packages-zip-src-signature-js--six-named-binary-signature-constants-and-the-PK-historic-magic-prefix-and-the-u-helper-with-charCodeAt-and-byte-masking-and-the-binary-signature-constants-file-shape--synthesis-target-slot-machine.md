---
title: §Synthesis target — slot machine library
source-slug: endo--packages-zip-src-signature-js
section-slug: six-named-binary-signature-constants-and-the-PK-historic-magic-prefix-and-the-u-helper-with-charCodeAt-and-byte-masking-and-the-binary-signature-constants-file-shape
source-url: https://github.com/endojs/endo/blob/master/packages/zip/src/signature.js
source-repo: endojs/endo
source-path: packages/zip/src/signature.js
source-author: Endo project (collective)
total-lines: 22
ingest-cycle: 278
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-zip-src-signature-js--six-named-binary-signature-constants-and-the-PK-historic-magic-prefix-and-the-u-helper-with-charCodeAt-and-byte-masking-and-the-binary-signature-constants-file-shape
---

§The-binary-signature-constants-file-shape applies to the §game-engine-cluster:

- §**`@game/replay/src/signature.js`** — a file whose sole purpose is exporting binary-signature constants for the game-replay-file-format.
- §**§game-format-magic-prefix** — e.g., `'GS'` for "GameState" — the project-or-inventor's initials as the magic prefix.
- §**§the-`charCodeAt(i) & 0xff`-pattern** — same string-to-Uint8Array conversion idiom for game-format magic bytes.
- §**§single-letter-named-helper** — `u` (or similar) for dense constant definition when used six+ times in a small file.
- §**§the-`/* eslint no-bitwise: ["off"] */`-directive** for files where bitwise IS the right tool.
- §**§named extended-format markers** — `GAME2_*` prefix for extended game-format constants (sibling to ZIP64).
