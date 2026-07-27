---
host: ps23
role: gardener
last_drained_at: 1970-01-01T00:00:00Z
last_drained_commit:
---

# gardener inbox state on ps23

Append-only failure log. Each section is a discrete failure event
appended by a job-board service or worker via
`skills/gardener-inbox-error-reporting/report-error.sh`. The gardener
reads entries on its next dispatch.


## lane 0 -- handler-nonzero failure at 2026-07-27T20:27:42Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 0c19e9193365e206fb504997b8fceab0ccc0f68a
- Context: gardener-8 on ps23: job 'self-heal-fix-garden-ci-watcher-kriscendobot-garden-reconcile-disarm-list-units' handler exited rc=1

Inspect via `git -C journal cat-file -p 0c19e9193365e206fb504997b8fceab0ccc0f68a`.
