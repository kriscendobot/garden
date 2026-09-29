---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-pr1097-orch-20260929-resume
priority: normal
role: fixer
posted_by: producer
posted_at: 2026-09-29T06:33:48Z
---

---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Retcon endojs/endo-but-for-bots PR #1097 (if necessary)

Repo endojs/endo-but-for-bots, PR https://github.com/endojs/endo-but-for-bots/pull/1097.
Ask 3 of kriskowal's APPROVED review https://github.com/endojs/endo-but-for-bots/pull/1097#pullrequestreview-5348027197: "Then retcon if necessary". Follow
skills/retcon/SKILL.md: reset + restage per-package with a separate
`chore: Update yarn.lock` commit, net diff invariant. If the history is already clean
per-package (and no yarn.lock churn), record that and make no change. No merge.
