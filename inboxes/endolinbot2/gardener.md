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

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T00:59:49Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 3e279bb0dbfdd14499315b9b09d55c0c70539443
- Context: gardener-45 on endolinbot2: job 'endojs-endo-but-for-bots-pr313-shepherd' transient-classified (rc=1) but elapsed near-constant (266,266s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 3e279bb0dbfdd14499315b9b09d55c0c70539443`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:00:11Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: a46e1b4d2fc6bb4481a0c8470dd0c45b9cb72fb4
- Context: gardener-84 on endolinbot2: job 'endojs-endo-but-for-bots-pr410-shepherd' transient-classified (rc=1) but elapsed near-constant (334,334s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p a46e1b4d2fc6bb4481a0c8470dd0c45b9cb72fb4`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:00:48Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 8ca33c6b5529b3780bbc99082eb4820b10bc0d1e
- Context: gardener-58 on endolinbot2: job 'endojs-endo-but-for-bots-pr393-shepherd' transient-classified (rc=1) but elapsed near-constant (332,332s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 8ca33c6b5529b3780bbc99082eb4820b10bc0d1e`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:01:09Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: ed0650c5e7199982bede3b64454027556f3b7163
- Context: gardener-35 on endolinbot2: job 'build-daemon-rename-to-manager' transient-classified (rc=1) but elapsed near-constant (340,340s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p ed0650c5e7199982bede3b64454027556f3b7163`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:02:58Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 8798db1f8f415e2153da59e6088a2ed077df39cf
- Context: gardener-60 on endolinbot2: job 'endojs-endo-but-for-bots-pr475-shepherd' transient-classified (rc=1) but elapsed near-constant (1131,1131s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 8798db1f8f415e2153da59e6088a2ed077df39cf`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:04:53Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 4568a64f8ac84088dae5a4da7d8d429b2d8f8512
- Context: gardener-66 on endolinbot2: job 'endojs-endo-but-for-bots-pr250-shepherd' transient-classified (rc=1) but elapsed near-constant (1,1s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 4568a64f8ac84088dae5a4da7d8d429b2d8f8512`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:05:50Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: e4202dbc6e20ff8c4d5d0a80af1089a47ec5437a
- Context: gardener-69 on endolinbot2: job 'endojs-endo-but-for-bots-pr420-shepherd' transient-classified (rc=1) but elapsed near-constant (3,3s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p e4202dbc6e20ff8c4d5d0a80af1089a47ec5437a`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:06:06Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 43e451bfedeb058af13da114a49260a451b423ad
- Context: gardener-76 on endolinbot2: job 'endojs-endo-but-for-bots-pr588-shepherd' transient-classified (rc=1) but elapsed near-constant (1,1s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 43e451bfedeb058af13da114a49260a451b423ad`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:06:14Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 82a927750cfab61fe72c70649cdcba2bd4698aad
- Context: gardener-98 on endolinbot2: job 'endojs-endo-but-for-bots-pr541-shepherd' transient-classified (rc=1) but elapsed near-constant (2,2s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 82a927750cfab61fe72c70649cdcba2bd4698aad`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:06:30Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 7759ff568f99b975e5dfa1fda3d4957ba3bb17cb
- Context: gardener-72 on endolinbot2: job 'endojs-endo-but-for-bots-pr587-shepherd' transient-classified (rc=1) but elapsed near-constant (5,5s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 7759ff568f99b975e5dfa1fda3d4957ba3bb17cb`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:06:41Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 80658c94ee23d723dcaed9ff0eda018e0534f171
- Context: gardener-34 on endolinbot2: job 'endojs-endo-but-for-bots-pr337-shepherd' transient-classified (rc=1) but elapsed near-constant (2,2s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 80658c94ee23d723dcaed9ff0eda018e0534f171`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:06:54Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 2fd79cb2ff309591a44276223fed6bfc1201f86e
- Context: gardener-88 on endolinbot2: job 'endojs-endo-but-for-bots-pr590-shepherd' transient-classified (rc=1) but elapsed near-constant (12,12s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 2fd79cb2ff309591a44276223fed6bfc1201f86e`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:07:10Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: d51e69a806f1230a3fce896c6d9420b2a509e220
- Context: gardener-64 on endolinbot2: job 'endojs-endo-but-for-bots-pr318-shepherd' transient-classified (rc=1) but elapsed near-constant (2,2s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p d51e69a806f1230a3fce896c6d9420b2a509e220`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:07:59Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 3cdb43ec95cc6ca1f1ed74caa4da62fa27010bc9
- Context: gardener-60 on endolinbot2: job 'endojs-endo-but-for-bots-pr324-shepherd' transient-classified (rc=1) but elapsed near-constant (2,2s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 3cdb43ec95cc6ca1f1ed74caa4da62fa27010bc9`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:08:20Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: aecee99ccc8a3663a38b1a8cec36b5631af3faee
- Context: gardener-68 on endolinbot2: job 'endojs-endo-but-for-bots-pr242-shepherd' transient-classified (rc=1) but elapsed near-constant (2,2s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p aecee99ccc8a3663a38b1a8cec36b5631af3faee`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:08:27Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: bfbdb560811f7f0f07f59c96bba615193b83df77
- Context: gardener-11 on endolinbot2: job 'endojs-endo-but-for-bots-pr301-weave' transient-classified (rc=1) but elapsed near-constant (14,14s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p bfbdb560811f7f0f07f59c96bba615193b83df77`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:08:56Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 57459f4af366e9825bcf83dd95bf67c3f5cb3f2f
- Context: gardener-13 on endolinbot2: job 'endojs-endo-but-for-bots-pr335-shepherd' transient-classified (rc=1) but elapsed near-constant (3,3s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 57459f4af366e9825bcf83dd95bf67c3f5cb3f2f`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:09:09Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: ab4d19ce8bf1bc568d3365a2c79ceed7d8231cbd
- Context: gardener-24 on endolinbot2: job 'endojs-endo-but-for-bots-pr60-shepherd' transient-classified (rc=1) but elapsed near-constant (1,1s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p ab4d19ce8bf1bc568d3365a2c79ceed7d8231cbd`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:10:50Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: f4a2234d87b7406dc8707fddf5ee9d2d6fdd0a0c
- Context: gardener-15 on endolinbot2: job 'endojs-endo-but-for-bots-pr585-shepherd' transient-classified (rc=1) but elapsed near-constant (739,739s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p f4a2234d87b7406dc8707fddf5ee9d2d6fdd0a0c`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:11:07Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: f6774a8d5cb7ded8382308e894edac17d889caf3
- Context: gardener-25 on endolinbot2: job 'endojs-endo-but-for-bots-pr316-shepherd' transient-classified (rc=1) but elapsed near-constant (18,18s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p f6774a8d5cb7ded8382308e894edac17d889caf3`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:11:19Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 729ae45016984beec838cd6a3b035759472f201b
- Context: gardener-47 on endolinbot2: job 'endojs-endo-but-for-bots-pr235-shepherd' transient-classified (rc=1) but elapsed near-constant (9,9s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 729ae45016984beec838cd6a3b035759472f201b`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:11:50Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: b63429053fb15e6f7127fb10cb9cab933903f4f9
- Context: gardener-20 on endolinbot2: job 'endojs-endo-but-for-bots-pr377-shepherd' transient-classified (rc=1) but elapsed near-constant (792,792s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p b63429053fb15e6f7127fb10cb9cab933903f4f9`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:12:01Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 47c196b909a866a48dacd195fdf7e525b3780454
- Context: gardener-8 on endolinbot2: job 'endojs-endo-but-for-bots-pr320-shepherd' transient-classified (rc=1) but elapsed near-constant (1,1s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 47c196b909a866a48dacd195fdf7e525b3780454`.

## lane 0 -- handler-nonzero failure at 2026-07-02T01:13:45Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: f564017b6837236fd6efda66be49ca3aef50cf22
- Context: gardener-94 on endolinbot2: job 'endojs-endo-but-for-bots-pr313-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p f564017b6837236fd6efda66be49ca3aef50cf22`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:15:31Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 939962e5d1a21daceee08e49485fb0ea06db3db1
- Context: gardener-62 on endolinbot2: job 'endojs-endo-but-for-bots-pr79-shepherd' transient-classified (rc=1) but elapsed near-constant (1,1s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 939962e5d1a21daceee08e49485fb0ea06db3db1`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:16:05Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 482bfb7975ef3168419668c5f2f1361838c33a76
- Context: gardener-30 on endolinbot2: job 'improve-issue-inbox-child-git-reaping' transient-classified (rc=1) but elapsed near-constant (2,2s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 482bfb7975ef3168419668c5f2f1361838c33a76`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:17:14Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 30d972f70c86e39f62d7d0aa17a332eb49db9890
- Context: gardener-10 on endolinbot2: job 'endojs-endo-but-for-bots-pr593-shepherd' transient-classified (rc=1) but elapsed near-constant (4,4s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 30d972f70c86e39f62d7d0aa17a332eb49db9890`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:17:52Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 39a401624790acd0639f4272273f81ce72f99d30
- Context: gardener-44 on endolinbot2: job 'improve-garden-identity-drift-detector' transient-classified (rc=1) but elapsed near-constant (2,2s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 39a401624790acd0639f4272273f81ce72f99d30`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:18:05Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 6d1af9856ca36174d73b05fcdd6157337cd7a777
- Context: gardener-5 on endolinbot2: job 'endojs-endo-but-for-bots-pr306-weaver' transient-classified (rc=1) but elapsed near-constant (1,1s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 6d1af9856ca36174d73b05fcdd6157337cd7a777`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:18:17Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: a1fc3beea4f7a95f6824aeced025d1972a4ebf16
- Context: gardener-80 on endolinbot2: job 'improve-gardener-transient-failure-backoff-and-fleet-brake' transient-classified (rc=1) but elapsed near-constant (7,7s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p a1fc3beea4f7a95f6824aeced025d1972a4ebf16`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:18:33Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: c1b887f477c8a4f0f68385097e8cdacd6dda3da4
- Context: gardener-64 on endolinbot2: job 'improve-repo-watcher-arm-retry' transient-classified (rc=1) but elapsed near-constant (2,2s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p c1b887f477c8a4f0f68385097e8cdacd6dda3da4`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:20:01Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 39d7bd4a8af6fd0970485d2187e4b59b3d282b67
- Context: gardener-98 on endolinbot2: job 'endojs-endo-but-for-bots-pr101-weaver' transient-classified (rc=1) but elapsed near-constant (6,6s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 39d7bd4a8af6fd0970485d2187e4b59b3d282b67`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:20:23Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: f0a4bfa59ef18a5fbaa76be510844e3407e3082e
- Context: gardener-79 on endolinbot2: job 'endojs-endo-but-for-bots-pr96-shepherd' transient-classified (rc=1) but elapsed near-constant (42,42s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p f0a4bfa59ef18a5fbaa76be510844e3407e3082e`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:20:44Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: a1acf0e58fe1830e0079b129969b91a669cc03f0
- Context: gardener-35 on endolinbot2: job 'endojs-endo-but-for-bots-pr394-fixer' transient-classified (rc=1) but elapsed near-constant (2,2s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p a1acf0e58fe1830e0079b129969b91a669cc03f0`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-02T01:21:38Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 3e599a1cc0920b99c2ca0e4478da8257e61491a1
- Context: gardener-46 on endolinbot2: job 'endojs-endo-but-for-bots-pr216-weave' transient-classified (rc=1) but elapsed near-constant (4,4s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 3e599a1cc0920b99c2ca0e4478da8257e61491a1`.

## lane 0 -- handler-nonzero failure at 2026-07-02T01:33:41Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1718daf668d2b0be729dca5d040ee539333366a5
- Context: gardener-90 on endolinbot2: job 'endojs-endo-but-for-bots-pr591-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 1718daf668d2b0be729dca5d040ee539333366a5`.

## lane 0 -- handler-nonzero failure at 2026-07-02T01:36:27Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 0cd5483e324c7e9aacc3ab96edce5692c08e63db
- Context: gardener-90 on endolinbot2: job 'endojs-endo-but-for-bots-pr587-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 0cd5483e324c7e9aacc3ab96edce5692c08e63db`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-03T14:53:39Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 329f21b9d4c273fb0acf4efe1f224e21b208fe6f
- Context: gardener-4 on endolinbot2: job 'xs2rust-endor-build-stage3-collections' transient-classified (rc=1) but elapsed near-constant (1,1s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 329f21b9d4c273fb0acf4efe1f224e21b208fe6f`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-03T15:03:26Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 96302ff67955ae848e075fb5f21c5ce507b06c40
- Context: gardener-1 on endolinbot2: job 'xs2rust-endor-press-20260703-145003' transient-classified (rc=1) but elapsed near-constant (2,2s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 96302ff67955ae848e075fb5f21c5ce507b06c40`.
