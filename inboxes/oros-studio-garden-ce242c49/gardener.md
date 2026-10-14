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

## lane 0 -- handler-nonzero failure at 2026-09-28T23:26:15Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: c1f952a0259a5e5f17661a0274dcf5cef3738d51
- Context: gardener-2 on oros-studio-garden-ce242c49: job 'kriscendobot-garden-pr81-postdeploy-pty-5119818493-20260928T215136Z' handler exited rc=1
- Capture: inboxes/oros-studio-garden-ce242c49/captures/c1f952a0259a5e5f17661a0274dcf5cef3738d51

Inspect via `git -C journal cat-file -p c1f952a0259a5e5f17661a0274dcf5cef3738d51` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/c1f952a0259a5e5f17661a0274dcf5cef3738d51`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- handler-nonzero failure at 2026-09-29T17:29:06Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: c64041a19ac5a00e48bff40a6ff59b78d0629820
- Context: gardener-2 on oros-studio-garden-ce242c49: job 'activate-ironhorse-ratchet-autopilot-20260929-r4' handler exited rc=1
- Capture: inboxes/oros-studio-garden-ce242c49/captures/c64041a19ac5a00e48bff40a6ff59b78d0629820

Inspect via `git -C journal cat-file -p c64041a19ac5a00e48bff40a6ff59b78d0629820` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/c64041a19ac5a00e48bff40a6ff59b78d0629820`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- handler-nonzero failure at 2026-09-29T17:47:15Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: c3d61191e4df5ba50523987891c11890c5c4984a
- Context: gardener-1 on oros-studio-garden-ce242c49: job 'kriscendobot-garden-pr81-postdeploy-pty-5119818493-20260928T215136Z' handler exited rc=1
- Capture: inboxes/oros-studio-garden-ce242c49/captures/c3d61191e4df5ba50523987891c11890c5c4984a

Inspect via `git -C journal cat-file -p c3d61191e4df5ba50523987891c11890c5c4984a` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/c3d61191e4df5ba50523987891c11890c5c4984a`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- handler-nonzero failure at 2026-09-30T03:06:17Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 78d8bd8813795a33119960de8bb61dfa79e13918
- Context: gardener-3 on oros-studio-garden-ce242c49: job 'claude-on-minion-town-completion-press-20260930-020508' handler exited rc=1
- Capture: inboxes/oros-studio-garden-ce242c49/captures/78d8bd8813795a33119960de8bb61dfa79e13918

Inspect via `git -C journal cat-file -p 78d8bd8813795a33119960de8bb61dfa79e13918` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/78d8bd8813795a33119960de8bb61dfa79e13918`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- handler-nonzero failure at 2026-10-08T20:11:00Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: c6ac67b9fdbb9dce5e3e67cb5b9bf80f10d5dbed
- Context: gardener-1 on oros-studio-garden-ce242c49: job 'design-minion-town-ocap-site-crawler-leak-rotation' handler exited rc=1
- Capture: inboxes/oros-studio-garden-ce242c49/captures/c6ac67b9fdbb9dce5e3e67cb5b9bf80f10d5dbed

Inspect via `git -C journal cat-file -p c6ac67b9fdbb9dce5e3e67cb5b9bf80f10d5dbed` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/c6ac67b9fdbb9dce5e3e67cb5b9bf80f10d5dbed`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- handler-nonzero failure at 2026-10-10T06:25:33Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1ba789e742a98c53224fa62ae6197aaba8c5732d
- Context: gardener-1 on oros-studio-garden-ce242c49: job 'kriscendobot-minion.town-pr166-gauntlet-20261010-panel-3' handler exited rc=1
- Capture: inboxes/oros-studio-garden-ce242c49/captures/1ba789e742a98c53224fa62ae6197aaba8c5732d

Inspect via `git -C journal cat-file -p 1ba789e742a98c53224fa62ae6197aaba8c5732d` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/1ba789e742a98c53224fa62ae6197aaba8c5732d`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- handler-nonzero failure at 2026-10-11T08:55:04Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e7c0a2c287d84772ebf65363d55d3bfd43d048cb
- Context: gardener-1 on oros-studio-garden-ce242c49: job 'claude-on-minion-town-press-20261010-133536' handler exited rc=1
- Capture: inboxes/oros-studio-garden-ce242c49/captures/e7c0a2c287d84772ebf65363d55d3bfd43d048cb

Inspect via `git -C journal cat-file -p e7c0a2c287d84772ebf65363d55d3bfd43d048cb` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/e7c0a2c287d84772ebf65363d55d3bfd43d048cb`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- handler-nonzero failure at 2026-10-11T22:07:00Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: c7e1c3a5e7d45c27910abc4f34ef15c08bbf8826
- Context: gardener-1 on oros-studio-garden-ce242c49: job 'endojs-endo-but-for-bots-pr1439-dependabot' handler exited rc=1
- Capture: inboxes/oros-studio-garden-ce242c49/captures/c7e1c3a5e7d45c27910abc4f34ef15c08bbf8826

Inspect via `git -C journal cat-file -p c7e1c3a5e7d45c27910abc4f34ef15c08bbf8826` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/c7e1c3a5e7d45c27910abc4f34ef15c08bbf8826`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- handler-nonzero failure at 2026-10-11T22:55:53Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ad9e1d4a67627cef33f6186d97ec9dfb9fa4bfc2
- Context: gardener-4 on oros-studio-garden-ce242c49: job 'kriscendobot-minion.town-pr181-gauntlet-fix-3' handler exited rc=1
- Capture: inboxes/oros-studio-garden-ce242c49/captures/ad9e1d4a67627cef33f6186d97ec9dfb9fa4bfc2

