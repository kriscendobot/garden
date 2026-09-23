---
title: Translation
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

| Marshal idiom | Adjacent vocabulary |
|---|---|
| "slot" | "object reference" or "remote reference" in CapTP / OCapN discussions; "swissnum" in older E literature; "vref" in Agoric's SwingSet |
| "convertSlotToVal" / "convertValToSlot" | the **slot mapper** is the application-supplied bridge between marshal's slot-key abstraction and the application's reference-tracking; in CapTP this is the per-session **Question / Answer / Import / Export table** lookup |
| "implementation restriction" | a **temporary workaround at the implementation layer** that disambiguates a spec-level ambiguity; tracked as an issue, intended to lift when the spec/encoding tightens |
| "TODO SECURITY HAZARD" | a **known-but-not-yet-fixed** vulnerability marker; the convention is that such markers point at an issue or PR with the remediation plan |

Source: [packages/marshal/src/marshal.js](https://github.com/endojs/endo/blob/da16a78e177904e08bd4603527fef98d68af2bbd/packages/marshal/src/marshal.js#L238-L336) at commit `da16a78e`.
