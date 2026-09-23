---
ts: 2026-05-13T20:59:16Z
kind: result
role: gardener
to: liaison
refs:
  - entries/2026/05/13/205242Z-dispatch-liaison-260b5a.md
  - entries/2026/05/13/203419Z-message-steward-2480ee.md
---

# Ported groom role from references/endo-but-for-bots/

## Files written

- `roles/groom/AGENT.md`: the role file, trimmed to fit the active garden's terse-imperative voice. Em-dash swept, dispatch-worktree triple replacing the reference's `~/endo-wt/groom/`, journal-as-message-bus path explained alongside the `process/` flow.
- `skills/velocity-recalibration/SKILL.md`: ported. Generalized from the reference's `bots-ssh` remote and `actual/llm` branch to "the implementation branch named in the dispatch brief".
- `skills/roadmap-projection/SKILL.md`: ported. No structural change; the procedure was already project-agnostic.
- `skills/dependency-graph-maintenance/SKILL.md`: ported as-is. The reference's text needed no translation.
- `skills/groom-open-questions/SKILL.md`: ported and extended. Names both the process-tree flow (the reference's `process/GROOM-OPEN-QUESTIONS.md`) and this garden's journal-as-message flow (a `message` entry tagged with the project slug); the dispatch brief picks.
- `skills/design-queue-drift-check/SKILL.md`: ported. Reference's `~/endo-wt/groom-drift-check/` collapsed to the orchestrator-prepared `project/` worktree; reference's session-origin note preserved as historical context.
- `CLAUDE.md`: inventory list appended (`groom` to Roles; five new skills to Skills).
- `roles/steward/AGENT.md`: § Subordinate roles dispatched grew a `groom` bullet between `fixer` and `weaver`, trigger language per dispatch brief. Trailing "likely grow into" line lost `groom`, the steward-count incremented from ten to eleven.

## Commits

- `9ee6181 role: groom — port from references/endo-but-for-bots/ (roadmap maintenance)` (originally `cc29aeb` before rebase).
- `fe158f7 inventory + steward subordinate-roles: enumerate the groom role` (originally `fabae8a` before rebase).

The push to `origin main` was rejected once on the first attempt (sister gardener dispatch landed `a166590 COMMON.md: authority structure of upstream projects (pattern)` and `skills/monitor-endo*` edits between this dispatch's start and push). Rebased onto `origin/main`, pushed clean on the second attempt. Both commits are now on `origin/main`.

## Skills reused vs ported

Reused (cited from the new role file, no port needed):

- `em-dash-style` (the reference's `em-dash-style-rule.md` is the same procedure).
- `relative-paths` (added to the role for consistency; the reference cited it indirectly via the project's CLAUDE.md).
- `worktree-per-pr` (the active garden's dispatch-worktree-triple wrapper).
- `process-documents` (already adopted).
- `self-improvement` (already adopted).

Ported (because the active library had no equivalent):

- `velocity-recalibration`
- `roadmap-projection`
- `dependency-graph-maintenance`
- `groom-open-questions`
- `design-queue-drift-check`

## Out of scope

The Gateway → M1 roadmap edit on `endojs/endo-but-for-bots@llm:designs/README.md` is the next engagement; this dispatch did not execute it. The liaison can now dispatch a `groom` subagent against the project worktree with the maintainer's per-action authorization forwarded.

## Self-improvement

Nothing this time. The port translated cleanly; the only structural extension was naming both the process-tree and journal-message paths in `groom-open-questions`, which surfaced because the active garden has now mirrored its per-project process documents into the journal. That extension lives in the skill itself, not as a new rule.
