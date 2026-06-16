---
title: The error-special-case at the encoding root, the `passStylePrefixes` table that coordinates per-PassStyle sort order with the cover machinery, and the reserved `|` ordinal-mapping prefix
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
kind: index
section_count: 4
---

Sections:

- [Abstract](endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table--abstract.md)
- [Body](endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table--body.md)
- [Translation](endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table--translation.md)
- [See also](endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table--see-also.md)

Source: [packages/marshal/src/encodePassable.js](https://github.com/endojs/endo/blob/e6192056a5d7ff5acb084f6a58dca3663aa9943e/packages/marshal/src/encodePassable.js#L598-L911) at commit `e6192056`.
