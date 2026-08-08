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

## lane 0 -- handler-nonzero failure at 2026-07-14T06:13:21Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20
- Context: gardener-4 on endolin-garden2-5bcdff64: job 'kriscendobot-agoric-sdk-pr16-dec1f704' handler exited rc=1

Inspect via `git -C journal cat-file -p 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20`.

## lane 0 -- handler-nonzero failure at 2026-07-14T06:50:01Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20
- Context: gardener-14 on endolin-garden2-5bcdff64: job 'design-ai-sdk-garden-integration' handler exited rc=1

Inspect via `git -C journal cat-file -p 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20`.

## lane 0 -- handler-nonzero failure at 2026-07-14T08:20:07Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr671-fix-registry-power-injection' handler exited rc=1

Inspect via `git -C journal cat-file -p 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20`.

## lane 0 -- handler-nonzero failure at 2026-07-14T08:25:08Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20
- Context: gardener-7 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr723-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20`.

## lane 0 -- handler-nonzero failure at 2026-07-14T08:25:43Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr682-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20`.

## lane 0 -- handler-nonzero failure at 2026-07-14T08:26:14Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20
- Context: gardener-3 on endolin-garden2-5bcdff64: job 'issue-kriskowal-garden-43' handler exited rc=1

Inspect via `git -C journal cat-file -p 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20`.

## lane 0 -- handler-nonzero failure at 2026-07-14T08:31:42Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: c20e2295749088ad2605c509fff578b5c6e9957c
- Context: gardener-15 on endolin-garden2-5bcdff64: job 'model-routing-journal-state-hermit-qwen' handler exited rc=1

Inspect via `git -C journal cat-file -p c20e2295749088ad2605c509fff578b5c6e9957c`.

## lane 0 -- handler-nonzero failure at 2026-07-14T09:03:27Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 7bdd6a1faece268c073beb4f6015a922b97b9d1c
- Context: gardener-18 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr721-review-56349e18' handler exited rc=1

Inspect via `git -C journal cat-file -p 7bdd6a1faece268c073beb4f6015a922b97b9d1c`.

## lane 0 -- handler-nonzero failure at 2026-07-14T10:53:17Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b13a12733921c9c380456e6f7db6b30852409df9
- Context: gardener-12 on endolin-garden2-5bcdff64: job 'design-ai-sdk-garden-integration' handler exited rc=1

Inspect via `git -C journal cat-file -p b13a12733921c9c380456e6f7db6b30852409df9`.

## lane 0 -- handler-nonzero failure at 2026-07-14T12:33:15Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 59960935acc6199001bf515944a2e3b958da4fef
- Context: gardener-18 on endolin-garden2-5bcdff64: job 'model-routing-journal-state-hermit-qwen' handler exited rc=1

Inspect via `git -C journal cat-file -p 59960935acc6199001bf515944a2e3b958da4fef`.

## lane 0 -- handler-nonzero failure at 2026-07-14T12:35:02Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20
- Context: gardener-10 on endolin-garden2-5bcdff64: job 'design-endor-registry-transport' handler exited rc=1

Inspect via `git -C journal cat-file -p 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20`.

## lane 0 -- handler-nonzero failure at 2026-07-14T15:03:16Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 929b9e2992091c180750b2218a783f96f42bc0cd
- Context: gardener-14 on endolin-garden2-5bcdff64: job 'design-ai-sdk-garden-integration' handler exited rc=1

Inspect via `git -C journal cat-file -p 929b9e2992091c180750b2218a783f96f42bc0cd`.

## lane 0 -- handler-nonzero failure at 2026-07-14T16:11:34Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 468417923d986367da5cb405d4459864204db0b8
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'test-hermit-local-inference-garden2' handler exited rc=1

Inspect via `git -C journal cat-file -p 468417923d986367da5cb405d4459864204db0b8`.

## lane 0 -- handler-nonzero failure at 2026-07-14T16:40:37Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20
- Context: gardener-8 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr730-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20`.

## lane 0 -- handler-nonzero failure at 2026-07-14T20:13:20Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 640e4a775b2660c18e36271cea1f48cc5310e69c
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'test-hermit-local-inference-garden2' handler exited rc=1

Inspect via `git -C journal cat-file -p 640e4a775b2660c18e36271cea1f48cc5310e69c`.

## lane 0 -- handler-nonzero failure at 2026-07-14T21:46:08Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20
- Context: gardener-10 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr521-e62f93ef' handler exited rc=1

Inspect via `git -C journal cat-file -p 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20`.

## lane 0 -- handler-nonzero failure at 2026-07-15T01:53:36Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: d255294dd8e48569901f897616d247bb00605f2d
- Context: gardener-8 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr521-e62f93ef' handler exited rc=1

Inspect via `git -C journal cat-file -p d255294dd8e48569901f897616d247bb00605f2d`.

## lane 0 -- handler-nonzero failure at 2026-07-15T04:31:31Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20
- Context: gardener-5 on endolin-garden2-5bcdff64: job 'kriskowal-garden-pr19-review-af733b76' handler exited rc=1

Inspect via `git -C journal cat-file -p 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20`.

## lane 0 -- handler-nonzero failure at 2026-07-15T05:25:38Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 757793df44097c9e7d8414a4ccd0766823a98341
- Context: gardener-9 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-design-endo-store-write-file-pr658-c4977137707' handler exited rc=1

Inspect via `git -C journal cat-file -p 757793df44097c9e7d8414a4ccd0766823a98341`.

## lane 0 -- handler-nonzero failure at 2026-07-15T05:58:51Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr714-review-b80b82c7' handler exited rc=1

Inspect via `git -C journal cat-file -p 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20`.

## lane 0 -- handler-nonzero failure at 2026-07-15T06:08:00Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20
- Context: gardener-3 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr259-b517a6e0' handler exited rc=1

Inspect via `git -C journal cat-file -p 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20`.

## lane 0 -- handler-nonzero failure at 2026-07-15T09:33:14Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 5867f7dc6e6356873197a08ebc4358b0e74f2cbf
- Context: gardener-10 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-design-endo-store-write-file-pr658-c4977137707' handler exited rc=1

Inspect via `git -C journal cat-file -p 5867f7dc6e6356873197a08ebc4358b0e74f2cbf`.

## lane 0 -- handler-nonzero failure at 2026-07-15T13:53:37Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr598-review-ac90d9cd' handler exited rc=1

Inspect via `git -C journal cat-file -p 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20`.

## lane 0 -- handler-nonzero failure at 2026-07-15T14:40:23Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20
- Context: gardener-5 on endolin-garden2-5bcdff64: job 'deadmail-issue-comment-4981804044' handler exited rc=1

Inspect via `git -C journal cat-file -p 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20`.

## lane 0 -- handler-nonzero failure at 2026-07-15T19:49:35Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr661-review-e6e9d5e5-retro' handler exited rc=1

Inspect via `git -C journal cat-file -p 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20`.

## lane 0 -- handler-nonzero failure at 2026-07-16T00:09:46Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20
- Context: gardener-3 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr667-review-20347bb0-retro' handler exited rc=1

Inspect via `git -C journal cat-file -p 89b0cd8c50f73436609a16e8dd0d481fbb0cdb20`.

## lane 0 -- handler-nonzero failure at 2026-07-17T00:19:51Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ce32f784b4c1eec5e72a5043f3bd0a00da2878cf
- Context: gardener-9 on endolin-garden2-5bcdff64: job 'scholar-ingest-financial-forecasting-corpus-8' handler exited rc=1

Inspect via `git -C journal cat-file -p ce32f784b4c1eec5e72a5043f3bd0a00da2878cf`.

## lane 0 -- handler-nonzero failure at 2026-07-17T00:24:08Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 9838b25af03d01e1ceb579bb06c4a81080a99bc3
- Context: gardener-7 on endolin-garden2-5bcdff64: job 'ocapn-noise-press-20260717-000503' handler exited rc=1

Inspect via `git -C journal cat-file -p 9838b25af03d01e1ceb579bb06c4a81080a99bc3`.

## lane 0 -- handler-nonzero failure at 2026-07-17T00:32:40Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ce32f784b4c1eec5e72a5043f3bd0a00da2878cf
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr765-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p ce32f784b4c1eec5e72a5043f3bd0a00da2878cf`.

## lane 0 -- handler-nonzero failure at 2026-07-17T00:33:32Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 15ca5d3419217aec9ebb2f0e491ca08860427456
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'endo-vfs-parity-press-20260717-000503' handler exited rc=1

