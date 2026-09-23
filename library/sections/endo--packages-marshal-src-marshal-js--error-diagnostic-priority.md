---
title: Error diagnostic priority — why marshal encodes Errors even when they are not Passable, why the stack is deliberately not shared, why errorId is allocated for cross-Vat correlation, and the late-addition tolerance pattern that ratchets the error wire shape
source: packages/marshal/src/marshal.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/marshal.js
source_line_range: "98-132, 158-170, 269-321"
source_commit: da16a78e177904e08bd4603527fef98d68af2bbd
comment_subject: "Why marshal sends Errors even if not Passable; deliberate no-stack-sharing with errorId-for-correlation; late-addition tolerance (cause/errors/errorId); descriptor properties use annotateError rather than decodeRecur"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, errors, capability-security]
status: current
kind: index
section_count: 5
---

Sections:

- [Abstract](endo--packages-marshal-src-marshal-js--error-diagnostic-priority--abstract.md)
- [Body](endo--packages-marshal-src-marshal-js--error-diagnostic-priority--body.md)
- [Translation](endo--packages-marshal-src-marshal-js--error-diagnostic-priority--translation.md)
- [See also](endo--packages-marshal-src-marshal-js--error-diagnostic-priority--see-also.md)
- [Common confusions](endo--packages-marshal-src-marshal-js--error-diagnostic-priority--common-confusions.md)

Source: [packages/marshal/src/marshal.js](https://github.com/endojs/endo/blob/da16a78e177904e08bd4603527fef98d68af2bbd/packages/marshal/src/marshal.js#L98-L321) at commit `da16a78e`.
