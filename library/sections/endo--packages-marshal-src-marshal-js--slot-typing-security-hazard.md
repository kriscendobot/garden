---
title: Slot-typing security hazard — why the current wire encoding cannot distinguish a remotable slot from a promise slot, and the implementation restriction that makes the under-typed encoding safe (#4334)
source: packages/marshal/src/marshal.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/marshal.js
source_line_range: "238-256, 322-336"
source_commit: da16a78e177904e08bd4603527fef98d68af2bbd
comment_subject: "TODO SECURITY HAZARD on decodeSlotCommon (remotable-vs-promise) and the matched implementation restriction on the capdata branch (#4334)"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, capability-security, captp]
status: current
kind: index
section_count: 5
---

Sections:

- [Abstract](endo--packages-marshal-src-marshal-js--slot-typing-security-hazard--abstract.md)
- [Body](endo--packages-marshal-src-marshal-js--slot-typing-security-hazard--body.md)
- [Translation](endo--packages-marshal-src-marshal-js--slot-typing-security-hazard--translation.md)
- [See also](endo--packages-marshal-src-marshal-js--slot-typing-security-hazard--see-also.md)
- [Common confusions](endo--packages-marshal-src-marshal-js--slot-typing-security-hazard--common-confusions.md)

Source: [packages/marshal/src/marshal.js](https://github.com/endojs/endo/blob/da16a78e177904e08bd4603527fef98d68af2bbd/packages/marshal/src/marshal.js#L238-L336) at commit `da16a78e`.
