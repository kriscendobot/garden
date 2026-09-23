---
ts: 2026-05-13T22:09:33Z
kind: dispatch
role: liaison
project: garden
to: "*"
refs:
  - entries/2026/05/13/215426Z-message-steward-5fd29d.md
---

# Dispatch: gardener ports `investigator` from references/

Dispatch root: `dispatches/gardener--port-investigator-role--20260513-220933--e0e7a3/`. The steward at `entries/2026/05/13/215426Z-message-steward-5fd29d.md` flagged `investigator` as the second role-gap surfaced (first was `groom`, now ported; the steward's read on `builder` was stale and that role is already active). Maintainer-authorized in this session.

Task: port `references/endo-but-for-bots/roles/investigator.md` to `roles/investigator/AGENT.md` via the standard port shape (which the gardener has done eight or so times today):

- Frontmatter (`created: 2026-05-13`, `updated: 2026-05-13`, `author: liaison`).
- Em-dash sweep; relative-path translations; `process/<file>.md` references rewrite to journal-mirror entry citations; reference's per-PR worktree pattern collapses to the dispatch-worktree triple.
- "Adopted from references/endo-but-for-bots/roles/investigator.md." note near the top.
- Keep the role file short; move sprawling material into cited skills.
- Pull in cited skills. Reuse aggressively against the existing `skills/` directory; only port what is missing.
- Update `CLAUDE.md` § Current inventory's Roles list with `investigator`. If new skills landed, add them to Skills too.
- Update `roles/steward/AGENT.md` § Subordinate roles dispatched: add `investigator` with its dispatch trigger (e.g. "when a maintainer-flagged bug or behavioral mystery surfaces that needs hypothesis-driven investigation, e.g. a CI failure whose root cause is not obvious or a `gh issue` request for SES/runtime investigation").

If you notice while porting that a `investigator`-shaped role could benefit from a cite of the new context-library or journalism skills (since investigation produces journal-side artifacts), use them. Don't invent new conventions; cite existing ones where they fit.

## Out of scope

- Do not run the investigator for any first engagement; this is meta-evolution only. The first real investigator dispatch happens when the maintainer next surfaces #147-shaped work (SES investigation) or similar.
- Do not touch other role files beyond the steward subordinate-roles edit and the CLAUDE.md inventory.
- Do not port any other reference role in this dispatch (one-role-per-engagement is fine; the proactive sweep the steward suggested is a separate question for the maintainer).

## Report

Commit SHAs on `main`, cited-skill picks (reused vs newly ported), self-improvement line.
