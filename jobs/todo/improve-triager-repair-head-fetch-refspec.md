---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/triager.sh
scripts/jobs/triager.sh:754 treats `fatal: couldn't find remote ref HEAD` as an unclassified failure, as seen for kriscendobot-garden-book at 2026-10-01T20:14:20Z. Detect this deterministic invalid bare-clone fetch-refspec state, restore the required `+refs/heads/*:refs/remotes/origin/*` origin refspec, and retry the bounded fetch once. Add a regression fixture proving the repair fetches normal branch refs without a maintainer warning.
