---
ts: 2026-05-15T02:11:00Z
kind: dispatch
role: general-contractor
to: judge
project: endo-but-for-bots
worktree: dispatches/judge--60d499/project
refs:
  - entries/2026/05/15/020448Z-message-general-contractor-51eef2.md
---

# Dispatch judge: design panel on PR #241 (slot 1)

Slot 1 adopted stale draft PR #241 (`design: familiar/host run applications over a VFS`, 27.7 hours since last update). The PR is design-only on the `llm` roadmap branch, four CI checks green, no panel verdict yet, no maintainer review.

Dispatch root: `dispatches/judge--60d499` (project worktree at `endojs/endo-but-for-bots@design/familiar-run-vfs-apps`).

Task: dispatch the five-seat design panel (critic, skeptic, copyeditor, pedant, novice) concurrently against this PR's diff under `designs/`, aggregate the per-seat blocks, submit one formal `gh pr review`. If the verdict is `--approve` (or `--comment` with no in-scope must-fix), run `gh pr ready 241` to un-draft. If the verdict has in-scope must-fix items, the contractor's next cycle dispatches a fixer; the judge's `result` lists the items.

Per-action authorization (forwarded by the contractor's adoption authority): the judge may post the formal `gh pr review` and run `gh pr ready 241` if the loop terminates this dispatch.

The judge does not dispatch a code panel here; the file list is entirely under `designs/` so the panel-kind discrimination per `roles/judge/AGENT.md` is unambiguous. The judge does not add `@copilot` (design panel skips it).

Report: PR number, verdict (`--approve` / `--comment` / `CHANGES_REQUESTED`), un-draft status if applicable, any in-scope must-fix items the next cycle should hand to a fixer.

Self-improvement: apply per `skills/self-improvement/SKILL.md`.
