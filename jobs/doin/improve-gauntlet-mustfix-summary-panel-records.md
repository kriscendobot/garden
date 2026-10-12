---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardening/gauntlet-mustfix-summary.sh
`scripts/jobs/gardening/gauntlet-mustfix-summary.sh:64-79` searches agent-authored panel tada reports for structured lists, but those reports omit them; the authoritative matching `panel-runs` record has them. Resolve each stage report’s reviewed head to its `panel-runs/<repo>-<pr>` record and render its bounded must-fix list, retaining the current fail-soft fallback. Evidence: the 2026-10-12T02:15:23Z digest reports PR #171’s unaddressed list as unknown although its panel record contains 20 items. Add a regression test using a stage report plus matching panel-run record.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-12T02:23:01Z
