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

## lane 0 -- handler-nonzero failure at 2026-09-27T11:27:58Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4b839e4ce57bf021aa3cec5e593c5870e4198417
- Context: gardener-4 on oros-studio-garden-ce242c49: job 'ironhorse-fuzz-89e303d17e33b117-repair' handler exited rc=1
- Capture: inboxes/oros-studio-garden-ce242c49/captures/4b839e4ce57bf021aa3cec5e593c5870e4198417

Inspect via `git -C journal cat-file -p 4b839e4ce57bf021aa3cec5e593c5870e4198417` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/4b839e4ce57bf021aa3cec5e593c5870e4198417`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- handler-nonzero failure at 2026-09-27T13:12:35Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: dab83b32ef16019b07301be32652a91d63698595
- Context: gardener-4 on oros-studio-garden-ce242c49: job 'ironhorse-fuzz-e773681b6d831dc1-repair' handler exited rc=1
- Capture: inboxes/oros-studio-garden-ce242c49/captures/dab83b32ef16019b07301be32652a91d63698595

Inspect via `git -C journal cat-file -p dab83b32ef16019b07301be32652a91d63698595` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/dab83b32ef16019b07301be32652a91d63698595`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- handler-nonzero failure at 2026-09-28T21:56:03Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 9ff584822966fb4b6612369bffca49d18ea67c09
- Context: gardener-3 on oros-studio-garden-ce242c49: job 'kriscendobot-garden-pr81-postdeploy-pty-5119818493-20260928T210602Z' handler exited rc=1
- Capture: inboxes/oros-studio-garden-ce242c49/captures/9ff584822966fb4b6612369bffca49d18ea67c09

Inspect via `git -C journal cat-file -p 9ff584822966fb4b6612369bffca49d18ea67c09` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/9ff584822966fb4b6612369bffca49d18ea67c09`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- handler-nonzero failure at 2026-09-28T22:27:19Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 72a46e9b6543cad5fe520092171f1cb0e5e408e8
- Context: gardener-1 on oros-studio-garden-ce242c49: job 'kriscendobot-garden-pr81-postdeploy-pty-5119818493-20260928T215136Z' handler exited rc=1
- Capture: inboxes/oros-studio-garden-ce242c49/captures/72a46e9b6543cad5fe520092171f1cb0e5e408e8

Inspect via `git -C journal cat-file -p 72a46e9b6543cad5fe520092171f1cb0e5e408e8` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/72a46e9b6543cad5fe520092171f1cb0e5e408e8`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- handler-nonzero failure at 2026-09-28T22:53:40Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 485c88c5d92f495eaf0e24c8a2b4dbec85abba02
- Context: gardener-2 on oros-studio-garden-ce242c49: job 'kriscendobot-garden-pr81-postdeploy-pty-5119818493-20260928T210602Z' handler exited rc=1
- Capture: inboxes/oros-studio-garden-ce242c49/captures/485c88c5d92f495eaf0e24c8a2b4dbec85abba02

Inspect via `git -C journal cat-file -p 485c88c5d92f495eaf0e24c8a2b4dbec85abba02` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/485c88c5d92f495eaf0e24c8a2b4dbec85abba02`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- handler-nonzero failure at 2026-09-28T22:58:15Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ef2ca74223469273406592ac69b720cd4710fa62
- Context: gardener-1 on oros-studio-garden-ce242c49: job 'garden-pr81-postdeploy-pty-20260928T221312Z' handler exited rc=1
- Capture: inboxes/oros-studio-garden-ce242c49/captures/ef2ca74223469273406592ac69b720cd4710fa62

Inspect via `git -C journal cat-file -p ef2ca74223469273406592ac69b720cd4710fa62` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/ef2ca74223469273406592ac69b720cd4710fa62`) -- both work off-host after a plain `journal2` fetch.
