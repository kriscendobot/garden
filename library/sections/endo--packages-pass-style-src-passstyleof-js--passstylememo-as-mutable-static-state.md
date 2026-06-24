---
title: passStyleMemo as mutable static state — the cache, the cycle-detection guard, and the proxy-observability hazard
source: packages/pass-style/src/passStyleOf.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/pass-style/src/passStyleOf.js
source_line_range: "101-144"
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
comment_subject: "Why passStyleOf carries a WeakMap memo (asymptotic correctness for nested copyRecord walks), why the comment flags it as mutable static state, and how the inProgress Set complements the memo to catch cyclic structures during the recursive walk"
ingested: 2026-05-28
ingested_by: scholar
topics: [pass-style, marshal, capability-security, hardened-javascript]
status: current
kind: index
section_count: 8
---

Sections:

- [Abstract](endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state--abstract.md)
- [The comment as written](endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state--the-comment-as-written.md)
- [Why the cache is needed](endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state--why-the-cache-is-needed.md)
- [Why the comment flags it as a hazard](endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state--why-the-comment-flags-it-as-a-hazard.md)
- [The inProgress Set as the correctness companion](endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state--the-inprogress-set-as-the-correctness-companion.md)
- [Why a Set, not a WeakSet](endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state--why-a-set-not-a-weakset.md)
- [Implications](endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state--implications.md)
- [See also](endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state--see-also.md)

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L101-L144) at commit `e56bf00f`.
