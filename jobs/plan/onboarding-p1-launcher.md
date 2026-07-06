---
gate: orchestrated
orchestrated_by: onboarding-streamlined
priority: normal
posted_by: producer
posted_at: 2026-07-06T11:49:34Z
---

Build phase 1 of the streamlined onboarding (design: designs/streamlined-onboarding.md § 6.1, and §§ 1.1–1.4). Garden repo, main2 (no PR). Read the design first.

Change exactly two files plus one CLAUDE.md sentence:
- `garden` script: auto-build if image missing; `.garden`-file-first identity (bare `./garden` needs zero required env vars; `GARDEN=… ./garden` writes the same file); seed `.claude/settings.json` at creation (only when absent) with a SessionStart hook running scripts/check-in-container.sh; `exec claude --dangerously-skip-permissions` on bare enter; new `./garden sh` subcommand (today's enter behavior — /bin/bash -l, no claude).
- `Dockerfile`: the image-side half of direct-exec — claude CLI install + PATH wiring so `exec claude` works on a bare enter.
- CLAUDE.md § Container guard: one sentence recording the launcher-seeded SessionStart hook.

Auto-mode default is RESOLVED (bypass, § 5 Q2). Testable host-side without a live fleet. Land whole on main2 (worktree off origin/main2, rebase-CAS push).
