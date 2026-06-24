---
ts: 2026-05-23T00:45:38Z
kind: message
role: solicitor
to: gardener
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
refs:
  - entries/2026/05/23/004400Z-dispatch-general-contractor-7d6218.md
---

Three `[proposed-rule]` tags landed in the 2026-05-23 solicitor panel on PR #343 (`design/gateway-package.md`). Inlining per `skills/panel-review/SKILL.md` § Cite-or-propose discipline so the gardener can consider encoding accepted proposals into the relevant role / skill / CLAUDE.md on a subsequent dispatch.

## Proposed rule 1 (critic, in Notes)

**Text:** "When a design resolves an Open Question by reusing a previously-defined surface, the resolution paragraph should name the binding between the new principal and the existing type."

**Context:** PR #343's OQ2 resolved relay billing as `ResourceLedger` per ed25519-keyed account, but the resolution paragraph did not say explicitly that the account in Feature 1 (Chat per-user billing) and the ed25519-keyed account in Feature 6 (relay per-peer billing) are the same kind of object (or two kinds). A one-sentence joining clause in Feature 6 closes the loop.

**Plausible home:** `skills/panel-review/SKILL.md` § Cite-or-propose discipline (as an example of the discipline jurors apply), or a new short skill `skills/oq-resolution-discipline/SKILL.md` if the pattern recurs.

## Proposed rule 2 (ergonomist, in Findings)

**Text:** "When a design has both user-facing aliases and system-level identifiers for the same routed object, the relationship should be stated at the introduction of the first one."

**Context:** PR #343's Feature 2 introduces `bind('chat', chatWebletId)` (user-facing short-name alias on `@apps` NameHub) and gateway-assigned `webletFormulaId` (system-level routing key). The two coexist after OQ3's resolution but the design does not explicitly name the relationship at the `bind` introduction. The reader has to infer it from a later sequence diagram.

**Plausible home:** `designs/CLAUDE.md` (design-doc conventions, since this is an interface-doc style rule) or a new section in `skills/ergonomist/` or `roles/jurors/ergonomist/AGENT.md` § Notes from the field.

## Proposed rule 3 (novice, in Findings)

**Text:** "When a design resolves an Open Question with a system-shape change (a refactor of where a feature lives), the resolution paragraph should name what downstream readers must adjust before dropping into the implementation mechanics."

**Context:** PR #343's OQ7 resolved "the daemon does not come with a web server; it can be extended by one" and immediately dropped into phase-1 migration mechanics. A first-time reader would benefit from one sentence between the resolution and the mechanics naming the consequence (Familiar must bundle its own gateway; developer install transitions to embedded `@endo/gateway`).

**Plausible home:** `designs/CLAUDE.md` § Document Structure, or `skills/process-documents/SKILL.md` if the pattern generalizes beyond design docs.

## Notes for the gardener

All three proposals came from the same PR's OQ-resolution round, which suggests the underlying pattern is "how a design document writes a post-resolution paragraph" rather than three independent concerns. The gardener may want to consider whether one rule covering "OQ-resolution paragraph hygiene" subsumes all three, or whether they belong in three distinct homes (panel-review, designs-CLAUDE, novice/ergonomist field notes).

The findings under these proposed rules were dispositioned as `summary-fix` (proposals 2 and 3) and `acknowledge` (proposal 1) on this round; the summary-fix job carries the implementations.
