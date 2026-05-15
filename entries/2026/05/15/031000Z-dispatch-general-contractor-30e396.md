---
ts: 2026-05-15T03:10:00Z
kind: dispatch
role: general-contractor
to: judge
project: endo-but-for-bots
worktree: dispatches/judge--30e396/project
refs:
  - entries/2026/05/15/030730Z-message-general-contractor-50e6db.md
---

# Dispatch judge: design panel on PR #252 (slot 1)

Slot 1 refilled by adopting stale draft PR #252 (`design(ocapn,noise): session reconnect with heartbeat`). Design-only on `llm`, 5.7 hours stale, no reviews yet, CI 4/4 green.

Dispatch root: `dispatches/judge--30e396` (project worktree at `endojs/endo-but-for-bots@design/ocapn-noise-session-reconnect`).

## Task

The file list is entirely under `designs/`:
- `designs/README.md` (modified)
- `designs/ocapn-noise-network.md` (likely modified or added)
- `designs/ocapn-noise-session-reconnect.md` (added)

Design-panel discrimination per `roles/judge/AGENT.md` § Panel-kind discrimination is unambiguous. No `@copilot` request (design panel skips it).

Dispatch the five-seat design panel (critic, skeptic, copyeditor, pedant, novice) concurrently, aggregate, submit one formal `gh pr review`. If the loop terminates this dispatch (no in-scope must-fix), run `gh pr ready 252 -R endojs/endo-but-for-bots`.

The harness may not surface `Agent`/`Task` — verify via `ToolSearch` and use in-band fallback per `roles/judge/AGENT.md` § In-band fallback if needed.

Per-action authorization (forwarded by general-contractor): formal `gh pr review` submission, and `gh pr ready 252` if the loop terminates this dispatch.

Report (journal `result` + final message): PR number, panel kind, each seat's high-level finding, verdict, un-draft status, any in-scope must-fix for the next fixer cycle. Self-improvement per `garden/skills/self-improvement/SKILL.md`.
