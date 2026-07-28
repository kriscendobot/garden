---
host: ps23
role: gardener
last_drained_at: 1970-01-01T00:00:00Z
last_drained_commit:
---

# gardener inbox state on ps23

Append-only failure log. Each section is a discrete failure event
appended by a job-board service or worker via
`skills/gardener-inbox-error-reporting/report-error.sh`. The gardener
reads entries on its next dispatch.


## lane 0 -- handler-nonzero failure at 2026-07-27T20:27:42Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 0c19e9193365e206fb504997b8fceab0ccc0f68a
- Context: gardener-8 on ps23: job 'self-heal-fix-garden-ci-watcher-kriscendobot-garden-reconcile-disarm-list-units' handler exited rc=1

Inspect via `git -C journal cat-file -p 0c19e9193365e206fb504997b8fceab0ccc0f68a`.

## lane 0 -- handler-nonzero failure at 2026-07-27T20:33:36Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 07ce1e65c5a6624c1380c7ec3a47a38a736f6cf1
- Context: gardener-7 on ps23: job 'endojs-endo-but-for-bots-pr713-gauntlet-backfill' handler exited rc=1

Inspect via `git -C journal cat-file -p 07ce1e65c5a6624c1380c7ec3a47a38a736f6cf1`.

## lane 0 -- handler-nonzero failure at 2026-07-27T20:54:25Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 66ab1f9273b9816c85d60104044a68b770b98eba
- Context: gardener-5 on ps23: job 'endojs-endo-but-for-bots-pr874-8ed41495' handler exited rc=1

Inspect via `git -C journal cat-file -p 66ab1f9273b9816c85d60104044a68b770b98eba`.

## lane 0 -- handler-nonzero failure at 2026-07-27T21:23:22Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 6ec4e2118d8bb17b83e04566cd43079db5164ac2
- Context: gardener-7 on ps23: job 'issue-kriskowal-garden-67' handler exited rc=1

Inspect via `git -C journal cat-file -p 6ec4e2118d8bb17b83e04566cd43079db5164ac2`.

## lane 0 -- handler-nonzero failure at 2026-07-27T21:53:25Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 968e03c81825e47e71022551abf776570390188a
- Context: gardener-8 on ps23: job 'finbot-progress-20260727-175002' handler exited rc=1

Inspect via `git -C journal cat-file -p 968e03c81825e47e71022551abf776570390188a`.

## lane 0 -- handler-nonzero failure at 2026-07-27T22:04:01Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e58fe46d851ab34fe28212a78bd18fd9b277ffc8
- Context: gardener-3 on ps23: job 'garden-repo-transfer-followthrough' handler exited rc=1

Inspect via `git -C journal cat-file -p e58fe46d851ab34fe28212a78bd18fd9b277ffc8`.

## lane 0 -- handler-nonzero failure at 2026-07-27T22:19:21Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1d1d711f9dbfd587445532bde264c2909c33e9e4
- Context: gardener-6 on ps23: job 'gnome-backend-autotune-design' handler exited rc=1

Inspect via `git -C journal cat-file -p 1d1d711f9dbfd587445532bde264c2909c33e9e4`.

## lane 0 -- handler-nonzero failure at 2026-07-27T22:28:13Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: cecbbe21614b5efa113a4dfc4b92bf099f9aef41
- Context: gardener-4 on ps23: job 'consolidate-maintainer-inbox-20260727' handler exited rc=1

Inspect via `git -C journal cat-file -p cecbbe21614b5efa113a4dfc4b92bf099f9aef41`.

## lane 0 -- handler-nonzero failure at 2026-07-27T22:34:02Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: a404c96381b06af4848fe427d09689a4bf85190d
- Context: gardener-6 on ps23: job 'ollama-hermit-simple-job-capability' handler exited rc=1

Inspect via `git -C journal cat-file -p a404c96381b06af4848fe427d09689a4bf85190d`.

