---
title: Common confusions
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

- The duplicated rationale block (98-102, 158-162) is not a typo or
  oversight; it's intentional redundancy so each call site carries
  the rationale at the point it might surprise a reader. Removing
  the duplication would make the capdata-branch reader chase up to
  the common helper.
- `errorId` is *not* a stable identifier across re-encodings of the
  same error. Each `encodeErrorCommon` call allocates a fresh
  identifier from `nextErrorId()`. If an error is re-thrown and
  re-encoded by the same marshal instance, the second send carries
  a different `errorId`. The local annotation chain accumulates;
  the wire identifier is per-send.
- `marshalSaveError`'s default (`console.log('Temporary logging
  ...')`) is explicitly flagged as a placeholder. Production
  callers are expected to supply their own sink; the placeholder
  is there so a misconfigured caller still produces *some* trail.

Source: [packages/marshal/src/marshal.js](https://github.com/endojs/endo/blob/da16a78e177904e08bd4603527fef98d68af2bbd/packages/marshal/src/marshal.js#L98-L321) at commit `da16a78e`.