Inspect via `git -C journal cat-file -p 15ca5d3419217aec9ebb2f0e491ca08860427456`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-17T03:54:25Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: c4ad1ca99d638483ff2b6ced8cff725cdfed845e
- Context: gardener-8 on endolin-garden2-5bcdff64: job 'migrate-endo-but-for-bots-master-to-npm' exit-0-unsatisfying but elapsed near-constant (56,56s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p c4ad1ca99d638483ff2b6ced8cff725cdfed845e`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-17T06:48:37Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: cabf31264ca709af60d8b36ed4f8a2deac5abc49
- Context: gardener-5 on endolin-garden2-5bcdff64: job 'endo-git-integration-press-20260717-060503' exit-0-unsatisfying but elapsed near-constant (310,310s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p cabf31264ca709af60d8b36ed4f8a2deac5abc49`.

## lane 0 -- handler-nonzero failure at 2026-07-17T10:23:51Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 24aea360ff2034ed242bee8b071a12729bdf63ec
- Context: gardener-5 on endolin-garden2-5bcdff64: job 'scholar-package-json-package-managers' handler exited rc=1

Inspect via `git -C journal cat-file -p 24aea360ff2034ed242bee8b071a12729bdf63ec`.

## lane 0 -- handler-nonzero failure at 2026-07-17T10:33:18Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 67dd02a117aa7fe899d7a6f27ec4f5a5cb614567
- Context: gardener-8 on endolin-garden2-5bcdff64: job 'endo-byte-array-press-20260717-060503' handler exited rc=1

Inspect via `git -C journal cat-file -p 67dd02a117aa7fe899d7a6f27ec4f5a5cb614567`.

## lane 0 -- handler-nonzero failure at 2026-07-17T18:21:32Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e46b7ea246006e6f18caeee59a791e074b4430f4
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'ocapn-noise-press-20260717-182002' handler exited rc=1

Inspect via `git -C journal cat-file -p e46b7ea246006e6f18caeee59a791e074b4430f4`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-19T01:04:14Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 7127bc766dfe1d6289e3aceb68e7d09004d7c497
- Context: gardener-9 on endolin-garden2-5bcdff64: job 'xs2rust-endor-stage10e-remeasure' exit-0-unsatisfying but elapsed near-constant (36,36s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 7127bc766dfe1d6289e3aceb68e7d09004d7c497`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-19T07:13:56Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 3afbec2de036793e7bcaa420bc7e10dea5047244
- Context: gardener-8 on endolin-garden2-5bcdff64: job 'xs2rust-endor-stage10f-remeasure' exit-0-unsatisfying but elapsed near-constant (27,27s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 3afbec2de036793e7bcaa420bc7e10dea5047244`.

## lane 0 -- handler-nonzero failure at 2026-07-20T02:29:05Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ab56a348f02de9bb869bcc033c8ed0ec718effd6
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'self-heal-fix-garden-repo-watcher-corrupt-journal-clone-refs' handler exited rc=1

Inspect via `git -C journal cat-file -p ab56a348f02de9bb869bcc033c8ed0ec718effd6`.

## lane 0 -- handler-nonzero failure at 2026-07-20T03:22:44Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: d8017eec336350bc92cd2d20412fa3b93e8765b9
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr160-fixer' handler exited rc=1

Inspect via `git -C journal cat-file -p d8017eec336350bc92cd2d20412fa3b93e8765b9`.

## lane 0 -- handler-nonzero failure at 2026-07-20T06:33:57Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 65d197f2c00bec91369aa06f618a8f2101103c33
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'esheets-supervisor-20260720-022510' handler exited rc=1

Inspect via `git -C journal cat-file -p 65d197f2c00bec91369aa06f618a8f2101103c33`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-21T13:15:50Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 83d18a7c1cbac4308eab62e4aa05ba80b8670ba1
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260721-122001' exit-0-unsatisfying but elapsed near-constant (744,744s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 83d18a7c1cbac4308eab62e4aa05ba80b8670ba1`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-21T22:13:57Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 6ccf9d9d799300ab63ab9a55625f6ab1a8a33b1f
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260721-212001' exit-0-unsatisfying but elapsed near-constant (1226,1226s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 6ccf9d9d799300ab63ab9a55625f6ab1a8a33b1f`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-22T05:10:12Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 39f71ccc8150a5c79c5250961a7eaca9e6d47a01
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260722-033502' exit-0-unsatisfying but elapsed near-constant (1600,1600s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 39f71ccc8150a5c79c5250961a7eaca9e6d47a01`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-22T06:38:27Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 8af243f7aa46920d6c706f2c0dd95a701a20f859
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260722-045001' exit-0-unsatisfying but elapsed near-constant (2067,2067s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 8af243f7aa46920d6c706f2c0dd95a701a20f859`.

## lane 0 -- handler-nonzero failure at 2026-07-22T07:43:27Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 60b37a043e1871316a4836966c4c731c02bf7423
- Context: gardener-3 on endolin-garden2-5bcdff64: job 'minion-town-pr13-75344d2-build-mcp-daemon-guest-tools' handler exited rc=1

Inspect via `git -C journal cat-file -p 60b37a043e1871316a4836966c4c731c02bf7423`.

## lane 0 -- handler-nonzero failure at 2026-07-22T16:19:24Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 77e59dff5cd6e0d4a140644cb3862a9547d7c32c
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-master-ci-fix' handler exited rc=1

Inspect via `git -C journal cat-file -p 77e59dff5cd6e0d4a140644cb3862a9547d7c32c`.

## lane 0 -- handler-nonzero failure at 2026-07-22T16:29:03Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 77e59dff5cd6e0d4a140644cb3862a9547d7c32c
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr809-review-e892a99c' handler exited rc=1

Inspect via `git -C journal cat-file -p 77e59dff5cd6e0d4a140644cb3862a9547d7c32c`.

## lane 0 -- handler-nonzero failure at 2026-07-22T16:43:44Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 77e59dff5cd6e0d4a140644cb3862a9547d7c32c
- Context: gardener-7 on endolin-garden2-5bcdff64: job 'minion-town-mcp-b2-first-guest-tools-gauntlet' handler exited rc=1

Inspect via `git -C journal cat-file -p 77e59dff5cd6e0d4a140644cb3862a9547d7c32c`.

## lane 0 -- handler-nonzero failure at 2026-07-22T18:02:42Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 77e59dff5cd6e0d4a140644cb3862a9547d7c32c
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr826-conduct' handler exited rc=1

Inspect via `git -C journal cat-file -p 77e59dff5cd6e0d4a140644cb3862a9547d7c32c`.

## lane 0 -- handler-nonzero failure at 2026-07-22T18:03:23Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: d89cccc5c35484d082e6c4cb2f2d9b43258cfab1
- Context: gardener-5 on endolin-garden2-5bcdff64: job 'minion-town-mcp-b4-full-facet-surface' handler exited rc=1

Inspect via `git -C journal cat-file -p d89cccc5c35484d082e6c4cb2f2d9b43258cfab1`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-22T22:34:36Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 1aff79425024e267119cf14dd4df4e8497a8760a
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr826-build' exit-0-unsatisfying but elapsed near-constant (52,52s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 1aff79425024e267119cf14dd4df4e8497a8760a`.

## lane 0 -- handler-nonzero failure at 2026-07-23T19:26:57Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 0bbf2541554cd1c144877679f861e00c9405ade0
- Context: gardener-3 on endolin-garden2-5bcdff64: job 'endo-byte-array-press-20260723-100531' handler exited rc=1

Inspect via `git -C journal cat-file -p 0bbf2541554cd1c144877679f861e00c9405ade0`.

## lane 0 -- handler-nonzero failure at 2026-07-23T19:27:38Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b7553ec60b9f6abf4b0d1d322ff177e2aa602f5b
- Context: gardener-13 on endolin-garden2-5bcdff64: job 'endo-byte-array-press-20260722-095006' handler exited rc=1

Inspect via `git -C journal cat-file -p b7553ec60b9f6abf4b0d1d322ff177e2aa602f5b`.

## lane 0 -- handler-nonzero failure at 2026-07-23T19:28:39Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 105334ea705ece7b093719f3bb8b204a9bea68e6
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'endo-git-integration-press-20260723-040502' handler exited rc=1

Inspect via `git -C journal cat-file -p 105334ea705ece7b093719f3bb8b204a9bea68e6`.

## lane 0 -- handler-nonzero failure at 2026-07-23T19:30:14Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: f8dae79cf1113c5b58bb17414c81f12b824a59b0
- Context: gardener-9 on endolin-garden2-5bcdff64: job 'endo-byte-array-press-20260723-040502' handler exited rc=1

Inspect via `git -C journal cat-file -p f8dae79cf1113c5b58bb17414c81f12b824a59b0`.

## lane 0 -- handler-nonzero failure at 2026-07-23T19:30:48Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e4206af5d95fc97bcab69d2893c688ed295e67fe
- Context: gardener-16 on endolin-garden2-5bcdff64: job 'endo-byte-array-press-20260722-220501' handler exited rc=1

Inspect via `git -C journal cat-file -p e4206af5d95fc97bcab69d2893c688ed295e67fe`.

## lane 0 -- handler-nonzero failure at 2026-07-23T19:33:25Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4ac30a0c0d708444fdfef49f5e26d1d04b161066
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'endo-master-fb9cef4-ci-build-gauntlet' handler exited rc=1

Inspect via `git -C journal cat-file -p 4ac30a0c0d708444fdfef49f5e26d1d04b161066`.

## lane 0 -- handler-nonzero failure at 2026-07-23T19:34:24Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 41b947c3b0212188b479c8383dd298eafefe705f
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'kimi-k3-canary-20260723-c' handler exited rc=1

Inspect via `git -C journal cat-file -p 41b947c3b0212188b479c8383dd298eafefe705f`.

## lane 0 -- handler-nonzero failure at 2026-07-23T19:38:38Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 84369996bdddf21a989f753a9ac05df6c220b19d
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'kimi-k3-canary-20260723-d' handler exited rc=1

Inspect via `git -C journal cat-file -p 84369996bdddf21a989f753a9ac05df6c220b19d`.

## lane 0 -- handler-nonzero failure at 2026-07-23T20:10:23Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 7ce56e8cc2f44c9501838f7916555e5ae0809328
- Context: gardener-10 on endolin-garden2-5bcdff64: job 'kimi-k3-harness-implement-20260723' handler exited rc=1

Inspect via `git -C journal cat-file -p 7ce56e8cc2f44c9501838f7916555e5ae0809328`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-23T21:29:14Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 0461da076b0ea0e24c72686fcf651805cc361470
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'drive-mystic-rollout-20260723' exit-0-unsatisfying but elapsed near-constant (344,344s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 0461da076b0ea0e24c72686fcf651805cc361470`.

## lane 0 -- handler-nonzero failure at 2026-07-24T00:45:03Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 8579a5c6ed5a9a382a64d79ac16ef10f4aafe603
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'endo-vfs-parity-press-20260723-162019' handler exited rc=1

Inspect via `git -C journal cat-file -p 8579a5c6ed5a9a382a64d79ac16ef10f4aafe603`.

## lane 0 -- handler-nonzero failure at 2026-07-24T00:45:41Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 8fe4f5e4a4619b7230aca650c4f2f7b047dd8317
- Context: gardener-5 on endolin-garden2-5bcdff64: job 'ocapn-noise-press-20260723-162019' handler exited rc=1

Inspect via `git -C journal cat-file -p 8fe4f5e4a4619b7230aca650c4f2f7b047dd8317`.

## lane 0 -- handler-nonzero failure at 2026-07-24T01:25:19Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 789a04d64bdd36f6270c7e430d6a6bfd2d8ae4aa
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'kimi-k3-canary-20260723-d' handler exited rc=1

Inspect via `git -C journal cat-file -p 789a04d64bdd36f6270c7e430d6a6bfd2d8ae4aa`.

## lane 0 -- handler-nonzero failure at 2026-07-24T01:25:43Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ce52e643d915b0df38d5ddf6b4328eacff9e0fd4
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'kimi-k3-canary-20260723-c' handler exited rc=1

Inspect via `git -C journal cat-file -p ce52e643d915b0df38d5ddf6b4328eacff9e0fd4`.

## lane 0 -- handler-nonzero failure at 2026-07-24T03:20:31Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: eb53fc58b36e330ef69f21e6b39a6cf84f089858
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'arc-status-daily-20260724-032002' handler exited rc=1

Inspect via `git -C journal cat-file -p eb53fc58b36e330ef69f21e6b39a6cf84f089858`.

## lane 0 -- handler-nonzero failure at 2026-07-24T04:35:46Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 65f9874d9fc648c1194d6cf230a311b370da9cf0
- Context: gardener-8 on endolin-garden2-5bcdff64: job 'endo-byte-array-press-20260724-043515' handler exited rc=1

Inspect via `git -C journal cat-file -p 65f9874d9fc648c1194d6cf230a311b370da9cf0`.

## lane 0 -- handler-nonzero failure at 2026-07-24T04:36:35Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: bc9dbd01601c942714d282f97fc869d80f8bba8f
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'endo-vfs-parity-press-20260724-043515' handler exited rc=1

Inspect via `git -C journal cat-file -p bc9dbd01601c942714d282f97fc869d80f8bba8f`.

## lane 0 -- handler-nonzero failure at 2026-07-24T04:43:21Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 3fd42cb240605416b49c9e65dd3f06077afbd935
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endo-git-integration-press-20260724-043515' handler exited rc=1

Inspect via `git -C journal cat-file -p 3fd42cb240605416b49c9e65dd3f06077afbd935`.

## lane 0 -- handler-nonzero failure at 2026-07-24T04:53:29Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1e5739d58b9ad371b49aac28212306ef7fefcb2a
- Context: gardener-14 on endolin-garden2-5bcdff64: job 'endo-npm-cas-registry-press-20260723-162019' handler exited rc=1

Inspect via `git -C journal cat-file -p 1e5739d58b9ad371b49aac28212306ef7fefcb2a`.

## lane 0 -- handler-nonzero failure at 2026-07-24T04:53:55Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: d9aa62522d21f4230dc04841a9fe89ca6359c1bc
- Context: gardener-15 on endolin-garden2-5bcdff64: job 'endo-sturdyref-press-20260723-162019' handler exited rc=1

Inspect via `git -C journal cat-file -p d9aa62522d21f4230dc04841a9fe89ca6359c1bc`.

## lane 0 -- handler-nonzero failure at 2026-07-24T04:54:26Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 5650fc626957d462bd73587ab1ecd83864fd99d4
- Context: gardener-13 on endolin-garden2-5bcdff64: job 'ocapn-noise-press-20260723-223502' handler exited rc=1

Inspect via `git -C journal cat-file -p 5650fc626957d462bd73587ab1ecd83864fd99d4`.

## lane 0 -- handler-nonzero failure at 2026-07-24T07:23:20Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 3550840e66f4f592081bb323e4ba0882d738cfc3
- Context: gardener-12 on endolin-garden2-5bcdff64: job 'arc-status-daily-20260724-032002' handler exited rc=1

Inspect via `git -C journal cat-file -p 3550840e66f4f592081bb323e4ba0882d738cfc3`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-24T07:34:56Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: b3abc79892084b33444e85f0594f4f8110ceefc1
- Context: gardener-3 on endolin-garden2-5bcdff64: job 'garden-fix-mystic-canary-runtime-20260724' exit-0-unsatisfying but elapsed near-constant (89,89s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p b3abc79892084b33444e85f0594f4f8110ceefc1`.

## lane 0 -- handler-nonzero failure at 2026-07-24T08:43:18Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 64b1f178b85cd65d9862a4a77109d20dde9ce898
- Context: gardener-5 on endolin-garden2-5bcdff64: job 'ocapn-noise-press-20260724-043515' handler exited rc=1

Inspect via `git -C journal cat-file -p 64b1f178b85cd65d9862a4a77109d20dde9ce898`.

## lane 0 -- handler-nonzero failure at 2026-07-24T08:43:35Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 8808ba6a06816f7620036c7a8db2afd860e5f4f8
- Context: gardener-14 on endolin-garden2-5bcdff64: job 'endo-sturdyref-press-20260724-043515' handler exited rc=1

Inspect via `git -C journal cat-file -p 8808ba6a06816f7620036c7a8db2afd860e5f4f8`.

## lane 0 -- handler-nonzero failure at 2026-07-24T08:53:15Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1f549b3e16b8443320a213cd2e31df498618f530
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'endo-git-integration-press-20260724-043515' handler exited rc=1

Inspect via `git -C journal cat-file -p 1f549b3e16b8443320a213cd2e31df498618f530`.

## lane 0 -- handler-nonzero failure at 2026-07-24T09:03:16Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: cd843ae7af6495fd9c30d7f3fb33a8afc92f5b45
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'endo-npm-cas-registry-press-20260723-223502' handler exited rc=1

Inspect via `git -C journal cat-file -p cd843ae7af6495fd9c30d7f3fb33a8afc92f5b45`.

## lane 0 -- handler-nonzero failure at 2026-07-24T09:03:33Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: a81f133d30bc8ecc193ee1b77200ac92e8d4a608
- Context: gardener-13 on endolin-garden2-5bcdff64: job 'endo-git-integration-press-20260723-162019' handler exited rc=1

Inspect via `git -C journal cat-file -p a81f133d30bc8ecc193ee1b77200ac92e8d4a608`.

## lane 0 -- handler-nonzero failure at 2026-07-24T09:03:47Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: c0cee60b2c05963f0f94d3c3515f1ea862cdc93e
- Context: gardener-18 on endolin-garden2-5bcdff64: job 'endo-byte-array-press-20260723-162019' handler exited rc=1

Inspect via `git -C journal cat-file -p c0cee60b2c05963f0f94d3c3515f1ea862cdc93e`.

## lane 0 -- handler-nonzero failure at 2026-07-24T09:04:00Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1831358199862a2ccef2381cf60e5e5708f3b43b
- Context: gardener-12 on endolin-garden2-5bcdff64: job 'endo-byte-array-press-20260723-223502' handler exited rc=1

Inspect via `git -C journal cat-file -p 1831358199862a2ccef2381cf60e5e5708f3b43b`.

## lane 0 -- handler-nonzero failure at 2026-07-24T10:51:05Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 28aa2b5fe07f555a1c0a1405f5d781c64a849ac9
- Context: gardener-8 on endolin-garden2-5bcdff64: job 'endo-sturdyref-press-20260724-105003' handler exited rc=1

Inspect via `git -C journal cat-file -p 28aa2b5fe07f555a1c0a1405f5d781c64a849ac9`.

## lane 0 -- handler-nonzero failure at 2026-07-24T10:51:39Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e06b4b434834cd281575ef6138929b546120e2ef
- Context: gardener-14 on endolin-garden2-5bcdff64: job 'ocapn-noise-press-20260724-105003' handler exited rc=1

Inspect via `git -C journal cat-file -p e06b4b434834cd281575ef6138929b546120e2ef`.

## lane 0 -- handler-nonzero failure at 2026-07-24T11:33:18Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: bc645198aa4222c134ed64a9eebb44f28975336e
- Context: gardener-18 on endolin-garden2-5bcdff64: job 'arc-status-daily-20260724-032002' handler exited rc=1

Inspect via `git -C journal cat-file -p bc645198aa4222c134ed64a9eebb44f28975336e`.

## lane 0 -- handler-nonzero failure at 2026-07-24T12:53:26Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4d2666ddc18d0bc8340e26be286eb81636c2ebea
- Context: gardener-5 on endolin-garden2-5bcdff64: job 'ocapn-noise-press-20260724-043515' handler exited rc=1

Inspect via `git -C journal cat-file -p 4d2666ddc18d0bc8340e26be286eb81636c2ebea`.

## lane 0 -- handler-nonzero failure at 2026-07-24T13:03:17Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 3b6526d2f3ecdc6bcfccc68473c77d6a721da453
- Context: gardener-8 on endolin-garden2-5bcdff64: job 'endo-git-integration-press-20260724-043515' handler exited rc=1

Inspect via `git -C journal cat-file -p 3b6526d2f3ecdc6bcfccc68473c77d6a721da453`.

## lane 0 -- handler-nonzero failure at 2026-07-24T13:13:16Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 0d3f372bc40e71b664f202a330a9a68e19012adc
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endo-byte-array-press-20260723-162019' handler exited rc=1

Inspect via `git -C journal cat-file -p 0d3f372bc40e71b664f202a330a9a68e19012adc`.

## lane 0 -- handler-nonzero failure at 2026-07-24T13:13:33Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 59807db73ab3c82b7d5138e7721fada64e30dbae
- Context: gardener-15 on endolin-garden2-5bcdff64: job 'endo-npm-cas-registry-press-20260723-223502' handler exited rc=1

Inspect via `git -C journal cat-file -p 59807db73ab3c82b7d5138e7721fada64e30dbae`.

## lane 0 -- handler-nonzero failure at 2026-07-24T13:13:52Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 5cf564082e45d92b6ec7c78deac12d157ed8c244
- Context: gardener-19 on endolin-garden2-5bcdff64: job 'endo-sturdyref-press-20260723-162019' handler exited rc=1

Inspect via `git -C journal cat-file -p 5cf564082e45d92b6ec7c78deac12d157ed8c244`.

## lane 0 -- handler-nonzero failure at 2026-07-24T13:14:14Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 36c5178c7b24de4215514df0d2d18d13cd96b02a
- Context: gardener-14 on endolin-garden2-5bcdff64: job 'endo-sturdyref-press-20260723-223502' handler exited rc=1

Inspect via `git -C journal cat-file -p 36c5178c7b24de4215514df0d2d18d13cd96b02a`.

## lane 0 -- handler-nonzero failure at 2026-07-24T14:53:20Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 39982c9a4f03d6bbcd0f7fb9e28f74752f134aa7
- Context: gardener-8 on endolin-garden2-5bcdff64: job 'ocapn-noise-press-20260724-105003' handler exited rc=1

Inspect via `git -C journal cat-file -p 39982c9a4f03d6bbcd0f7fb9e28f74752f134aa7`.

## lane 0 -- handler-nonzero failure at 2026-07-24T14:53:38Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: fe3427a03db48164418e317f03ca323a4b8501f7
- Context: gardener-15 on endolin-garden2-5bcdff64: job 'endo-git-integration-press-20260724-105003' handler exited rc=1

Inspect via `git -C journal cat-file -p fe3427a03db48164418e317f03ca323a4b8501f7`.

## lane 0 -- handler-nonzero failure at 2026-07-24T15:43:15Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 2061462b6576859109653a07cc9642cfd871a380
- Context: gardener-12 on endolin-garden2-5bcdff64: job 'arc-status-daily-20260724-032002' handler exited rc=1

Inspect via `git -C journal cat-file -p 2061462b6576859109653a07cc9642cfd871a380`.

## lane 0 -- handler-nonzero failure at 2026-07-24T16:50:35Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 2248c7f0573b923cff98bb8d8283fd2dd23c8933
- Context: gardener-15 on endolin-garden2-5bcdff64: job 'endo-byte-array-press-20260724-165003' handler exited rc=1

Inspect via `git -C journal cat-file -p 2248c7f0573b923cff98bb8d8283fd2dd23c8933`.

## lane 0 -- handler-nonzero failure at 2026-07-24T16:51:13Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4cc517bf0412d62162ab43271f94051ec6d91f3c
- Context: gardener-3 on endolin-garden2-5bcdff64: job 'endo-sturdyref-press-20260724-165003' handler exited rc=1

Inspect via `git -C journal cat-file -p 4cc517bf0412d62162ab43271f94051ec6d91f3c`.

## lane 0 -- handler-nonzero failure at 2026-07-24T16:51:55Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 8c9a5ac54b6ec0c7962f9289bf772c1bd414a8bc
- Context: gardener-20 on endolin-garden2-5bcdff64: job 'finbot-progress-20260724-165003' handler exited rc=1

Inspect via `git -C journal cat-file -p 8c9a5ac54b6ec0c7962f9289bf772c1bd414a8bc`.

## lane 0 -- handler-nonzero failure at 2026-07-24T17:03:21Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 84bfc0bf2e87731ce24ad3aca07d84c44f7ba4b5
- Context: gardener-13 on endolin-garden2-5bcdff64: job 'endo-npm-cas-registry-press-20260724-043515' handler exited rc=1

Inspect via `git -C journal cat-file -p 84bfc0bf2e87731ce24ad3aca07d84c44f7ba4b5`.

## lane 0 -- handler-nonzero failure at 2026-07-24T17:03:36Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: eca1af04151a271456af8b81166c8548989d10f9
- Context: gardener-18 on endolin-garden2-5bcdff64: job 'endo-vfs-parity-press-20260724-043515' handler exited rc=1

Inspect via `git -C journal cat-file -p eca1af04151a271456af8b81166c8548989d10f9`.

## lane 0 -- handler-nonzero failure at 2026-07-24T17:13:21Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4c9415fa4bda70ac2f8aa7e3ac17f9169699aab6
- Context: gardener-7 on endolin-garden2-5bcdff64: job 'endo-git-integration-press-20260724-043515' handler exited rc=1

Inspect via `git -C journal cat-file -p 4c9415fa4bda70ac2f8aa7e3ac17f9169699aab6`.

## lane 0 -- handler-nonzero failure at 2026-07-24T17:23:32Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e2829a2af698fe8e9b3133a0c92c73adde0ccb9f
- Context: gardener-12 on endolin-garden2-5bcdff64: job 'endo-byte-array-press-20260723-223502' handler exited rc=1

Inspect via `git -C journal cat-file -p e2829a2af698fe8e9b3133a0c92c73adde0ccb9f`.

## lane 0 -- handler-nonzero failure at 2026-07-24T18:50:29Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 73ca4495daa1f910e78af415e4aa3fb85bf7dcf8
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'proposal-compartments-press-20260724-185001' handler exited rc=1

Inspect via `git -C journal cat-file -p 73ca4495daa1f910e78af415e4aa3fb85bf7dcf8`.

## lane 0 -- handler-nonzero failure at 2026-07-24T19:03:32Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 272e27d53c7ba21e735a79a9859eea9e502f19cb
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'ocapn-noise-press-20260724-105003' handler exited rc=1

Inspect via `git -C journal cat-file -p 272e27d53c7ba21e735a79a9859eea9e502f19cb`.

## lane 0 -- handler-nonzero failure at 2026-07-24T19:40:18Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 73ca4495daa1f910e78af415e4aa3fb85bf7dcf8
- Context: gardener-14 on endolin-garden2-5bcdff64: job 'scholar-ingest-source-claude-5-context-engineering' handler exited rc=1

Inspect via `git -C journal cat-file -p 73ca4495daa1f910e78af415e4aa3fb85bf7dcf8`.

## lane 0 -- handler-nonzero failure at 2026-07-24T19:43:19Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 474f41b5a02e7f3fcf0bad9f2d95f34e74d0c197
- Context: gardener-12 on endolin-garden2-5bcdff64: job 'deadmail-issue-comment-5073593277' handler exited rc=1

Inspect via `git -C journal cat-file -p 474f41b5a02e7f3fcf0bad9f2d95f34e74d0c197`.

## lane 0 -- handler-nonzero failure at 2026-07-24T19:53:22Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 46b2c878d8566e8c3aa8099dc8e4fa30a7169c48
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'arc-status-daily-20260724-032002' handler exited rc=1

Inspect via `git -C journal cat-file -p 46b2c878d8566e8c3aa8099dc8e4fa30a7169c48`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-24T19:53:42Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 359714839dba1a3263f803ba935852f009138255
- Context: gardener-17 on endolin-garden2-5bcdff64: job 'deadmail-issue-comment-5073666635' exit-0-unsatisfying but elapsed near-constant (14,14s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 359714839dba1a3263f803ba935852f009138255`.

## lane 0 -- handler-nonzero failure at 2026-07-24T19:55:10Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 73ca4495daa1f910e78af415e4aa3fb85bf7dcf8
- Context: gardener-3 on endolin-garden2-5bcdff64: job 'issue-kriskowal-garden-64' handler exited rc=1

Inspect via `git -C journal cat-file -p 73ca4495daa1f910e78af415e4aa3fb85bf7dcf8`.

## lane 0 -- handler-nonzero failure at 2026-07-24T21:18:37Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: c6281f7d97527dafb3a14cb8bc0800720a43854a
- Context: gardener-12 on endolin-garden2-5bcdff64: job 'endo-vfs-parity-press-20260724-165003' handler exited rc=1

Inspect via `git -C journal cat-file -p c6281f7d97527dafb3a14cb8bc0800720a43854a`.

## lane 0 -- handler-nonzero failure at 2026-07-24T21:18:56Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 79db061ec83af98492ce77107316a277ada4bce3
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'endo-byte-array-press-20260724-043515' handler exited rc=1

Inspect via `git -C journal cat-file -p 79db061ec83af98492ce77107316a277ada4bce3`.

## lane 0 -- handler-nonzero failure at 2026-07-24T21:22:08Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 797e519fa3a5523cb728c6230bccba7dc77a2e96
- Context: gardener-15 on endolin-garden2-5bcdff64: job 'issue-kriskowal-garden-65' handler exited rc=1

Inspect via `git -C journal cat-file -p 797e519fa3a5523cb728c6230bccba7dc77a2e96`.

## lane 0 -- handler-nonzero failure at 2026-07-24T22:17:33Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e847f4b43918a2cb50e68fbf2f3f426854493196
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'scholar-ingest-fireworks-ai-harness-followup' handler exited rc=1

Inspect via `git -C journal cat-file -p e847f4b43918a2cb50e68fbf2f3f426854493196`.

## lane 0 -- handler-nonzero failure at 2026-07-24T22:50:41Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 14ee2fbe5ca7dc004a6c3efdd391b4b1f77f8ebc
- Context: gardener-7 on endolin-garden2-5bcdff64: job 'endo-byte-array-press-20260724-225004' handler exited rc=1

Inspect via `git -C journal cat-file -p 14ee2fbe5ca7dc004a6c3efdd391b4b1f77f8ebc`.

## lane 0 -- handler-nonzero failure at 2026-07-24T22:51:30Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 2d9cb37b3e14b427345c4799a1e47a485b9cccf8
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'finbot-progress-20260724-225004' handler exited rc=1

Inspect via `git -C journal cat-file -p 2d9cb37b3e14b427345c4799a1e47a485b9cccf8`.

## lane 0 -- handler-nonzero failure at 2026-07-24T22:53:21Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 58e326a040cc04e00b4972f6901e35d850a69d3b
- Context: gardener-19 on endolin-garden2-5bcdff64: job 'proposal-compartments-press-20260724-185001' handler exited rc=1

Inspect via `git -C journal cat-file -p 58e326a040cc04e00b4972f6901e35d850a69d3b`.

## lane 0 -- handler-nonzero failure at 2026-07-24T23:13:23Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: bcc6d1ed983428b9db4f06b86b7eca905870e016
- Context: gardener-20 on endolin-garden2-5bcdff64: job 'ocapn-noise-press-20260724-105003' handler exited rc=1

Inspect via `git -C journal cat-file -p bcc6d1ed983428b9db4f06b86b7eca905870e016`.

## lane 0 -- handler-nonzero failure at 2026-07-24T23:43:21Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 7e87a27d1ad149d6cbcaba71b2b31afa172b04f2
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'scholar-ingest-source-claude-5-context-engineering' handler exited rc=1

Inspect via `git -C journal cat-file -p 7e87a27d1ad149d6cbcaba71b2b31afa172b04f2`.

## lane 0 -- handler-nonzero failure at 2026-07-24T23:53:16Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 8f493d32394c648c1f22ed4483a1a8a0a4f6356c
- Context: gardener-9 on endolin-garden2-5bcdff64: job 'deadmail-issue-comment-5073593277' handler exited rc=1

Inspect via `git -C journal cat-file -p 8f493d32394c648c1f22ed4483a1a8a0a4f6356c`.

## lane 0 -- handler-nonzero failure at 2026-07-25T00:19:05Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 6bbd6a76f05ce133bd90e28ca1ce33b3374705af
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'kimi-k3-canary-20260723-c' handler exited rc=1

Inspect via `git -C journal cat-file -p 6bbd6a76f05ce133bd90e28ca1ce33b3374705af`.

## lane 0 -- handler-nonzero failure at 2026-07-25T00:19:35Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 81a68e7b7a412a97b6704f6eefc85645866028f3
- Context: gardener-4 on endolin-garden2-5bcdff64: job 'fix-systemd-api-key-handoff-20260725' handler exited rc=1

Inspect via `git -C journal cat-file -p 81a68e7b7a412a97b6704f6eefc85645866028f3`.

## lane 0 -- handler-nonzero failure at 2026-07-25T00:19:45Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b3ca3367e051f0bc863a0c2d2c49e4694f350345
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'kimi-k3-canary-20260723-d' handler exited rc=1

Inspect via `git -C journal cat-file -p b3ca3367e051f0bc863a0c2d2c49e4694f350345`.

## lane 0 -- handler-nonzero failure at 2026-07-25T00:22:20Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: a317e3d317de7d821a6690319d82d698bed72b7c
- Context: gardener-13 on endolin-garden2-5bcdff64: job 'fix-mystic-prompt-yolo-20260725' handler exited rc=1

Inspect via `git -C journal cat-file -p a317e3d317de7d821a6690319d82d698bed72b7c`.

## lane 0 -- handler-nonzero failure at 2026-07-25T00:27:04Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: a7a5cc5494f11a159b7d7ce611a4af5f0ca3da98
- Context: gardener-19 on endolin-garden2-5bcdff64: job 'design-endor-packaging' handler exited rc=1

Inspect via `git -C journal cat-file -p a7a5cc5494f11a159b7d7ce611a4af5f0ca3da98`.

## lane 0 -- handler-nonzero failure at 2026-07-25T00:32:54Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 57b5c1eafd1664d8feb6c59bba706942d4f64c47
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'kimi-k3-canary-20260725-e' handler exited rc=1

Inspect via `git -C journal cat-file -p 57b5c1eafd1664d8feb6c59bba706942d4f64c47`.

## lane 0 -- handler-nonzero failure at 2026-07-25T01:23:34Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e294e064a0d823c22827a6af713c28831663ec7a
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'ocapn-noise-press-20260724-165003' handler exited rc=1

Inspect via `git -C journal cat-file -p e294e064a0d823c22827a6af713c28831663ec7a`.

## lane 0 -- handler-nonzero failure at 2026-07-25T01:24:51Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 73ca4495daa1f910e78af415e4aa3fb85bf7dcf8
- Context: gardener-18 on endolin-garden2-5bcdff64: job 'scholar-ingest-osdi26-sharma-sandboxing' handler exited rc=1

Inspect via `git -C journal cat-file -p 73ca4495daa1f910e78af415e4aa3fb85bf7dcf8`.

## lane 0 -- handler-nonzero failure at 2026-07-25T02:53:19Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b6b4f7146d7098d9f5598b4af135daf5fb4168f1
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endo-git-integration-press-20260724-225004' handler exited rc=1

Inspect via `git -C journal cat-file -p b6b4f7146d7098d9f5598b4af135daf5fb4168f1`.

## lane 0 -- handler-nonzero failure at 2026-07-25T02:53:33Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: bce08dd67173be412117709757a8ce7f1fa10962
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'endo-vfs-parity-press-20260724-225004' handler exited rc=1

Inspect via `git -C journal cat-file -p bce08dd67173be412117709757a8ce7f1fa10962`.

## lane 0 -- handler-nonzero failure at 2026-07-25T05:17:00Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ed5da75aee06e4911a0c921afacd7398bef4fa5f
- Context: gardener-4 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr852-review-c981d05c' handler exited rc=1

Inspect via `git -C journal cat-file -p ed5da75aee06e4911a0c921afacd7398bef4fa5f`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-25T05:20:05Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 7bd2d09590d38d36cd399cf5604a16602b135784
- Context: gardener-19 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr541-ci-green-cascade-20260725' transient-classified (rc=1) but elapsed near-constant (1587,1587s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 7bd2d09590d38d36cd399cf5604a16602b135784`.

## lane 0 -- handler-nonzero failure at 2026-07-25T05:23:34Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: a46cf63b78c7f17d7bd2f4689c11e8d27b0b8222
- Context: gardener-15 on endolin-garden2-5bcdff64: job 'endo-sturdyref-press-20260724-165003' handler exited rc=1

Inspect via `git -C journal cat-file -p a46cf63b78c7f17d7bd2f4689c11e8d27b0b8222`.

## lane 0 -- handler-nonzero failure at 2026-07-25T05:33:26Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: f0aa917654aaeb59115fa910013540b19d9f6d70
- Context: gardener-18 on endolin-garden2-5bcdff64: job 'endo-byte-array-press-20260724-165003' handler exited rc=1

Inspect via `git -C journal cat-file -p f0aa917654aaeb59115fa910013540b19d9f6d70`.

## lane 0 -- handler-nonzero failure at 2026-07-25T05:50:09Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ed5da75aee06e4911a0c921afacd7398bef4fa5f
- Context: gardener-12 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr856-review-6cfb0803' handler exited rc=1

Inspect via `git -C journal cat-file -p ed5da75aee06e4911a0c921afacd7398bef4fa5f`.

## lane 0 -- handler-nonzero failure at 2026-07-25T05:51:44Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ed5da75aee06e4911a0c921afacd7398bef4fa5f
- Context: gardener-3 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr855-df7988e4' handler exited rc=1

Inspect via `git -C journal cat-file -p ed5da75aee06e4911a0c921afacd7398bef4fa5f`.

## lane 0 -- handler-nonzero failure at 2026-07-25T05:53:09Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ed5da75aee06e4911a0c921afacd7398bef4fa5f
- Context: gardener-15 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr849-a6858de7' handler exited rc=1

Inspect via `git -C journal cat-file -p ed5da75aee06e4911a0c921afacd7398bef4fa5f`.

## lane 0 -- handler-nonzero failure at 2026-07-25T05:53:26Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ed5da75aee06e4911a0c921afacd7398bef4fa5f
- Context: gardener-19 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr698-ci-green-cascade-20260725' handler exited rc=1

Inspect via `git -C journal cat-file -p ed5da75aee06e4911a0c921afacd7398bef4fa5f`.

## lane 0 -- handler-nonzero failure at 2026-07-25T05:56:55Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 96772c7dd7c237da1a77f29d7b9e787c3e2df258
- Context: gardener-9 on endolin-garden2-5bcdff64: job 'tune-fable-k3-model-assignments-20260725' handler exited rc=1

Inspect via `git -C journal cat-file -p 96772c7dd7c237da1a77f29d7b9e787c3e2df258`.

## lane 0 -- handler-nonzero failure at 2026-07-25T06:10:35Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ed5da75aee06e4911a0c921afacd7398bef4fa5f
- Context: gardener-11 on endolin-garden2-5bcdff64: job 'deadmail-issue-comment-5077246643' handler exited rc=1

Inspect via `git -C journal cat-file -p ed5da75aee06e4911a0c921afacd7398bef4fa5f`.

## lane 0 -- handler-nonzero failure at 2026-07-25T06:38:42Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 6452897168edb435a55deccd4a723ca4e4686d94
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'build-endo-but-for-bots-cap-std-watch-gauntlet' handler exited rc=1

Inspect via `git -C journal cat-file -p 6452897168edb435a55deccd4a723ca4e4686d94`.

## lane 0 -- handler-nonzero failure at 2026-07-25T07:03:49Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 7ad044a86e83f644c07ceac808849c77aeed19ae
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endo-sturdyref-press-20260724-225004' handler exited rc=1

Inspect via `git -C journal cat-file -p 7ad044a86e83f644c07ceac808849c77aeed19ae`.

## lane 0 -- handler-nonzero failure at 2026-07-25T07:04:13Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: f91812fab7dc30824fca49ec3797e4623e3b4848
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endo-vfs-parity-press-20260724-225004' handler exited rc=1

Inspect via `git -C journal cat-file -p f91812fab7dc30824fca49ec3797e4623e3b4848`.

## lane 0 -- handler-nonzero failure at 2026-07-25T07:04:42Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 48c9843d58d376b550b987fb6a2978f46b88e6fd
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'ocapn-noise-press-20260724-225004' handler exited rc=1

Inspect via `git -C journal cat-file -p 48c9843d58d376b550b987fb6a2978f46b88e6fd`.

## lane 0 -- handler-nonzero failure at 2026-07-25T07:05:13Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b322120dc87e3ce231dc337d60f136a68fcfdd85
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endo-byte-array-press-20260724-225004' handler exited rc=1

Inspect via `git -C journal cat-file -p b322120dc87e3ce231dc337d60f136a68fcfdd85`.

## lane 0 -- handler-nonzero failure at 2026-07-25T09:33:40Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: eb70ceeb884f71ef4bfb3085db2f82fb12aa9b3a
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'finbot-pr4-panel-rerun-20260725' handler exited rc=1

Inspect via `git -C journal cat-file -p eb70ceeb884f71ef4bfb3085db2f82fb12aa9b3a`.

## lane 0 -- handler-nonzero failure at 2026-07-25T10:23:26Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 7f51e38aa4816d9ee8a936bb7452f08e694e8b18
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr852-d502e7a9-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 7f51e38aa4816d9ee8a936bb7452f08e694e8b18`.

## lane 0 -- handler-nonzero failure at 2026-07-25T10:54:10Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 5efe0423346fdb4c71e97bc3b1dc145fbcdc2114
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'ebfb-stream-buffer-spring-sink-refactor-gauntlet' handler exited rc=1

Inspect via `git -C journal cat-file -p 5efe0423346fdb4c71e97bc3b1dc145fbcdc2114`.

## lane 0 -- handler-nonzero failure at 2026-07-25T11:03:36Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 2d10e951caa2832e2ac3a57ba215fb791e30963b
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'improve-local-provider-model-presence-preflight' handler exited rc=1

Inspect via `git -C journal cat-file -p 2d10e951caa2832e2ac3a57ba215fb791e30963b`.

## lane 0 -- handler-nonzero failure at 2026-07-25T14:03:31Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: f532d9e241fe471070f611c621248494bc11377c
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr856-review-6cfb0803' handler exited rc=1

Inspect via `git -C journal cat-file -p f532d9e241fe471070f611c621248494bc11377c`.

## lane 0 -- handler-nonzero failure at 2026-07-25T14:53:35Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: d6f010e52d5c486553dd4fc8d50da651300754d3
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'build-endo-but-for-bots-cap-std-watch-gauntlet' handler exited rc=1

Inspect via `git -C journal cat-file -p d6f010e52d5c486553dd4fc8d50da651300754d3`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-25T15:12:48Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: fb3a191441c4f9e709f5a3a6051a7ae544a82323
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'ebfb-stream-buffer-spring-sink-refactor-gauntlet' exit-0-unsatisfying but elapsed near-constant (561,561s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p fb3a191441c4f9e709f5a3a6051a7ae544a82323`.

## lane 0 -- handler-nonzero failure at 2026-07-25T17:06:26Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1b9948b9d9afa30b1dda96577bf94bcccdc290da
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'librarian-library-audit-20260725-170501' handler exited rc=1

Inspect via `git -C journal cat-file -p 1b9948b9d9afa30b1dda96577bf94bcccdc290da`.

## lane 0 -- handler-nonzero failure at 2026-07-25T17:11:39Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e25209ecd260fc539fdab52519ae73eea87cbbe6
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'merge-endo-but-for-bots-pr856-ambiguous-entry-esm' handler exited rc=1

Inspect via `git -C journal cat-file -p e25209ecd260fc539fdab52519ae73eea87cbbe6`.

## lane 0 -- handler-nonzero failure at 2026-07-25T18:13:51Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 30eaf1b845029a4aa5c2f1924ca92a82b3d2a970
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr849-dependabot' handler exited rc=1

Inspect via `git -C journal cat-file -p 30eaf1b845029a4aa5c2f1924ca92a82b3d2a970`.

## lane 0 -- handler-nonzero failure at 2026-07-25T18:17:52Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 5ccf7bce41f68883edf04cdb453e5657878c07e3
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr856-conduct' handler exited rc=1

Inspect via `git -C journal cat-file -p 5ccf7bce41f68883edf04cdb453e5657878c07e3`.

## lane 0 -- handler-nonzero failure at 2026-07-25T18:43:29Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: da5deb9f87f30e94410cd25a3129c7e010ba321f
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr852-d502e7a9-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p da5deb9f87f30e94410cd25a3129c7e010ba321f`.

## lane 0 -- handler-nonzero failure at 2026-07-25T18:53:37Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ef160833c8d705e5d7a44a713f2956826b7ba77e
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'proposal-compartments-endor-validation-20260725' handler exited rc=1

Inspect via `git -C journal cat-file -p ef160833c8d705e5d7a44a713f2956826b7ba77e`.

## lane 0 -- handler-nonzero failure at 2026-07-25T19:03:43Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4177146625cf755a3b55106399176db9f3854a20
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'improve-report-error-transcript-reachable' handler exited rc=1

Inspect via `git -C journal cat-file -p 4177146625cf755a3b55106399176db9f3854a20`.

## lane 0 -- handler-nonzero failure at 2026-07-25T19:08:56Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 0a09379467832ae19639618b2e8c56cab3b78202
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'fu-proposal-compartments-v8-validation-20260725-1' handler exited rc=1

Inspect via `git -C journal cat-file -p 0a09379467832ae19639618b2e8c56cab3b78202`.

## lane 0 -- handler-nonzero failure at 2026-07-25T19:43:47Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: de78a8851b1b94fe8766fcf415da4a3bcac4d4f2
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr719-313d4bc7' handler exited rc=1

Inspect via `git -C journal cat-file -p de78a8851b1b94fe8766fcf415da4a3bcac4d4f2`.

## lane 0 -- handler-nonzero failure at 2026-07-25T20:03:28Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 56070ad64512a29e270eb3f740962286fcd97f7f
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'build-endo-but-for-bots-cap-std-watch-gauntlet' handler exited rc=1

Inspect via `git -C journal cat-file -p 56070ad64512a29e270eb3f740962286fcd97f7f`.

## lane 0 -- handler-nonzero failure at 2026-07-25T20:33:46Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 863cc70d38758ce32ba8a9fac78d80c7c4bf4b59
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'kriscendobot-endo-but-for-bots-pr1-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 863cc70d38758ce32ba8a9fac78d80c7c4bf4b59`.

## lane 0 -- handler-nonzero failure at 2026-07-25T21:13:34Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: c3e153e292bad0b9bd314ee6925f2a20bb64ac90
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'librarian-library-audit-20260725-170501' handler exited rc=1

Inspect via `git -C journal cat-file -p c3e153e292bad0b9bd314ee6925f2a20bb64ac90`.

## lane 0 -- handler-nonzero failure at 2026-07-25T22:33:28Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: a5cae829ffe35897a48b5f4c9f30eee0b006ac25
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr856-conduct' handler exited rc=1

Inspect via `git -C journal cat-file -p a5cae829ffe35897a48b5f4c9f30eee0b006ac25`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-25T22:38:04Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 605cbb480a710b58a8926af63614972a979a9b79
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr849-dependabot' exit-0-unsatisfying but elapsed near-constant (874,874s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 605cbb480a710b58a8926af63614972a979a9b79`.

## lane 0 -- handler-nonzero failure at 2026-07-25T22:55:49Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: faa56f1b8d51ed5661e29759e998a3bf3768e701
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr852-d502e7a9-conduct' handler exited rc=1

Inspect via `git -C journal cat-file -p faa56f1b8d51ed5661e29759e998a3bf3768e701`.

## lane 0 -- handler-nonzero failure at 2026-07-25T23:03:37Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e45fe488f3f4fca414d5d1d0086a331dcd076f87
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'proposal-compartments-endor-validation-20260725' handler exited rc=1

Inspect via `git -C journal cat-file -p e45fe488f3f4fca414d5d1d0086a331dcd076f87`.

## lane 0 -- handler-nonzero failure at 2026-07-25T23:13:27Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 461984adacd1c605cb9c84861eeecc39a91776f2
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'finbot-progress-20260725-105007' handler exited rc=1

Inspect via `git -C journal cat-file -p 461984adacd1c605cb9c84861eeecc39a91776f2`.

## lane 0 -- handler-nonzero failure at 2026-07-25T23:53:28Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 60c3d8e74f49efa895037c14dc969858fdad7c5d
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr719-313d4bc7' handler exited rc=1

Inspect via `git -C journal cat-file -p 60c3d8e74f49efa895037c14dc969858fdad7c5d`.

## lane 0 -- handler-nonzero failure at 2026-07-26T00:43:38Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: d20c6245156b411d1831b31305d152e93b9a8743
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'build-endo-but-for-bots-cap-std-watch-gauntlet' handler exited rc=1

Inspect via `git -C journal cat-file -p d20c6245156b411d1831b31305d152e93b9a8743`.

## lane 0 -- handler-nonzero failure at 2026-07-26T01:28:06Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: fe42ea6026e307b9bec4f918312533d3ffff4e4a
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'librarian-index-sources-compartment-class-20260726' handler exited rc=1

Inspect via `git -C journal cat-file -p fe42ea6026e307b9bec4f918312533d3ffff4e4a`.

## lane 0 -- handler-nonzero failure at 2026-07-26T01:33:48Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 570b24e1c2ceb7002cfc724ec3dd9df5e41abdeb
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-012007' handler exited rc=1

Inspect via `git -C journal cat-file -p 570b24e1c2ceb7002cfc724ec3dd9df5e41abdeb`.

## lane 0 -- handler-nonzero failure at 2026-07-26T02:35:43Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e4ce1b32d9c2c8a8e9e84451e87e490fdb0a9cbe
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-023504' handler exited rc=1

Inspect via `git -C journal cat-file -p e4ce1b32d9c2c8a8e9e84451e87e490fdb0a9cbe`.

## lane 0 -- handler-nonzero failure at 2026-07-26T03:43:44Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4a68301e150de1de54836b8da3b47412fbf858e1
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'build-exo-google-sheets' handler exited rc=1

Inspect via `git -C journal cat-file -p 4a68301e150de1de54836b8da3b47412fbf858e1`.

## lane 0 -- handler-nonzero failure at 2026-07-26T03:50:50Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 5d5b7bab99fdfb3e9e89bd792c4bfc4f45bbf00f
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-035002' handler exited rc=1

Inspect via `git -C journal cat-file -p 5d5b7bab99fdfb3e9e89bd792c4bfc4f45bbf00f`.

## lane 0 -- handler-nonzero failure at 2026-07-26T04:03:43Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 3d2e801b45722c462d1e17dd729bb98e47f6ef15
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr719-313d4bc7' handler exited rc=1

Inspect via `git -C journal cat-file -p 3d2e801b45722c462d1e17dd729bb98e47f6ef15`.

## lane 0 -- handler-nonzero failure at 2026-07-26T04:50:49Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ce5adc3005d47345f914732c529336cdd015d040
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-045004' handler exited rc=1

Inspect via `git -C journal cat-file -p ce5adc3005d47345f914732c529336cdd015d040`.

## lane 0 -- handler-nonzero failure at 2026-07-26T04:53:38Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 700f25ef0d8cd903a6b9f26d9b6a1f407dac74b8
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'build-endo-but-for-bots-cap-std-watch-gauntlet' handler exited rc=1

Inspect via `git -C journal cat-file -p 700f25ef0d8cd903a6b9f26d9b6a1f407dac74b8`.

## lane 0 -- handler-nonzero failure at 2026-07-26T05:15:58Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: d250414f29b00538275e52e5dd3de5fe2cfc9014
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'finbot-pr4-panel-fixer-20260726-050514' handler exited rc=1

Inspect via `git -C journal cat-file -p d250414f29b00538275e52e5dd3de5fe2cfc9014`.

## lane 0 -- handler-nonzero failure at 2026-07-26T05:43:28Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 780dd4b463829bb8e05cfd16213f17d178df3389
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-012007' handler exited rc=1

Inspect via `git -C journal cat-file -p 780dd4b463829bb8e05cfd16213f17d178df3389`.

## lane 0 -- handler-nonzero failure at 2026-07-26T06:05:42Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: d1135f4a57165e5d3b4247e2529a9232117065fc
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-060501' handler exited rc=1

Inspect via `git -C journal cat-file -p d1135f4a57165e5d3b4247e2529a9232117065fc`.

## lane 0 -- handler-nonzero failure at 2026-07-26T06:43:29Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: abff8915ebc21d0aaf2dbfbdcfca88095bd8eadb
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-023504' handler exited rc=1

Inspect via `git -C journal cat-file -p abff8915ebc21d0aaf2dbfbdcfca88095bd8eadb`.

## lane 0 -- handler-nonzero failure at 2026-07-26T07:05:55Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 84f1b7b264a1b14441d8ab584f26a8a99725c4b3
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-070504' handler exited rc=1

Inspect via `git -C journal cat-file -p 84f1b7b264a1b14441d8ab584f26a8a99725c4b3`.

## lane 0 -- handler-nonzero failure at 2026-07-26T07:53:26Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 597dfb8b29d60596413aebedaee35bb5583307b2
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'build-exo-google-sheets' handler exited rc=1

Inspect via `git -C journal cat-file -p 597dfb8b29d60596413aebedaee35bb5583307b2`.

## lane 0 -- handler-nonzero failure at 2026-07-26T08:03:28Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 44c9820f44b76c07e6b1f860423456e1252bed33
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-035002' handler exited rc=1

Inspect via `git -C journal cat-file -p 44c9820f44b76c07e6b1f860423456e1252bed33`.

## lane 0 -- handler-nonzero failure at 2026-07-26T08:20:50Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: dbfb52ffa79fb2744ce0be1a21a75cf51031b6e1
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-082003' handler exited rc=1

Inspect via `git -C journal cat-file -p dbfb52ffa79fb2744ce0be1a21a75cf51031b6e1`.

## lane 0 -- handler-nonzero failure at 2026-07-26T08:53:39Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: cee0755dcf1dca21e94957c75a8d5a4c9d901f28
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-045004' handler exited rc=1

Inspect via `git -C journal cat-file -p cee0755dcf1dca21e94957c75a8d5a4c9d901f28`.

## lane 0 -- handler-nonzero failure at 2026-07-26T09:53:52Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1454b05abcb88b1042b706188dea2e1925e8a60e
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-012007' handler exited rc=1

Inspect via `git -C journal cat-file -p 1454b05abcb88b1042b706188dea2e1925e8a60e`.

## lane 0 -- handler-nonzero failure at 2026-07-26T10:13:34Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 2b8de17a0af76e5636b65f9411141097099e8285
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-060501' handler exited rc=1

Inspect via `git -C journal cat-file -p 2b8de17a0af76e5636b65f9411141097099e8285`.

## lane 0 -- handler-nonzero failure at 2026-07-26T10:36:05Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b9fd899bfdb5f94fd57fee56389902b16965cae4
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-103521' handler exited rc=1

Inspect via `git -C journal cat-file -p b9fd899bfdb5f94fd57fee56389902b16965cae4`.

## lane 0 -- handler-nonzero failure at 2026-07-26T10:44:02Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 31cb0efde50c17a091b60c2b4cc31d103252e6f1
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-023504' handler exited rc=1

Inspect via `git -C journal cat-file -p 31cb0efde50c17a091b60c2b4cc31d103252e6f1`.

## lane 0 -- handler-nonzero failure at 2026-07-26T11:23:37Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: f6405d52ba874c7ac103b64f3778221b0abeaa8a
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-070504' handler exited rc=1

Inspect via `git -C journal cat-file -p f6405d52ba874c7ac103b64f3778221b0abeaa8a`.

## lane 0 -- handler-nonzero failure at 2026-07-26T11:50:48Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: f662c5080f3111a74c0ef7923072969c4be18b46
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-115001' handler exited rc=1

Inspect via `git -C journal cat-file -p f662c5080f3111a74c0ef7923072969c4be18b46`.

## lane 0 -- handler-nonzero failure at 2026-07-26T12:23:35Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 413834d09a2d27bf361b9b33727bed1916418b1c
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-082003' handler exited rc=1

Inspect via `git -C journal cat-file -p 413834d09a2d27bf361b9b33727bed1916418b1c`.

## lane 0 -- handler-nonzero failure at 2026-07-26T12:53:38Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: fd4f18c84394fabc7c51554814d1432bcd2091f0
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-125016' handler exited rc=1

Inspect via `git -C journal cat-file -p fd4f18c84394fabc7c51554814d1432bcd2091f0`.

## lane 0 -- handler-nonzero failure at 2026-07-26T13:03:31Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: c39a27394e3f38f072a80afe6549c876855cb233
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-045004' handler exited rc=1

Inspect via `git -C journal cat-file -p c39a27394e3f38f072a80afe6549c876855cb233`.

## lane 0 -- handler-nonzero failure at 2026-07-26T14:33:29Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: a33dd934becd37fc546ce615b94c2ad446cf5ad6
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-060501' handler exited rc=1

Inspect via `git -C journal cat-file -p a33dd934becd37fc546ce615b94c2ad446cf5ad6`.

## lane 0 -- handler-nonzero failure at 2026-07-26T14:43:34Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e524615b3fd1b1c6091e0710907e50c734624656
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-140502' handler exited rc=1

Inspect via `git -C journal cat-file -p e524615b3fd1b1c6091e0710907e50c734624656`.

## lane 0 -- handler-nonzero failure at 2026-07-26T14:47:46Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: f9bda05136e7c89727100d03c36b26bdb6e0061d
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr861-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p f9bda05136e7c89727100d03c36b26bdb6e0061d`.

## lane 0 -- handler-nonzero failure at 2026-07-26T14:53:37Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e2beff5d1e5c77cb2889e3ea91439e60d70a2ad7
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-023504' handler exited rc=1

Inspect via `git -C journal cat-file -p e2beff5d1e5c77cb2889e3ea91439e60d70a2ad7`.

## lane 0 -- handler-nonzero failure at 2026-07-26T15:03:34Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 2d001b609d8c3f04d87ba294dc1811a0a42b5cab
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-103521' handler exited rc=1

Inspect via `git -C journal cat-file -p 2d001b609d8c3f04d87ba294dc1811a0a42b5cab`.

## lane 0 -- handler-nonzero failure at 2026-07-26T15:13:36Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: a4033c02e44cf792b0834c130bbe45346ed37bfd
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-150502' handler exited rc=1

Inspect via `git -C journal cat-file -p a4033c02e44cf792b0834c130bbe45346ed37bfd`.

## lane 0 -- handler-nonzero failure at 2026-07-26T15:14:30Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b27f4b04040f0982c9429bb8861bb89071610c07
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr740-40e1dd8c' handler exited rc=1

Inspect via `git -C journal cat-file -p b27f4b04040f0982c9429bb8861bb89071610c07`.

## lane 0 -- handler-nonzero failure at 2026-07-26T15:33:45Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4b3b123377d8558e877507ca65eaf3db06ddd661
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-070504' handler exited rc=1

Inspect via `git -C journal cat-file -p 4b3b123377d8558e877507ca65eaf3db06ddd661`.

## lane 0 -- handler-nonzero failure at 2026-07-26T16:03:31Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 07d93df451f1d98f8d883c8a74524a6a047f58ad
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-115001' handler exited rc=1

Inspect via `git -C journal cat-file -p 07d93df451f1d98f8d883c8a74524a6a047f58ad`.

## lane 0 -- handler-nonzero failure at 2026-07-26T16:23:37Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e8b9738b61a0bed1a5f080f3d42b17163d253f29
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-160502' handler exited rc=1

Inspect via `git -C journal cat-file -p e8b9738b61a0bed1a5f080f3d42b17163d253f29`.

## lane 0 -- handler-nonzero failure at 2026-07-26T16:33:40Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 67cf7e3c82b4582126f340af2e44a438a20cdb56
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-082003' handler exited rc=1

Inspect via `git -C journal cat-file -p 67cf7e3c82b4582126f340af2e44a438a20cdb56`.

## lane 0 -- handler-nonzero failure at 2026-07-26T17:03:51Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: d611df7baffc9d699cf51411c66596d5f31340a3
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-045004' handler exited rc=1

Inspect via `git -C journal cat-file -p d611df7baffc9d699cf51411c66596d5f31340a3`.

## lane 0 -- handler-nonzero failure at 2026-07-26T17:05:49Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 303a06be3c6029cde6cc7512c1a721ab14f919e0
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-170508' handler exited rc=1

Inspect via `git -C journal cat-file -p 303a06be3c6029cde6cc7512c1a721ab14f919e0`.

## lane 0 -- handler-nonzero failure at 2026-07-26T17:48:57Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: bb9024119ebef2be9f4fc66b9cc91e7575dc144e
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'fu-endo-npm-cas-registry-press-20260726-172007-1' handler exited rc=1

Inspect via `git -C journal cat-file -p bb9024119ebef2be9f4fc66b9cc91e7575dc144e`.

## lane 0 -- handler-nonzero failure at 2026-07-26T17:53:22Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 60a35d622a744900f36e2fc035bac044d6d47162
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'endo-sturdyref-agent-surface-build' handler exited rc=1

Inspect via `git -C journal cat-file -p 60a35d622a744900f36e2fc035bac044d6d47162`.

## lane 0 -- handler-nonzero failure at 2026-07-26T18:43:58Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 2338ae57bdf7bb89b2b9c68fdcb814bc51cbe54d
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-060501' handler exited rc=1

Inspect via `git -C journal cat-file -p 2338ae57bdf7bb89b2b9c68fdcb814bc51cbe54d`.

## lane 0 -- handler-nonzero failure at 2026-07-26T19:13:36Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 312138f5ec92e22d46c0a8f2f7e2008522baaa61
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-150502' handler exited rc=1

Inspect via `git -C journal cat-file -p 312138f5ec92e22d46c0a8f2f7e2008522baaa61`.

## lane 0 -- handler-nonzero failure at 2026-07-26T19:20:46Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 98e92c84f9145a1a98f2e29d0be210ce60f9f297
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-192001' handler exited rc=1

Inspect via `git -C journal cat-file -p 98e92c84f9145a1a98f2e29d0be210ce60f9f297`.

## lane 0 -- handler-nonzero failure at 2026-07-26T19:25:17Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: a71e0ae9223b71e6e89dd519823865d42f9a4dd1
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-build-endor-git-cas' handler exited rc=1

Inspect via `git -C journal cat-file -p a71e0ae9223b71e6e89dd519823865d42f9a4dd1`.

## lane 0 -- handler-nonzero failure at 2026-07-26T20:13:31Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: d87a78b214377327130ebf7f99a09c69bc5c791b
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-115001' handler exited rc=1

Inspect via `git -C journal cat-file -p d87a78b214377327130ebf7f99a09c69bc5c791b`.

## lane 0 -- handler-nonzero failure at 2026-07-26T20:33:38Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: d4e7a09cf35891f18f69e9b58bcadb732d22d0d6
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-202002' handler exited rc=1

Inspect via `git -C journal cat-file -p d4e7a09cf35891f18f69e9b58bcadb732d22d0d6`.

## lane 0 -- handler-nonzero failure at 2026-07-26T20:43:44Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 64db0a5542c117b4f10b6cdeb7c94407e6516de7
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-082003' handler exited rc=1

Inspect via `git -C journal cat-file -p 64db0a5542c117b4f10b6cdeb7c94407e6516de7`.

## lane 0 -- handler-nonzero failure at 2026-07-26T21:13:28Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 3669d2395d8f98827e0cf3cee6f7871fcef8c118
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-170508' handler exited rc=1

Inspect via `git -C journal cat-file -p 3669d2395d8f98827e0cf3cee6f7871fcef8c118`.

## lane 0 -- handler-nonzero failure at 2026-07-26T21:20:56Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: bef48c3bc07cf94efee1c5b07d29b45c682fcde4
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-212016' handler exited rc=1

Inspect via `git -C journal cat-file -p bef48c3bc07cf94efee1c5b07d29b45c682fcde4`.

## lane 0 -- handler-nonzero failure at 2026-07-26T21:53:29Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: a9d2d55e34cb774701b103e78d0854650de165d1
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'fu-endo-npm-cas-registry-press-20260726-172007-1' handler exited rc=1

Inspect via `git -C journal cat-file -p a9d2d55e34cb774701b103e78d0854650de165d1`.

## lane 0 -- handler-nonzero failure at 2026-07-26T22:35:50Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 839ede07b9dd714634547611c8130ff485fe22d3
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-223501' handler exited rc=1

Inspect via `git -C journal cat-file -p 839ede07b9dd714634547611c8130ff485fe22d3`.

## lane 0 -- handler-nonzero failure at 2026-07-26T23:23:33Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: c6526175cd94fad63ed21899c236ee8b1f4d891b
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-150502' handler exited rc=1

Inspect via `git -C journal cat-file -p c6526175cd94fad63ed21899c236ee8b1f4d891b`.

## lane 0 -- handler-nonzero failure at 2026-07-26T23:33:41Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: cd25a1507dbdaf62c725f72e279424e2c5fea3e7
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-192001' handler exited rc=1

Inspect via `git -C journal cat-file -p cd25a1507dbdaf62c725f72e279424e2c5fea3e7`.

## lane 0 -- handler-nonzero failure at 2026-07-26T23:36:38Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: a427f87d0bfa347f30426192043a8e412b5bec2f
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'finbot-progress-20260726-233502' handler exited rc=1

Inspect via `git -C journal cat-file -p a427f87d0bfa347f30426192043a8e412b5bec2f`.

## lane 0 -- handler-nonzero failure at 2026-07-26T23:43:50Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 3b4f60c262adcebe3efede62dda433de73282f93
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-233502' handler exited rc=1

Inspect via `git -C journal cat-file -p 3b4f60c262adcebe3efede62dda433de73282f93`.

## lane 0 -- handler-nonzero failure at 2026-07-26T23:59:24Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: d2e4dcf2ee7ec5437a077bcf0b31a412ae6bc1b2
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'fu-endo-npm-cas-registry-press-20260726-233502-1' handler exited rc=1

Inspect via `git -C journal cat-file -p d2e4dcf2ee7ec5437a077bcf0b31a412ae6bc1b2`.

## lane 0 -- handler-nonzero failure at 2026-07-27T00:43:38Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: bbe8d06f69ef29212d38a304cef4c25dd19ff557
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-003508' handler exited rc=1

Inspect via `git -C journal cat-file -p bbe8d06f69ef29212d38a304cef4c25dd19ff557`.

## lane 0 -- handler-nonzero failure at 2026-07-27T01:24:08Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 60e0deb0f1a728ba45be6a9b91b839370ff843cd
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-170508' handler exited rc=1

Inspect via `git -C journal cat-file -p 60e0deb0f1a728ba45be6a9b91b839370ff843cd`.

## lane 0 -- handler-nonzero failure at 2026-07-27T01:33:34Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 2ff2e742a7348f3e753529f12145c9ec3b032c31
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-212016' handler exited rc=1

Inspect via `git -C journal cat-file -p 2ff2e742a7348f3e753529f12145c9ec3b032c31`.

## lane 0 -- handler-nonzero failure at 2026-07-27T01:36:18Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: d6e2eeb370f92736ecd3226fc54bc6f3a7a4f4b9
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-013518' handler exited rc=1

Inspect via `git -C journal cat-file -p d6e2eeb370f92736ecd3226fc54bc6f3a7a4f4b9`.

## lane 0 -- handler-nonzero failure at 2026-07-27T02:03:27Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 08e7d10a386240301f14839bb347c227f2360eb9
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'fu-endo-npm-cas-registry-press-20260726-172007-1' handler exited rc=1

Inspect via `git -C journal cat-file -p 08e7d10a386240301f14839bb347c227f2360eb9`.

## lane 0 -- handler-nonzero failure at 2026-07-27T02:35:45Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e12e7dc454df23979a286216e053a4daa9ef8014
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'plan-recalibrate-20260727-023502' handler exited rc=1

Inspect via `git -C journal cat-file -p e12e7dc454df23979a286216e053a4daa9ef8014`.

## lane 0 -- handler-nonzero failure at 2026-07-27T02:53:37Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 49d7f85a0892853373e395b40596d29dfca75f0f
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-223501' handler exited rc=1

Inspect via `git -C journal cat-file -p 49d7f85a0892853373e395b40596d29dfca75f0f`.

## lane 0 -- handler-nonzero failure at 2026-07-27T03:03:48Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 50418ab74a2352370df7279fcc6b70c6a581aab2
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-025003' handler exited rc=1

Inspect via `git -C journal cat-file -p 50418ab74a2352370df7279fcc6b70c6a581aab2`.

## lane 0 -- handler-nonzero failure at 2026-07-27T03:33:37Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 9522376aef8305e0d8c2c87797d37e683420ff58
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-150502' handler exited rc=1

Inspect via `git -C journal cat-file -p 9522376aef8305e0d8c2c87797d37e683420ff58`.

## lane 0 -- handler-nonzero failure at 2026-07-27T03:43:42Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ca80f5f51e7691fc9510f5ef1f2c9394547136e0
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-192001' handler exited rc=1

Inspect via `git -C journal cat-file -p ca80f5f51e7691fc9510f5ef1f2c9394547136e0`.

## lane 0 -- handler-nonzero failure at 2026-07-27T03:51:09Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: d8f33df92cf279c0639ef45b856befd57daa4cf5
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-035010' handler exited rc=1

Inspect via `git -C journal cat-file -p d8f33df92cf279c0639ef45b856befd57daa4cf5`.

## lane 0 -- handler-nonzero failure at 2026-07-27T03:54:55Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: f17c0c1f994584e75a3dddc6d12725ff1b9e5e21
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'finbot-pr5-panel-20260727' handler exited rc=1

Inspect via `git -C journal cat-file -p f17c0c1f994584e75a3dddc6d12725ff1b9e5e21`.

## lane 0 -- handler-nonzero failure at 2026-07-27T04:03:35Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 09d3c69c9960dbdd6787af5e1db1afb5caaccca1
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'fu-endo-npm-cas-registry-press-20260726-233502-1' handler exited rc=1

Inspect via `git -C journal cat-file -p 09d3c69c9960dbdd6787af5e1db1afb5caaccca1`.

## lane 0 -- handler-nonzero failure at 2026-07-27T04:13:40Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: f86ddb28e64fbacb732bef8f4df26430bd4eec18
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-233502' handler exited rc=1

Inspect via `git -C journal cat-file -p f86ddb28e64fbacb732bef8f4df26430bd4eec18`.

## lane 0 -- handler-nonzero failure at 2026-07-27T04:50:06Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 9dc62f0cc4899f7f6ca5eb169c43caa0296be11c
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr874-review-e6cccb99' handler exited rc=1

Inspect via `git -C journal cat-file -p 9dc62f0cc4899f7f6ca5eb169c43caa0296be11c`.

## lane 0 -- handler-nonzero failure at 2026-07-27T04:53:27Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 941552adca76e3a9d2f60589b91d61a51224ab51
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-003508' handler exited rc=1

Inspect via `git -C journal cat-file -p 941552adca76e3a9d2f60589b91d61a51224ab51`.

## lane 0 -- handler-nonzero failure at 2026-07-27T05:13:53Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 850901bbd3d57d0393e0e226a7db6a7c625f4603
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-050502' handler exited rc=1

Inspect via `git -C journal cat-file -p 850901bbd3d57d0393e0e226a7db6a7c625f4603`.

## lane 0 -- handler-nonzero failure at 2026-07-27T05:36:21Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 031b0118863e793a703d6220fd1124bf458915b2
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'finbot-progress-20260727-053502' handler exited rc=1

Inspect via `git -C journal cat-file -p 031b0118863e793a703d6220fd1124bf458915b2`.

## lane 0 -- handler-nonzero failure at 2026-07-27T05:43:38Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: d7250a1bb0479b0c7a628060710fbb4cedc5ee10
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-212016' handler exited rc=1

Inspect via `git -C journal cat-file -p d7250a1bb0479b0c7a628060710fbb4cedc5ee10`.

## lane 0 -- handler-nonzero failure at 2026-07-27T05:53:33Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 259d594953b14349cde3105f475e3c615e6f2e04
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-013518' handler exited rc=1

Inspect via `git -C journal cat-file -p 259d594953b14349cde3105f475e3c615e6f2e04`.

## lane 0 -- handler-nonzero failure at 2026-07-27T06:20:44Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 925aa1ccd000e157d5cd5ce9e0b1b48e947b5587
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-062002' handler exited rc=1

Inspect via `git -C journal cat-file -p 925aa1ccd000e157d5cd5ce9e0b1b48e947b5587`.

## lane 0 -- handler-nonzero failure at 2026-07-27T07:03:31Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 749e44a0aabdd34134ee6c862633da451368e209
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-223501' handler exited rc=1

Inspect via `git -C journal cat-file -p 749e44a0aabdd34134ee6c862633da451368e209`.

## lane 0 -- handler-nonzero failure at 2026-07-27T07:20:46Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 139972956d411d6cf9b9974e6987d7918d8b5e79
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-072006' handler exited rc=1

Inspect via `git -C journal cat-file -p 139972956d411d6cf9b9974e6987d7918d8b5e79`.

## lane 0 -- handler-nonzero failure at 2026-07-27T08:43:48Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 3b159918c0ec25495be1143507eb93fe5495c797
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-083507' handler exited rc=1

Inspect via `git -C journal cat-file -p 3b159918c0ec25495be1143507eb93fe5495c797`.

## lane 0 -- handler-nonzero failure at 2026-07-27T08:53:40Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ae5332a29c2ce2928cd8aa8da8e3fcfc2760b689
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-003508' handler exited rc=1

Inspect via `git -C journal cat-file -p ae5332a29c2ce2928cd8aa8da8e3fcfc2760b689`.

## lane 0 -- handler-nonzero failure at 2026-07-27T09:23:39Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1a7efc24dac0e81917d3c5e4f003334c6e5d9487
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-050502' handler exited rc=1

Inspect via `git -C journal cat-file -p 1a7efc24dac0e81917d3c5e4f003334c6e5d9487`.

## lane 0 -- handler-nonzero failure at 2026-07-27T09:50:45Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 147ccb414d414b89f75346b864ea56527ebcf7fe
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-095001' handler exited rc=1

Inspect via `git -C journal cat-file -p 147ccb414d414b89f75346b864ea56527ebcf7fe`.

## lane 0 -- handler-nonzero failure at 2026-07-27T10:23:31Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 7b27233269206c533369da41e1ebd46fb3230011
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-062002' handler exited rc=1

Inspect via `git -C journal cat-file -p 7b27233269206c533369da41e1ebd46fb3230011`.

## lane 0 -- handler-nonzero failure at 2026-07-27T10:53:36Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: bc1cda7f80a9b9d589cb70fa41e5d99086fef280
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-105002' handler exited rc=1

Inspect via `git -C journal cat-file -p bc1cda7f80a9b9d589cb70fa41e5d99086fef280`.

## lane 0 -- handler-nonzero failure at 2026-07-27T11:13:33Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: cedab758c9f127f43e97f21c229f20ca45951bf5
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260726-223501' handler exited rc=1

Inspect via `git -C journal cat-file -p cedab758c9f127f43e97f21c229f20ca45951bf5`.

## lane 0 -- handler-nonzero failure at 2026-07-27T11:23:29Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e4e8318c5109b79ff55645aae9dca73a553cb66f
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-072006' handler exited rc=1

Inspect via `git -C journal cat-file -p e4e8318c5109b79ff55645aae9dca73a553cb66f`.

## lane 0 -- handler-nonzero failure at 2026-07-27T11:36:28Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: acc5d71befa1e4cf84ef20f5b9043ac04632edf6
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'finbot-progress-20260727-113510' handler exited rc=1

Inspect via `git -C journal cat-file -p acc5d71befa1e4cf84ef20f5b9043ac04632edf6`.

## lane 0 -- handler-nonzero failure at 2026-07-27T11:51:03Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ba76edfa438567e1d1d88070b012a0270f4612f1
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-115015' handler exited rc=1

Inspect via `git -C journal cat-file -p ba76edfa438567e1d1d88070b012a0270f4612f1`.

## lane 0 -- handler-nonzero failure at 2026-07-27T12:03:35Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: cca3453b0ec2e02f8d23e41e2b8e4fd89afd8ad3
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-035010' handler exited rc=1

Inspect via `git -C journal cat-file -p cca3453b0ec2e02f8d23e41e2b8e4fd89afd8ad3`.

## lane 0 -- handler-nonzero failure at 2026-07-27T12:51:19Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 54135df9d7635a4352addf4d562d92fa6d216eec
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-125027' handler exited rc=1

Inspect via `git -C journal cat-file -p 54135df9d7635a4352addf4d562d92fa6d216eec`.

## lane 0 -- handler-nonzero failure at 2026-07-27T12:53:38Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4d6670b1a5b8a56fcc482982e7a3ff4d74d6239a
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-083507' handler exited rc=1

Inspect via `git -C journal cat-file -p 4d6670b1a5b8a56fcc482982e7a3ff4d74d6239a`.

## lane 0 -- handler-nonzero failure at 2026-07-27T14:03:31Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 2693b847aee80872c4ed116a6bec15527f51a5a5
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-095001' handler exited rc=1

Inspect via `git -C journal cat-file -p 2693b847aee80872c4ed116a6bec15527f51a5a5`.

## lane 0 -- handler-nonzero failure at 2026-07-27T14:05:40Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: bb139c5b3d733c52e772d800d56b7b449dbd72e8
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-140502' handler exited rc=1

Inspect via `git -C journal cat-file -p bb139c5b3d733c52e772d800d56b7b449dbd72e8`.

## lane 0 -- handler-nonzero failure at 2026-07-27T14:33:28Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: deb6097d05ee804110d25c913c835b842ceda4d0
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-062002' handler exited rc=1

Inspect via `git -C journal cat-file -p deb6097d05ee804110d25c913c835b842ceda4d0`.

## lane 0 -- handler-nonzero failure at 2026-07-27T15:03:31Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1e673905d0b70dde1b7bff801bd0048226971c40
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-105002' handler exited rc=1

Inspect via `git -C journal cat-file -p 1e673905d0b70dde1b7bff801bd0048226971c40`.

## lane 0 -- handler-nonzero failure at 2026-07-27T15:05:53Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 98672f534ed9fa1746ed7b05e1776643a4644343
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-150502' handler exited rc=1

Inspect via `git -C journal cat-file -p 98672f534ed9fa1746ed7b05e1776643a4644343`.

## lane 0 -- handler-nonzero failure at 2026-07-27T15:33:38Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4802d3e1ced2cf9435e53a81ff4c9f4bbcb78580
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-072006' handler exited rc=1

Inspect via `git -C journal cat-file -p 4802d3e1ced2cf9435e53a81ff4c9f4bbcb78580`.

## lane 0 -- handler-nonzero failure at 2026-07-27T16:13:44Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 473f22083d613c2330c476dc902c8c9cb6bb4080
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-160502' handler exited rc=1

Inspect via `git -C journal cat-file -p 473f22083d613c2330c476dc902c8c9cb6bb4080`.

## lane 0 -- handler-nonzero failure at 2026-07-27T16:53:53Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: bbd1b685e4776e2640df59ae4b20adec76da0b1b
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-125027' handler exited rc=1

Inspect via `git -C journal cat-file -p bbd1b685e4776e2640df59ae4b20adec76da0b1b`.

## lane 0 -- handler-nonzero failure at 2026-07-27T17:03:32Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e9088b1daba60a4e4d5cecb81e23382466a43a75
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-083507' handler exited rc=1

Inspect via `git -C journal cat-file -p e9088b1daba60a4e4d5cecb81e23382466a43a75`.

## lane 0 -- handler-nonzero failure at 2026-07-27T17:06:17Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 52a3113f8ac72e3ce6fef75ea358dc6cbf71cd7d
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-170531' handler exited rc=1

Inspect via `git -C journal cat-file -p 52a3113f8ac72e3ce6fef75ea358dc6cbf71cd7d`.

## lane 0 -- handler-nonzero failure at 2026-07-27T17:18:32Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: a36b458ab9fa9954782bc0cdc4417b7f1060186c
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'issue-kriskowal-garden-67' handler exited rc=1

Inspect via `git -C journal cat-file -p a36b458ab9fa9954782bc0cdc4417b7f1060186c`.

## lane 0 -- handler-nonzero failure at 2026-07-27T17:51:23Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 0af9b32dbb6abb01f29fa00a30ddd4476f92858e
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'finbot-progress-20260727-175002' handler exited rc=1

Inspect via `git -C journal cat-file -p 0af9b32dbb6abb01f29fa00a30ddd4476f92858e`.

## lane 0 -- handler-nonzero failure at 2026-07-27T18:20:53Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: f07aad8aa12c687e283943bea6b5e048302ae275
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-182001' handler exited rc=1

Inspect via `git -C journal cat-file -p f07aad8aa12c687e283943bea6b5e048302ae275`.

## lane 0 -- handler-nonzero failure at 2026-07-27T18:43:31Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 8255a0511fad7c93f1fe1057692c956fc272d599
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-062002' handler exited rc=1

Inspect via `git -C journal cat-file -p 8255a0511fad7c93f1fe1057692c956fc272d599`.

## lane 0 -- handler-nonzero failure at 2026-07-27T19:13:57Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: fe0a6a31f3ac888cc32439678b07f1becf59f7fa
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-105002' handler exited rc=1

Inspect via `git -C journal cat-file -p fe0a6a31f3ac888cc32439678b07f1becf59f7fa`.

## lane 0 -- handler-nonzero failure at 2026-07-27T19:24:06Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 3cf338273a451a349e4ddedebd65d64611a263ef
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-192007' handler exited rc=1

Inspect via `git -C journal cat-file -p 3cf338273a451a349e4ddedebd65d64611a263ef`.

## lane 0 -- handler-nonzero failure at 2026-07-27T19:43:44Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e5d798824aa0891704ef14e9c7dacb599dcf0c04
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-150502' handler exited rc=1

Inspect via `git -C journal cat-file -p e5d798824aa0891704ef14e9c7dacb599dcf0c04`.

## lane 0 -- handler-nonzero failure at 2026-07-27T19:56:24Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 918d26f3db2ca495bce55f3f111216cf91a1de9d
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'self-heal-fix-garden-comment-watcher-kriscendobot-garden-repo-404-crashloop' handler exited rc=1

Inspect via `git -C journal cat-file -p 918d26f3db2ca495bce55f3f111216cf91a1de9d`.

## lane 0 -- handler-nonzero failure at 2026-07-27T20:03:31Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 318237efa42db51364050e8370721fcb2cfb178c
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-115015' handler exited rc=1

Inspect via `git -C journal cat-file -p 318237efa42db51364050e8370721fcb2cfb178c`.

## lane 0 -- handler-nonzero failure at 2026-07-27T20:23:29Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 0130bebb566e1bd00c168761e9f8c63acb4fa01b
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-160502' handler exited rc=1

Inspect via `git -C journal cat-file -p 0130bebb566e1bd00c168761e9f8c63acb4fa01b`.

## lane 0 -- handler-nonzero failure at 2026-07-27T20:34:34Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 9af17a9c54dbbb51e94455e82e21dd86ec7f2215
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-202011' handler exited rc=1

Inspect via `git -C journal cat-file -p 9af17a9c54dbbb51e94455e82e21dd86ec7f2215`.

## lane 0 -- handler-nonzero failure at 2026-07-27T21:03:37Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 10121750f2ba480583933d31276d8ca94c55048e
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-125027' handler exited rc=1

Inspect via `git -C journal cat-file -p 10121750f2ba480583933d31276d8ca94c55048e`.

## lane 0 -- handler-nonzero failure at 2026-07-27T21:13:33Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b3d319b49ad21606de3fec1fcf64c08948953aa0
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-170531' handler exited rc=1

Inspect via `git -C journal cat-file -p b3d319b49ad21606de3fec1fcf64c08948953aa0`.

## lane 0 -- handler-nonzero failure at 2026-07-27T21:35:55Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: f6aed41f02b391e0dd90487f59854f4976b595d2
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-213502' handler exited rc=1

Inspect via `git -C journal cat-file -p f6aed41f02b391e0dd90487f59854f4976b595d2`.

## lane 0 -- handler-nonzero failure at 2026-07-28T08:05:54Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 71fc0226e58b4e7bf2c87f5682d9e852e7a18c99
- Context: gardener-3 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr779-panel-remaining-seats' handler exited rc=1

Inspect via `git -C journal cat-file -p 71fc0226e58b4e7bf2c87f5682d9e852e7a18c99`.

## lane 0 -- handler-nonzero failure at 2026-07-28T08:06:56Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4f8df9b5b57c972fcd85e1acf2491bc65c6007ff
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'finbot-progress-20260728-065010' handler exited rc=1

Inspect via `git -C journal cat-file -p 4f8df9b5b57c972fcd85e1acf2491bc65c6007ff`.

## lane 0 -- handler-nonzero failure at 2026-07-28T08:07:37Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 71fc0226e58b4e7bf2c87f5682d9e852e7a18c99
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'fu-endo-npm-cas-registry-press-20260728-065010-1' handler exited rc=1

Inspect via `git -C journal cat-file -p 71fc0226e58b4e7bf2c87f5682d9e852e7a18c99`.

## lane 0 -- handler-nonzero failure at 2026-07-28T08:08:16Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 71fc0226e58b4e7bf2c87f5682d9e852e7a18c99
- Context: gardener-4 on endolin-garden2-5bcdff64: job 'fu-clarify-drain-moratorium-vocabulary-1' handler exited rc=1

Inspect via `git -C journal cat-file -p 71fc0226e58b4e7bf2c87f5682d9e852e7a18c99`.

## lane 0 -- handler-nonzero failure at 2026-07-28T08:10:03Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 71fc0226e58b4e7bf2c87f5682d9e852e7a18c99
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'fix-censored-events-frozen-reputation-arm' handler exited rc=1

Inspect via `git -C journal cat-file -p 71fc0226e58b4e7bf2c87f5682d9e852e7a18c99`.

## lane 0 -- handler-nonzero failure at 2026-07-28T08:10:46Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 71fc0226e58b4e7bf2c87f5682d9e852e7a18c99
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'issue-garden-62-jcorbin-cross-analysis' handler exited rc=1

Inspect via `git -C journal cat-file -p 71fc0226e58b4e7bf2c87f5682d9e852e7a18c99`.

## lane 0 -- handler-nonzero failure at 2026-07-28T08:11:32Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 8a7d5468e3ed866f11012bb51d932c261cfe43ab
- Context: gardener-4 on endolin-garden2-5bcdff64: job 'ocapn-noise-press-20260728-065010' handler exited rc=1

Inspect via `git -C journal cat-file -p 8a7d5468e3ed866f11012bb51d932c261cfe43ab`.

## lane 0 -- handler-nonzero failure at 2026-07-28T08:12:14Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 71fc0226e58b4e7bf2c87f5682d9e852e7a18c99
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'self-heal-fix-garden-dependabot-watcher-kriscendobot-chrome-native-function-caller-arguments-repro-armed-fork-upstream-404-no-disarm' handler exited rc=1

Inspect via `git -C journal cat-file -p 71fc0226e58b4e7bf2c87f5682d9e852e7a18c99`.

## lane 0 -- handler-nonzero failure at 2026-07-28T08:13:22Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: fba12001f99779d4bc462da0ba6794cacf9458b2
- Context: gardener-7 on endolin-garden2-5bcdff64: job 'hermit-failure-reputation-followup' handler exited rc=1

Inspect via `git -C journal cat-file -p fba12001f99779d4bc462da0ba6794cacf9458b2`.

## lane 0 -- handler-nonzero failure at 2026-07-28T08:14:04Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 6482529ae3b0648ef0831ff1cf7ef0b4d724d3ec
- Context: gardener-7 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr870-dependabot' handler exited rc=1

Inspect via `git -C journal cat-file -p 6482529ae3b0648ef0831ff1cf7ef0b4d724d3ec`.

## lane 0 -- handler-nonzero failure at 2026-07-28T08:14:41Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: bb0b82d2a6f4c652b24c5ab915e6df5f3e91e0ba
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'fireworks-glm52-kimik3-build' handler exited rc=1

Inspect via `git -C journal cat-file -p bb0b82d2a6f4c652b24c5ab915e6df5f3e91e0ba`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-28T08:15:24Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: d5d235750447f4097fd864c390d2252e3a76a5a8
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'build-token-cost-ledger' transient-classified (rc=1) but elapsed near-constant (15,15s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p d5d235750447f4097fd864c390d2252e3a76a5a8`.

## lane 0 -- handler-nonzero failure at 2026-07-28T08:15:59Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: f5ef8725ac0cf73860be44ab4bee42a2a6abbc3e
- Context: gardener-5 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-form-data-advisory' handler exited rc=1

Inspect via `git -C journal cat-file -p f5ef8725ac0cf73860be44ab4bee42a2a6abbc3e`.

## lane 0 -- handler-nonzero failure at 2026-07-28T08:16:31Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: c3d5754160e8974f262cc1402044b3167b7a409b
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr868-lint-fix' handler exited rc=1

Inspect via `git -C journal cat-file -p c3d5754160e8974f262cc1402044b3167b7a409b`.

## lane 0 -- handler-nonzero failure at 2026-07-28T08:17:01Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 71fc0226e58b4e7bf2c87f5682d9e852e7a18c99
- Context: gardener-3 on endolin-garden2-5bcdff64: job 'build-exo-google-sheets-facets' handler exited rc=1

Inspect via `git -C journal cat-file -p 71fc0226e58b4e7bf2c87f5682d9e852e7a18c99`.

## lane 0 -- handler-nonzero failure at 2026-07-28T08:21:30Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 71fc0226e58b4e7bf2c87f5682d9e852e7a18c99
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr825-fixer-ci-daemon-unhandled-rejection' handler exited rc=1

Inspect via `git -C journal cat-file -p 71fc0226e58b4e7bf2c87f5682d9e852e7a18c99`.

## lane 0 -- handler-nonzero failure at 2026-07-28T08:23:53Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 5425ee9fb98a970d79141fcb8d97a6171a795c5e
- Context: gardener-4 on endolin-garden2-5bcdff64: job 'build-token-cost-ledger' handler exited rc=1

Inspect via `git -C journal cat-file -p 5425ee9fb98a970d79141fcb8d97a6171a795c5e`.

## lane 0 -- handler-nonzero failure at 2026-07-28T08:24:21Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 71fc0226e58b4e7bf2c87f5682d9e852e7a18c99
- Context: gardener-3 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr881-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 71fc0226e58b4e7bf2c87f5682d9e852e7a18c99`.

## lane 0 -- handler-nonzero failure at 2026-07-28T08:33:27Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 5f99cc728db7d61b7d53d12bbc7a4bacf7f0e6c7
- Context: gardener-5 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-182001' handler exited rc=1

Inspect via `git -C journal cat-file -p 5f99cc728db7d61b7d53d12bbc7a4bacf7f0e6c7`.

## lane 0 -- handler-nonzero failure at 2026-07-28T08:40:34Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 71fc0226e58b4e7bf2c87f5682d9e852e7a18c99
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'requeue-ps23-stranded-claims' handler exited rc=1

Inspect via `git -C journal cat-file -p 71fc0226e58b4e7bf2c87f5682d9e852e7a18c99`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-28T12:17:03Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: b9cb1986d4918f836f3eeedd2e3656a7016e5aeb
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'finbot-pr5-panel-20260728' exit-0-unsatisfying but elapsed near-constant (181,181s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p b9cb1986d4918f836f3eeedd2e3656a7016e5aeb`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-28T12:19:29Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 7c9bcddaa56ec2880375542567cb6ea498670c95
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr713-gauntlet-backfill' exit-0-unsatisfying but elapsed near-constant (166,166s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 7c9bcddaa56ec2880375542567cb6ea498670c95`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-28T12:32:49Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 63c9322d6760cd77543cc137e4704b909e876ea2
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'build-exo-google-sheets-facets' exit-0-unsatisfying but elapsed near-constant (447,447s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 63c9322d6760cd77543cc137e4704b909e876ea2`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:34:09Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e663023177debb37f337ac6086ac8d5aab2b03a7
- Context: gardener-8 on endolin-garden2-5bcdff64: job 'improve-review-miss-gaming-category' handler exited rc=1

Inspect via `git -C journal cat-file -p e663023177debb37f337ac6086ac8d5aab2b03a7`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-28T12:34:21Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 95e8ae688f17c1ef8b47010d0747728cc8293b5f
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-form-data-advisory' transient-classified (rc=1) but elapsed near-constant (12,12s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 95e8ae688f17c1ef8b47010d0747728cc8293b5f`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-28T12:34:43Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 303b1ead14dfcef11b1c97cb4b448e92ebe26d78
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr705-fixer-changes-requested' transient-classified (rc=1) but elapsed near-constant (61,61s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 303b1ead14dfcef11b1c97cb4b448e92ebe26d78`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-28T12:35:08Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 1a836735793cf05d69b4da34c3be2ea049eb502b
- Context: gardener-5 on endolin-garden2-5bcdff64: job 'hermit-failure-reputation-followup' transient-classified (rc=1) but elapsed near-constant (853,853s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 1a836735793cf05d69b4da34c3be2ea049eb502b`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:35:20Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 208c5e60af0c6b3806d207be9fe96230eb64f7af
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'build-token-cost-ledger' handler exited rc=1

Inspect via `git -C journal cat-file -p 208c5e60af0c6b3806d207be9fe96230eb64f7af`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:36:03Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 0cb309be32c8796a9b84668c8db498c939ed44ed
- Context: gardener-8 on endolin-garden2-5bcdff64: job 'finbot-pr6-panel-20260728' handler exited rc=1

Inspect via `git -C journal cat-file -p 0cb309be32c8796a9b84668c8db498c939ed44ed`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:36:48Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1eb7d1d2231589cc7c9c350b4860732ba3434526
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr755-gauntlet' handler exited rc=1

Inspect via `git -C journal cat-file -p 1eb7d1d2231589cc7c9c350b4860732ba3434526`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:37:01Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 63932cc1a3958c12f7b89e7aa2629c15d5c41a0f
- Context: gardener-3 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr881-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 63932cc1a3958c12f7b89e7aa2629c15d5c41a0f`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:37:08Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 13c870244497de8e235db805e0ed4127c3c17c07
- Context: gardener-4 on endolin-garden2-5bcdff64: job 'finbot-pr4-panel-20260728' handler exited rc=1

Inspect via `git -C journal cat-file -p 13c870244497de8e235db805e0ed4127c3c17c07`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:37:57Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e554789ab0b3a81dd42b2d04f47335aa2eabb9dd
- Context: gardener-7 on endolin-garden2-5bcdff64: job 'migrate-garden-origins-to-kriscendobot' handler exited rc=1

Inspect via `git -C journal cat-file -p e554789ab0b3a81dd42b2d04f47335aa2eabb9dd`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:38:13Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1eb7d1d2231589cc7c9c350b4860732ba3434526
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'fu-fu-fix-identity-drift-guard-test-inbox-leak-3-1' handler exited rc=1

Inspect via `git -C journal cat-file -p 1eb7d1d2231589cc7c9c350b4860732ba3434526`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:38:31Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 6ec4321282ab98001ff83737507935836cb14101
- Context: gardener-3 on endolin-garden2-5bcdff64: job 'ocapn-noise-press-20260728-065010' handler exited rc=1

Inspect via `git -C journal cat-file -p 6ec4321282ab98001ff83737507935836cb14101`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-28T12:38:39Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: e777c8047f1c4ba9162824d1f81a336a97e57bbd
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'fu-endojs-endo-but-for-bots-pr825-8840fcdb-2' transient-classified (rc=1) but elapsed near-constant (1403,1403s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p e777c8047f1c4ba9162824d1f81a336a97e57bbd`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:39:18Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 0221a56490817a0c3b071288db8f782fb10b7e34
- Context: gardener-7 on endolin-garden2-5bcdff64: job 'suffix-github-comments-with-provenance' handler exited rc=1

Inspect via `git -C journal cat-file -p 0221a56490817a0c3b071288db8f782fb10b7e34`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:39:46Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 559d8df0d6a35fc6fae70e99fd4ed741b7841119
- Context: gardener-8 on endolin-garden2-5bcdff64: job 'wallclock-cost-proxy-for-censored-arms' handler exited rc=1

Inspect via `git -C journal cat-file -p 559d8df0d6a35fc6fae70e99fd4ed741b7841119`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:40:04Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1e847e680e438d2bb3b176ce7fb4e7fd8663a52a
- Context: gardener-3 on endolin-garden2-5bcdff64: job 'measure-requeue-exit-knowledge-loss' handler exited rc=1

Inspect via `git -C journal cat-file -p 1e847e680e438d2bb3b176ce7fb4e7fd8663a52a`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:40:12Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 0f79a6e40bae0f5615d25068175bfb08ced706f9
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'arc-status-daily-20260728-033502' handler exited rc=1

Inspect via `git -C journal cat-file -p 0f79a6e40bae0f5615d25068175bfb08ced706f9`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:40:25Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 49f2879f1095f5d97e01baa8f0dde70864846bca
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'gnome-backend-autotune-build' handler exited rc=1

Inspect via `git -C journal cat-file -p 49f2879f1095f5d97e01baa8f0dde70864846bca`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:40:50Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: f3b620ead839ac86509d1554ccad98f9c550641d
- Context: gardener-4 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr713-gauntlet-backfill' handler exited rc=1

Inspect via `git -C journal cat-file -p f3b620ead839ac86509d1554ccad98f9c550641d`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:41:01Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 9a0c0f5c0bc5c0449212836228fd5ec33932aaf7
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-s1-daemon-integration' handler exited rc=1

Inspect via `git -C journal cat-file -p 9a0c0f5c0bc5c0449212836228fd5ec33932aaf7`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:41:10Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 3681918e9acce45a196c0407f18bc70f84bc15ab
- Context: gardener-5 on endolin-garden2-5bcdff64: job 'fireworks-glm52-kimik3-build' handler exited rc=1

Inspect via `git -C journal cat-file -p 3681918e9acce45a196c0407f18bc70f84bc15ab`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:41:54Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: be8b6989643f39f0c20c7026d5dbd8436b79b7d3
- Context: gardener-4 on endolin-garden2-5bcdff64: job 'scholar-atproto-ucan-addressing-taxonomy' handler exited rc=1

Inspect via `git -C journal cat-file -p be8b6989643f39f0c20c7026d5dbd8436b79b7d3`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:42:10Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: caa23672440ce237b3208b0e3e15c75c555086db
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr868-lint-fix' handler exited rc=1

Inspect via `git -C journal cat-file -p caa23672440ce237b3208b0e3e15c75c555086db`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:44:01Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 75303a0ef231d8f1447fe25402dab24b8bb802c7
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'hermit-failure-reputation-followup' handler exited rc=1

Inspect via `git -C journal cat-file -p 75303a0ef231d8f1447fe25402dab24b8bb802c7`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:44:14Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 775578d0411d012c3e156070ac449ffa9c36ef1e
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-press-20260727-182001' handler exited rc=1

Inspect via `git -C journal cat-file -p 775578d0411d012c3e156070ac449ffa9c36ef1e`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-28T12:46:15Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: e36c34157f63603ae07a48bd4785ada1aeac9e1a
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr874-gauntlet-retry' exit-0-unsatisfying but elapsed near-constant (111,111s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p e36c34157f63603ae07a48bd4785ada1aeac9e1a`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:53:06Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1eb7d1d2231589cc7c9c350b4860732ba3434526
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr882-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 1eb7d1d2231589cc7c9c350b4860732ba3434526`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:53:27Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: f2224320fcef58738236925cf39098ed08ad67e0
- Context: gardener-4 on endolin-garden2-5bcdff64: job 'build-exo-google-sheets-facets' handler exited rc=1

Inspect via `git -C journal cat-file -p f2224320fcef58738236925cf39098ed08ad67e0`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:53:40Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 0b8efc22242a19f3a6dad27cdcba1992e311411a
- Context: gardener-8 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr874-gauntlet-retry' handler exited rc=1

Inspect via `git -C journal cat-file -p 0b8efc22242a19f3a6dad27cdcba1992e311411a`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:58:20Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 5799cee088ac3693e7cec6873b495cb07a78797a
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr705-fixer-changes-requested' handler exited rc=1

Inspect via `git -C journal cat-file -p 5799cee088ac3693e7cec6873b495cb07a78797a`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:58:28Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 89d1aaba8c700ee885087238df2b342fda77b618
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'fu-endojs-endo-but-for-bots-pr825-8840fcdb-2' handler exited rc=1

Inspect via `git -C journal cat-file -p 89d1aaba8c700ee885087238df2b342fda77b618`.

## lane 0 -- handler-nonzero failure at 2026-07-28T12:58:40Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: bbc144876b47413a4dc4b5e2643f0ac4fcfed505
- Context: gardener-3 on endolin-garden2-5bcdff64: job 'finbot-progress-20260728-065010' handler exited rc=1

Inspect via `git -C journal cat-file -p bbc144876b47413a4dc4b5e2643f0ac4fcfed505`.

## lane 0 -- handler-nonzero failure at 2026-07-28T13:03:24Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4dcfc45f36386b13a4d50fd7b9ab73102def216e
- Context: gardener-4 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-form-data-advisory' handler exited rc=1

Inspect via `git -C journal cat-file -p 4dcfc45f36386b13a4d50fd7b9ab73102def216e`.

## lane 0 -- handler-nonzero failure at 2026-07-28T13:05:46Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 61e7fee1f6b2be35b9a95091ddac9c5c155c9181
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'endo-byte-array-press-20260728-130502' handler exited rc=1

Inspect via `git -C journal cat-file -p 61e7fee1f6b2be35b9a95091ddac9c5c155c9181`.

## lane 0 -- handler-nonzero failure at 2026-07-28T13:06:07Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 5f2d98a0625dea79c52ed8c623d70d61987bec2c
- Context: gardener-3 on endolin-garden2-5bcdff64: job 'endo-sturdyref-press-20260728-130502' handler exited rc=1

Inspect via `git -C journal cat-file -p 5f2d98a0625dea79c52ed8c623d70d61987bec2c`.

## lane 0 -- handler-nonzero failure at 2026-07-28T13:06:24Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: d5e4a609652a4c8f08460d456aaf88aab2a0ff15
- Context: gardener-4 on endolin-garden2-5bcdff64: job 'endo-npm-cas-registry-press-20260728-130502' handler exited rc=1

Inspect via `git -C journal cat-file -p d5e4a609652a4c8f08460d456aaf88aab2a0ff15`.

## lane 0 -- handler-nonzero failure at 2026-07-28T13:06:54Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 13da40005db51338ebe13bf821ddccb8497b5811
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'finbot-progress-20260728-130502' handler exited rc=1

Inspect via `git -C journal cat-file -p 13da40005db51338ebe13bf821ddccb8497b5811`.

## lane 0 -- handler-nonzero failure at 2026-07-28T13:07:19Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e755042170c3164bc5a710b383b90143cbc1342a
- Context: gardener-4 on endolin-garden2-5bcdff64: job 'ocapn-noise-press-20260728-130502' handler exited rc=1

Inspect via `git -C journal cat-file -p e755042170c3164bc5a710b383b90143cbc1342a`.

## lane 0 -- handler-nonzero failure at 2026-07-28T14:45:24Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1eb7d1d2231589cc7c9c350b4860732ba3434526
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr825-review-18fde0da' handler exited rc=1

Inspect via `git -C journal cat-file -p 1eb7d1d2231589cc7c9c350b4860732ba3434526`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-28T16:48:18Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 67610b7ff59f283d2106f5c51124861238511109
- Context: gardener-7 on endolin-garden2-5bcdff64: job 'finbot-pr4-panel-20260728' exit-0-unsatisfying but elapsed near-constant (210,210s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 67610b7ff59f283d2106f5c51124861238511109`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-28T16:50:45Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 2eeab5ed4d72fffdd191bb7f3c1483dc1374d5df
- Context: gardener-4 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr881-shepherd' exit-0-unsatisfying but elapsed near-constant (361,361s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 2eeab5ed4d72fffdd191bb7f3c1483dc1374d5df`.

## lane 0 -- handler-nonzero failure at 2026-07-28T18:53:27Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: cb73a27d6edeac81474c15e6d14928dc789099ea
- Context: gardener-4 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr825-review-18fde0da' handler exited rc=1

Inspect via `git -C journal cat-file -p cb73a27d6edeac81474c15e6d14928dc789099ea`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-28T21:40:35Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 81c9603007997a8b7f46e4f54972dbbaffe25e70
- Context: gardener-8 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr705-fixer-changes-requested' exit-0-unsatisfying but elapsed near-constant (417,417s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 81c9603007997a8b7f46e4f54972dbbaffe25e70`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-29T02:18:18Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: b4e2435b702259acffa0011898d877b23e7b7b0d
- Context: gardener-8 on endolin-garden2-5bcdff64: job 'endo-cbor-adopt-ocapn-gauntlet' exit-0-unsatisfying but elapsed near-constant (193,193s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p b4e2435b702259acffa0011898d877b23e7b7b0d`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:43:45Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b7a840dbb20dfc0624d588c34511aeff590949fb
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr859-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p b7a840dbb20dfc0624d588c34511aeff590949fb`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:45:05Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b7a840dbb20dfc0624d588c34511aeff590949fb
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr860-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p b7a840dbb20dfc0624d588c34511aeff590949fb`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:45:20Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b7a840dbb20dfc0624d588c34511aeff590949fb
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr882-panel-fix-1' handler exited rc=1

Inspect via `git -C journal cat-file -p b7a840dbb20dfc0624d588c34511aeff590949fb`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:47:21Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b7a840dbb20dfc0624d588c34511aeff590949fb
- Context: gardener-5 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr876-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p b7a840dbb20dfc0624d588c34511aeff590949fb`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:53:50Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: d2f0c4a70c70426374c4ccabf5fdc8512d38f1f1
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'registry-immutable-byte-array-followup' handler exited rc=1

Inspect via `git -C journal cat-file -p d2f0c4a70c70426374c4ccabf5fdc8512d38f1f1`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:56:34Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b7a840dbb20dfc0624d588c34511aeff590949fb
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr869-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p b7a840dbb20dfc0624d588c34511aeff590949fb`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:57:24Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b7a840dbb20dfc0624d588c34511aeff590949fb
- Context: gardener-4 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr870-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p b7a840dbb20dfc0624d588c34511aeff590949fb`.

## lane 0 -- handler-nonzero failure at 2026-07-29T03:06:03Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b7a840dbb20dfc0624d588c34511aeff590949fb
- Context: gardener-7 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr558-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p b7a840dbb20dfc0624d588c34511aeff590949fb`.

## lane 0 -- handler-nonzero failure at 2026-07-29T03:06:19Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b7a840dbb20dfc0624d588c34511aeff590949fb
- Context: gardener-6 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr556-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p b7a840dbb20dfc0624d588c34511aeff590949fb`.

## lane 0 -- handler-nonzero failure at 2026-07-29T04:14:07Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b7a840dbb20dfc0624d588c34511aeff590949fb
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr340-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p b7a840dbb20dfc0624d588c34511aeff590949fb`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-29T07:33:22Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 60cc50d799317ccb69cc995a9549a9b24eb795db
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr241-review-b15e4ef6' exit-0-unsatisfying but elapsed near-constant (36,40s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 60cc50d799317ccb69cc995a9549a9b24eb795db`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-29T10:25:54Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 782f5fb23488619475be1e69604c9e0fd1ec39aa
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr723-conduct' exit-0-unsatisfying but elapsed near-constant (45,38s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 782f5fb23488619475be1e69604c9e0fd1ec39aa`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-29T10:28:43Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: a9b4defc13bf2cfbd3a92806b9319e18a45c743f
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr836-review-ee46b083' exit-0-unsatisfying but elapsed near-constant (32,31s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p a9b4defc13bf2cfbd3a92806b9319e18a45c743f`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-29T17:40:03Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 9d2c0ee8c7cc0f3a1ab1f4f728f9e575e355fd80
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'fix-botanist-scripts-enabled-install-gap-gauntlet' exit-0-unsatisfying but elapsed near-constant (29,25s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 9d2c0ee8c7cc0f3a1ab1f4f728f9e575e355fd80`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-30T09:23:27Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 6d99de3ffd800ae4169d1538f96a847fc0490268
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'finbot-pr5-panel-20260730' exit-0-unsatisfying but elapsed near-constant (15,19s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 6d99de3ffd800ae4169d1538f96a847fc0490268`.

## lane 0 -- handler-nonzero failure at 2026-07-30T11:01:17Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 29e2ebe27b6895af1676f3af19b1387dc8e23a9a
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'scholar-library-cycle-20260729-225002' handler exited rc=1

Inspect via `git -C journal cat-file -p 29e2ebe27b6895af1676f3af19b1387dc8e23a9a`.

## lane 0 -- handler-nonzero failure at 2026-07-30T20:23:27Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 3095d01493d869ad491323cac459d004f5004c34
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'build-endo-regexp-conservative-subset' handler exited rc=1

Inspect via `git -C journal cat-file -p 3095d01493d869ad491323cac459d004f5004c34`.

## lane 0 -- handler-nonzero failure at 2026-07-31T00:09:52Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 016358289bbaa07744411855bbf258c8d141231a
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'finbot-pr4-panel-rerun-20260728' handler exited rc=1

Inspect via `git -C journal cat-file -p 016358289bbaa07744411855bbf258c8d141231a`.

## lane 0 -- handler-nonzero failure at 2026-07-31T00:10:29Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: a54be6b662c573fa4b7c0ad9d95365840c45c7ab
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'finbot-pr5-panel-20260728' handler exited rc=1

Inspect via `git -C journal cat-file -p a54be6b662c573fa4b7c0ad9d95365840c45c7ab`.

## lane 0 -- handler-nonzero failure at 2026-07-31T00:11:50Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: d4ab2376a142f2be88d5eaf69bf9aa06c0117a3d
- Context: gardener-3 on endolin-garden2-5bcdff64: job 'finbot-pr4-panel-20260728' handler exited rc=1

Inspect via `git -C journal cat-file -p d4ab2376a142f2be88d5eaf69bf9aa06c0117a3d`.

## lane 0 -- handler-nonzero failure at 2026-07-31T00:12:24Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1a9235697244ce160a3d7d3425642428204de9e3
- Context: gardener-3 on endolin-garden2-5bcdff64: job 'finbot-pr5-panel-20260729' handler exited rc=1

Inspect via `git -C journal cat-file -p 1a9235697244ce160a3d7d3425642428204de9e3`.

## lane 0 -- handler-nonzero failure at 2026-07-31T00:33:42Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: a785f80572f65c692180ec821b5f5be57c003b03
- Context: gardener-3 on endolin-garden2-5bcdff64: job 'endo-cbor-adopt-daemon-envelope' handler exited rc=1

Inspect via `git -C journal cat-file -p a785f80572f65c692180ec821b5f5be57c003b03`.

## lane 0 -- handler-nonzero failure at 2026-07-31T00:34:02Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 3b245bcdb5f47d64b861c08f8ca2374d0458598b
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'finbot-pr6-panel-20260728' handler exited rc=1

Inspect via `git -C journal cat-file -p 3b245bcdb5f47d64b861c08f8ca2374d0458598b`.

## lane 0 -- handler-nonzero failure at 2026-07-31T00:34:11Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 7d3c700b8a2e77858df709a2a235cccbb0c91f28
- Context: gardener-4 on endolin-garden2-5bcdff64: job 'finbot-pr5-panel-20260729-195004' handler exited rc=1

Inspect via `git -C journal cat-file -p 7d3c700b8a2e77858df709a2a235cccbb0c91f28`.

## lane 0 -- handler-nonzero failure at 2026-07-31T00:34:46Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: f3e8e6adee94889b3e66340969a6ad5070f20dca
- Context: gardener-3 on endolin-garden2-5bcdff64: job 'finbot-progress-20260730-082002' handler exited rc=1

Inspect via `git -C journal cat-file -p f3e8e6adee94889b3e66340969a6ad5070f20dca`.

## lane 0 -- handler-nonzero failure at 2026-07-31T00:35:01Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1cb67df13d9f1f15f7b50a044a448830e637a9ef
- Context: gardener-4 on endolin-garden2-5bcdff64: job 'finbot-pr6-bind-coverage-evidence' handler exited rc=1

Inspect via `git -C journal cat-file -p 1cb67df13d9f1f15f7b50a044a448830e637a9ef`.

## lane 0 -- handler-nonzero failure at 2026-07-31T00:35:19Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ba62a23d57c8c2560578d5897ec7a996a1351dab
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'finbot-progress-20260730-143501' handler exited rc=1

Inspect via `git -C journal cat-file -p ba62a23d57c8c2560578d5897ec7a996a1351dab`.

## lane 0 -- handler-nonzero failure at 2026-07-31T00:36:06Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 373a76aabe174a14a289fab44010ce3a33cd9d0d
- Context: gardener-4 on endolin-garden2-5bcdff64: job 'finbot-progress-20260730-020502-gauntlet-clean' handler exited rc=1

Inspect via `git -C journal cat-file -p 373a76aabe174a14a289fab44010ce3a33cd9d0d`.

## lane 0 -- handler-nonzero failure at 2026-07-31T00:36:16Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: a31c37abac235cea4ae1c22844f974136a289c23
- Context: gardener-3 on endolin-garden2-5bcdff64: job 'garden-approval-reconciler-build' handler exited rc=1

Inspect via `git -C journal cat-file -p a31c37abac235cea4ae1c22844f974136a289c23`.

## lane 0 -- handler-nonzero failure at 2026-07-31T00:37:03Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1596572914dadeb1269dcb5d12ae5783e687b3ae
- Context: gardener-4 on endolin-garden2-5bcdff64: job 'finbot-progress-20260730-203502' handler exited rc=1

Inspect via `git -C journal cat-file -p 1596572914dadeb1269dcb5d12ae5783e687b3ae`.

## lane 0 -- handler-nonzero failure at 2026-07-31T00:37:47Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 565a63434684c990e27c6892852a39efa145e3b5
- Context: gardener-4 on endolin-garden2-5bcdff64: job 'fireworks-glm52-kimik3-build' handler exited rc=1

Inspect via `git -C journal cat-file -p 565a63434684c990e27c6892852a39efa145e3b5`.

## lane 0 -- handler-nonzero failure at 2026-07-31T00:38:19Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 08e81e84865f4bcdc712473ba10553b7069d71e3
- Context: gardener-4 on endolin-garden2-5bcdff64: job 'fix-botanist-scripts-enabled-install-gap-gauntlet' handler exited rc=1

Inspect via `git -C journal cat-file -p 08e81e84865f4bcdc712473ba10553b7069d71e3`.

## lane 0 -- handler-nonzero failure at 2026-08-01T10:24:32Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: a644bb2bf7c0e7659073730dba6bd77ce5337dc6
- Context: gardener-3 on endolin-garden2-5bcdff64: job 'garden-fireworks-glm52-register' handler exited rc=1

Inspect via `git -C journal cat-file -p a644bb2bf7c0e7659073730dba6bd77ce5337dc6`.

## lane 0 -- handler-nonzero failure at 2026-08-01T10:26:34Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ae7093e049c1ed16905f4089fa5db25472813773
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'finbot-pr6-panel-20260801' handler exited rc=1

Inspect via `git -C journal cat-file -p ae7093e049c1ed16905f4089fa5db25472813773`.

## lane 0 -- handler-nonzero failure at 2026-08-01T10:36:14Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: f86cb463220f1ef33d8fd01f96badd5047e36f77
- Context: gardener-5 on endolin-garden2-5bcdff64: job 'garden-widen-sysop-host-maintenance' handler exited rc=1

Inspect via `git -C journal cat-file -p f86cb463220f1ef33d8fd01f96badd5047e36f77`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-08-01T11:17:48Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: f97272a699b498346a97dc309affa95628a02b16
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'xs2rust-endor-watchdog-20260801-010501' transient-classified (rc=1) but elapsed near-constant (2,2s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p f97272a699b498346a97dc309affa95628a02b16`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-08-01T11:27:26Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 91aeafab8151da11b8f1cef8fcfa41e15adb1ec1
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'propose-merge-upstream-master-into-llm-20260801' transient-classified (rc=1) but elapsed near-constant (2,2s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 91aeafab8151da11b8f1cef8fcfa41e15adb1ec1`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-08-01T11:36:36Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 53574d13e20ac025906d411dad5aed2b61a42197
- Context: gardener-4 on endolin-garden2-5bcdff64: job 'proposal-compartments-press-20260731-192002' transient-classified (rc=1) but elapsed near-constant (2,2s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 53574d13e20ac025906d411dad5aed2b61a42197`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-08-01T11:45:36Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: a8b4b243a36639537e71657b438af97e6806a1ca
- Context: gardener-1 on endolin-garden2-5bcdff64: job 'pr-ebfb-877-bundle-endo-base64' transient-classified (rc=1) but elapsed near-constant (2,2s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p a8b4b243a36639537e71657b438af97e6806a1ca`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-08-01T11:45:58Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: d4a7ee27a798169fc556496974ef8919c716c256
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'registry-immutable-byte-array-followup-gauntlet-panel-1' transient-classified (rc=1) but elapsed near-constant (2,2s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p d4a7ee27a798169fc556496974ef8919c716c256`.

## lane 0 -- handler-nonzero failure at 2026-08-01T15:43:21Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 10634cf44187366ff9ca9cca7962ec9dc0c67717
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'finbot-pr6-panel-r3-20260801' handler exited rc=1

Inspect via `git -C journal cat-file -p 10634cf44187366ff9ca9cca7962ec9dc0c67717`.

## lane 0 -- handler-nonzero failure at 2026-08-06T05:53:58Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 10d7344cd836f1d0038c1da631e12272ebe9aaf3
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'garden-style-url-not-path' handler exited rc=1
- Capture: inboxes/endolin-garden2-5bcdff64/captures/10d7344cd836f1d0038c1da631e12272ebe9aaf3

Inspect via `git -C journal cat-file -p 10d7344cd836f1d0038c1da631e12272ebe9aaf3` (or read
`journal/inboxes/endolin-garden2-5bcdff64/captures/10d7344cd836f1d0038c1da631e12272ebe9aaf3`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-08-08T07:54:11Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 0019f76c72a50266669586f225acdedc4064ff3f
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'ironhorse-js-00-report-harness-foundation-gauntlet-panel-2' transient-classified (rc=1) but elapsed near-constant (4,3s) over 2 cycles — likely deterministic overrun, not a blip
- Capture: inboxes/endolin-garden2-5bcdff64/captures/0019f76c72a50266669586f225acdedc4064ff3f

Inspect via `git -C journal cat-file -p 0019f76c72a50266669586f225acdedc4064ff3f` (or read
`journal/inboxes/endolin-garden2-5bcdff64/captures/0019f76c72a50266669586f225acdedc4064ff3f`) -- both work off-host after a plain `journal2` fetch.
