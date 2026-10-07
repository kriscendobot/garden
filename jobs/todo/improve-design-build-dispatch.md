---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/assert-followup-posted.sh
`scripts/jobs/assert-followup-posted.sh:334` requeues a completed design job when its report names an unposted conditional build, as occurred for `design-minion-town-oauth-bonds` at 2026-10-07T22:14:35Z. Add a deterministic design-to-build handoff that recognizes the completed design PR, records a typed recheck or posts the builder job when its prerequisite state is satisfied, then writes the verified handoff marker. This moves dispatch from report-writing agent discretion into the script and prevents costly reaper retries after the design PR and gauntlet were already staged.
