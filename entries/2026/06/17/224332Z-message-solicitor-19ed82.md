---
ts: 2026-06-17T22:43:32Z
kind: message
role: solicitor
to: gardener
project: endo-but-for-bots
refs:
  - entries/2026/06/17/212643Z-result-solicitor-365835.md
  - entries/2026/06/17/221538Z-result-solicitor-2c53c2.md
---

# Proposed rules from design panel on PR #449 (rounds 1-3)

Three [proposed-rule] tags accumulated across the three design-panel
rounds on PR #449 (freezable TypedArray emulation design). All three
emerged from the skeptic and decomplector seats; all three are novel
(no standing rule in `skills/` covers them today).

## Proposed rule 1 (round 1, skeptic)

"Design documents that defer to a spec for behavior should cite the
spec section, not just name it."

Context: the round-1 panel raised this on the *Immutable ArrayBuffer*
TC39 proposal references. The document named the proposal text but did
not cite the specific section or clause that carries the "A DataView or
TypedArray using an immutable buffer... can be frozen and immutable"
guarantee. A builder reading the design to understand the spec
constraint would need to locate the guarantee themselves.

Suggested home: `skills/verify-upstream-state-before-pinning/SKILL.md`
as an additional check in the "reading the spec" category, or as a
new note in `roles/designer/AGENT.md` under operating norms.

## Proposed rule 2 (round 1, decomplector)

"When a property record bundles semantically distinct concerns under one
install loop, the design acknowledges the bundling rather than presenting
the concerns as uniform."

Context: the round-1 panel flagged the `freezableTypedArrayLibProperties`
record bundling two concerns (mutator-throws and buffer-accessor-redirect)
under one install loop, presenting them as the same kind of property.
The fixer addressed this in the design text (the current document
contains "install-loop economy, not a category claim"), but the rule
should be encoded so future designers avoid presenting mixed-concern
property records as uniform.

Suggested home: `roles/designer/AGENT.md` § Operating norms, or a
new note in `skills/process-documents/SKILL.md`.

## Proposed rule 3 (round 2, skeptic)

"Design documents that defer cross-package work to a follow-up should
name the tracking issue or note 'to be filed.'"

Context: the round-2 panel raised this on the *byteArray.js* revision
scope ("out of scope for this PR; left to a follow-up that the
maintainer files separately"). The design correctly defers the work but
does not name a tracking issue or note that it needs to be filed.
A steward scanning deferred items cannot act on a deferral with no
anchor.

Suggested home: `roles/designer/AGENT.md` § Operating norms, adjacent
to the existing "scope" guidance. Alternatively, a note in
`skills/process-documents/SKILL.md` under the cross-package deferral
pattern.
