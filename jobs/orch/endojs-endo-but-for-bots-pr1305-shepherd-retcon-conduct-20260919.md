---
child-endojs-endo-but-for-bots-pr1305-shepherd-20260919-failure-notified: true
child-endojs-endo-but-for-bots-pr1305-shepherd-20260919-host: endolin-garden-ece02cb4
child-endojs-endo-but-for-bots-pr1305-shepherd-20260919-reap-count: 0
order: serial
children: endojs-endo-but-for-bots-pr1305-shepherd-20260919 endojs-endo-but-for-bots-pr1305-retcon-20260919 endojs-endo-but-for-bots-pr1305-conduct-20260919
on-child-failure: halt
state: running
created_by: gardener:endojs-endo-but-for-bots-pr1305-d4fa4360
created_at: 2026-09-19T06:14:07Z
---

# Shepherd → retcon → conduct endojs/endo-but-for-bots PR #1305 (belayed directive)

Maintainer @kriskowal on 2026-09-19 directed **"Belay that. Please shepherd,
retcon, and conduct."** on PR #1305
(https://github.com/endojs/endo-but-for-bots/pull/1305#issuecomment-5739760774),
superseding the prior "rebase and shepherd" (comment 5739672933) — the rebase is
already done (base retargeted onto `llm`; slices #1304 and #1306 merged).

This campaign runs the three ops SERIALLY, halting on any child failure:
  1. endojs-endo-but-for-bots-pr1305-shepherd-20260919  — drive CI green
     (current head has a `test (24.x, macos-15)` failure).
  2. endojs-endo-but-for-bots-pr1305-retcon-20260919    — per-package restage with
     a separate `chore: Update yarn.lock` commit, net diff invariant; force-push
     RE-TRIGGERS CI.
  3. endojs-endo-but-for-bots-pr1305-conduct-20260919   — wait for the re-triggered
     CI to go green, then merge (conductor owns the method).

Landing #1305 resolves the last artifact-level blocker of arc item 7's CapTP half
(kriscendobot/garden#89).
