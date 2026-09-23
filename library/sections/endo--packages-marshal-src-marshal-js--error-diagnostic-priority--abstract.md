---
title: Abstract
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

`makeMarshal`'s longform comments establish a single rule that
threads through both encoding and decoding of error values: **the
diagnostic information an error carries is more valuable than the
report that the error itself failed to serialize.** The encoder
side (`encodeErrorCommon`, with a duplicated rationale block
above `encodeErrorToCapData`) opens with the "rather send it
anyway" claim and is the upstream of the `isErrorLike` pre-recursion
branch documented separately for `encodeToSmallcaps`. The encoder
deliberately *omits the stack* from the wire and instead allocates
a fresh `errorId` per send to allow privileged correlators on the
sending Vat to link a local stacktrace to the redacted summary that
the receiving Vat sees. The decoder side (`decodeErrorCommon`)
implements a **late-addition tolerance pattern**: `errorId`,
`cause`, and `errors` are all optional and decoded only when
present, because older counterparties cannot send them and adding
unconditional reads would break backward compatibility. The
descriptor-properties pass at the end of `decodeErrorCommon` uses
`annotateError` rather than recursive decoding of property names,
because the rest-bag is for diagnostic-only annotations whose key
names are not part of the wire contract. The comment cluster is
the canonical source for these four decisions, all of which the
marshal README and the smallcaps cheatsheet reference summarily.

Source: [packages/marshal/src/marshal.js](https://github.com/endojs/endo/blob/da16a78e177904e08bd4603527fef98d68af2bbd/packages/marshal/src/marshal.js#L98-L321) at commit `da16a78e`.
