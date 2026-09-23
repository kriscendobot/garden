---
ts: 2026-05-13T01:42:10Z
kind: dispatch
role: liaison
project: garden
to: "*"
refs:
  - entries/2026/05/13/013947Z-result-liaison-439ad4.md
---

# Dispatch: gardener designs the journalist role for bulletin maintenance

Dispatch root: `dispatches/gardener--design-journalist-role--20260513-014206--9c3ae6/`. Subagent operates as the newly-landed `gardener` role; this is the gardener's first real engagement.

Task: design a new role, `journalist`, that maintains the bulletin board on `journal/README.md`. The maintainer's specific brief:

- Consult `endo-but-for-bots@llm:designs/` (provided as the dispatch's project worktree at `<dispatch-root>/project/designs/`) for the endo project roadmap. The directory is the source of truth for what the project's milestones are.
- Classify pull requests by milestone when applicable. The current *Pending kriskowal reviews* bulletin section is a flat chronological list (101 rows); the journalist should produce a milestone-classified rendering.
- Remaining review requests (PRs that do not map to any milestone in the designs, or that live outside the endo project) get binned by repository.

This is the gardener's job (designing a new role) rather than the journalist's first actual run. The journalist's actual bulletin-writing dispatches come later, fired by the steward on cadence or in response to review-queue daemon ADD/REMOVE lines.

Decisions the gardener should make and record in the role file:

- Whether the journalist replaces the review-queue role's bulletin-writing duty, or augments it. The user's framing ("a journalist role, for maintaining the bulletin board") suggests it owns the bulletin going forward; the review-queue daemon and skill keep producing the canonical-set data the journalist consumes.
- What the bulletin section's new shape is (milestones across all endo-project PRs, then per-repo bins for the rest). Stable-delimiter conventions matching the existing `<!-- BEGIN pending-kriskowal-reviews -->` style.
- What the journalist reads from `designs/` and how it maps PRs to milestones. The designs directory has dozens of files; you have it materialized as `<dispatch-root>/project/designs/` so you can browse before specifying.
- Whether the journalist owns additional bulletin sections (currently: *Awaits maintainer review*, *Awaits maintainer decision*, *Surplus authority discovered*, *Pre-staged authorizations*, *Scheduled engagements*, *PR backlog*, *Pending kriskowal reviews*). Default lean: the journalist owns the *Pending kriskowal reviews* and *PR backlog* sections (both review-list shaped); other sections stay with whichever role posts to them. State this explicitly so the steward and liaison know.
- The journalist's dispatch triggers. Liaison-driven (user asks for a milestone-classified review queue), steward-driven (on a cadence the gardener picks, e.g. every N review-queue daemon ADD events; or on each cycle close as part of bulletin maintenance).
- The skills it cites (`journal-sync`, `em-dash-style`, `relative-paths`, `self-improvement` at minimum; plus any new skill the design needs).

Out of scope for this dispatch:

- Do not run the journalist for its first real bulletin update. That happens after the role file lands and the steward picks it up.
- Do not modify the review-queue daemon (`scripts/review-queue-poll.sh`); its canonical set is the input the journalist consumes.
- Do not touch other bulletin sections beyond renaming or relocating *Pending kriskowal reviews* and *PR backlog* if the design warrants.

Report expected on return: the role file path, commit SHA(s) on `main`, one-paragraph description of the design choices (especially the milestone-mapping rule and the section-ownership split), and any messages routed to the liaison for maintainer attention.
