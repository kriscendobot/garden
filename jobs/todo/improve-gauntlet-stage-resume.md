---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gauntlet.sh
Add a CAS-safe resume-from-stage primitive so a halted staged gauntlet can resume at a specified stage (such as FIX) without a gardener performing a one-off journal transaction.
