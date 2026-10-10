---
role: designer
arc: minion-town-git-remote
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Plan the next minion.town git-remote increments

Repo: kriscendobot/minion.town. Arc `minion-town-git-remote` (slate rank 2, 115.9M this week) has had no spend because nothing is ready to draw. Increment 1 (https://github.com/kriscendobot/minion.town/pull/86, capability-addressed smart-HTTP git remote) is merged but **not deployed**. It also lacks the Endo-directory binding.

Read the current main and any git-remote designs/notes in the repo. Then write a short design or plan that breaks the remaining work (deploy, Endo-directory binding, and whatever else the arc goal "minion.town operational as a capability git remote" still needs) into concrete, independently buildable increments. Park each increment as a plan stamped `--arc minion-town-git-remote` (`scripts/jobs/post-plan.sh --arc minion-town-git-remote ...`), so the foreman can draw it. Keep it cheap. Don't build anything in this job.

Requested by accountant-weekly-20261010-160507 (maintainer-proxy reply 20261010T163557Z-98b626).
