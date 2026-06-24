---
title: See also
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
parent: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard
---

- [`endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme`](endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme.md) — the contiguous reserved-character range that assigns `$` to remotable and `&` to promise, which is the smallcaps-side substrate for the partial prefix discrimination described here.
- [`endo--pkg-marshal-readme--convert-val-slot`](endo--pkg-marshal-readme--convert-val-slot.md) — the README's framing of the application-supplied slot-table; this section is the rationale for why that table has to carry the kind information the wire does not.
- [`endo--pkg-captp-readme`](../sources/endo--pkg-captp-readme.md) — CapTP is the consumer of marshal that maintains the per-session import/export tables which `convertSlotToVal` consults.
- [`endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise`](endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise.md) — the distinction between a remotable and a promise is partly about the *passable promise* invariant; the slot-kind hazard documented here is one way the distinction can be muddled at the wire boundary.
- [[smallcaps-encoding]] — the concept page for smallcaps' wire format.
- [[object-capability]] — the broader discipline this hazard threatens: an ambient confusion between two kinds of references is a way authority can leak between them.

Source: [packages/marshal/src/marshal.js](https://github.com/endojs/endo/blob/da16a78e177904e08bd4603527fef98d68af2bbd/packages/marshal/src/marshal.js#L238-L336) at commit `da16a78e`.
