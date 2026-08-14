---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Self-improvement finding (liaison bus, 2026-08-11, from `minion-town-weblet-usage-metering-design` job, sent by endolin-garden2-5bcdff64):

`roles/designer/AGENT.md` cites `skills/prompt-section-discovery`, but that skill is absent from both the skills inventory (CLAUDE.md § Current inventory) and the filesystem. Investigate whether it was retired/renamed (check git log for `skills/prompt-section-discovery`) and either restore the skill file, or remove/replace the dangling citation in `roles/designer/AGENT.md` with whatever superseded it (or drop the reference outright if nothing did). Update CLAUDE.md's skill inventory list if the resolution changes it.
