---
title: The install-on-global gate as authorization
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

The comment names the gate explicitly: *any* party that can install
a `PassStyleOfEndowmentSymbol` property on the start-compartment
global is already trusted at the level liveslots is trusted at,
because installing a property on the start compartment global
requires either (a) write access to that global or (b) the ability
to provide endowments at compartment construction. Both are
abilities liveslots already has by construction; both are the
*minimum* abilities any other actor would need to substitute a
classifier; therefore the gate stands in for the authorization
check.

This is a worked example of the **authority-by-substrate**
discipline: rather than checking a permission token at the
delegation point, the discipline arranges for the substrate to
*only* grant the necessary primitive to authorized parties. A
caller that lacks write access to the start compartment global
cannot install the symbol property at all, so no check beyond
"is the property present" is needed. The check is *implicit* in
the substrate's authority structure.

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L219-L245) at commit `e56bf00f`.