## lane 0 -- handler-nonzero failure at 2026-07-27T23:31:05Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: abfe86c07859388b062a322aefe90712097c0db4
- Context: gardener-2 on ps23: job 'xs2rust-endor-press-20260727-182001' handler exited rc=1

Inspect via `git -C journal cat-file -p abfe86c07859388b062a322aefe90712097c0db4`.

## lane 0 -- handler-nonzero failure at 2026-07-28T00:47:30Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1a305dda6ee43f2489873d54b12e7c021cadc94f
- Context: gardener-3 on ps23: job 'endojs-endo-but-for-bots-pr779-gauntlet-backfill' handler exited rc=1

Inspect via `git -C journal cat-file -p 1a305dda6ee43f2489873d54b12e7c021cadc94f`.

## lane 0 -- handler-nonzero failure at 2026-07-28T00:47:39Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 670857b7db4be95f0300081fb248e654777ff9a5
- Context: gardener-1 on ps23: job 'endo-git-integration-press-20260728-004711' handler exited rc=1

Inspect via `git -C journal cat-file -p 670857b7db4be95f0300081fb248e654777ff9a5`.

## lane 0 -- handler-nonzero failure at 2026-07-28T00:47:48Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 24687274cf7bb40e192079f5d55d50620d5c7d4c
- Context: gardener-1 on ps23: job 'endojs-endo-but-for-bots-pr825-8840fcdb' handler exited rc=1

Inspect via `git -C journal cat-file -p 24687274cf7bb40e192079f5d55d50620d5c7d4c`.

## lane 0 -- handler-nonzero failure at 2026-07-28T00:47:54Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ac004c344543fb945287071a1e0fa9b130200cf2
- Context: gardener-8 on ps23: job 'endojs-endo-but-for-bots-pr705-fixer-changes-requested' handler exited rc=1

Inspect via `git -C journal cat-file -p ac004c344543fb945287071a1e0fa9b130200cf2`.

## lane 0 -- handler-nonzero failure at 2026-07-28T00:48:01Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 54e3a2f38c33051483ac0268799e9e3b473e74d9
- Context: gardener-1 on ps23: job 'endojs-endo-but-for-bots-pr874-gauntlet-retry' handler exited rc=1

Inspect via `git -C journal cat-file -p 54e3a2f38c33051483ac0268799e9e3b473e74d9`.

## lane 0 -- handler-nonzero failure at 2026-07-28T00:48:11Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: acbb372ce1f0a248b1a103d67341733d48b95d63
- Context: gardener-5 on ps23: job 'endojs-endo-but-for-bots-pr713-gauntlet-backfill' handler exited rc=1

Inspect via `git -C journal cat-file -p acbb372ce1f0a248b1a103d67341733d48b95d63`.

## lane 0 -- handler-nonzero failure at 2026-07-28T00:48:29Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 6155bbf6b4945253a716d88b33a8475e3d0d0100
- Context: gardener-6 on ps23: job 'endo-byte-array-press-20260728-004711' handler exited rc=1

Inspect via `git -C journal cat-file -p 6155bbf6b4945253a716d88b33a8475e3d0d0100`.

## lane 0 -- handler-nonzero failure at 2026-07-28T00:48:55Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 835b09215e61c20ff51edfe1b3a5af25b6ab93ce
- Context: gardener-1 on ps23: job 'finbot-progress-20260728-004711' handler exited rc=1

Inspect via `git -C journal cat-file -p 835b09215e61c20ff51edfe1b3a5af25b6ab93ce`.

## lane 0 -- handler-nonzero failure at 2026-07-28T00:49:03Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 518d6662ae416237d98a32c09a08a37d3aa04306
- Context: gardener-1 on ps23: job 'ocapn-noise-press-20260728-004711' handler exited rc=1

Inspect via `git -C journal cat-file -p 518d6662ae416237d98a32c09a08a37d3aa04306`.

## lane 0 -- handler-nonzero failure at 2026-07-28T00:49:47Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4b5b36c539031c64a9178ce7c52999820edecea5
- Context: gardener-4 on ps23: job 'xs2rust-endor-press-20260728-004711' handler exited rc=1

