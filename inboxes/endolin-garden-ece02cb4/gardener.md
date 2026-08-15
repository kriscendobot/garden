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

## lane 0 -- handler-nonzero failure at 2026-07-17T00:43:48Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ac1a1d97f4b68e6df517c94e30257268e09f2b12
- Context: gardener-10 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr737-review-3363fee9' handler exited rc=1

Inspect via `git -C journal cat-file -p ac1a1d97f4b68e6df517c94e30257268e09f2b12`.

## lane 0 -- handler-nonzero failure at 2026-07-17T00:45:09Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ac1a1d97f4b68e6df517c94e30257268e09f2b12
- Context: gardener-16 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr598-a5ffa84f' handler exited rc=1

Inspect via `git -C journal cat-file -p ac1a1d97f4b68e6df517c94e30257268e09f2b12`.

## lane 0 -- handler-nonzero failure at 2026-07-17T01:03:29Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ac1a1d97f4b68e6df517c94e30257268e09f2b12
- Context: gardener-11 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr762-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p ac1a1d97f4b68e6df517c94e30257268e09f2b12`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-17T01:03:55Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 6f6a6f7c9dca67d8221f3eb4762fed71e7016657
- Context: gardener-2 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr755-shepherd' exit-0-unsatisfying but elapsed near-constant (15,15s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 6f6a6f7c9dca67d8221f3eb4762fed71e7016657`.

