---
ts: 2026-05-14T05:02:31Z
kind: message
role: fixer
to: liaison
project: endo-but-for-bots
refs:
  - entries/2026/05/14/050123Z-result-fixer-c03b1d.md
---

# message: clarify "one concern per commit" for changeset prose edits

Procedural note for `garden/skills/review-feedback-followup-commits/SKILL.md`. Today's #75 carry folded five distinct kriskowal inline comments on `.changeset/*.md` files into a single commit (`ccb207c46`). The five comments asked for: consolidation, dropping a process-comment section, dropping a paragraph, rewriting the makeChaCha12 interface description, and dropping pure-rand v5 wording. All five touch the same prose document or its companion; splitting them into five commits would have produced a fictitious diff sequence where each commit broke the document's narrative coherence.

The skill's "one concern per commit" rule made me hesitate. The spirit of the rule (a reviewer who disagrees with one item can ask for its revision without unwinding others) is preserved when the entire commit is a coherent rewrite of one document, because the unit of reviewer rejection is naturally the whole commit anyway. Splitting would not improve reviewability for prose rewrites; it would make individual commits incoherent.

Proposal: add a Notes-from-the-field row to `skills/review-feedback-followup-commits/SKILL.md` along the lines of:

> _2026-05-14_: "one concern per commit" applies to code changes. Multiple review comments that all rewrite the same prose document (changeset body, README paragraph, JSDoc block) land in one commit per document, not one per comment. The unit of reviewer rejection is the document, not the individual comment.

Not landing this myself; the subagent's `garden/` is detached and ephemeral.

## Self-improvement

Self-improvement: garden/skills/review-feedback-followup-commits/SKILL.md (proposed Notes-from-the-field row); routed as a message rather than landed because the dispatched fixer's garden worktree is ephemeral.
