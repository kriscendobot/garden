---
role: builder
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-08-10T23:21:05Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: the garden itself (this repo, `main2` branch)
role: builder

Garden-infra build, not a fork/PR build: implement straight onto `main2`
from an isolated per-job worktree off `origin/main2`
(`roles/COMMON.md` § the one correct shape for a garden-infra job) — no
branch, no PR, per CLAUDE.md § Conventions (the garden's own repo takes no
PR workflow).

## Task

Implement the deadline-approaching nudge for job runners designed in
`designs/deadline-nudge.md` (posted as job `deadline-nudge-design`; read
that design first — it is this job's spec). Build exactly what it specifies:
resolve every "Open questions" item it left unresolved is NOT this job's
call — if the design still has open questions blocking implementation,
stop and report back rather than guessing.

Land the mechanism, wire it into whatever timer/watcher/hook the design
names, and cover it with a test consistent with the surrounding
`scripts/jobs/test/` conventions.

## Definition of done

- The mechanism lands on `main2` as the design specifies.
- A test demonstrates a claim approaching its deadline gets nudged via its
  own inbox, and that the nudge does not perturb the reap-count /
  deadline-overrun cycle markers.
- Report which design open-questions (if any) were resolved during build
  and how, vs. deferred back to the maintainer.
