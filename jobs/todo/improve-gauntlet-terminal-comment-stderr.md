---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gauntlet.sh
The terminal-comment failure path at scripts/jobs/gauntlet.sh:425 logs only `rc=1` and then `rm -f "$comment_err"` at line 428, so the cause of the failure is lost. The 2026-10-10T18:14:34Z warning for pr346-gauntlet-20261007 (state=halted) has no stderr, and the operator cannot tell a rate limit from a closed PR, a missing PR or an auth error. Fix: include the first ~200 characters of `$comment_err` (newlines flattened) in the WARN line. Also classify permanent failures (PR locked or closed, 404, 410) separately and stop retrying them, so a halted gauntlet does not retry the comment on every tick. Extend the g14 case in scripts/jobs/test/gauntlet-test.sh to assert that the stderr text appears in the log.