Inspect via `git -C journal cat-file -p 4b5b36c539031c64a9178ce7c52999820edecea5`.

## lane 0 -- handler-nonzero failure at 2026-07-28T01:00:21Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 87cbb1dd297d46bd6ae6bf40ae8d40c137c5ba3c
- Context: gardener-7 on ps23: job 'endojs-endo-but-for-bots-pr755-review-a0778b2e' handler exited rc=1

Inspect via `git -C journal cat-file -p 87cbb1dd297d46bd6ae6bf40ae8d40c137c5ba3c`.

## lane 0 -- handler-nonzero failure at 2026-07-28T01:00:41Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: f4497c5b0d0434363474e14451b571b954e6070d
- Context: gardener-3 on ps23: job 'endojs-endo-but-for-bots-pr874-8ed41495' handler exited rc=1

Inspect via `git -C journal cat-file -p f4497c5b0d0434363474e14451b571b954e6070d`.

## lane 0 -- handler-nonzero failure at 2026-07-28T01:01:25Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b253ba3744131949c198ba32204aa9f53772a521
- Context: gardener-2 on ps23: job 'xs2rust-endor-s1-daemon-integration' handler exited rc=1

Inspect via `git -C journal cat-file -p b253ba3744131949c198ba32204aa9f53772a521`.

## lane 0 -- handler-nonzero failure at 2026-07-28T01:01:54Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 6067815b4568aebfd8b63ea60303bb73dcdaec3b
- Context: gardener-8 on ps23: job 'self-heal-fix-garden-comment-watcher-kriscendobot-chrome-native-function-caller-arguments-repro-upstream-404' handler exited rc=1

Inspect via `git -C journal cat-file -p 6067815b4568aebfd8b63ea60303bb73dcdaec3b`.

## lane 0 -- handler-nonzero failure at 2026-07-28T01:04:08Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: d2be48c26155b7e7dc53f19a9de7b7984c2465a6
- Context: gardener-2 on ps23: job 'self-heal-fix-garden-ci-watcher-kriscendobot-chrome-native-function-caller-arguments-repro-dead-upstream-404' handler exited rc=1

Inspect via `git -C journal cat-file -p d2be48c26155b7e7dc53f19a9de7b7984c2465a6`.

## lane 0 -- handler-nonzero failure at 2026-07-28T01:04:37Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: fa759460d261b6166d9ecec5094e7d30743decce
- Context: gardener-2 on ps23: job 'endojs-endo-but-for-bots-pr869-dependabot' handler exited rc=1

Inspect via `git -C journal cat-file -p fa759460d261b6166d9ecec5094e7d30743decce`.

## lane 0 -- handler-nonzero failure at 2026-07-28T01:05:10Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 2823dc5f9ef763424a1537fc44894f572075c182
- Context: gardener-8 on ps23: job 'endojs-endo-but-for-bots-pr867-dependabot' handler exited rc=1

Inspect via `git -C journal cat-file -p 2823dc5f9ef763424a1537fc44894f572075c182`.

## lane 0 -- handler-nonzero failure at 2026-07-28T01:05:37Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ff9e408b4a75fb38636e446c1e2106b319679717
- Context: gardener-7 on ps23: job 'endojs-endo-but-for-bots-pr562-dependabot' handler exited rc=1

Inspect via `git -C journal cat-file -p ff9e408b4a75fb38636e446c1e2106b319679717`.

## lane 0 -- handler-nonzero failure at 2026-07-28T01:06:03Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 8ecbbd56660d471cabc3d30067d703548380405d
- Context: gardener-2 on ps23: job 'endojs-endo-but-for-bots-pr560-dependabot' handler exited rc=1

Inspect via `git -C journal cat-file -p 8ecbbd56660d471cabc3d30067d703548380405d`.

