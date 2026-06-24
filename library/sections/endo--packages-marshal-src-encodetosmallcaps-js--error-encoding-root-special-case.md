---
title: Why error-like values get a special pre-recursion encoding path that bypasses normal Passable validation
source: packages/marshal/src/encodeToSmallcaps.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodeToSmallcaps.js
source_line_range: "276-293"
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
comment_subject: "Why encodeToSmallcaps pulls error-like values out of the recursion at the root: errors that are not valid Passables (e.g., unfrozen errors) should still be encodable, because reporting their diagnostic information trumps reporting the failure to report"
ingested: 2026-05-15
ingested_by: scholar
topics: [marshal, pass-style, errors]
status: current
kind: index
section_count: 4
---

Sections:

- [Abstract](endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case--abstract.md)
- [Body](endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case--body.md)
- [Translation](endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case--translation.md)
- [See also](endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case--see-also.md)

Source: [packages/marshal/src/encodeToSmallcaps.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/marshal/src/encodeToSmallcaps.js#L276-L293) at commit `e56bf00f`.
