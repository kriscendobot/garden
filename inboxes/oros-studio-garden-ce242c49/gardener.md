---
host: oros-studio-garden-ce242c49
role: gardener
last_drained_at: 1970-01-01T00:00:00Z
last_drained_commit:
---

# gardener inbox state on oros-studio-garden-ce242c49

Append-only failure log. Each section is a discrete failure event
appended by a job-board service or worker via
`skills/gardener-inbox-error-reporting/report-error.sh`. The gardener
reads entries on its next dispatch.


## lane 0 -- handler-nonzero failure at 2026-09-16T23:18:01Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 27ed4914e6ec7dff7e00fd8b0d89f3ba15a7d88f
- Context: gardener-1 on oros-studio-garden-ce242c49: job 'undraft-minion-town-99-harness-provisioning-20260916' handler exited rc=1
- Capture: inboxes/oros-studio-garden-ce242c49/captures/27ed4914e6ec7dff7e00fd8b0d89f3ba15a7d88f

Inspect via `git -C journal cat-file -p 27ed4914e6ec7dff7e00fd8b0d89f3ba15a7d88f` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/27ed4914e6ec7dff7e00fd8b0d89f3ba15a7d88f`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- handler-nonzero failure at 2026-09-16T23:25:53Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 9b8fa304c775075b7142f408f2c4614d65d6ca4b
- Context: gardener-1 on oros-studio-garden-ce242c49: job 'undraft-minion-town-99-harness-provisioning-20260916' handler exited rc=1
- Capture: inboxes/oros-studio-garden-ce242c49/captures/9b8fa304c775075b7142f408f2c4614d65d6ca4b

Inspect via `git -C journal cat-file -p 9b8fa304c775075b7142f408f2c4614d65d6ca4b` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/9b8fa304c775075b7142f408f2c4614d65d6ca4b`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- handler-nonzero failure at 2026-09-16T23:54:54Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 870d6b6a631f2e9fc3144d760b15ab99d9d0b23b
- Context: gardener-1 on oros-studio-garden-ce242c49: job 'build-thesaurus-botese-jury-seat' handler exited rc=1
- Capture: inboxes/oros-studio-garden-ce242c49/captures/870d6b6a631f2e9fc3144d760b15ab99d9d0b23b

Inspect via `git -C journal cat-file -p 870d6b6a631f2e9fc3144d760b15ab99d9d0b23b` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/870d6b6a631f2e9fc3144d760b15ab99d9d0b23b`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-09-17T00:27:57Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 8e5757a31b246e727aca1fecab261f6cfe3f6ed1
- Context: gardener-1 on oros-studio-garden-ce242c49: job 'weave-ebfb-1100-pin-merge-base-20260916' exit-0-unsatisfying but elapsed near-constant (1839,1465s) over 2 cycles — likely a wedged child, not a working one
- Capture: inboxes/oros-studio-garden-ce242c49/captures/8e5757a31b246e727aca1fecab261f6cfe3f6ed1

Inspect via `git -C journal cat-file -p 8e5757a31b246e727aca1fecab261f6cfe3f6ed1` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/8e5757a31b246e727aca1fecab261f6cfe3f6ed1`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- handler-nonzero failure at 2026-09-17T08:01:52Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: fc559d24803e4c0c46755b347c82288df4db045a
- Context: gardener-1 on oros-studio-garden-ce242c49: job 'endojs-endo-but-for-bots-pr1125-review-b786506c' handler exited rc=1
- Capture: inboxes/oros-studio-garden-ce242c49/captures/fc559d24803e4c0c46755b347c82288df4db045a

Inspect via `git -C journal cat-file -p fc559d24803e4c0c46755b347c82288df4db045a` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/fc559d24803e4c0c46755b347c82288df4db045a`) -- both work off-host after a plain `journal2` fetch.