## lane 0 -- handler-nonzero failure at 2026-07-28T01:06:25Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b3fbf4a81dcd33901079e5f89fba81f3c1560d17
- Context: gardener-1 on ps23: job 'self-heal-fix-garden-dependabot-watcher-kriscendobot-chrome-native-function-caller-arguments-repro-armed-fork-upstream-404-no-disarm' handler exited rc=1

Inspect via `git -C journal cat-file -p b3fbf4a81dcd33901079e5f89fba81f3c1560d17`.

## lane 0 -- handler-nonzero failure at 2026-07-28T01:06:54Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ed4d88fb28b1b765b0019c468d59dc54732c1188
- Context: gardener-1 on ps23: job 'endojs-endo-but-for-bots-pr268-dependabot' handler exited rc=1

Inspect via `git -C journal cat-file -p ed4d88fb28b1b765b0019c468d59dc54732c1188`.

## lane 0 -- handler-nonzero failure at 2026-07-28T01:11:27Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: a1c015328a952410301adc6fd806aa8c558bd0ea
- Context: gardener-7 on ps23: job 'fix-fork-watch-dead-upstream-armed-slug' handler exited rc=1

Inspect via `git -C journal cat-file -p a1c015328a952410301adc6fd806aa8c558bd0ea`.

## lane 0 -- handler-nonzero failure at 2026-07-28T01:12:21Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: df42a95e3099bec6df4fe4692a7c6c30e4e81dcd
- Context: gardener-4 on ps23: job 'endojs-endo-but-for-bots-pr868-lint-fix' handler exited rc=1

Inspect via `git -C journal cat-file -p df42a95e3099bec6df4fe4692a7c6c30e4e81dcd`.

## lane 0 -- handler-nonzero failure at 2026-07-28T01:18:42Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 5b5f9923f7e33bc9ed074f541d4ac62326518949
- Context: gardener-2 on ps23: job 'fu-endo-npm-cas-registry-press-20260728-004711-1' handler exited rc=1

Inspect via `git -C journal cat-file -p 5b5f9923f7e33bc9ed074f541d4ac62326518949`.

## lane 0 -- handler-nonzero failure at 2026-07-28T01:19:42Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 2af559d978016f01e92139b0f98d805b91b3b73a
- Context: gardener-4 on ps23: job 'design-sysop-host-operations-daemon' handler exited rc=1

Inspect via `git -C journal cat-file -p 2af559d978016f01e92139b0f98d805b91b3b73a`.

## lane 0 -- handler-nonzero failure at 2026-07-28T01:20:34Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e2823804a352ea574722cc924fe0fd67a1df1b1a
- Context: gardener-3 on ps23: job 'dependabotany-recheck-endo-but-for-bots-20260728-012002' handler exited rc=1

Inspect via `git -C journal cat-file -p e2823804a352ea574722cc924fe0fd67a1df1b1a`.

## lane 0 -- handler-nonzero failure at 2026-07-28T01:23:53Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 3ffb0a461e44b3ed721caaebbc2475e74315fe65
- Context: gardener-6 on ps23: job 'improve-fork-watch-provisioner-armed-recheck' handler exited rc=1

Inspect via `git -C journal cat-file -p 3ffb0a461e44b3ed721caaebbc2475e74315fe65`.

## lane 0 -- handler-nonzero failure at 2026-07-28T01:33:15Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e8c727a5b8fea82d3af53af4ea99960a07942b8b
- Context: gardener-8 on ps23: job 'issue-kriskowal-garden-67' handler exited rc=1

Inspect via `git -C journal cat-file -p e8c727a5b8fea82d3af53af4ea99960a07942b8b`.

## lane 0 -- handler-nonzero failure at 2026-07-28T02:03:24Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 6828e8c482376fe88dd0903acf9f20fabe2cbb36
- Context: gardener-5 on ps23: job 'finbot-progress-20260727-175002' handler exited rc=1

Inspect via `git -C journal cat-file -p 6828e8c482376fe88dd0903acf9f20fabe2cbb36`.

