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

## lane 0 -- handler-nonzero failure at 2026-07-27T20:33:36Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 07ce1e65c5a6624c1380c7ec3a47a38a736f6cf1
- Context: gardener-7 on ps23: job 'endojs-endo-but-for-bots-pr713-gauntlet-backfill' handler exited rc=1

Inspect via `git -C journal cat-file -p 07ce1e65c5a6624c1380c7ec3a47a38a736f6cf1`.

## lane 0 -- handler-nonzero failure at 2026-07-27T20:54:25Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 66ab1f9273b9816c85d60104044a68b770b98eba
- Context: gardener-5 on ps23: job 'endojs-endo-but-for-bots-pr874-8ed41495' handler exited rc=1

Inspect via `git -C journal cat-file -p 66ab1f9273b9816c85d60104044a68b770b98eba`.

## lane 0 -- handler-nonzero failure at 2026-07-27T21:23:22Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 6ec4e2118d8bb17b83e04566cd43079db5164ac2
- Context: gardener-7 on ps23: job 'issue-kriskowal-garden-67' handler exited rc=1

Inspect via `git -C journal cat-file -p 6ec4e2118d8bb17b83e04566cd43079db5164ac2`.
