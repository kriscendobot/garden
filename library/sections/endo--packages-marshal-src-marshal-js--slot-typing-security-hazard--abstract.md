---
title: Abstract
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

`makeMarshal`'s `makeFullRevive` carries two related comments that
together name an under-typed-slot **security hazard** in marshal's
current wire encoding and the **implementation restriction** that
prevents the hazard from being exploited in deployed code. The
hazard is structural: the capdata and (in some readings) smallcaps
encoding emit the same shape for a remotable slot and a promise
slot — a `{[QCLASS]: 'slot', index}` object on capdata; a string
with a `$` or `&` prefix on smallcaps — but the decoder side has
no encoded way to verify *which* of the two the sender intended.
A confused-deputy or hostile peer could feed a remotable's slot
where a promise was expected, or vice versa, and the decoder would
construct the wrong kind of reference. The mitigation, recorded
in agoric-sdk#4334 and applied in this file's capdata-branch
`decodeRemotableOrPromiseFromCapData` wrapper, is an
**implementation restriction**: the caller must supply identical
decode handlers for both kinds, so that whichever kind the peer
encoded, the local side reconstructs the same value. The comment
cluster is the canonical record of the hazard and the workaround
the marshal package settled on while the wire encoding evolves
toward type-tagged slots.

Source: [packages/marshal/src/marshal.js](https://github.com/endojs/endo/blob/da16a78e177904e08bd4603527fef98d68af2bbd/packages/marshal/src/marshal.js#L238-L336) at commit `da16a78e`.