## lane 0 -- handler-nonzero failure at 2026-07-28T02:13:21Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: f103de5ebad2fb5ee6087d96f00630a2b3895eab
- Context: gardener-2 on ps23: job 'garden-repo-transfer-followthrough' handler exited rc=1

Inspect via `git -C journal cat-file -p f103de5ebad2fb5ee6087d96f00630a2b3895eab`.

## lane 0 -- handler-nonzero failure at 2026-07-28T02:23:12Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 89bce4f4a6a3f10f366c6a3bc27fb68d0315ae00
- Context: gardener-1 on ps23: job 'gnome-backend-autotune-design' handler exited rc=1

Inspect via `git -C journal cat-file -p 89bce4f4a6a3f10f366c6a3bc27fb68d0315ae00`.

## lane 0 -- handler-nonzero failure at 2026-07-28T02:33:20Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 19a689b8f565a66e4fddd84d54e20a6283ad768d
- Context: gardener-1 on ps23: job 'hermit-failure-reputation-followup' handler exited rc=1

Inspect via `git -C journal cat-file -p 19a689b8f565a66e4fddd84d54e20a6283ad768d`.

## lane 0 -- handler-nonzero failure at 2026-07-28T02:54:10Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 628993aaae133d7391f8174e714ebcca12ae1c6f
- Context: gardener-8 on ps23: job 'improve-gardener-claude-bin-resolution' handler exited rc=1

Inspect via `git -C journal cat-file -p 628993aaae133d7391f8174e714ebcca12ae1c6f`.

## lane 0 -- handler-nonzero failure at 2026-07-28T03:33:17Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 941795e78da3fd7dfa03de3bf1064718f07b69fd
- Context: gardener-3 on ps23: job 'xs2rust-endor-press-20260727-182001' handler exited rc=1

Inspect via `git -C journal cat-file -p 941795e78da3fd7dfa03de3bf1064718f07b69fd`.

## lane 0 -- handler-nonzero failure at 2026-07-28T03:35:13Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 8f3ec208787598eed310e4d6dfdede6ea50a9fea
- Context: gardener-1 on ps23: job 'arc-status-daily-20260728-033502' handler exited rc=1

Inspect via `git -C journal cat-file -p 8f3ec208787598eed310e4d6dfdede6ea50a9fea`.

## lane 0 -- handler-nonzero failure at 2026-07-28T03:35:21Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 696dc4e520013702ce4fbc6aedfa536224adf640
- Context: gardener-1 on ps23: job 'esheets-supervisor-20260728-033502' handler exited rc=1

Inspect via `git -C journal cat-file -p 696dc4e520013702ce4fbc6aedfa536224adf640`.

## lane 0 -- handler-nonzero failure at 2026-07-28T04:53:23Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4faf6237d6045caf5d19b02c769fc969a5928e13
- Context: gardener-4 on ps23: job 'endojs-endo-but-for-bots-pr779-gauntlet-backfill' handler exited rc=1

Inspect via `git -C journal cat-file -p 4faf6237d6045caf5d19b02c769fc969a5928e13`.

## lane 0 -- handler-nonzero failure at 2026-07-28T04:53:43Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: c9417e6cb19c259d62303c5f6808c4c1849a69ec
- Context: gardener-1 on ps23: job 'endojs-endo-but-for-bots-pr705-fixer-changes-requested' handler exited rc=1

Inspect via `git -C journal cat-file -p c9417e6cb19c259d62303c5f6808c4c1849a69ec`.

## lane 0 -- handler-nonzero failure at 2026-07-28T04:53:47Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 935acd373f48faef7f877e16bf4a4085d449f233
- Context: gardener-6 on ps23: job 'endojs-endo-but-for-bots-pr874-gauntlet-retry' handler exited rc=1

Inspect via `git -C journal cat-file -p 935acd373f48faef7f877e16bf4a4085d449f233`.

## lane 0 -- handler-nonzero failure at 2026-07-28T04:54:02Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 0b9a29e74ed61c81072d807fe89339e35217ae73
- Context: gardener-1 on ps23: job 'endo-git-integration-press-20260728-004711' handler exited rc=1

