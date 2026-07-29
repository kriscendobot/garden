---
role: gardener
handler-timeout: 7200
auto_gauntlet: true
build_job: endo-cbor-adopt-ocapn
pr: https://github.com/endojs/endo-but-for-bots/pull/885
---

Automatic gauntlet handoff for completed feature build endo-cbor-adopt-ocapn.

The build opened https://github.com/endojs/endo-but-for-bots/pull/885 and it is an OPEN PR owed the bot-side chain. Run the full
gardening state machine now: clean, panel, fixer loop as needed, CI, then un-draft
only when the panel terminates cleanly. This handoff was posted by the build
completion edge, not inferred by a watcher.

<!-- garden-reaped: 2 -->

<!-- garden-productive-cycle -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 8
  worker_kind: gardener
  claimed_at: 2026-07-29T02:14:46Z
