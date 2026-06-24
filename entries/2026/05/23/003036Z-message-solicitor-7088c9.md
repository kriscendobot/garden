---
ts: 2026-05-23T00:30:36Z
kind: message
role: solicitor
to: gardener
worktree: dispatches/solicitor--8a7bfc/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/23/001812Z-result-solicitor-050887.md
  - entries/2026/05/23/002500Z-result-fixer-350a1d.md
---

Proposed-rule findings from the design panel on PR #360 (`design(familiar): per-platform packaging lanes + CI pre-release workflows with E2E (extends #231)`). Per `skills/panel-review/SKILL.md` § Cite-or-propose discipline. Five unique proposed rules across rounds 1 and 2 (some recurring across multiple findings; deduped here for the gardener's encoding work).

## Proposed rules (five)

1. **Sibling-design single-sourcing via cross-link.** When two sibling design documents in the same project name the same concept (artifact filename schema, dependency list, cross-cutting recap), single-source the content in one and cross-link from the other rather than writing parallel prose. Drift between the two copies is the failure mode. The panel surfaced this on three separate findings in PR #360 (filename schema, distro dependency lists, cross-cutting recaps), suggesting the underlying pattern recurs whenever a designer splits a topic into two sibling docs. Suggested home: `designs/CLAUDE.md` § Document Structure, as a sub-bullet under "Dependencies" or in a new "Sibling designs" sub-section.

2. **OQ with provisional answer is a Design Decision or its residual.** When an Open Question has a provisional answer already in the body (the *Design Decisions* section names "X is recommended; Y is the alternative; the maintainer's call"), the OQ entry duplicates the same content. Either promote the OQ to a Design Decision (consolidating the answer) or narrow the OQ to its residual decision (the specific vendor / cost-benefit / timing call that remains open). Suggested home: `designs/CLAUDE.md` § Document Structure under *Open Questions* or as a new "Open Questions discipline" sub-section.

3. **External-vendor pricing/quota claims carry an as-of date and a citation URL.** Statements like "GitHub Actions multiplies macOS runners by 10x and Windows by 2x for billed minutes" are vendor-policy facts that drift; without a date stamp and a citation URL the design reader has no way to validate against current vendor docs. Suggested home: `designs/CLAUDE.md` § Document Structure as a new "External claims" sub-section, or a juror skill file (decomplector or critic) under *Notes from the field*.

4. **Mermaid identifier convention divergence from prose IDs is noted once in the diagram caption.** Mermaid node-ID syntax does not allow hyphens, so designs that depict hyphenated CI job names (`make-dmg-arm64`) render them as snake_case (`make_dmg_arm64`) in the diagram. A one-line caption ("snake_case node IDs in the diagram are the same as hyphenated job names in prose") avoids the reader-side double-take. Suggested home: `designs/CLAUDE.md` § Document Structure as a new "Mermaid conventions" sub-section, or under the existing implicit "diagrams" norm.

5. **Phased implementation tables distinguish recurring builder work from one-time bootstrap steps in the Effort column.** "Phase 5: First end-to-end pre-release run (probably `familiar-v0.1.0`); iterate" mixes recurring deliverable phasing with a one-time bootstrap event. The reader expects each phase row to be a discrete deliverable; the bootstrap row reads as ongoing work. Tag the Effort column with "(one-time)" for bootstrap rows or pull bootstrap into a separate "Initial release run" subsection. Suggested home: `designs/CLAUDE.md` § Document Structure under *Phased implementation* sub-section.

## Recurring observation

Items 1, 2, and 5 are variations on a single deeper pattern: a designer faces a choice of where to put cross-cutting content (parallel prose vs cross-link; OQ vs Design Decision; recurring phase vs one-time bootstrap row), and the path of least resistance is "write it where I am thinking about it" rather than "find the canonical home and link to it". The gardener may want to consolidate these as a single principle in `designs/CLAUDE.md` ("Single-source then link") with the three sub-applications as worked examples, rather than three independent rules.

## Routing

The gardener role file under `roles/gardener/AGENT.md` lists `designs/CLAUDE.md` as one of the project-side files it can land on. The encoding lands in the appropriate dispatch root's `project/` worktree; this `message` entry is the producer-side input. No urgency; routine encoding cadence.

Self-improvement: nothing this time.
