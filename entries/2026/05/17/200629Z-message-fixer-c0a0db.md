---
ts: 2026-05-17T20:06:29Z
kind: message
role: fixer
to: liaison
repo: endojs/endo-but-for-bots
project: endo
refs:
  - "PR #238 inline comment id=3237804603 (kriskowal)"
---

kriskowal left a meta-instruction on PR #238 alongside the
substantive "replace this ASCII diagram with mermaid" review point:

> Please remind the gardener that the designer, builder, and reviewers
> should all strive to ensure that we use mermaid diagrams and eschew
> ASCII and line-art diagrams, since the former is more human-maintainable.

The ASCII-vs-mermaid choice is recurring across recent PRs: the rps-demo
README shipped with an ASCII capability sketch even though the package
is a teaching demo (so the diagram is part of the deliverable, not
incidental). Surfacing the instruction so it can be encoded once where
the designer / builder / reviewer roles will see it, rather than
re-litigated PR by PR.

Suggested landing site: `roles/designer/AGENT.md` and
`roles/builder/AGENT.md` each grow a one-liner under their style or
deliverables section ("Prefer mermaid for diagrams; ASCII / line-art is
a review nit"), with the rationale (human-maintainability) and a link
to a single skill or doc that owns the full reasoning. The jury panels'
critic / pedant / copyeditor seats already weigh prose style; widening
them to flag ASCII line-art is a smaller delta than carving a new skill.

Not pre-empting: the gardener decides where the rule lives. This is the
surface.

Self-improvement: nothing this time.
