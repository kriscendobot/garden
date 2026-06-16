---
title: toPassableError and toThrowable — diagnostic-information preservation and the exo-boundary throwable contract
source: packages/pass-style/src/passStyleOf.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/pass-style/src/passStyleOf.js
source_line_range: "287-405"
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
comment_subject: "Why pass-style exports two coercion functions (toPassableError, toThrowable) rather than just asserting passability, the diagnostic-preservation rule that motivates the copy-with-cause path, and the exo-boundary security-review framing that motivates throwables-only"
ingested: 2026-05-28
ingested_by: scholar
topics: [pass-style, errors, marshal, capability-security]
status: current
kind: index
section_count: 8
---

Sections:

- [Abstract](endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable--abstract.md)
- [The comments as written](endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable--the-comments-as-written.md)
- [The diagnostic-preservation rule](endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable--the-diagnostic-preservation-rule.md)
- [The throwable layer above passable](endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable--the-throwable-layer-above-passable.md)
- [How toPassableError mediates between the two layers](endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable--how-topassableerror-mediates-between-the-two-layers.md)
- [The TODO trail and the implementation gap](endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable--the-todo-trail-and-the-implementation-gap.md)
- [Implications](endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable--implications.md)
- [See also](endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable--see-also.md)

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L287-L405) at commit `e56bf00f`.