Inspect via `git -C journal cat-file -p 0b9a29e74ed61c81072d807fe89339e35217ae73`.

## lane 0 -- handler-nonzero failure at 2026-07-28T04:54:20Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: da838c8853e3db2259410a07ec4347bda93b61fd
- Context: gardener-5 on ps23: job 'ocapn-noise-press-20260728-004711' handler exited rc=1

Inspect via `git -C journal cat-file -p da838c8853e3db2259410a07ec4347bda93b61fd`.

## lane 0 -- handler-nonzero failure at 2026-07-28T04:54:29Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 69d6b732a58373a49835457405f62e77a1cf9da1
- Context: gardener-6 on ps23: job 'endo-byte-array-press-20260728-004711' handler exited rc=1

Inspect via `git -C journal cat-file -p 69d6b732a58373a49835457405f62e77a1cf9da1`.

## lane 0 -- handler-nonzero failure at 2026-07-28T04:54:44Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 172c1deeca345a7d17a6dd6b8b47ce48cd18950c
- Context: gardener-5 on ps23: job 'endo-sturdyref-press-20260728-004711' handler exited rc=1

Inspect via `git -C journal cat-file -p 172c1deeca345a7d17a6dd6b8b47ce48cd18950c`.

## lane 0 -- handler-nonzero failure at 2026-07-28T04:54:48Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 83f23bce46a9e6d947a8bc8059a3f082d99f1858
- Context: gardener-1 on ps23: job 'endo-vfs-parity-press-20260728-004711' handler exited rc=1

Inspect via `git -C journal cat-file -p 83f23bce46a9e6d947a8bc8059a3f082d99f1858`.

## lane 0 -- handler-nonzero failure at 2026-07-28T04:54:53Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 63f05d9ce54b0ea26c12d1fb52c3ca405de1d41b
- Context: gardener-8 on ps23: job 'finbot-progress-20260728-004711' handler exited rc=1

Inspect via `git -C journal cat-file -p 63f05d9ce54b0ea26c12d1fb52c3ca405de1d41b`.

## lane 0 -- handler-nonzero failure at 2026-07-28T05:03:19Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 3b7e57e8a3870901b71ce0ac97e11da72f70e808
- Context: gardener-1 on ps23: job 'endojs-endo-but-for-bots-pr874-8ed41495' handler exited rc=1

Inspect via `git -C journal cat-file -p 3b7e57e8a3870901b71ce0ac97e11da72f70e808`.

## lane 0 -- handler-nonzero failure at 2026-07-28T05:03:24Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 1ac46f26c62f8ffdfe99396264aee41bad2bb109
- Context: gardener-4 on ps23: job 'endojs-endo-but-for-bots-pr755-review-a0778b2e' handler exited rc=1

Inspect via `git -C journal cat-file -p 1ac46f26c62f8ffdfe99396264aee41bad2bb109`.

## lane 0 -- handler-nonzero failure at 2026-07-28T05:03:33Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: a09062ab582e390630b5df5fc7ae0101615f3bcd
- Context: gardener-1 on ps23: job 'xs2rust-endor-s1-daemon-integration' handler exited rc=1

Inspect via `git -C journal cat-file -p a09062ab582e390630b5df5fc7ae0101615f3bcd`.

## lane 0 -- handler-nonzero failure at 2026-07-28T05:03:40Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 59978fed22a34976333e8f1bd0186e65aa0ac4fe
- Context: gardener-7 on ps23: job 'self-heal-fix-garden-comment-watcher-kriscendobot-chrome-native-function-caller-arguments-repro-upstream-404' handler exited rc=1

Inspect via `git -C journal cat-file -p 59978fed22a34976333e8f1bd0186e65aa0ac4fe`.

## lane 0 -- handler-nonzero failure at 2026-07-28T05:08:40Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: f46a01e480ffab2d87ae0c5efc9e6bdbf30c8a83
- Context: gardener-5 on ps23: job 'fu-endojs-endo-but-for-bots-pr825-8840fcdb-2' handler exited rc=1

