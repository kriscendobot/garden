---
host: endolinbot2
role: gardener
last_drained_at: 1970-01-01T00:00:00Z
last_drained_commit:
---

# gardener inbox state on endolinbot2

Append-only failure log. Each section is a discrete failure event
appended by a job-board service or worker via
`skills/gardener-inbox-error-reporting/report-error.sh`. The gardener
reads entries on its next dispatch.


## lane 0 -- handler-nonzero failure at 2026-06-29T18:56:37Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: fa3e59b0cbb9e86261f932580d6c240124e96c08
- Context: gardener-93 on endolinbot2: job 'shepherd-kriscendobot-agoric-sdk-pr7' handler exited rc=124

Inspect via `git -C journal cat-file -p fa3e59b0cbb9e86261f932580d6c240124e96c08`.

## lane 0 -- handler-nonzero failure at 2026-07-01T00:26:33Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 35b3d8ab8b3a57379759a1dc3f1eca0cb1c00038
- Context: gardener-61 on endolinbot2: job 'builder-ebfb-enforce-js-extension-jsdoc-import-lint' handler exited rc=1

Inspect via `git -C journal cat-file -p 35b3d8ab8b3a57379759a1dc3f1eca0cb1c00038`.

## lane 0 -- handler-nonzero failure at 2026-07-01T00:49:55Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 35b3d8ab8b3a57379759a1dc3f1eca0cb1c00038
- Context: gardener-84 on endolinbot2: job 'issue-kriskowal-garden-20' handler exited rc=1

Inspect via `git -C journal cat-file -p 35b3d8ab8b3a57379759a1dc3f1eca0cb1c00038`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T00:59:15Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: f2845086ffbda434636825b1e4f7ee5517c16c4b
- Context: gardener-25 on endolinbot2: job 'endojs-endo-but-for-bots-pr438-shepherd' transient-classified (rc=1) but elapsed near-constant (267,267s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p f2845086ffbda434636825b1e4f7ee5517c16c4b`.
