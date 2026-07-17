---
host: endolin-garden-ece02cb4
role: gardener
last_drained_at: 1970-01-01T00:00:00Z
last_drained_commit:
---

# gardener inbox state on endolin-garden-ece02cb4

Append-only failure log. Each section is a discrete failure event
appended by a job-board service or worker via
`skills/gardener-inbox-error-reporting/report-error.sh`. The gardener
reads entries on its next dispatch.


## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-06T12:36:22Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 386f3771f0e504b5d78d2439b887bd708efc7b24
- Context: gardener-15 on endolin-garden-ece02cb4: job 'pr-ebfb-286-shepherd' exit-0-unsatisfying but elapsed near-constant (179,179s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 386f3771f0e504b5d78d2439b887bd708efc7b24`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-06T22:06:52Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: ddf19dff486ab0b558b9b8cbd368a345044cdb59
- Context: gardener-9 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr615-gauntlet' exit-0-unsatisfying but elapsed near-constant (201,201s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p ddf19dff486ab0b558b9b8cbd368a345044cdb59`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-06T23:08:27Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: e729813ec647f015d0e4fbb88ab6b9a1af0e5de4
- Context: gardener-12 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr616-gauntlet' exit-0-unsatisfying but elapsed near-constant (881,881s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p e729813ec647f015d0e4fbb88ab6b9a1af0e5de4`.

## lane 0 -- handler-nonzero failure at 2026-07-10T08:07:00Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b0a1225026f36f1f388e4b212c220b80e8448786
- Context: gardener-13 on endolin-garden-ece02cb4: job 'self-heal-fix-garden-triager-kriscendobot-endo-revparse-verify' handler exited rc=1

Inspect via `git -C journal cat-file -p b0a1225026f36f1f388e4b212c220b80e8448786`.

## lane 0 -- handler-nonzero failure at 2026-07-10T08:35:40Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 6f9794aaa0ba08ac0d3ca49b21e919641eeb92b1
- Context: gardener-17 on endolin-garden-ece02cb4: job 'xst-validation-orchestrator-20260710-083510' handler exited rc=1

Inspect via `git -C journal cat-file -p 6f9794aaa0ba08ac0d3ca49b21e919641eeb92b1`.

## lane 0 -- handler-nonzero failure at 2026-07-10T08:43:40Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b0a1225026f36f1f388e4b212c220b80e8448786
- Context: gardener-4 on endolin-garden-ece02cb4: job 'kriscendobot-agoric-sdk-pr14-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p b0a1225026f36f1f388e4b212c220b80e8448786`.

## lane 0 -- handler-nonzero failure at 2026-07-10T09:05:16Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b0a1225026f36f1f388e4b212c220b80e8448786
- Context: gardener-13 on endolin-garden-ece02cb4: job 'kriscendobot-agoric-sdk-pr13-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p b0a1225026f36f1f388e4b212c220b80e8448786`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-10T11:55:52Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 4eb62734ebabd7ab4b8b87ac5fa1b6cfab81dea6
- Context: gardener-15 on endolin-garden-ece02cb4: job 'kriscendobot-agoric-sdk-pr14-fix-chaininfo-snapshots' exit-0-unsatisfying but elapsed near-constant (148,148s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 4eb62734ebabd7ab4b8b87ac5fa1b6cfab81dea6`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-10T12:34:16Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: be7f5ba9b7dfdd89fe3ab6ddabda9ef71f550c03
- Context: gardener-18 on endolin-garden-ece02cb4: job 'kriscendobot-agoric-sdk-pr13-fix-chaininfo-snapshots' exit-0-unsatisfying but elapsed near-constant (646,646s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p be7f5ba9b7dfdd89fe3ab6ddabda9ef71f550c03`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-10T15:44:06Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: a184ce2cb49ea67f491f858a1b23ebf92a1ddca9
- Context: gardener-6 on endolin-garden-ece02cb4: job 'gauntlet-endo-but-for-bots-pull-request-667-genie-stdio-jsonl-rpc-bridge' exit-0-unsatisfying but elapsed near-constant (37,37s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p a184ce2cb49ea67f491f858a1b23ebf92a1ddca9`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-10T17:28:05Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: e02c7978c47e9ee7a4678c67ddc743981852e9c2
- Context: gardener-3 on endolin-garden-ece02cb4: job 'gauntlet-endo-but-for-bots-pull-request-672-genie-subscription-oauth' transient-classified (rc=1) but elapsed near-constant (252,252s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p e02c7978c47e9ee7a4678c67ddc743981852e9c2`.

## lane 0 -- handler-nonzero failure at 2026-07-10T17:33:36Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: be6fc8fbd936bd0e38373d8fda3d1e35f8b421f5
- Context: gardener-4 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr650-conduct' handler exited rc=1

Inspect via `git -C journal cat-file -p be6fc8fbd936bd0e38373d8fda3d1e35f8b421f5`.

## lane 0 -- handler-nonzero failure at 2026-07-10T17:38:57Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 5633f3c3cc1a5ac8402712ab69abfa27db82d394
- Context: gardener-1 on endolin-garden-ece02cb4: job 'readme-control-surface-illustrations' handler exited rc=1

Inspect via `git -C journal cat-file -p 5633f3c3cc1a5ac8402712ab69abfa27db82d394`.

## lane 0 -- handler-nonzero failure at 2026-07-10T17:46:25Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: be68bd60cf955c59acac52dad67aa7f8a09da278
- Context: gardener-1 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr618-6a3affe0' handler exited rc=1

Inspect via `git -C journal cat-file -p be68bd60cf955c59acac52dad67aa7f8a09da278`.

## lane 0 -- handler-nonzero failure at 2026-07-10T18:03:25Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: c1e61cf3848a559a6b3d83d14dcddf2403332d4e
- Context: gardener-4 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr592-01edab2b' handler exited rc=1

Inspect via `git -C journal cat-file -p c1e61cf3848a559a6b3d83d14dcddf2403332d4e`.

## lane 0 -- handler-nonzero failure at 2026-07-10T18:05:52Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1615c49ff023c4213899e7f3d9f5f9c2b625c1cc
- Context: gardener-1 on endolin-garden-ece02cb4: job 'xst-validation-orchestrator-20260710-180513' handler exited rc=1

Inspect via `git -C journal cat-file -p 1615c49ff023c4213899e7f3d9f5f9c2b625c1cc`.

## lane 0 -- handler-nonzero failure at 2026-07-10T18:23:36Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: dab2671ab8ce6b2afd159b272f82b676c96375eb
- Context: gardener-18 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr288-gauntlet' handler exited rc=1

Inspect via `git -C journal cat-file -p dab2671ab8ce6b2afd159b272f82b676c96375eb`.

## lane 0 -- handler-nonzero failure at 2026-07-10T18:33:45Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 6804788965c20e3603707c73c37abb3066f7abcb
- Context: gardener-1 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr650-conduct' handler exited rc=1

Inspect via `git -C journal cat-file -p 6804788965c20e3603707c73c37abb3066f7abcb`.

## lane 0 -- handler-nonzero failure at 2026-07-10T18:43:19Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 0942e4ba602a0c54fbff8485cc237f0865415519
- Context: gardener-8 on endolin-garden-ece02cb4: job 'readme-control-surface-illustrations' handler exited rc=1

Inspect via `git -C journal cat-file -p 0942e4ba602a0c54fbff8485cc237f0865415519`.

## lane 0 -- handler-nonzero failure at 2026-07-10T18:50:23Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: be68bd60cf955c59acac52dad67aa7f8a09da278
- Context: gardener-13 on endolin-garden-ece02cb4: job 'esheets-supervisor-20260710-185003' handler exited rc=1

Inspect via `git -C journal cat-file -p be68bd60cf955c59acac52dad67aa7f8a09da278`.

## lane 0 -- handler-nonzero failure at 2026-07-10T19:05:44Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 6deba42b8e9c3be1fc36a48c46d636c35fcb45db
- Context: gardener-6 on endolin-garden-ece02cb4: job 'xst-validation-orchestrator-20260710-190513' handler exited rc=1

Inspect via `git -C journal cat-file -p 6deba42b8e9c3be1fc36a48c46d636c35fcb45db`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-10T19:47:20Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 58e4389987c7fa16a5f53902e1816efe44930bb6
- Context: gardener-12 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr650-conduct' exit-0-unsatisfying but elapsed near-constant (211,211s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 58e4389987c7fa16a5f53902e1816efe44930bb6`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-11T10:33:54Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: efc82597f16aa2fc007ad6c9e5a1ca22c2f2ca5b
- Context: gardener-13 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr684-shepherd' exit-0-unsatisfying but elapsed near-constant (29,29s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p efc82597f16aa2fc007ad6c9e5a1ca22c2f2ca5b`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-12T04:13:50Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 7a481d73197b31a36ddea5ba5ec036f8401287d3
- Context: gardener-7 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr704-shepherd' exit-0-unsatisfying but elapsed near-constant (27,27s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 7a481d73197b31a36ddea5ba5ec036f8401287d3`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-12T04:14:01Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 0d69735cdbc01f7d5725188ed55c4bdc0d791032
- Context: gardener-12 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr703-shepherd' exit-0-unsatisfying but elapsed near-constant (34,34s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 0d69735cdbc01f7d5725188ed55c4bdc0d791032`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-12T07:25:08Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 37013ad6ce367ddd04b0d4f7b86b15fd8c2e9f8c
- Context: gardener-7 on endolin-garden-ece02cb4: job 'endo-sturdyref-press-20260712-065004' exit-0-unsatisfying but elapsed near-constant (101,101s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 37013ad6ce367ddd04b0d4f7b86b15fd8c2e9f8c`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-12T10:04:10Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: b23d2d6b365b6fed96a5386cd237f3f607476ef8
- Context: gardener-15 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr707-shepherd' exit-0-unsatisfying but elapsed near-constant (31,31s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p b23d2d6b365b6fed96a5386cd237f3f607476ef8`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-12T21:13:56Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 42579683b681950c64d6ddc9fe5b9b99659ae7c2
- Context: gardener-20 on endolin-garden-ece02cb4: job 'deadmail-issue-comment-4952694523' exit-0-unsatisfying but elapsed near-constant (34,34s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 42579683b681950c64d6ddc9fe5b9b99659ae7c2`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-13T15:44:40Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 0630c8598de25f566d3acd33facbcfe8e9cb884a
- Context: gardener-18 on endolin-garden-ece02cb4: job 'fix-kriscendobot-agoric-sdk-16' exit-0-unsatisfying but elapsed near-constant (41,41s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 0630c8598de25f566d3acd33facbcfe8e9cb884a`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-13T16:38:08Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 516b04864a9096c6949aaaa8fc09ec7c03262611
- Context: gardener-13 on endolin-garden-ece02cb4: job 'gauntlet-endo-but-for-bots-pull-request-707-git-capability-worked-version-controlled-filesystem-loop' transient-classified (rc=1) but elapsed near-constant (278,278s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 516b04864a9096c6949aaaa8fc09ec7c03262611`.

## lane 0 -- handler-nonzero failure at 2026-07-13T16:43:19Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 5c2b64e286d0e43e68587f117d357c0f4832ec55
- Context: gardener-11 on endolin-garden-ece02cb4: job 'kriscendobot-agoric-sdk-pr16-review-77ecb195' handler exited rc=1

Inspect via `git -C journal cat-file -p 5c2b64e286d0e43e68587f117d357c0f4832ec55`.

## lane 0 -- handler-nonzero failure at 2026-07-13T17:20:30Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4c8633cd0a7a0475459eff511edecf67eac93f95
- Context: gardener-7 on endolin-garden-ece02cb4: job 'deadmail-issue-comment-4960632792' handler exited rc=1

Inspect via `git -C journal cat-file -p 4c8633cd0a7a0475459eff511edecf67eac93f95`.

## lane 0 -- handler-nonzero failure at 2026-07-13T17:35:34Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 5bf54d2bb5ab16d4686a2f319db1646fee220f0e
- Context: gardener-5 on endolin-garden-ece02cb4: job 'endo-sturdyref-press-20260713-173502' handler exited rc=1

Inspect via `git -C journal cat-file -p 5bf54d2bb5ab16d4686a2f319db1646fee220f0e`.

## lane 0 -- handler-nonzero failure at 2026-07-13T17:50:54Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4c8633cd0a7a0475459eff511edecf67eac93f95
- Context: gardener-17 on endolin-garden-ece02cb4: job 'agoric-sdk-pr9-drive-20260713-175015' handler exited rc=1

Inspect via `git -C journal cat-file -p 4c8633cd0a7a0475459eff511edecf67eac93f95`.

## lane 0 -- handler-nonzero failure at 2026-07-13T17:53:17Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 8dcb8cb7d2c64e12eba360d77b2e18ed29ece05d
- Context: gardener-17 on endolin-garden-ece02cb4: job 'gauntlet-endo-but-for-bots-pull-request-707-git-capability-worked-version-controlled-filesystem-loop' handler exited rc=1

Inspect via `git -C journal cat-file -p 8dcb8cb7d2c64e12eba360d77b2e18ed29ece05d`.

## lane 0 -- handler-nonzero failure at 2026-07-13T17:53:30Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1f663ddec9bb63f85992d9cf7b8098d0fd517e74
- Context: gardener-14 on endolin-garden-ece02cb4: job 'deadmail-issue-comment-4960246553' handler exited rc=1

Inspect via `git -C journal cat-file -p 1f663ddec9bb63f85992d9cf7b8098d0fd517e74`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-13T19:06:35Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 37aa653271a813a9a24d46b8e988670785b91af3
- Context: gardener-13 on endolin-garden-ece02cb4: job 'gauntlet-endo-but-for-bots-pull-request-721-endo-reminder-message-scheduler-plugin' exit-0-unsatisfying but elapsed near-constant (171,171s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 37aa653271a813a9a24d46b8e988670785b91af3`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-13T20:24:23Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 7acb66e5dd4eb645f150c94edfb91a70cdaadc98
- Context: gardener-1 on endolin-garden-ece02cb4: job 'kriscendobot-agoric-sdk-pr17-shepherd' exit-0-unsatisfying but elapsed near-constant (49,49s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 7acb66e5dd4eb645f150c94edfb91a70cdaadc98`.

## lane 0 -- handler-nonzero failure at 2026-07-14T03:21:01Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 48b72015cb81891130a6611f645d8b5c05c01795
- Context: gardener-1 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr706-review-7a1d9ca9' handler exited rc=1

Inspect via `git -C journal cat-file -p 48b72015cb81891130a6611f645d8b5c05c01795`.

## lane 0 -- handler-nonzero failure at 2026-07-14T06:05:46Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ea5b6cd20432557738fed642e10f113df8444a8e
- Context: gardener-10 on endolin-garden-ece02cb4: job 'kriscendobot-agoric-sdk-pr16-review-d584f885' handler exited rc=1

Inspect via `git -C journal cat-file -p ea5b6cd20432557738fed642e10f113df8444a8e`.

## lane 0 -- handler-nonzero failure at 2026-07-14T06:50:04Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: a034d6e891148248b8b212070a2d3bc60238cacd
- Context: gardener-5 on endolin-garden-ece02cb4: job 'test-hermit-local-inference-garden2' handler exited rc=1

Inspect via `git -C journal cat-file -p a034d6e891148248b8b212070a2d3bc60238cacd`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-14T16:34:34Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 9a8f11741819799a054b9dc49e0f2387ba861827
- Context: gardener-9 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr723-shepherd' exit-0-unsatisfying but elapsed near-constant (779,779s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 9a8f11741819799a054b9dc49e0f2387ba861827`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-16T18:34:21Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 3819a42abd222a211bf7c4bc2f5d6c4409202520
- Context: gardener-2 on endolin-garden-ece02cb4: job 'endo-git-integration-press-20260716-175014' exit-0-unsatisfying but elapsed near-constant (44,44s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 3819a42abd222a211bf7c4bc2f5d6c4409202520`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-17T00:27:03Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 0e4885d62977a3a0ac7a25cb3f1aa3c4398c376f
- Context: gardener-20 on endolin-garden-ece02cb4: job 'mirror-endo-2780-cache-globals-gauntlet' exit-0-unsatisfying but elapsed near-constant (180,180s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 0e4885d62977a3a0ac7a25cb3f1aa3c4398c376f`.

## lane 0 -- handler-nonzero failure at 2026-07-17T00:33:28Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1873a9acc83cad683ae08d864dde3c4556870838
- Context: gardener-20 on endolin-garden-ece02cb4: job 'mirror-endo-2780-cache-globals-gauntlet' handler exited rc=1

Inspect via `git -C journal cat-file -p 1873a9acc83cad683ae08d864dde3c4556870838`.

## lane 0 -- handler-nonzero failure at 2026-07-17T00:35:42Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e6fe0633def09ec1789110e5aee2000ef48d1ea7
- Context: gardener-16 on endolin-garden-ece02cb4: job 'endo-sturdyref-press-20260717-003509' handler exited rc=1

Inspect via `git -C journal cat-file -p e6fe0633def09ec1789110e5aee2000ef48d1ea7`.

## lane 0 -- handler-nonzero failure at 2026-07-17T00:37:29Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ac1a1d97f4b68e6df517c94e30257268e09f2b12
- Context: gardener-12 on endolin-garden-ece02cb4: job 'ebfb-retire-master-pr-719' handler exited rc=1

Inspect via `git -C journal cat-file -p ac1a1d97f4b68e6df517c94e30257268e09f2b12`.

## lane 0 -- handler-nonzero failure at 2026-07-17T00:43:20Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 8f883eab01d496804bdde7e4fabb5ed09ff54de4
- Context: gardener-8 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr760-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 8f883eab01d496804bdde7e4fabb5ed09ff54de4`.
