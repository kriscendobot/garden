---
title: Why liveslots needs to swap in its own implementation
source: packages/pass-style/src/passStyleOf.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/pass-style/src/passStyleOf.js
source_line_range: "219-245"
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
comment_subject: "Why pass-style exports the globalThis-installed passStyleOf when present (liveslots delegation), how the install-on-global gate stands in for explicit authorization, and the GC-detection hazard the delegated implementation must preserve determinism to avoid"
ingested: 2026-05-28
ingested_by: scholar
topics: [pass-style, marshal, capability-security, persistence]
status: current
parent: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism
---

In a SwingSet vat under liveslots, durable storage holds objects
*virtually*: a remote reference may be represented as a slot index
during persistence and rehydrated to a JavaScript object on
access. The pass-style package's default `passStyleOf` walks the
JavaScript object's properties to classify it; on a Far-virtualized
object whose JS representation is a thin wrapper hiding the real
durable identity, the default walk classifies based on the wrapper's
properties, not the durable identity's.

The liveslots-supplied `passStyleOf` is virtualization-aware: it
consults the live-slot table to recover the underlying kind
(remotable vs copyArray vs copyRecord vs ...) and returns the
classification that the durable state intends. This is what lets
marshal serialize values *out of* a vat's durable store correctly:
the wire format reflects the durable identity, not the in-realm JS
representation.

The Endo / Agoric reuse pattern is to share one implementation of
each pass-style-touching algorithm across both the durable-store
and the realm-only world, by substituting the classifier at the
boundary. The substitution point is this `PassStyleOfEndowmentSymbol`
export.

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L219-L245) at commit `e56bf00f`.
