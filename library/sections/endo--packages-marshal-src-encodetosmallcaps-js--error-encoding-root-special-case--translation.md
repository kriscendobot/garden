---
title: Translation
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
parent: endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case
---

| Smallcaps idiom | Adjacent vocabulary |
|---|---|
| "error-like" | the `isErrorLike` structural predicate; covers `instanceof Error` plus error-shape duck typing |
| "valid Passable" | "passable" in pass-style vocabulary; means `passStyleOf` returns a known style without throwing |
| "at the root" | the top-level encode call; the comment uses "outside the recursion" interchangeably |

Source: [packages/marshal/src/encodeToSmallcaps.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/marshal/src/encodeToSmallcaps.js#L276-L293) at commit `e56bf00f`.
