---
role: gardener
handler-timeout: 7200
auto_gauntlet: true
build_job: fix-botanist-scripts-enabled-install-gap
pr: https://github.com/endojs/endo-but-for-bots/pull/867
---

Automatic gauntlet handoff for completed feature build fix-botanist-scripts-enabled-install-gap.

The build opened https://github.com/endojs/endo-but-for-bots/pull/867 and it is an OPEN PR owed the bot-side chain. Run the full
gardening state machine now: clean, panel, fixer loop as needed, CI, then un-draft
only when the panel terminates cleanly. This handoff was posted by the build
completion edge, not inferred by a watcher.

NOTE: this PR was found NON-DRAFT at the build completion edge, against the
unconditional draft norm (roles/builder/AGENT.md), and this hook converted it back
to draft so the chain can run. Nothing here has been panel-reviewed: treat it as a
cold PR owed a full review, not as work that already passed and regressed.

<!-- garden-reaped: 2 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  claimed_at: 2026-07-29T16:04:59Z
