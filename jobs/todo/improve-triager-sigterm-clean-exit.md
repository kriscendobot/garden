---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/triager.sh
Handle TERM/INT before fetch classification and exit with the corresponding clean signal status. A systemd stop produced fetch rc=143 with no diagnostic, which the script treated as a real fetch failure and logged as a warning despite being an expected interrupted tick.
