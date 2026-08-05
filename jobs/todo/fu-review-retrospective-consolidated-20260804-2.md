---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In the garden's own repo (github.com/kriscendobot/garden), investigate the gauntlet-coverage gap the 2026-08-04 review retrospective identified: PRs on kriscendobot/endo-but-for-bots (#881, #806, #684, #836) that reached review with no build/gauntlet/panel job recorded at all, so "the panel missed it" was really "the panel never ran." Determine where the auto-gauntlet invariant (build → clean → panel → fix-loop → un-draft) fails to fire for PRs that did not originate from a `build` job, and write a design proposal in `designs/` covering the general case (not just the existing `garden-design-pr-gauntlet-bypass` design-PR cluster).
