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
