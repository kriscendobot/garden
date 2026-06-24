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
title: Ponyfill with native fallthrough cloned from base64 skeleton, with design-after-implementation as ratification discipline
parent: endo-but-for-bots--llm-designs-hex-package--ponyfill-with-native-fallthrough-cloned-from-base64-skeleton-and-design-after-implementation
---

> §Designs-lane after cycle 179's chat-lane. §The fourteenth consecutive
> designs/chat alternation cycle (166-180). §Status: **Complete** —
> shipped on `llm` on 2026-04-24 (commit `ad7a177e8`) with the dev-
> dependency cycle break landing 2026-05-12 via PR #211 / commit
> `68246ad92`. §Sibling-extract-pattern to cycle 172's @endo/bytes
> and cycle 174's gateway-package.

`@endo/hex` is a 692-line design for a new leaf ponyfill package
that consolidates four independent in-tree hex implementations,
delegating to the TC39 `Uint8Array.prototype.toHex` /
`Uint8Array.fromHex` native methods when available, falling back
to portable JS otherwise.

§The-single-most-structurally-interesting-move is §design-after-
implementation-as-ratification-discipline combined with §sibling-
package-cloned-file-for-file-from-base64. §The-design-was-written-
2026-04-29 (single commit `102a94bc9` in a batch of seven
proposals) §after the initial package landed 2026-04-24 in
`ad7a177e8`. §The-design-ratifies-the-upstream-implementation
rather than driving it. §This-is-a-different-discipline from the
common §design-then-build pattern.
