---
host: ps23-garden-f65473ae
role: gardener
last_drained_at: 1970-01-01T00:00:00Z
last_drained_commit:
---

# gardener inbox state on ps23-garden-f65473ae

Append-only failure log. Each section is a discrete failure event
appended by a job-board service or worker via
`skills/gardener-inbox-error-reporting/report-error.sh`. The gardener
reads entries on its next dispatch.


## lane 0 -- handler-nonzero failure at 2026-07-28T16:44:50Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 7aa46954ae26004273188a125033ffead5b2da87
- Context: gardener-8 on ps23-garden-f65473ae: job 'validate-fireworks-job-end-to-end' handler exited rc=1

Inspect via `git -C journal cat-file -p 7aa46954ae26004273188a125033ffead5b2da87`.
