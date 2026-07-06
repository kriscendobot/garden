---
gate: orchestrated
orchestrated_by: onboarding-streamlined
priority: normal
posted_by: producer
posted_at: 2026-07-06T11:49:38Z
---

Build phase 2 of streamlined onboarding (design: designs/streamlined-onboarding.md § 3.2 shape, § 4 migration map). Garden repo, main2. Read the design first.

Author the new top-level `context/` tree on main2 under the context-library discipline: index README + the nine leaf fragments per § 3.2 (first-run/{README,identity,auth,first-job}.md, operations/{README,starting,leader-follower,scaling,deploy,schedules,health}.md). MIGRATE substance from README.md / CLAUDE.md per § 4 (content moves here FIRST, while the sources still carry it — do NOT yet slim the sources; that is phase 4). Amend skills/context-library/SKILL.md scope to declare context/ a second canonical tree.

Blessed § 5 answers to honor: Q1 (subscription-login in step 2 as beaten path, ANTHROPIC_API_KEY the silent alternative), Q5 (context/ ships with code on main2; journal library stays per-instance — starting-the-garden procedure ships with the code). Land whole on main2 (worktree off origin/main2, rebase-CAS push).
