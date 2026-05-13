---
ts: 2026-05-13T20:52:42Z
kind: dispatch
role: liaison
project: garden
to: "*"
refs:
  - entries/2026/05/13/203419Z-message-steward-2480ee.md
---

# Dispatch: gardener ports the `groom` role from references/

Dispatch root: `dispatches/gardener--port-groom-role--20260513-205242--260b5a/`.

Task: adopt `references/endo-but-for-bots/roles/groom.md` as `roles/groom/AGENT.md` in the active library. The maintainer authorized this port after the steward routed a roadmap-edit directive (endo-but-for-bots#134#issuecomment-4438141029, "raise the Gateway concern to M1") that has no good home in the existing active set. The groom role's documented purpose is roadmap maintenance — the canonical fit.

Standard port shape (the gardener has done seven of these today; same procedure):

- Copy and translate the reference into `roles/groom/AGENT.md` with frontmatter (`created: 2026-05-13`, `updated: 2026-05-13`, `author: liaison`).
- Em-dash sweep; path translations (`../skills/<slug>.md` → `../../skills/<slug>/SKILL.md`; reference's per-PR worktree pattern → the dispatch-worktree triple per `WORKTREES.md` § Per-dispatch worktree triple; reference's `process/<file>.md` references → cite the migrated journal entry mirrors under `project: endo-but-for-bots`).
- Pull in cited skills. Reuse aggressively against `skills/` already in the active library; only port skills the active set lacks.
- Update `CLAUDE.md` § Current inventory (Roles list).
- Update `roles/steward/AGENT.md` § Subordinate roles dispatched: add `groom` with a one-line description of when the steward dispatches it (default: when a maintainer roadmap-edit directive surfaces; the steward forwards the per-action authorization).

Out of scope:

- Do NOT execute the Gateway → M1 roadmap edit in this dispatch. The groom role landing is one engagement; the first real groom dispatch (with project worktree of endo-but-for-bots@llm) is the next engagement.
- Do NOT touch `roles/{liaison,steward,monitor,review-queue,boatman,fixer,weaver,shepherd,conductor,designer,scout,botanist,major-general,journalist,librarian,scholar,timekeeper,gardener}/AGENT.md` files beyond the steward's subordinate-roles entry.

Report on return: role file path, cited skills reused vs newly ported, commit SHAs on `main`, one-line confirmation that the role is ready for first dispatch.
