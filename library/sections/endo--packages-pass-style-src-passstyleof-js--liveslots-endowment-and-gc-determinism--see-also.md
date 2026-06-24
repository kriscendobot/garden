---
title: See also
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

- [[principle-of-least-authority]] — the install-on-global gate
  enacts POLA at the delegation boundary: the only party with the
  authority to substitute is the one already holding the
  substrate-level authority that a substitute would imply.
- [[four-ways-to-acquire-references]] — Endowment (the third of the
  four mechanisms) is what installs the
  `PassStyleOfEndowmentSymbol` property; the substitution mechanism
  is therefore an Endowment-shaped authority transfer rather than
  Introduction or Parenthood.
- [[object-capability]] — Property A (No Designation Without
  Authority) is what the gate enacts: any party that can designate
  the symbol property on the global also has the authority to
  install a classifier under it. The two are the same fact.
- [`endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state`](endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state.md)
  — the sibling section on the realm-default classifier's memo;
  both sections together cover the pass-style package's two
  distinct hazard surfaces.

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L219-L245) at commit `e56bf00f`.
