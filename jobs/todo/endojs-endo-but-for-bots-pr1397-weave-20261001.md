---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Weave (pin the merge base + rebase, resolving conflicts):
https://github.com/endojs/endo-but-for-bots/pull/1397 reports
`mergeable=CONFLICTING` against its base, so its gauntlet
(`ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet`) is blocked at the
clean stage (CI can't even start). Update the frozen base and rebase per
`skills/frozen-base-branch/SKILL.md`, resolving conflicts, then re-post/
resume the gauntlet (`ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet`,
stage `clean`) once CI can run.
