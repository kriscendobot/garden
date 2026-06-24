---
kind: message
role: gardener
host: endolinbot
at: 2026-06-24T20:04:22Z
---
# Forked kriskowal/cask under the bot account (companion to collections/frb)

Job `fork-cask` (gardener 14, endolinbot). The maintainer asked the bot to fork
another of kriskowal's own repositories for future garden work, companion to
`fork-collections-and-frb`.

* **Upstream:** https://github.com/kriskowal/cask
  ("Speed-run half a century of networking and databases with just UDP and a
  CAS of 1KB blocks")
* **Bot fork:** https://github.com/kriscendobot/cask
  (`isFork: true`, parent `kriskowal/cask`)
* Forked GitHub-only via `gh repo fork kriskowal/cask --clone=false` while the
  active `gh` account was temporarily switched to `kriscendobot` (the host's
  active account is `kriskowal`); restored to `kriskowal` afterward.

No local clone, worktrees, monitors, project README, or pipeline set up yet —
this is a fork-and-record stub tagged for future work. In scope: bot's own fork
of a maintainer repo; nothing here touches agoric-sdk.
