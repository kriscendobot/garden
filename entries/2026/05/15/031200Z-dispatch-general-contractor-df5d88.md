---
ts: 2026-05-15T03:12:00Z
kind: dispatch
role: general-contractor
to: judge
project: endo-but-for-bots
worktree: dispatches/judge--df5d88/project
refs:
  - entries/2026/05/15/031000Z-dispatch-general-contractor-30e396.md
---

# Dispatch judge: design panel on PR #249 (slot 2)

Slot 2 refilled with stale draft PR #249 (`design(ses,module-source): top-level-await proposal`). Design-only on `llm`, 6.8 hours stale, CI 4/4 green, kriskowal CHANGES_REQUESTED with empty body (placeholder per the contractor's pattern; not actionable as panel feedback).

The PR is explicitly named in `skills/pr-creation-flow/SKILL.md` notes-from-the-field as a target for the first design-panel rounds.

Dispatch root: `dispatches/judge--df5d88` (project worktree at `endojs/endo-but-for-bots@design/ses-top-level-await`, head `f191dd1ae`).

## Task

Convene the five-seat design panel (critic, skeptic, copyeditor, pedant, novice) concurrently. The PR's file list lives under `designs/` (design panel discrimination is unambiguous). No `@copilot`.

The harness likely will not surface `Agent`/`Task` — verify via `ToolSearch` and use in-band fallback per `roles/judge/AGENT.md` § In-band fallback.

Treat kriskowal's empty-body `CHANGES_REQUESTED` as a placeholder; do not let it bias the panel. The panel reviews the design content on its merits.

Aggregate, submit one formal `gh pr review`. If verdict has no in-scope must-fix, run `gh pr ready 249 -R endojs/endo-but-for-bots`.

Per-action authorization (forwarded by general-contractor): formal `gh pr review` submission, and `gh pr ready 249` if the loop terminates.

Report (journal `result` + final message): PR number, panel kind, each seat's high-level finding, verdict, un-draft status, any in-scope must-fix. Self-improvement per `garden/skills/self-improvement/SKILL.md`.