## lane 0 -- handler-nonzero failure at 2026-07-17T01:13:14Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 0b2d51d0660cccfc58b60a50da023f8dea3b56a2
- Context: gardener-8 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr755-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 0b2d51d0660cccfc58b60a50da023f8dea3b56a2`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-17T03:44:11Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 5b61f2141ea367332694811aac493e7b5b000c48
- Context: gardener-4 on endolin-garden-ece02cb4: job 'migrate-endo-but-for-bots-master-to-pnpm' exit-0-unsatisfying but elapsed near-constant (47,47s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 5b61f2141ea367332694811aac493e7b5b000c48`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-17T04:36:41Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 941bf7521fe0d604fc0a8e45041b51926804fe20
- Context: gardener-5 on endolin-garden-ece02cb4: job 'ocapn-noise-press-20260717-000503' exit-0-unsatisfying but elapsed near-constant (161,161s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 941bf7521fe0d604fc0a8e45041b51926804fe20`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-17T05:11:27Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: b31dd17a99aad2a5ce06c497be3a1775abbd8dfa
- Context: gardener-2 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr760-shepherd' exit-0-unsatisfying but elapsed near-constant (1052,1052s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p b31dd17a99aad2a5ce06c497be3a1775abbd8dfa`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-17T05:41:12Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: ad3d2dbbf6157f4076be101392732958de4ac904
- Context: gardener-1 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr762-shepherd' exit-0-unsatisfying but elapsed near-constant (437,437s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p ad3d2dbbf6157f4076be101392732958de4ac904`.

## lane 0 -- handler-nonzero failure at 2026-07-17T06:12:14Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 87498befa0381e3e46e25af90b7a9536912c2db1
- Context: gardener-20 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr779-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 87498befa0381e3e46e25af90b7a9536912c2db1`.

## lane 0 -- handler-nonzero failure at 2026-07-17T06:13:48Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ec60472dea61ee47d4864788c243e0bb9c4dfdb3
- Context: gardener-5 on endolin-garden-ece02cb4: job 'scholar-package-json-package-managers' handler exited rc=1

Inspect via `git -C journal cat-file -p ec60472dea61ee47d4864788c243e0bb9c4dfdb3`.

## lane 0 -- handler-nonzero failure at 2026-07-17T06:23:41Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 9e63de5a23255b1bef41d4167fd4233725ef72f0
- Context: gardener-11 on endolin-garden-ece02cb4: job 'endo-byte-array-press-20260717-060503' handler exited rc=1

Inspect via `git -C journal cat-file -p 9e63de5a23255b1bef41d4167fd4233725ef72f0`.

## lane 0 -- handler-nonzero failure at 2026-07-17T06:33:41Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 87498befa0381e3e46e25af90b7a9536912c2db1
- Context: gardener-1 on endolin-garden-ece02cb4: job 'ebfb-retire-master-pr-353' handler exited rc=1

Inspect via `git -C journal cat-file -p 87498befa0381e3e46e25af90b7a9536912c2db1`.

## lane 0 -- handler-nonzero failure at 2026-07-17T06:53:16Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: c4b9690c04408aba3aa6d7cb4d4cd537c8ae1d04
- Context: gardener-14 on endolin-garden-ece02cb4: job 'endo-git-integration-press-20260717-060503' handler exited rc=1

Inspect via `git -C journal cat-file -p c4b9690c04408aba3aa6d7cb4d4cd537c8ae1d04`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-17T07:02:18Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: eced37840e6f6d79301eeddd3352d162f65c3448
- Context: gardener-1 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr771-shepherd' exit-0-unsatisfying but elapsed near-constant (1732,1732s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p eced37840e6f6d79301eeddd3352d162f65c3448`.

## lane 0 -- handler-nonzero failure at 2026-07-17T07:03:17Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: d0ce6610b51b0d4c9fc8a8ca2a066ce556c788c5
- Context: gardener-12 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr771-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p d0ce6610b51b0d4c9fc8a8ca2a066ce556c788c5`.

## lane 0 -- handler-nonzero failure at 2026-07-17T07:20:32Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 5cfeb0a9348e9a3e533495d74cb83e658894ee7c
- Context: gardener-8 on endolin-garden-ece02cb4: job 'endo-sturdyref-press-20260717-072004' handler exited rc=1

Inspect via `git -C journal cat-file -p 5cfeb0a9348e9a3e533495d74cb83e658894ee7c`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-17T10:29:45Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 83c2dd76c77f95b450241dac8d32792a78f002d1
- Context: gardener-19 on endolin-garden-ece02cb4: job 'endo-vfs-parity-press-20260717-060503' exit-0-unsatisfying but elapsed near-constant (353,353s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 83c2dd76c77f95b450241dac8d32792a78f002d1`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-17T12:08:47Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: dec9184ce46e723bd880673ce16f69aa542f9c18
- Context: gardener-5 on endolin-garden-ece02cb4: job 'xs2rust-endor-stage8-cxs-baseline' exit-0-unsatisfying but elapsed near-constant (898,898s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p dec9184ce46e723bd880673ce16f69aa542f9c18`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-17T12:26:28Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: d3629ba536b0073fb0f3d9775c8e19e9007b6d8b
- Context: gardener-7 on endolin-garden-ece02cb4: job 'xs2rust-endor-stage8-cxs-baseline' transient-classified (rc=1) but elapsed near-constant (177,177s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p d3629ba536b0073fb0f3d9775c8e19e9007b6d8b`.

## lane 0 -- handler-nonzero failure at 2026-07-17T12:30:01Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b3d59011cf513cc2d05637daff9704359fc5c5d2
- Context: gardener-12 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr250-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p b3d59011cf513cc2d05637daff9704359fc5c5d2`.

## lane 0 -- handler-nonzero failure at 2026-07-17T12:36:27Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 6fc093ddfc9d40ab6e609d8cc5cdff1345e5e16c
- Context: gardener-17 on endolin-garden-ece02cb4: job 'port-xs-to-rust-memory-safe-engine-s24' handler exited rc=1

Inspect via `git -C journal cat-file -p 6fc093ddfc9d40ab6e609d8cc5cdff1345e5e16c`.

## lane 0 -- handler-nonzero failure at 2026-07-17T12:37:26Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b3d59011cf513cc2d05637daff9704359fc5c5d2
- Context: gardener-15 on endolin-garden-ece02cb4: job 'ebfb-retire-master-pr-182' handler exited rc=1

Inspect via `git -C journal cat-file -p b3d59011cf513cc2d05637daff9704359fc5c5d2`.

## lane 0 -- handler-nonzero failure at 2026-07-17T18:20:45Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1f6753a8dc5a05878c2907e441cc56a93883a9f6
- Context: gardener-14 on endolin-garden-ece02cb4: job 'endo-daemon-data-plane-press-20260717-182002' handler exited rc=1

Inspect via `git -C journal cat-file -p 1f6753a8dc5a05878c2907e441cc56a93883a9f6`.

## lane 0 -- handler-nonzero failure at 2026-07-17T18:26:37Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 088b4481cc137de725a19712eb3948c7a7daefbc
- Context: gardener-6 on endolin-garden-ece02cb4: job 'port-xs-to-rust-memory-safe-engine-s25' handler exited rc=1

Inspect via `git -C journal cat-file -p 088b4481cc137de725a19712eb3948c7a7daefbc`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-17T22:57:38Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: a1055ad502f89b0dd0e9aa7c540f606ce32508b0
- Context: gardener-6 on endolin-garden-ece02cb4: job 'port-xs-to-rust-memory-safe-engine-s25' exit-0-unsatisfying but elapsed near-constant (244,244s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p a1055ad502f89b0dd0e9aa7c540f606ce32508b0`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-18T12:54:17Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: ffeabd6e2864ed891bf71b4948f5e3f84de7fb96
- Context: gardener-1 on endolin-garden-ece02cb4: job 'endo-vfs-parity-press-20260718-122003' exit-0-unsatisfying but elapsed near-constant (52,52s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p ffeabd6e2864ed891bf71b4948f5e3f84de7fb96`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-18T13:53:44Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 0ae775701f1cdbf10d475f8b9d2ad3bad4c01c75
- Context: gardener-3 on endolin-garden-ece02cb4: job 'design-endo-content-plane-git-http' exit-0-unsatisfying but elapsed near-constant (18,18s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 0ae775701f1cdbf10d475f8b9d2ad3bad4c01c75`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-18T20:46:55Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 14d5bde5b4eab239b903d11e1d832de345f979dc
- Context: gardener-12 on endolin-garden-ece02cb4: job 'xs2rust-endor-stage10c-remeasure' exit-0-unsatisfying but elapsed near-constant (211,211s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 14d5bde5b4eab239b903d11e1d832de345f979dc`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-19T01:03:57Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: c19c65c6ada1918a7704ee1394c074e1bff04798
- Context: gardener-14 on endolin-garden-ece02cb4: job 'ocapn-noise-press-20260719-003513' exit-0-unsatisfying but elapsed near-constant (29,29s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p c19c65c6ada1918a7704ee1394c074e1bff04798`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-20T07:12:43Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 123185c1d12d5660e22cd32f3d923e40aacc5e78
- Context: gardener-6 on endolin-garden-ece02cb4: job 'xs2rust-endor-stage10n-remeasure' exit-0-unsatisfying but elapsed near-constant (542,542s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 123185c1d12d5660e22cd32f3d923e40aacc5e78`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-20T07:50:25Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: bec9c8763dd597ccb3e7a32c7702114e32a1dbeb
- Context: gardener-10 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr160-fixer' exit-0-unsatisfying but elapsed near-constant (409,409s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p bec9c8763dd597ccb3e7a32c7702114e32a1dbeb`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-20T11:46:44Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: a07a331d68717b0eac46ddbbd72162975f6f1720
- Context: gardener-7 on endolin-garden-ece02cb4: job 'xs2rust-endor-stage10p-fresh-env-sweep' exit-0-unsatisfying but elapsed near-constant (792,792s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p a07a331d68717b0eac46ddbbd72162975f6f1720`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-22T00:43:48Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: fc439ae66503b654bdceb2a80e41e4b13f144330
- Context: gardener-19 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr819-shepherd' exit-0-unsatisfying but elapsed near-constant (23,23s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p fc439ae66503b654bdceb2a80e41e4b13f144330`.

## lane 0 -- handler-nonzero failure at 2026-07-22T07:19:09Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 318da18ccc2950e98aea55a8f586c4e653ad3f30
- Context: gardener-10 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr160-review-b7e466e9' handler exited rc=1

Inspect via `git -C journal cat-file -p 318da18ccc2950e98aea55a8f586c4e653ad3f30`.

## lane 0 -- handler-nonzero failure at 2026-07-22T09:05:17Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 38fd5edbdfeefc77b6b2586c6f13398b1cd74c1c
- Context: gardener-15 on endolin-garden-ece02cb4: job 'minion-town-daemon-guest-mcp-b2' handler exited rc=1

Inspect via `git -C journal cat-file -p 38fd5edbdfeefc77b6b2586c6f13398b1cd74c1c`.

## lane 0 -- handler-nonzero failure at 2026-07-22T09:16:42Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 77e59dff5cd6e0d4a140644cb3862a9547d7c32c
- Context: gardener-19 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr804-47b714b2' handler exited rc=1

Inspect via `git -C journal cat-file -p 77e59dff5cd6e0d4a140644cb3862a9547d7c32c`.

## lane 0 -- handler-nonzero failure at 2026-07-22T09:50:32Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 46a77a1a806b4edde845b38dec3a3fee2a4fe3cf
- Context: gardener-7 on endolin-garden-ece02cb4: job 'endo-byte-array-press-20260722-095006' handler exited rc=1

Inspect via `git -C journal cat-file -p 46a77a1a806b4edde845b38dec3a3fee2a4fe3cf`.

## lane 0 -- handler-nonzero failure at 2026-07-22T09:51:23Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1296f659ea5dcc4b11a5d8ebae9f622a183af279
- Context: gardener-3 on endolin-garden-ece02cb4: job 'endo-sturdyref-press-20260722-095006' handler exited rc=1

Inspect via `git -C journal cat-file -p 1296f659ea5dcc4b11a5d8ebae9f622a183af279`.

## lane 0 -- handler-nonzero failure at 2026-07-22T09:53:38Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 77e59dff5cd6e0d4a140644cb3862a9547d7c32c
- Context: gardener-4 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr806-conduct' handler exited rc=1

Inspect via `git -C journal cat-file -p 77e59dff5cd6e0d4a140644cb3862a9547d7c32c`.

## lane 0 -- handler-nonzero failure at 2026-07-22T11:13:34Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 77e59dff5cd6e0d4a140644cb3862a9547d7c32c
- Context: gardener-10 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr160-review-b7e466e9' handler exited rc=1

Inspect via `git -C journal cat-file -p 77e59dff5cd6e0d4a140644cb3862a9547d7c32c`.

## lane 0 -- handler-nonzero failure at 2026-07-22T11:43:26Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 77e59dff5cd6e0d4a140644cb3862a9547d7c32c
- Context: gardener-9 on endolin-garden-ece02cb4: job 'minion-town-pr13-75344d2-build-mcp-daemon-guest-tools' handler exited rc=1

Inspect via `git -C journal cat-file -p 77e59dff5cd6e0d4a140644cb3862a9547d7c32c`.

## lane 0 -- handler-nonzero failure at 2026-07-22T13:13:21Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 53b917f907ea56805fcfbf99e7b2f50c5fcc745f
- Context: gardener-19 on endolin-garden-ece02cb4: job 'issue-kriskowal-garden-36-refresh' handler exited rc=1

Inspect via `git -C journal cat-file -p 53b917f907ea56805fcfbf99e7b2f50c5fcc745f`.

## lane 0 -- handler-nonzero failure at 2026-07-22T13:23:15Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 0a3d6b2ab9f6fca4760c6a96c65cb0e400e08ff5
- Context: gardener-15 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr804-47b714b2' handler exited rc=1

Inspect via `git -C journal cat-file -p 0a3d6b2ab9f6fca4760c6a96c65cb0e400e08ff5`.

## lane 0 -- handler-nonzero failure at 2026-07-22T13:28:28Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 77e59dff5cd6e0d4a140644cb3862a9547d7c32c
- Context: gardener-8 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr824-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 77e59dff5cd6e0d4a140644cb3862a9547d7c32c`.

## lane 0 -- handler-nonzero failure at 2026-07-22T13:34:31Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 51400a4730cd3e1ea66e69460d1bb2af66b4d355
- Context: gardener-3 on endolin-garden-ece02cb4: job 'minion-town-daemon-guest-mcp-b4' handler exited rc=1

Inspect via `git -C journal cat-file -p 51400a4730cd3e1ea66e69460d1bb2af66b4d355`.

## lane 0 -- handler-nonzero failure at 2026-07-22T13:53:26Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ec59e511d32410d85ce5e7d74c2b5ce56fa9605a
- Context: gardener-20 on endolin-garden-ece02cb4: job 'ocapn-noise-press-20260722-095006' handler exited rc=1

Inspect via `git -C journal cat-file -p ec59e511d32410d85ce5e7d74c2b5ce56fa9605a`.

## lane 0 -- handler-nonzero failure at 2026-07-22T14:13:18Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 395d17d184cd6a70b7ace91fd9d4cbaa8fb7d310
- Context: gardener-20 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr806-conduct' handler exited rc=1

Inspect via `git -C journal cat-file -p 395d17d184cd6a70b7ace91fd9d4cbaa8fb7d310`.

## lane 0 -- handler-nonzero failure at 2026-07-22T14:44:10Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 77e59dff5cd6e0d4a140644cb3862a9547d7c32c
- Context: gardener-17 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr807-5e6eb4e5' handler exited rc=1

Inspect via `git -C journal cat-file -p 77e59dff5cd6e0d4a140644cb3862a9547d7c32c`.

## lane 0 -- handler-nonzero failure at 2026-07-22T14:45:33Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 77e59dff5cd6e0d4a140644cb3862a9547d7c32c
- Context: gardener-12 on endolin-garden-ece02cb4: job 'deadmail-issue-comment-5047612017' handler exited rc=1

Inspect via `git -C journal cat-file -p 77e59dff5cd6e0d4a140644cb3862a9547d7c32c`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-22T17:43:19Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 3968b7d29b2876b448eafec016a6c8d84ce1de57
- Context: gardener-15 on endolin-garden-ece02cb4: job 'minion-town-mcp-b4-full-facet-surface' exit-0-unsatisfying but elapsed near-constant (587,587s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 3968b7d29b2876b448eafec016a6c8d84ce1de57`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-22T18:04:33Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: b5db38399588d78a7e4e25676f496312ae36ca64
- Context: gardener-29 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr824-merge' exit-0-unsatisfying but elapsed near-constant (27,27s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p b5db38399588d78a7e4e25676f496312ae36ca64`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-22T18:05:17Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 1f628db859d4212001ed89645be1fc38eb023752
- Context: gardener-7 on endolin-garden-ece02cb4: job 'minion-town-daemon-guest-mcp-b4-gauntlet' exit-0-unsatisfying but elapsed near-constant (34,34s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 1f628db859d4212001ed89645be1fc38eb023752`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-22T18:26:31Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 6852f65fb6f363aaa776e8a9272247700b381816
- Context: gardener-9 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr806-conduct' exit-0-unsatisfying but elapsed near-constant (175,175s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 6852f65fb6f363aaa776e8a9272247700b381816`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-22T19:13:39Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 70807a03bf364952a07b45d5cd4bdc4353991e7d
- Context: gardener-28 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr786-3c31fdde' exit-0-unsatisfying but elapsed near-constant (13,13s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 70807a03bf364952a07b45d5cd4bdc4353991e7d`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-22T20:43:53Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 77e816049edea50665e21bbde4ef81f7df737fc7
- Context: gardener-19 on endolin-garden-ece02cb4: job 'minion-town-mcp-b2-first-guest-tools-gauntlet' exit-0-unsatisfying but elapsed near-constant (20,20s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 77e816049edea50665e21bbde4ef81f7df737fc7`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-22T22:54:35Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: d4cc9178e599d24bc1f895f0771d6cec724e5525
- Context: gardener-22 on endolin-garden-ece02cb4: job 'minion-town-mcp-b5-retire-toy-tools' exit-0-unsatisfying but elapsed near-constant (59,59s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p d4cc9178e599d24bc1f895f0771d6cec724e5525`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-22T22:57:12Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: e924921c3e4b22265b256674bf4c75d605731568
- Context: gardener-6 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr824-build' exit-0-unsatisfying but elapsed near-constant (221,221s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p e924921c3e4b22265b256674bf4c75d605731568`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-22T23:24:56Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: d87326c08d9b25e007e39a80fc5ec5041b57e2f9
- Context: gardener-11 on endolin-garden-ece02cb4: job 'build-readableblob-range-attenuation' exit-0-unsatisfying but elapsed near-constant (74,74s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p d87326c08d9b25e007e39a80fc5ec5041b57e2f9`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-23T19:32:38Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 634062fa3686ec26630eaff38f9a6162fc3736b8
- Context: gardener-17 on endolin-garden-ece02cb4: job 'endo-master-fb9cef4-ci-build-gauntlet' exit-0-unsatisfying but elapsed near-constant (150,150s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 634062fa3686ec26630eaff38f9a6162fc3736b8`.

## lane 0 -- handler-nonzero failure at 2026-07-25T05:56:33Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 6f9942fe81cb8581c1bd29c9650816fc5ee19bac
- Context: gardener-1 on endolin-garden-ece02cb4: job 'kimi-k3-canary-20260725-e' handler exited rc=1

Inspect via `git -C journal cat-file -p 6f9942fe81cb8581c1bd29c9650816fc5ee19bac`.

## lane 0 -- handler-nonzero failure at 2026-07-25T05:57:20Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 3f6feb56fdb739d763336047770a9a2773f58b08
- Context: gardener-1 on endolin-garden-ece02cb4: job 'kimi-k3-canary-20260723-d' handler exited rc=1

Inspect via `git -C journal cat-file -p 3f6feb56fdb739d763336047770a9a2773f58b08`.

## lane 0 -- handler-nonzero failure at 2026-07-25T06:04:43Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4706bf3a9646a9a8ad1c3ea192e71a2bef04796d
- Context: gardener-1 on endolin-garden-ece02cb4: job 'downgrade-mechanical-model-tiers' handler exited rc=1

Inspect via `git -C journal cat-file -p 4706bf3a9646a9a8ad1c3ea192e71a2bef04796d`.

## lane 0 -- handler-nonzero failure at 2026-07-25T06:13:49Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: df2579c58627a41a3bdc28f93ee67b0ba68fca93
- Context: gardener-2 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr852-d502e7a9-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p df2579c58627a41a3bdc28f93ee67b0ba68fca93`.

## lane 0 -- handler-nonzero failure at 2026-07-25T06:23:21Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4bacab30e6b516ff285f16f053984cb674fe4900
- Context: gardener-2 on endolin-garden-ece02cb4: job 'fireworks-gardener-implement' handler exited rc=1

Inspect via `git -C journal cat-file -p 4bacab30e6b516ff285f16f053984cb674fe4900`.

## lane 0 -- handler-nonzero failure at 2026-07-25T06:23:56Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 0e59bf1b631176d101371a73f95cb2fd053cd996
- Context: gardener-2 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr719-rebase' handler exited rc=1

Inspect via `git -C journal cat-file -p 0e59bf1b631176d101371a73f95cb2fd053cd996`.

## lane 0 -- handler-nonzero failure at 2026-07-25T06:54:14Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 56778a9e6086aa2227876549e064a8cd90b6c9e2
- Context: gardener-1 on endolin-garden-ece02cb4: job 'improve-local-provider-model-presence-preflight' handler exited rc=1

Inspect via `git -C journal cat-file -p 56778a9e6086aa2227876549e064a8cd90b6c9e2`.

## lane 0 -- handler-nonzero failure at 2026-07-25T07:13:50Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1d78584b4717c3c463c3062ed698d4709b95e289
- Context: gardener-2 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr852-57d49137' handler exited rc=1

Inspect via `git -C journal cat-file -p 1d78584b4717c3c463c3062ed698d4709b95e289`.

## lane 0 -- handler-nonzero failure at 2026-07-25T09:53:37Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: cb2d94e5eff5f541689f73e5180e3e37ad4ffab2
- Context: gardener-1 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr855-df7988e4' handler exited rc=1

Inspect via `git -C journal cat-file -p cb2d94e5eff5f541689f73e5180e3e37ad4ffab2`.

## lane 0 -- handler-nonzero failure at 2026-07-25T09:58:00Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e4f2291b450393f54aa34f91c5799596b8067792
- Context: gardener-2 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr849-dependabot' handler exited rc=1

Inspect via `git -C journal cat-file -p e4f2291b450393f54aa34f91c5799596b8067792`.

## lane 0 -- handler-nonzero failure at 2026-07-25T10:03:20Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 81ade5d85cd5164ebdea7099c15291ce9d745173
- Context: gardener-1 on endolin-garden-ece02cb4: job 'kimi-k3-canary-20260723-c' handler exited rc=1

Inspect via `git -C journal cat-file -p 81ade5d85cd5164ebdea7099c15291ce9d745173`.

## lane 0 -- handler-nonzero failure at 2026-07-25T10:03:59Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1abf435a5b681710933f81d14957f90c7cddb496
- Context: gardener-1 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr698-ci-green-cascade-20260725' handler exited rc=1

Inspect via `git -C journal cat-file -p 1abf435a5b681710933f81d14957f90c7cddb496`.

## lane 0 -- handler-nonzero failure at 2026-07-25T10:13:29Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: d75ec5810e520373411a5818dd0393d7d67662a2
- Context: gardener-1 on endolin-garden-ece02cb4: job 'downgrade-mechanical-model-tiers' handler exited rc=1

Inspect via `git -C journal cat-file -p d75ec5810e520373411a5818dd0393d7d67662a2`.

## lane 0 -- handler-nonzero failure at 2026-07-25T10:43:35Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b082d8fbd69890c83e0a07827a9bf5c809a3d0d3
- Context: gardener-2 on endolin-garden-ece02cb4: job 'build-endo-but-for-bots-cap-std-watch-gauntlet' handler exited rc=1

Inspect via `git -C journal cat-file -p b082d8fbd69890c83e0a07827a9bf5c809a3d0d3`.

## lane 0 -- handler-nonzero failure at 2026-07-25T10:51:17Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 9228f7797c26102abcf1efcfbbcb1d216a68408a
- Context: gardener-2 on endolin-garden-ece02cb4: job 'finbot-progress-20260725-105007' handler exited rc=1

Inspect via `git -C journal cat-file -p 9228f7797c26102abcf1efcfbbcb1d216a68408a`.

## lane 0 -- handler-nonzero failure at 2026-07-25T10:52:37Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: aa37ab3652e0e80789a7f355004f8d26bb5c2874
- Context: gardener-2 on endolin-garden-ece02cb4: job 'improve-report-error-transcript-reachable' handler exited rc=1

Inspect via `git -C journal cat-file -p aa37ab3652e0e80789a7f355004f8d26bb5c2874`.

## lane 0 -- handler-nonzero failure at 2026-07-25T12:13:12Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: fad20cd4c94f476f40cf942843e722ee81f585eb
- Context: gardener-2 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr613-57fb6b21' handler exited rc=1

Inspect via `git -C journal cat-file -p fad20cd4c94f476f40cf942843e722ee81f585eb`.

## lane 0 -- handler-nonzero failure at 2026-07-25T13:43:34Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 013f336ade9843f8c5a634e1ad51b12a25b7713d
- Context: gardener-2 on endolin-garden-ece02cb4: job 'finbot-pr4-panel-rerun-20260725' handler exited rc=1

Inspect via `git -C journal cat-file -p 013f336ade9843f8c5a634e1ad51b12a25b7713d`.

## lane 0 -- handler-nonzero failure at 2026-07-25T14:03:36Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 0adc7dfd54bc7bfce3d60cbb1e4ed2265530bfa9
- Context: gardener-1 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr849-dependabot' handler exited rc=1

Inspect via `git -C journal cat-file -p 0adc7dfd54bc7bfce3d60cbb1e4ed2265530bfa9`.

## lane 0 -- handler-nonzero failure at 2026-07-25T14:13:36Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 7b5e0f97b57de0eb50d10c45b5e2d03fdafbbe46
- Context: gardener-2 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr698-ci-green-cascade-20260725' handler exited rc=1

Inspect via `git -C journal cat-file -p 7b5e0f97b57de0eb50d10c45b5e2d03fdafbbe46`.

## lane 0 -- handler-nonzero failure at 2026-07-25T14:23:27Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 3d27e845ab6acb69c2d187c8122b555cb7d4ef8e
- Context: gardener-2 on endolin-garden-ece02cb4: job 'downgrade-mechanical-model-tiers' handler exited rc=1

Inspect via `git -C journal cat-file -p 3d27e845ab6acb69c2d187c8122b555cb7d4ef8e`.

## lane 0 -- handler-nonzero failure at 2026-07-25T14:33:32Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 44275aa642b97dc5aa74f2187a3599dbd2db0d08
- Context: gardener-1 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr852-d502e7a9-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 44275aa642b97dc5aa74f2187a3599dbd2db0d08`.

## lane 0 -- handler-nonzero failure at 2026-07-25T14:53:28Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 154a73161672f4b79e012ffc3d9a02a7e2c2f585
- Context: gardener-1 on endolin-garden-ece02cb4: job 'finbot-progress-20260725-105007' handler exited rc=1

Inspect via `git -C journal cat-file -p 154a73161672f4b79e012ffc3d9a02a7e2c2f585`.

## lane 0 -- handler-nonzero failure at 2026-07-25T15:13:27Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 3c40461ac6612e6fd266472b2cfc1415458a135f
- Context: gardener-2 on endolin-garden-ece02cb4: job 'ebfb-stream-buffer-spring-sink-refactor-gauntlet' handler exited rc=1

Inspect via `git -C journal cat-file -p 3c40461ac6612e6fd266472b2cfc1415458a135f`.

## lane 0 -- handler-nonzero failure at 2026-07-25T15:21:46Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b1056f4aa5019ccf6f0f39692e182e0f778712bb
- Context: gardener-1 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr740-review-6ca53b57' handler exited rc=1

Inspect via `git -C journal cat-file -p b1056f4aa5019ccf6f0f39692e182e0f778712bb`.

## lane 0 -- handler-nonzero failure at 2026-07-25T15:39:46Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 84ce169b96a34eff107e1f173f9802c757c8af7c
- Context: gardener-2 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr719-313d4bc7' handler exited rc=1

Inspect via `git -C journal cat-file -p 84ce169b96a34eff107e1f173f9802c757c8af7c`.

## lane 0 -- handler-nonzero failure at 2026-07-25T16:17:16Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 800a37c31156106c920f67c83aeb7db2d2605e3b
- Context: gardener-2 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr719-ade4a938' handler exited rc=1

Inspect via `git -C journal cat-file -p 800a37c31156106c920f67c83aeb7db2d2605e3b`.

## lane 0 -- handler-nonzero failure at 2026-07-25T17:06:10Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 2e0c43041f1bbcc7d7ce77a3f301aae4896b0c04
- Context: gardener-2 on endolin-garden-ece02cb4: job 'finbot-progress-20260725-170501' handler exited rc=1

Inspect via `git -C journal cat-file -p 2e0c43041f1bbcc7d7ce77a3f301aae4896b0c04`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-25T19:04:04Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 8fab7e9276324af38dc8efcb98acbce0a35c5697
- Context: gardener-2 on endolin-garden-ece02cb4: job 'build-endo-but-for-bots-cap-std-watch-gauntlet' exit-0-unsatisfying but elapsed near-constant (15,15s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 8fab7e9276324af38dc8efcb98acbce0a35c5697`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-25T19:34:00Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: ea8d9b88f2ba7928d9681ed061d0cbd263c6e49e
- Context: gardener-2 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr740-review-6ca53b57' exit-0-unsatisfying but elapsed near-constant (16,16s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p ea8d9b88f2ba7928d9681ed061d0cbd263c6e49e`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-25T23:13:54Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 843a4813c201183602ee74eb34a4bcf6c87f8b16
- Context: gardener-2 on endolin-garden-ece02cb4: job 'improve-report-error-transcript-reachable' exit-0-unsatisfying but elapsed near-constant (17,17s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 843a4813c201183602ee74eb34a4bcf6c87f8b16`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-26T03:14:01Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 275c052322e11796368e4ba11cd5cb8985f1a6af
- Context: gardener-2 on endolin-garden-ece02cb4: job 'finbot-progress-20260725-105007' exit-0-unsatisfying but elapsed near-constant (12,12s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 275c052322e11796368e4ba11cd5cb8985f1a6af`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-26T09:54:11Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 433ab33c69fb3f3f728fb944a0293dae9ae66a82
- Context: gardener-2 on endolin-garden-ece02cb4: job 'xs2rust-endor-press-20260726-093506' exit-0-unsatisfying but elapsed near-constant (12,12s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 433ab33c69fb3f3f728fb944a0293dae9ae66a82`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-26T12:03:40Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 818c2bb52168df06fc16dcefa535a61f24758add
- Context: gardener-2 on endolin-garden-ece02cb4: job 'build-exo-google-sheets' exit-0-unsatisfying but elapsed near-constant (13,13s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 818c2bb52168df06fc16dcefa535a61f24758add`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-26T12:14:02Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 44fcdd6a40cbc05a3d141ac57daab285b4282421
- Context: gardener-1 on endolin-garden-ece02cb4: job 'xs2rust-endor-press-20260726-035002' exit-0-unsatisfying but elapsed near-constant (15,15s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 44fcdd6a40cbc05a3d141ac57daab285b4282421`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-26T14:23:36Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 0fe02574d0eb42ded52b6058772fc3f4261f9027
- Context: gardener-1 on endolin-garden-ece02cb4: job 'xs2rust-endor-press-20260726-140502' exit-0-unsatisfying but elapsed near-constant (12,12s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 0fe02574d0eb42ded52b6058772fc3f4261f9027`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-26T14:23:54Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 0464053446676cc6aea5d216bdff033ebb333ae4
- Context: gardener-2 on endolin-garden-ece02cb4: job 'xs2rust-endor-press-20260726-060501' exit-0-unsatisfying but elapsed near-constant (11,11s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 0464053446676cc6aea5d216bdff033ebb333ae4`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-26T14:53:51Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 0d93716966d2e450239784f1bdbfbd634aaa31bd
- Context: gardener-2 on endolin-garden-ece02cb4: job 'xs2rust-endor-press-20260726-103521' exit-0-unsatisfying but elapsed near-constant (13,13s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 0d93716966d2e450239784f1bdbfbd634aaa31bd`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-26T17:04:09Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 9700da99509e2faa08cce92f00940a900f5670a9
- Context: gardener-1 on endolin-garden-ece02cb4: job 'xs2rust-endor-press-20260726-125016' exit-0-unsatisfying but elapsed near-constant (12,12s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 9700da99509e2faa08cce92f00940a900f5670a9`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-26T18:23:43Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 4cea496b9aabed84366c8de7650e20135bfec2e7
- Context: gardener-2 on endolin-garden-ece02cb4: job 'xs2rust-endor-press-20260726-180521' exit-0-unsatisfying but elapsed near-constant (13,13s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 4cea496b9aabed84366c8de7650e20135bfec2e7`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-26T19:04:04Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 09852b6bdbd27a5719e255770a1ad127d034434b
- Context: gardener-2 on endolin-garden-ece02cb4: job 'xs2rust-endor-press-20260726-023504' exit-0-unsatisfying but elapsed near-constant (9,9s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 09852b6bdbd27a5719e255770a1ad127d034434b`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-26T19:43:58Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 29d665c4139f24b8fd584da7700cd08067327f25
- Context: gardener-2 on endolin-garden-ece02cb4: job 'xs2rust-endor-press-20260726-070504' exit-0-unsatisfying but elapsed near-constant (13,13s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 29d665c4139f24b8fd584da7700cd08067327f25`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-26T20:34:00Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 51f3573768546a60aafe398e419bc0d3086ccfe0
- Context: gardener-2 on endolin-garden-ece02cb4: job 'xs2rust-endor-press-20260726-160502' exit-0-unsatisfying but elapsed near-constant (19,19s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 51f3573768546a60aafe398e419bc0d3086ccfe0`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-26T21:13:54Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: a4e021a8e4e2ced650ce671372b9bfe42887ef31
- Context: gardener-2 on endolin-garden-ece02cb4: job 'xs2rust-endor-press-20260726-045004' exit-0-unsatisfying but elapsed near-constant (9,9s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p a4e021a8e4e2ced650ce671372b9bfe42887ef31`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-27T00:23:50Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: abafcc946c28025987ada3113c2141db611b2bbf
- Context: gardener-2 on endolin-garden-ece02cb4: job 'xs2rust-endor-press-20260726-115001' exit-0-unsatisfying but elapsed near-constant (13,13s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p abafcc946c28025987ada3113c2141db611b2bbf`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-27T00:33:56Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 7ff1375aeea121b6e7a5b0e690db8ab9bc63c486
- Context: gardener-2 on endolin-garden-ece02cb4: job 'xs2rust-endor-press-20260726-202002' exit-0-unsatisfying but elapsed near-constant (15,15s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 7ff1375aeea121b6e7a5b0e690db8ab9bc63c486`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-27T00:54:10Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: ee4a6665386c5cc7ed41faa18520fcd72c84d2e8
- Context: gardener-2 on endolin-garden-ece02cb4: job 'xs2rust-endor-press-20260726-082003' exit-0-unsatisfying but elapsed near-constant (11,11s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p ee4a6665386c5cc7ed41faa18520fcd72c84d2e8`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-27T03:53:56Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: a01d0007d6599e7681e564fb972d8911e7517022
- Context: gardener-2 on endolin-garden-ece02cb4: job 'xs2rust-endor-press-20260726-233502' exit-0-unsatisfying but elapsed near-constant (17,17s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p a01d0007d6599e7681e564fb972d8911e7517022`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-27T04:23:45Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: bc65a7bc2d9dbe6240932d42fe5954c3b8fa0a6b
- Context: gardener-2 on endolin-garden-ece02cb4: job 'build-endo-google-sheets-client' exit-0-unsatisfying but elapsed near-constant (12,12s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p bc65a7bc2d9dbe6240932d42fe5954c3b8fa0a6b`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-27T05:33:55Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: ceb32872c3a900f9ad1ccdc984681c7c5afb0977
- Context: gardener-2 on endolin-garden-ece02cb4: job 'xs2rust-endor-press-20260726-170508' exit-0-unsatisfying but elapsed near-constant (9,9s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p ceb32872c3a900f9ad1ccdc984681c7c5afb0977`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-27T07:13:40Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 3611323d21e3c9a90c7920fe7238833da1a867bf
- Context: gardener-2 on endolin-garden-ece02cb4: job 'xs2rust-endor-press-20260727-025003' exit-0-unsatisfying but elapsed near-constant (14,14s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 3611323d21e3c9a90c7920fe7238833da1a867bf`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-27T07:53:49Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 88c920bcdd1e64330ab82a17416c6de784299062
- Context: gardener-2 on endolin-garden-ece02cb4: job 'xs2rust-endor-press-20260726-192001' exit-0-unsatisfying but elapsed near-constant (15,15s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 88c920bcdd1e64330ab82a17416c6de784299062`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-27T09:53:40Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 98dca3f6e722c7141ecb9d281b1239c967f1a1db
- Context: gardener-2 on endolin-garden-ece02cb4: job 'xs2rust-endor-press-20260726-212016' exit-0-unsatisfying but elapsed near-constant (13,13s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 98dca3f6e722c7141ecb9d281b1239c967f1a1db`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-27T10:03:51Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 5e69b7da1e1131dc9fa74b3a798ecd6cacc2a63c
- Context: gardener-2 on endolin-garden-ece02cb4: job 'xs2rust-endor-press-20260727-013518' exit-0-unsatisfying but elapsed near-constant (14,14s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 5e69b7da1e1131dc9fa74b3a798ecd6cacc2a63c`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-27T13:03:45Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 47c913e4e158195192c3afeafaaf918c6355a15f
- Context: gardener-1 on endolin-garden-ece02cb4: job 'xs2rust-endor-press-20260727-003508' exit-0-unsatisfying but elapsed near-constant (15,15s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 47c913e4e158195192c3afeafaaf918c6355a15f`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-27T13:33:34Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 0e8fcb9bec1da0ac6cdb5e1236303457b02791fc
- Context: gardener-1 on endolin-garden-ece02cb4: job 'xs2rust-endor-press-20260727-050502' exit-0-unsatisfying but elapsed near-constant (9,9s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 0e8fcb9bec1da0ac6cdb5e1236303457b02791fc`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-27T15:53:40Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 9cb605757460f16e3748299c13fc5e45653c4b56
- Context: gardener-2 on endolin-garden-ece02cb4: job 'finbot-progress-20260727-113510' exit-0-unsatisfying but elapsed near-constant (14,14s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 9cb605757460f16e3748299c13fc5e45653c4b56`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-27T16:54:02Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 90443278dfa194fda6c1d413caf75377562f9c2e
- Context: gardener-2 on endolin-garden-ece02cb4: job 'xs2rust-endor-press-20260727-083507' exit-0-unsatisfying but elapsed near-constant (15,15s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 90443278dfa194fda6c1d413caf75377562f9c2e`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-27T18:13:58Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: adfd197d35161c1b7d05abad267280d408f9e080
- Context: gardener-1 on endolin-garden-ece02cb4: job 'xs2rust-endor-press-20260727-095001' exit-0-unsatisfying but elapsed near-constant (17,17s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p adfd197d35161c1b7d05abad267280d408f9e080`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-27T19:23:48Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: b787937cbb1c96da12ad077bbf1312aba54ca641
- Context: gardener-2 on endolin-garden-ece02cb4: job 'xs2rust-endor-press-20260727-150502' exit-0-unsatisfying but elapsed near-constant (14,14s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p b787937cbb1c96da12ad077bbf1312aba54ca641`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-27T19:44:49Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: c3da067f0c7008a4deda9eaeb27013e096686481
- Context: gardener-1 on endolin-garden-ece02cb4: job 'xs2rust-endor-press-20260727-072006' exit-0-unsatisfying but elapsed near-constant (11,11s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p c3da067f0c7008a4deda9eaeb27013e096686481`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-28T07:44:28Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 0954f983743afc241693863ff68c587eb2c9f496
- Context: gardener-1 on endolin-garden-ece02cb4: job 'endo-git-integration-press-20260728-004711' exit-0-unsatisfying but elapsed near-constant (334,334s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 0954f983743afc241693863ff68c587eb2c9f496`.

## lane 0 -- handler-nonzero failure at 2026-07-28T20:05:42Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 0ee56cdbd76701374c93a40e35c982031a8eb6c6
- Context: gardener-1 on endolin-garden-ece02cb4: job 'endo-meeting-agenda-20260728-200501' handler exited rc=1

Inspect via `git -C journal cat-file -p 0ee56cdbd76701374c93a40e35c982031a8eb6c6`.

## lane 0 -- handler-nonzero failure at 2026-07-28T20:54:08Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ada9d8b814626e3d9378a9ffe335bf40a1730d38
- Context: gardener-2 on endolin-garden-ece02cb4: job 'job-host-requirements-gating' handler exited rc=1

Inspect via `git -C journal cat-file -p ada9d8b814626e3d9378a9ffe335bf40a1730d38`.

## lane 0 -- handler-nonzero failure at 2026-07-28T21:03:59Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 8ef13e9d2f8d0b75bc7984dc66755bc0ed0318f4
- Context: gardener-3 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr881-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 8ef13e9d2f8d0b75bc7984dc66755bc0ed0318f4`.

## lane 0 -- handler-nonzero failure at 2026-07-28T21:14:10Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 8ef13e9d2f8d0b75bc7984dc66755bc0ed0318f4
- Context: gardener-5 on endolin-garden-ece02cb4: job 'migrate-garden-origins-to-kriscendobot' handler exited rc=1

Inspect via `git -C journal cat-file -p 8ef13e9d2f8d0b75bc7984dc66755bc0ed0318f4`.

## lane 0 -- handler-nonzero failure at 2026-07-28T21:14:26Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: f0a3ce2767e3ae7923bda76335edd91de118cdb2
- Context: gardener-7 on endolin-garden-ece02cb4: job 'gnome-backend-autotune-build' handler exited rc=1

Inspect via `git -C journal cat-file -p f0a3ce2767e3ae7923bda76335edd91de118cdb2`.

## lane 0 -- handler-nonzero failure at 2026-07-28T21:14:35Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 8ef13e9d2f8d0b75bc7984dc66755bc0ed0318f4
- Context: gardener-1 on endolin-garden-ece02cb4: job 'scholar-refresh-assert-js-line-citations' handler exited rc=1

Inspect via `git -C journal cat-file -p 8ef13e9d2f8d0b75bc7984dc66755bc0ed0318f4`.

## lane 0 -- handler-nonzero failure at 2026-07-28T21:24:08Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 8ef13e9d2f8d0b75bc7984dc66755bc0ed0318f4
- Context: gardener-6 on endolin-garden-ece02cb4: job 'fu-endojs-endo-but-for-bots-pr825-8840fcdb-2' handler exited rc=1

Inspect via `git -C journal cat-file -p 8ef13e9d2f8d0b75bc7984dc66755bc0ed0318f4`.

## lane 0 -- handler-nonzero failure at 2026-07-28T21:24:17Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 7fa31fe622d07582ae3f255c9517c4a1f8fc30f6
- Context: gardener-5 on endolin-garden-ece02cb4: job 'finbot-progress-20260728-065010' handler exited rc=1

Inspect via `git -C journal cat-file -p 7fa31fe622d07582ae3f255c9517c4a1f8fc30f6`.

## lane 0 -- handler-nonzero failure at 2026-07-28T21:24:31Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 8ef13e9d2f8d0b75bc7984dc66755bc0ed0318f4
- Context: gardener-8 on endolin-garden-ece02cb4: job 'scholar-ingest-atproto-ucan-did-specs' handler exited rc=1

Inspect via `git -C journal cat-file -p 8ef13e9d2f8d0b75bc7984dc66755bc0ed0318f4`.

## lane 0 -- handler-nonzero failure at 2026-07-28T21:24:55Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 3ade79d7dfdc0ebb65ff035b5803b469a3cd5574
- Context: gardener-3 on endolin-garden-ece02cb4: job 'finbot-pr4-panel-rerun-20260728' handler exited rc=1

Inspect via `git -C journal cat-file -p 3ade79d7dfdc0ebb65ff035b5803b469a3cd5574`.

## lane 0 -- handler-nonzero failure at 2026-07-28T21:33:43Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 8ef13e9d2f8d0b75bc7984dc66755bc0ed0318f4
- Context: gardener-3 on endolin-garden-ece02cb4: job 'improve-drift-scan-refresh-once-per-source' handler exited rc=1

Inspect via `git -C journal cat-file -p 8ef13e9d2f8d0b75bc7984dc66755bc0ed0318f4`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:08:01Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e0610f3789691e8f3f9726b0a25d8a6218555e1c
- Context: gardener-3 on endolin-garden-ece02cb4: job 'endo-git-integration-press-20260729-012002' handler exited rc=1

Inspect via `git -C journal cat-file -p e0610f3789691e8f3f9726b0a25d8a6218555e1c`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:09:01Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4a9fcc0201818c8ed786d375285fb049df575689
- Context: gardener-2 on endolin-garden-ece02cb4: job 'scholar-ingest-did-plc-ucan-invocation-revocation' handler exited rc=1

Inspect via `git -C journal cat-file -p 4a9fcc0201818c8ed786d375285fb049df575689`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:10:47Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4a9fcc0201818c8ed786d375285fb049df575689
- Context: gardener-3 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr647-review-ec3d282c' handler exited rc=1

Inspect via `git -C journal cat-file -p 4a9fcc0201818c8ed786d375285fb049df575689`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:13:07Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4a9fcc0201818c8ed786d375285fb049df575689
- Context: gardener-6 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr691-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 4a9fcc0201818c8ed786d375285fb049df575689`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:13:55Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: a659c9417d89cd516ec7a7ca6b69a4086036b61a
- Context: gardener-8 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr282-148f5c93' handler exited rc=1

Inspect via `git -C journal cat-file -p a659c9417d89cd516ec7a7ca6b69a4086036b61a`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:14:12Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 5ba55646d6af14d08a26a7c975530f58bae09777
- Context: gardener-5 on endolin-garden-ece02cb4: job 'fix-botanist-scripts-enabled-install-gap-gauntlet' handler exited rc=1

Inspect via `git -C journal cat-file -p 5ba55646d6af14d08a26a7c975530f58bae09777`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:14:38Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 75c42f144d294262d2825e5bf6e48bbaf0865ca3
- Context: gardener-2 on endolin-garden-ece02cb4: job 'fu-wallclock-cost-proxy-for-censored-arms-1' handler exited rc=1

Inspect via `git -C journal cat-file -p 75c42f144d294262d2825e5bf6e48bbaf0865ca3`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-29T02:17:00Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: a8dabec3502eacc4ff4bf975c02fc9ef05e385a4
- Context: gardener-1 on endolin-garden-ece02cb4: job 'finbot-pr6-panel-20260728' exit-0-unsatisfying but elapsed near-constant (150,173s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p a8dabec3502eacc4ff4bf975c02fc9ef05e385a4`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:20:11Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4a9fcc0201818c8ed786d375285fb049df575689
- Context: gardener-8 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr241-review-b15e4ef6' handler exited rc=1

Inspect via `git -C journal cat-file -p 4a9fcc0201818c8ed786d375285fb049df575689`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:23:35Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: adc5a687f10c7ee10ba86bdc0d10588b1a64bcce
- Context: gardener-6 on endolin-garden-ece02cb4: job 'xs2rust-endor-s2-test-rust-green' handler exited rc=1

Inspect via `git -C journal cat-file -p adc5a687f10c7ee10ba86bdc0d10588b1a64bcce`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:23:42Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: bae40409d31dc46fd76d1462df9690e20d29290c
- Context: gardener-3 on endolin-garden-ece02cb4: job 'finbot-pr6-panel-20260728' handler exited rc=1

Inspect via `git -C journal cat-file -p bae40409d31dc46fd76d1462df9690e20d29290c`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:24:38Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4a9fcc0201818c8ed786d375285fb049df575689
- Context: gardener-4 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr730-review-27278ba1' handler exited rc=1

Inspect via `git -C journal cat-file -p 4a9fcc0201818c8ed786d375285fb049df575689`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:26:19Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 097ba849ff7f79d29f515e7344507379268aafc3
- Context: gardener-2 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr403-conduct' handler exited rc=1

Inspect via `git -C journal cat-file -p 097ba849ff7f79d29f515e7344507379268aafc3`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:29:47Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4a9fcc0201818c8ed786d375285fb049df575689
- Context: gardener-1 on endolin-garden-ece02cb4: job 'fu-fu-improve-promote-plan-poison-reset-3-1' handler exited rc=1

Inspect via `git -C journal cat-file -p 4a9fcc0201818c8ed786d375285fb049df575689`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:30:07Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4a9fcc0201818c8ed786d375285fb049df575689
- Context: gardener-3 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr667-198c8d1e' handler exited rc=1

Inspect via `git -C journal cat-file -p 4a9fcc0201818c8ed786d375285fb049df575689`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:32:34Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4a9fcc0201818c8ed786d375285fb049df575689
- Context: gardener-8 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr676-review-4939792d' handler exited rc=1

Inspect via `git -C journal cat-file -p 4a9fcc0201818c8ed786d375285fb049df575689`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:33:30Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e1adf781130ea2cb8cbad91eba6c27f2f822d75b
- Context: gardener-2 on endolin-garden-ece02cb4: job 'finbot-pr4-panel-rerun-20260728' handler exited rc=1

Inspect via `git -C journal cat-file -p e1adf781130ea2cb8cbad91eba6c27f2f822d75b`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:36:58Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4a9fcc0201818c8ed786d375285fb049df575689
- Context: gardener-5 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr723-review-b5ddd4da' handler exited rc=1

Inspect via `git -C journal cat-file -p 4a9fcc0201818c8ed786d375285fb049df575689`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:38:25Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4a9fcc0201818c8ed786d375285fb049df575689
- Context: gardener-5 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr857-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 4a9fcc0201818c8ed786d375285fb049df575689`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:43:22Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e8e3aa1d87677b8b235b39983c38f41ad4932103
- Context: gardener-8 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr873-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p e8e3aa1d87677b8b235b39983c38f41ad4932103`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:45:35Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4a9fcc0201818c8ed786d375285fb049df575689
- Context: gardener-2 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr875-review-8e639c41' handler exited rc=1

Inspect via `git -C journal cat-file -p 4a9fcc0201818c8ed786d375285fb049df575689`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:50:17Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4a9fcc0201818c8ed786d375285fb049df575689
- Context: gardener-8 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr877-review-2a8cbbfd' handler exited rc=1

Inspect via `git -C journal cat-file -p 4a9fcc0201818c8ed786d375285fb049df575689`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:55:26Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4a9fcc0201818c8ed786d375285fb049df575689
- Context: gardener-7 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr878-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 4a9fcc0201818c8ed786d375285fb049df575689`.

## lane 0 -- handler-nonzero failure at 2026-07-29T02:59:47Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4a9fcc0201818c8ed786d375285fb049df575689
- Context: gardener-5 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr867-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 4a9fcc0201818c8ed786d375285fb049df575689`.

## lane 0 -- handler-nonzero failure at 2026-07-29T03:02:07Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4a9fcc0201818c8ed786d375285fb049df575689
- Context: gardener-1 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr880-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 4a9fcc0201818c8ed786d375285fb049df575689`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-29T16:33:28Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 908bab5e2a9e74a8d30eaaeae28543f29232c201
- Context: gardener-7 on endolin-garden-ece02cb4: job 'fu-wallclock-cost-proxy-for-censored-arms-1' exit-0-unsatisfying but elapsed near-constant (924,860s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 908bab5e2a9e74a8d30eaaeae28543f29232c201`.

## lane 0 -- handler-nonzero failure at 2026-07-29T17:03:36Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b7a840dbb20dfc0624d588c34511aeff590949fb
- Context: gardener-7 on endolin-garden-ece02cb4: job 'minion-town-agenda-review-20260729-162012' handler exited rc=1

Inspect via `git -C journal cat-file -p b7a840dbb20dfc0624d588c34511aeff590949fb`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-29T17:25:59Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 050d68ae70a4a338767a74d179e968f62e87c5be
- Context: gardener-1 on endolin-garden-ece02cb4: job 'finbot-pr5-panel-20260729' exit-0-unsatisfying but elapsed near-constant (30,31s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 050d68ae70a4a338767a74d179e968f62e87c5be`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-29T17:49:33Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 8db2cd5d9923e6f1000e4c2828dd44a2ca18fce0
- Context: gardener-1 on endolin-garden-ece02cb4: job 'finbot-pr4-panel-rerun-20260728' exit-0-unsatisfying but elapsed near-constant (19,23s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 8db2cd5d9923e6f1000e4c2828dd44a2ca18fce0`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-29T21:24:35Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 6cfe446043e2ffec17451ced38b34d4cc6357f14
- Context: gardener-1 on endolin-garden-ece02cb4: job 'finbot-pr5-panel-20260729-195004' exit-0-unsatisfying but elapsed near-constant (23,27s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 6cfe446043e2ffec17451ced38b34d4cc6357f14`.

## lane 0 -- handler-nonzero failure at 2026-07-30T01:34:11Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 9eb0fbbb2c081c3c640b42e50b518d54d6a6cdc8
- Context: gardener-3 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr875-review-51bf66b1' handler exited rc=1

Inspect via `git -C journal cat-file -p 9eb0fbbb2c081c3c640b42e50b518d54d6a6cdc8`.

## lane 0 -- handler-nonzero failure at 2026-07-30T01:34:26Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 7400a51656107a5a4a0ce065a69bed824adde876
- Context: gardener-4 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr873-conduct' handler exited rc=1

Inspect via `git -C journal cat-file -p 7400a51656107a5a4a0ce065a69bed824adde876`.

## lane 0 -- handler-nonzero failure at 2026-07-30T01:34:41Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 2584bcca41a961fe28a50c585912534b63157414
- Context: gardener-5 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr652-weave' handler exited rc=1

Inspect via `git -C journal cat-file -p 2584bcca41a961fe28a50c585912534b63157414`.

## lane 0 -- handler-nonzero failure at 2026-07-30T01:38:18Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 99243418a1358353717c1c63b9072987684adffe
- Context: gardener-4 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr876-conduct' handler exited rc=1

Inspect via `git -C journal cat-file -p 99243418a1358353717c1c63b9072987684adffe`.

## lane 0 -- handler-nonzero failure at 2026-07-30T01:38:27Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: bd69785b46859cbe4c484f0d6055eb1396c5c077
- Context: gardener-3 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr876-review-ac5d6dfa' handler exited rc=1

Inspect via `git -C journal cat-file -p bd69785b46859cbe4c484f0d6055eb1396c5c077`.

## lane 0 -- handler-nonzero failure at 2026-07-30T01:38:42Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 0e997c33fd9d4705b721679135763d54c3d4798d
- Context: gardener-5 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr877-review-1eec395e' handler exited rc=1

Inspect via `git -C journal cat-file -p 0e997c33fd9d4705b721679135763d54c3d4798d`.

## lane 0 -- handler-nonzero failure at 2026-07-30T01:42:18Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4e78102288d80928e700537d8cf2ad134595f51e
- Context: gardener-4 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr880-conduct' handler exited rc=1

Inspect via `git -C journal cat-file -p 4e78102288d80928e700537d8cf2ad134595f51e`.

## lane 0 -- handler-nonzero failure at 2026-07-30T01:42:24Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: a445547d56224a5e93f025536facc5c6663611eb
- Context: gardener-3 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr878-conduct' handler exited rc=1

Inspect via `git -C journal cat-file -p a445547d56224a5e93f025536facc5c6663611eb`.

## lane 0 -- handler-nonzero failure at 2026-07-30T01:42:41Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: fb37cffe7ddeb5a68192cab910de12d56ec34a55
- Context: gardener-5 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr885-conduct' handler exited rc=1

Inspect via `git -C journal cat-file -p fb37cffe7ddeb5a68192cab910de12d56ec34a55`.

## lane 0 -- handler-nonzero failure at 2026-07-30T01:46:19Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: a4d07c75bf35255c50d9b2813929adc7c2b993cd
- Context: gardener-4 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr885-review-c5f39398' handler exited rc=1

Inspect via `git -C journal cat-file -p a4d07c75bf35255c50d9b2813929adc7c2b993cd`.

## lane 0 -- handler-nonzero failure at 2026-07-30T01:46:28Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b881d57b7672c0806513d9d4c75f20970d59d55d
- Context: gardener-3 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr886-conduct' handler exited rc=1

Inspect via `git -C journal cat-file -p b881d57b7672c0806513d9d4c75f20970d59d55d`.

## lane 0 -- handler-nonzero failure at 2026-07-30T01:46:39Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 0260d565b3f5aa06ebdd6cf733ef7f41c73bbcac
- Context: gardener-5 on endolin-garden-ece02cb4: job 'garden-approval-reconciler-build' handler exited rc=1

Inspect via `git -C journal cat-file -p 0260d565b3f5aa06ebdd6cf733ef7f41c73bbcac`.

## lane 0 -- handler-nonzero failure at 2026-07-30T01:50:09Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 2c8a84af683d3313676af125d1eb01b4d93c2511
- Context: gardener-4 on endolin-garden-ece02cb4: job 'garden-fireworks-glm52-register-retry' handler exited rc=1

Inspect via `git -C journal cat-file -p 2c8a84af683d3313676af125d1eb01b4d93c2511`.

## lane 0 -- handler-nonzero failure at 2026-07-30T01:50:44Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 8e05167cdf7bd26c8d5de45a617b6b2a7b4f67bf
- Context: gardener-5 on endolin-garden-ece02cb4: job 'pr-ebfb-877-bundle-endo-base64' handler exited rc=1

Inspect via `git -C journal cat-file -p 8e05167cdf7bd26c8d5de45a617b6b2a7b4f67bf`.

## lane 0 -- handler-nonzero failure at 2026-07-30T01:58:11Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 304eada4097d60e54b88d21b2a5f011d660c713e
- Context: gardener-2 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr403-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 304eada4097d60e54b88d21b2a5f011d660c713e`.

## lane 0 -- handler-nonzero failure at 2026-07-30T03:14:34Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 9a1bf1ff4b54c6e98e3f1c8ba01477d51a736b2e
- Context: gardener-3 on endolin-garden-ece02cb4: job 'xs2rust-endor-s2-test-rust-green' handler exited rc=1

Inspect via `git -C journal cat-file -p 9a1bf1ff4b54c6e98e3f1c8ba01477d51a736b2e`.

## lane 0 -- handler-nonzero failure at 2026-07-30T03:14:53Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1f7bb61e0d0d6cf6e49f149ad8abd642706166cc
- Context: gardener-2 on endolin-garden-ece02cb4: job 'endo-sturdyref-press-20260729-195004' handler exited rc=1

Inspect via `git -C journal cat-file -p 1f7bb61e0d0d6cf6e49f149ad8abd642706166cc`.

## lane 0 -- handler-nonzero failure at 2026-07-30T03:15:32Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 9b1956fd9bc1e254015924c8395254a5b6d37ec2
- Context: gardener-4 on endolin-garden-ece02cb4: job 'build-endo-regexp-conservative-subset' handler exited rc=1

Inspect via `git -C journal cat-file -p 9b1956fd9bc1e254015924c8395254a5b6d37ec2`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-08-01T11:27:59Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 029711a5271941aa6c4cba6182e6a913446247d4
- Context: gardener-5 on endolin-garden-ece02cb4: job 'xs2rust-endor-stage10p-fresh-env-sweep' transient-classified (rc=1) but elapsed near-constant (4,3s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 029711a5271941aa6c4cba6182e6a913446247d4`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-08-01T11:35:13Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: bb926fd2bec0b6991868dea740eb35d1dfeffb1b
- Context: gardener-4 on endolin-garden-ece02cb4: job 'ocapn-noise-press-20260801-090502' transient-classified (rc=1) but elapsed near-constant (2,2s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p bb926fd2bec0b6991868dea740eb35d1dfeffb1b`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-08-01T11:37:10Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: cc7c7f0ed8ab3ed9e22ea85562bb34bb28862dda
- Context: gardener-1 on endolin-garden-ece02cb4: job 'build-kebab-case-lint-wildcard-test262' transient-classified (rc=1) but elapsed near-constant (2,2s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p cc7c7f0ed8ab3ed9e22ea85562bb34bb28862dda`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-08-01T11:45:20Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 6b2085de99f40d91210f48fa5f98ea61b4cee013
- Context: gardener-1 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr592-cancel-in-options' transient-classified (rc=1) but elapsed near-constant (4,4s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 6b2085de99f40d91210f48fa5f98ea61b4cee013`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-08-01T22:53:56Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 990b21664be253db3936c4d8f4a0177f5a1f627b
- Context: gardener-5 on endolin-garden-ece02cb4: job 'finbot-pr6-fix-panel-r5' transient-classified (rc=1) but elapsed near-constant (3,4s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 990b21664be253db3936c4d8f4a0177f5a1f627b`.

## lane 0 -- handler-nonzero failure at 2026-08-06T15:36:22Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: a48b0b8dd660dc25671f3394c9d5c7e00c123b78
- Context: gardener-1 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr943-shepherd' handler exited rc=1
- Capture: inboxes/endolin-garden-ece02cb4/captures/a48b0b8dd660dc25671f3394c9d5c7e00c123b78

Inspect via `git -C journal cat-file -p a48b0b8dd660dc25671f3394c9d5c7e00c123b78` (or read
`journal/inboxes/endolin-garden-ece02cb4/captures/a48b0b8dd660dc25671f3394c9d5c7e00c123b78`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- handler-nonzero failure at 2026-08-12T22:46:18Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 848561e8681199b1877c7b09908b20705382587c
- Context: gardener-3 on endolin-garden-ece02cb4: job 'ebfb-guest-unconfined-from-tree' handler exited rc=1
- Capture: inboxes/endolin-garden-ece02cb4/captures/848561e8681199b1877c7b09908b20705382587c

Inspect via `git -C journal cat-file -p 848561e8681199b1877c7b09908b20705382587c` (or read
`journal/inboxes/endolin-garden-ece02cb4/captures/848561e8681199b1877c7b09908b20705382587c`) -- both work off-host after a plain `journal2` fetch.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-08-15T06:44:03Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 8c64b1c77afd3e9b2a5fb4b894f2f52bdb31faa4
- Context: gardener-1 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr286-refresh' transient-classified (rc=1) but elapsed near-constant (5,5s) over 2 cycles — likely deterministic overrun, not a blip
- Capture: inboxes/endolin-garden-ece02cb4/captures/8c64b1c77afd3e9b2a5fb4b894f2f52bdb31faa4

Inspect via `git -C journal cat-file -p 8c64b1c77afd3e9b2a5fb4b894f2f52bdb31faa4` (or read
`journal/inboxes/endolin-garden-ece02cb4/captures/8c64b1c77afd3e9b2a5fb4b894f2f52bdb31faa4`) -- both work off-host after a plain `journal2` fetch.
