---
title: See also
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
parent: endo--packages-marshal-src-marshal-js--error-diagnostic-priority
---

- [`endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case`](endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case.md) — the smallcaps-side `isErrorLike` pre-recursion branch that implements the "rather send it anyway" rule documented here.
- [`endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable`](endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable.md) — `toPassableError` is marshal's canonical answer when a thrown error doesn't pass; this section is the encode-side rule, that section is the coercion-level rule.
- [`endo--docs-errors--hiding-revealing-distributed-diagnostic`](endo--docs-errors--hiding-revealing-distributed-diagnostic.md) — the upstream design discussion of distributed error diagnostics; the deliberate-no-stack rule here is one operational realization.
- [`endo--pkg-marshal-readme--beyond-json`](endo--pkg-marshal-readme--beyond-json.md) — the README's framing of error handling as one of the things smallcaps extends JSON to encode; this section is the rationale behind the encoding choices.
- [[pass-invariant-handle-equality]] — pass-invariant equality is the round-trip discipline that errors do *not* fully satisfy: the encoded error is a salvage, not an identity-preserving copy. This section documents the deliberate departure.

Source: [packages/marshal/src/marshal.js](https://github.com/endojs/endo/blob/da16a78e177904e08bd4603527fef98d68af2bbd/packages/marshal/src/marshal.js#L98-L321) at commit `da16a78e`.
