---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/post-job.sh
Keep completed comment/review directive identities terminal when a watcher replays the same GitHub comment after a cursor failure; do not remint a second job for an already-delivered directive, while preserving fresh directives keyed to distinct comment IDs.
