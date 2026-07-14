---
host: endolin-garden2-5bcdff64
role: gardener
last_drained_at: 1970-01-01T00:00:00Z
last_drained_commit:
---

# gardener inbox state on endolin-garden2-5bcdff64

Append-only failure log. Each section is a discrete failure event
appended by a job-board service or worker via
`skills/gardener-inbox-error-reporting/report-error.sh`. The gardener
reads entries on its next dispatch.


## lane 0 -- handler-nonzero failure at 2026-07-07T01:23:38Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: d3846c1987b263f5e2a38cb2682862e82f46c857
- Context: gardener-19 on endolin-garden2-5bcdff64: job 'xs2rust-endor-stage5-coder-decl' handler exited rc=1

Inspect via `git -C journal cat-file -p d3846c1987b263f5e2a38cb2682862e82f46c857`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-07T02:45:16Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 47919798b3b0dbe59454d4297d45ae3e5976e5fa
- Context: gardener-8 on endolin-garden2-5bcdff64: job 'xs2rust-endor-stage5-coder-decl' exit-0-unsatisfying but elapsed near-constant (1266,1266s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 47919798b3b0dbe59454d4297d45ae3e5976e5fa`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-07T06:25:21Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: d9aed1437224ebbf7e88022e21fa40579a0fa97e
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'minion-town-phase3-google-idp' exit-0-unsatisfying but elapsed near-constant (109,109s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p d9aed1437224ebbf7e88022e21fa40579a0fa97e`.

## lane 0 -- handler-nonzero failure at 2026-07-08T06:43:55Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4debb6e629e4d2a90ba540c97de7dfa33beab454
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'design-endo-daemon-cloudflare-storage' handler exited rc=1

Inspect via `git -C journal cat-file -p 4debb6e629e4d2a90ba540c97de7dfa33beab454`.

## lane 0 -- handler-nonzero failure at 2026-07-08T06:52:16Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 049076a7e1f30fe3690d22bca23c6b25e826341c
- Context: gardener-17 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr637-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 049076a7e1f30fe3690d22bca23c6b25e826341c`.

## lane 0 -- handler-nonzero failure at 2026-07-08T07:05:49Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 049076a7e1f30fe3690d22bca23c6b25e826341c
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'daily-progress-summary-20260708-070528' handler exited rc=1

Inspect via `git -C journal cat-file -p 049076a7e1f30fe3690d22bca23c6b25e826341c`.

## lane 0 -- handler-nonzero failure at 2026-07-08T07:53:31Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: c89d71388c9f1a5f55c9e31aa9cfe2ca9dd952f5
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr637-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p c89d71388c9f1a5f55c9e31aa9cfe2ca9dd952f5`.

## lane 0 -- handler-nonzero failure at 2026-07-08T09:03:33Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 2ddd29ac9248a8519099229f9d944d7012339bb4
- Context: gardener-10 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr637-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 2ddd29ac9248a8519099229f9d944d7012339bb4`.

## lane 0 -- handler-nonzero failure at 2026-07-08T10:13:16Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 7edcac1e234bdb047b4b15d33889e9c72efdc248
- Context: gardener-13 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr637-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 7edcac1e234bdb047b4b15d33889e9c72efdc248`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-10T02:46:58Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 99a1134b9c84b18f6e4dbecde1b431efda3d6036
- Context: gardener-15 on endolin-garden2-5bcdff64: job 'gauntlet-endo-but-for-bots-pr653-mount-glob' exit-0-unsatisfying but elapsed near-constant (210,210s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 99a1134b9c84b18f6e4dbecde1b431efda3d6036`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-10T06:40:13Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: e8c013656a8cde82fc3b0c7e224b441327713102
- Context: gardener-10 on endolin-garden2-5bcdff64: job 'gauntlet-endo-but-for-bots-pr661-agent-tools-http-client' exit-0-unsatisfying but elapsed near-constant (402,402s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p e8c013656a8cde82fc3b0c7e224b441327713102`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-10T17:36:46Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: ca39e5dbb97ef4c04bb059399502cc6189a06959
- Context: gardener-15 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr592-01edab2b' exit-0-unsatisfying but elapsed near-constant (187,187s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p ca39e5dbb97ef4c04bb059399502cc6189a06959`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-10T22:04:12Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 517cff4a5e541f1a99fc7c31f14b97a3001f8801
- Context: gardener-18 on endolin-garden2-5bcdff64: job 'kriscendobot-agoric-sdk-pr8-gauntlet' exit-0-unsatisfying but elapsed near-constant (40,40s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 517cff4a5e541f1a99fc7c31f14b97a3001f8801`.

## lane 0 -- handler-nonzero failure at 2026-07-10T23:13:17Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 69384f6d3d5c3f64b4ef18c5e8f782040328adf2
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr678-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 69384f6d3d5c3f64b4ef18c5e8f782040328adf2`.

## lane 0 -- handler-nonzero failure at 2026-07-10T23:23:15Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e55c790f40b16e5cb7cf25885fde2ce13f120eac
- Context: gardener-18 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr677-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p e55c790f40b16e5cb7cf25885fde2ce13f120eac`.

## lane 0 -- handler-nonzero failure at 2026-07-10T23:35:31Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: edc771c033a18119bf8a2fa6198e2ba61616b670
- Context: gardener-18 on endolin-garden2-5bcdff64: job 'scholar-library-cycle-20260710-233505' handler exited rc=1

Inspect via `git -C journal cat-file -p edc771c033a18119bf8a2fa6198e2ba61616b670`.

## lane 0 -- handler-nonzero failure at 2026-07-10T23:35:58Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 107af26d7445fa53b4f512d0fd639bb673100d56
- Context: gardener-11 on endolin-garden2-5bcdff64: job 'xst-validation-orchestrator-20260710-233505' handler exited rc=1

Inspect via `git -C journal cat-file -p 107af26d7445fa53b4f512d0fd639bb673100d56`.

## lane 0 -- handler-nonzero failure at 2026-07-10T23:40:34Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: edc771c033a18119bf8a2fa6198e2ba61616b670
- Context: gardener-11 on endolin-garden2-5bcdff64: job 'deadmail-issue-comment-4940396976' handler exited rc=1

Inspect via `git -C journal cat-file -p edc771c033a18119bf8a2fa6198e2ba61616b670`.

## lane 0 -- handler-nonzero failure at 2026-07-11T00:23:19Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ceb78b7c5a955c3e08b729de5287bcc7017ea4f1
- Context: gardener-18 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr678-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p ceb78b7c5a955c3e08b729de5287bcc7017ea4f1`.

## lane 0 -- handler-nonzero failure at 2026-07-11T04:46:15Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: a13135ac4d1fb8f9574a792c9b8d96d14b2b2bfd
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr660-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p a13135ac4d1fb8f9574a792c9b8d96d14b2b2bfd`.

## lane 0 -- handler-nonzero failure at 2026-07-11T04:51:07Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: a13135ac4d1fb8f9574a792c9b8d96d14b2b2bfd
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'agoric-sdk-pr9-drive-20260711-045005' handler exited rc=1

Inspect via `git -C journal cat-file -p a13135ac4d1fb8f9574a792c9b8d96d14b2b2bfd`.

## lane 0 -- handler-nonzero failure at 2026-07-11T05:01:53Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: fb05ca4866c05f4bbd557dcc260935b86b7e206a
- Context: gardener-16 on endolin-garden2-5bcdff64: job 'xs2rust-endor-stage5-fix6-verify' handler exited rc=1

Inspect via `git -C journal cat-file -p fb05ca4866c05f4bbd557dcc260935b86b7e206a`.

## lane 0 -- handler-nonzero failure at 2026-07-11T05:03:24Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4c692edaac06b010b8862e895228acf8f4cc8f14
- Context: gardener-8 on endolin-garden2-5bcdff64: job 'ocapn-daemon-minion-deploy-demo' handler exited rc=1

Inspect via `git -C journal cat-file -p 4c692edaac06b010b8862e895228acf8f4cc8f14`.

## lane 0 -- handler-nonzero failure at 2026-07-11T05:21:10Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: abffc20ca7aeb17743dec53a7c47368ebac21119
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xst-validation-orchestrator-20260711-052002' handler exited rc=1

Inspect via `git -C journal cat-file -p abffc20ca7aeb17743dec53a7c47368ebac21119`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-11T12:56:18Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: dfefbbff58455ff09c63b8059bfe6596a975557b
- Context: gardener-10 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr609-shepherd' exit-0-unsatisfying but elapsed near-constant (154,154s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p dfefbbff58455ff09c63b8059bfe6596a975557b`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-11T18:34:06Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 2424a7bd0c846c08bc8621acd761338440817997
- Context: gardener-15 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr693-shepherd' exit-0-unsatisfying but elapsed near-constant (37,37s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 2424a7bd0c846c08bc8621acd761338440817997`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-11T21:36:47Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: ecbc9c9ec182799472dcd2e4e4f55576f4556295
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'gauntlet-endo-but-for-bots-pr694-daemon-docker-self-hosting' exit-0-unsatisfying but elapsed near-constant (186,186s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p ecbc9c9ec182799472dcd2e4e4f55576f4556295`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-12T03:05:07Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 09853562bd00e5a58248136e3748c7cf7053ea2f
- Context: gardener-7 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr702-shepherd' exit-0-unsatisfying but elapsed near-constant (102,102s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 09853562bd00e5a58248136e3748c7cf7053ea2f`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-12T05:49:51Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 1a217fcfdba865bf680bc9f94a298a4fdba3c1eb
- Context: gardener-5 on endolin-garden2-5bcdff64: job 'gauntlet-endo-but-for-bots-pull-request-643-exo-git-platform-filesystem-path-types' exit-0-unsatisfying but elapsed near-constant (370,370s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 1a217fcfdba865bf680bc9f94a298a4fdba3c1eb`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-12T19:14:11Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 72611a6dc9f7f13224d5156f415542f59ae51845
- Context: gardener-12 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr694-docker-selfhost-gauntlet' exit-0-unsatisfying but elapsed near-constant (35,35s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 72611a6dc9f7f13224d5156f415542f59ae51845`.

## lane 0 -- handler-nonzero failure at 2026-07-13T06:34:46Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b8b8e9b737c7cb87c14e5bad99ece430ba4c1fea
- Context: gardener-20 on endolin-garden2-5bcdff64: job 'harden-comment-watcher-review-comment-drops' handler exited rc=1

Inspect via `git -C journal cat-file -p b8b8e9b737c7cb87c14e5bad99ece430ba4c1fea`.

## lane 0 -- handler-nonzero failure at 2026-07-13T06:43:14Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 2ee828f782a18503246bf19d9752c95fecf6f24c
- Context: gardener-10 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr133-review-d1b65e59' handler exited rc=1

Inspect via `git -C journal cat-file -p 2ee828f782a18503246bf19d9752c95fecf6f24c`.

## lane 0 -- handler-nonzero failure at 2026-07-13T07:05:30Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'daily-progress-summary-20260713-070501' handler exited rc=1

Inspect via `git -C journal cat-file -p 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20`.

## lane 0 -- handler-nonzero failure at 2026-07-13T07:23:36Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20
- Context: gardener-8 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr169-review-1aae27be' handler exited rc=1

Inspect via `git -C journal cat-file -p 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20`.

## lane 0 -- handler-nonzero failure at 2026-07-13T07:28:10Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20
- Context: gardener-19 on endolin-garden2-5bcdff64: job 'kriscendobot-minion.town-pr4-review-49e01038' handler exited rc=1

Inspect via `git -C journal cat-file -p 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20`.

## lane 0 -- handler-nonzero failure at 2026-07-14T04:06:12Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20
- Context: gardener-5 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr671-review-3fa7398f' handler exited rc=1

Inspect via `git -C journal cat-file -p 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20`.

## lane 0 -- handler-nonzero failure at 2026-07-14T04:58:02Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr721-review-56349e18' handler exited rc=1

Inspect via `git -C journal cat-file -p 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20`.
