---
title: Translation
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

| Marshal idiom | Adjacent vocabulary |
|---|---|
| "Sent as ${errorId}" annotation | "request-id" in distributed-tracing systems; "span-id" in OpenTelemetry |
| `marshalSaveError` hook | "audit sink" or "structured-error logger" in observability tooling |
| "late addition so be tolerant" | the **deserialization-tolerance** half of a forward-compatibility ratchet (encoders ratchet second) |
| "diagnostic info... is more valuable than diagnosing why the error isn't passable" | a *salvage-over-strict-validation* policy |

Source: [packages/marshal/src/marshal.js](https://github.com/endojs/endo/blob/da16a78e177904e08bd4603527fef98d68af2bbd/packages/marshal/src/marshal.js#L98-L321) at commit `da16a78e`.
