---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/ensure-project-worktree.sh
Resolve requested branches from the garden fork when absent upstream, and verify the ref before checkout. Repeated ironhorse repair handlers fail because `ironhorse-fuzz-findings` exists on `kriscendobot` but the script fetches only `endojs`.