Inspect via `git -C journal cat-file -p ad9e1d4a67627cef33f6186d97ec9dfb9fa4bfc2` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/ad9e1d4a67627cef33f6186d97ec9dfb9fa4bfc2`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- handler-nonzero failure at 2026-10-12T00:26:33Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4322b8ca757800bfe82af1708517910212a2c7bb
- Context: gardener-3 on oros-studio-garden-ce242c49: job 'kriscendobot-minion.town-pr174-gauntlet-panel-9' handler exited rc=1
- Capture: inboxes/oros-studio-garden-ce242c49/captures/4322b8ca757800bfe82af1708517910212a2c7bb

Inspect via `git -C journal cat-file -p 4322b8ca757800bfe82af1708517910212a2c7bb` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/4322b8ca757800bfe82af1708517910212a2c7bb`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- handler-nonzero failure at 2026-10-12T02:26:25Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: f4a2e2c0acf2c55f4a9adeae026e3c8d16f929e9
- Context: gardener-1 on oros-studio-garden-ce242c49: job 'kriscendobot-minion.town-pr93-gauntlet-20261010-fix-10' handler exited rc=1
- Capture: inboxes/oros-studio-garden-ce242c49/captures/f4a2e2c0acf2c55f4a9adeae026e3c8d16f929e9

Inspect via `git -C journal cat-file -p f4a2e2c0acf2c55f4a9adeae026e3c8d16f929e9` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/f4a2e2c0acf2c55f4a9adeae026e3c8d16f929e9`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- handler-nonzero failure at 2026-10-12T05:57:44Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 0c851339c05da29fb8ccfbad42e691fb7084b5d8
- Context: gardener-5 on oros-studio-garden-ce242c49: job 'kriscendobot-minion.town-pr182-gauntlet-panel-4' handler exited rc=1
- Capture: inboxes/oros-studio-garden-ce242c49/captures/0c851339c05da29fb8ccfbad42e691fb7084b5d8

Inspect via `git -C journal cat-file -p 0c851339c05da29fb8ccfbad42e691fb7084b5d8` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/0c851339c05da29fb8ccfbad42e691fb7084b5d8`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- handler-nonzero failure at 2026-10-12T10:56:00Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 552472f16220754ce4b1df59971c84c44856f948
- Context: gardener-6 on oros-studio-garden-ce242c49: job 'claude-on-minion-town-press-20261012-093524' handler exited rc=76
- Capture: inboxes/oros-studio-garden-ce242c49/captures/552472f16220754ce4b1df59971c84c44856f948

Inspect via `git -C journal cat-file -p 552472f16220754ce4b1df59971c84c44856f948` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/552472f16220754ce4b1df59971c84c44856f948`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- handler-nonzero failure at 2026-10-12T14:31:51Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 5903e877990f46eb043bbc3817a39d70532cf713
- Context: gardener-5 on oros-studio-garden-ce242c49: job 'kriscendobot-minion.town-pr181-gauntlet-fix-5' handler exited rc=1
- Capture: inboxes/oros-studio-garden-ce242c49/captures/5903e877990f46eb043bbc3817a39d70532cf713

Inspect via `git -C journal cat-file -p 5903e877990f46eb043bbc3817a39d70532cf713` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/5903e877990f46eb043bbc3817a39d70532cf713`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- handler-nonzero failure at 2026-10-13T19:01:17Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 25b0067d36714cbf3974269732266b55138db022
- Context: gardener-5 on oros-studio-garden-ce242c49: job 'claude-on-minion-town-press-20261013-163508' handler exited rc=76
- Capture: inboxes/oros-studio-garden-ce242c49/captures/25b0067d36714cbf3974269732266b55138db022

Inspect via `git -C journal cat-file -p 25b0067d36714cbf3974269732266b55138db022` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/25b0067d36714cbf3974269732266b55138db022`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- handler-nonzero failure at 2026-10-14T00:15:24Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 0fd26f51b2d5235daf9a8d1390dfb60826300f65
- Context: gardener-3 on oros-studio-garden-ce242c49: job 'claude-on-minion-town-press-20261013-193508' handler exited rc=76
- Capture: inboxes/oros-studio-garden-ce242c49/captures/0fd26f51b2d5235daf9a8d1390dfb60826300f65

Inspect via `git -C journal cat-file -p 0fd26f51b2d5235daf9a8d1390dfb60826300f65` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/0fd26f51b2d5235daf9a8d1390dfb60826300f65`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- handler-nonzero failure at 2026-10-14T02:16:03Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 9f85afd37ebebdb0410ca3a4d1961a53046ef879
- Context: gardener-5 on oros-studio-garden-ce242c49: job 'claude-on-minion-town-completion-press-20261013-200507-expanded-window' handler exited rc=76
- Capture: inboxes/oros-studio-garden-ce242c49/captures/9f85afd37ebebdb0410ca3a4d1961a53046ef879

Inspect via `git -C journal cat-file -p 9f85afd37ebebdb0410ca3a4d1961a53046ef879` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/9f85afd37ebebdb0410ca3a4d1961a53046ef879`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- handler-nonzero failure at 2026-10-14T07:07:08Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b80cc6141ab6be3a7874e3d9524fe09a883620aa
- Context: gardener-2 on oros-studio-garden-ce242c49: job 'minion-town-arc-press-20261014-035009' handler exited rc=1
- Capture: inboxes/oros-studio-garden-ce242c49/captures/b80cc6141ab6be3a7874e3d9524fe09a883620aa

Inspect via `git -C journal cat-file -p b80cc6141ab6be3a7874e3d9524fe09a883620aa` (or read
`journal/inboxes/oros-studio-garden-ce242c49/captures/b80cc6141ab6be3a7874e3d9524fe09a883620aa`) -- both work off-host after a plain `journal2` fetch.
