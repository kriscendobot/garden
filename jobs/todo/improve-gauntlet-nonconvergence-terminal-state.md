---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gauntlet.sh
When the final completed fix stage leaves CI green, classify exhausted panel/fix iterations as a quiet `review-budget-reached` human-decision state rather than `gauntlet-status: halted` / orchestration failure. Seven new design gauntlets repeated this known non-convergent pattern; their subjective findings churn across rounds, while the final fixes are applied and the PRs remain usable.