Inspect via `git -C journal cat-file -p f46a01e480ffab2d87ae0c5efc9e6bdbf30c8a83`.

## lane 0 -- handler-nonzero failure at 2026-07-28T05:13:23Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 2b3198de8b3925170ea2d3bc305bdc5c73bc5d14
- Context: gardener-4 on ps23: job 'endojs-endo-but-for-bots-pr557-dependabot' handler exited rc=1

Inspect via `git -C journal cat-file -p 2b3198de8b3925170ea2d3bc305bdc5c73bc5d14`.

## lane 0 -- handler-nonzero failure at 2026-07-28T05:13:36Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 355ca9829e6d2450903dfd6f79a4ebce4ea22537
- Context: gardener-1 on ps23: job 'endojs-endo-but-for-bots-pr561-dependabot' handler exited rc=1

Inspect via `git -C journal cat-file -p 355ca9829e6d2450903dfd6f79a4ebce4ea22537`.

## lane 0 -- handler-nonzero failure at 2026-07-28T05:13:47Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4a450c889557c2100e32f6a100cbcf0049ee8b8b
- Context: gardener-1 on ps23: job 'endojs-endo-but-for-bots-pr556-dependabot' handler exited rc=1

Inspect via `git -C journal cat-file -p 4a450c889557c2100e32f6a100cbcf0049ee8b8b`.

## lane 0 -- handler-nonzero failure at 2026-07-28T05:13:56Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 3dd8eee820fa015bd49b2970adc6eec821de25b1
- Context: gardener-6 on ps23: job 'endojs-endo-but-for-bots-pr870-dependabot' handler exited rc=1

Inspect via `git -C journal cat-file -p 3dd8eee820fa015bd49b2970adc6eec821de25b1`.

## lane 0 -- handler-nonzero failure at 2026-07-28T05:14:02Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 83149894dd8627dd7e914c709460af0f6bb870c5
- Context: gardener-3 on ps23: job 'endojs-endo-but-for-bots-pr558-dependabot' handler exited rc=1

Inspect via `git -C journal cat-file -p 83149894dd8627dd7e914c709460af0f6bb870c5`.

## lane 0 -- handler-nonzero failure at 2026-07-28T05:14:14Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e0c177ad356499a5ecde519c4ee34eb34b3697c6
- Context: gardener-1 on ps23: job 'self-heal-fix-garden-ci-watcher-kriscendobot-chrome-native-function-caller-arguments-repro-dead-upstream-404' handler exited rc=1

Inspect via `git -C journal cat-file -p e0c177ad356499a5ecde519c4ee34eb34b3697c6`.

## lane 0 -- handler-nonzero failure at 2026-07-28T05:14:21Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 968f5a488a6cf6e80dccffd40abe7cc1f15a31b2
- Context: gardener-4 on ps23: job 'endojs-endo-but-for-bots-pr869-dependabot' handler exited rc=1

Inspect via `git -C journal cat-file -p 968f5a488a6cf6e80dccffd40abe7cc1f15a31b2`.

## lane 0 -- handler-nonzero failure at 2026-07-28T05:14:32Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: ed661227d758145e3d0fd772f21ea5c4abff9c62
- Context: gardener-1 on ps23: job 'endojs-endo-but-for-bots-pr562-dependabot' handler exited rc=1

Inspect via `git -C journal cat-file -p ed661227d758145e3d0fd772f21ea5c4abff9c62`.

## lane 0 -- handler-nonzero failure at 2026-07-28T05:14:37Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 2251f9ee83bd7a09d4a2b2a91c53ee90e25fea0c
- Context: gardener-5 on ps23: job 'self-heal-fix-garden-dependabot-watcher-kriscendobot-chrome-native-function-caller-arguments-repro-armed-fork-upstream-404-no-disarm' handler exited rc=1

Inspect via `git -C journal cat-file -p 2251f9ee83bd7a09d4a2b2a91c53ee90e25fea0c`.
