---
title: Translation
source: packages/marshal/src/encodePassable.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodePassable.js
source_line_range: "584-665, 869-911"
source_commit: e6192056a5d7ff5acb084f6a58dca3663aa9943e
comment_subject: "Why `encodePassable` extracts an error-special-case before the per-PassStyle switch (diagnostic-priority over Passable-validation); the canonical `passStylePrefixes` table whose ordering matches the rankOrder PassStyle order; the `|` ordinal-mapping prefix reserved outside the cover range; the Array.prototype.sort-driven choice to put `undefined` last"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table
---

| encodePassable idiom | Adjacent vocabulary |
|---|---|
| "isErrorLike" | the `@endo/pass-style` predicate that recognizes Error instances even when they are not valid Passables; the gate for the diagnostic-priority special case |
| "diagnostic-priority" | the rule that error diagnostics outweigh Passable-validity reporting; recurs across encodeToSmallcaps.js (cycle 69), marshal.js (cycle 74), and this section |
| "passStylePrefixes" | the canonical first-byte table shared by encodePassable.js and rankOrder.js |
| "cover range" | the set of first-byte characters used by PassStyle encodings; `|` is reserved outside this range |
| "ordinal-mapping prefix" | `|` (U+007C); used by the keyed-store substrate to encode remotable-to-ordinal mappings outside the value-key namespace |
| "Array.prototype.sort quirk" | the JavaScript-language behavior that places `undefined` last regardless of comparator output; pins the `undefined` row to the end of the table |

Source: [packages/marshal/src/encodePassable.js](https://github.com/endojs/endo/blob/e6192056a5d7ff5acb084f6a58dca3663aa9943e/packages/marshal/src/encodePassable.js#L598-L911) at commit `e6192056`.
