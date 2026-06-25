---
host: endolinbot
role: gardener
last_drained_at: 1970-01-01T00:00:00Z
last_drained_commit:
---

# gardener inbox state on endolinbot

Append-only failure log. Each section is a discrete failure event
appended by a job-board service or worker via
`skills/gardener-inbox-error-reporting/report-error.sh`. The gardener
reads entries on its next dispatch.


## lane 0 -- handler-nonzero failure at 2026-06-25T00:34:08Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e69de29bb2d1d6434b8b29ae775ad8c2e48c5391
- Context: gardener-30 on endolinbot: job 'scholar-ingest-cask-13' handler exited non-zero

Inspect via `git -C journal cat-file -p e69de29bb2d1d6434b8b29ae775ad8c2e48c5391`.

## lane 0 -- handler-nonzero failure at 2026-06-25T15:38:10Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e69de29bb2d1d6434b8b29ae775ad8c2e48c5391
- Context: gardener-24 on endolinbot: job 'scholar-ingest-cask-14' handler exited non-zero

Inspect via `git -C journal cat-file -p e69de29bb2d1d6434b8b29ae775ad8c2e48c5391`.

## lane 0 -- handler-nonzero failure at 2026-06-25T18:04:11Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e69de29bb2d1d6434b8b29ae775ad8c2e48c5391
- Context: gardener-58 on endolinbot: job 'fix-compartment-mapper-bundle-missing-deps' handler exited non-zero

Inspect via `git -C journal cat-file -p e69de29bb2d1d6434b8b29ae775ad8c2e48c5391`.
