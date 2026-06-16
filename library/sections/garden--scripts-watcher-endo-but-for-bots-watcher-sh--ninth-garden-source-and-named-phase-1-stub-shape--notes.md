---
title: Notes
section-slug: garden--scripts-watcher-endo-but-for-bots-watcher-sh--ninth-garden-source-and-named-phase-1-stub-shape
source-slug: garden--scripts-watcher-endo-but-for-bots-watcher-sh
url: https://github.com/kriskowal/garden/blob/main/scripts/watcher/endo-but-for-bots/watcher.sh
authors: [Endo project (collective; role-as-author convention)]
repo: kriskowal/garden
path: scripts/watcher/endo-but-for-bots/watcher.sh
total-lines: 60
ingest-cycle: 304
ingest-date: 2026-06-11
lane: chat
scope: full
parent: garden--scripts-watcher-endo-but-for-bots-watcher-sh--ninth-garden-source-and-named-phase-1-stub-shape
---

- Cycle 304 IS the **third script-implementation source** in the garden cluster (after cycle 298's dispatch-prepare/teardown pair and cycle 300's daemons triple). The garden has now established a §three-cycles-with-named-script-implementation-source pattern.
- The named-Phase-1-stub IS a deliberate vertical-slice realization: the systemd plumbing works end-to-end, the contract IS named, the feed integration IS deferred. **§the-named-plumbing-first-substance-later-discipline**.
- The named-stub-IS-named-contract-bearer: the stub's docstring NAMES the five-step contract its eventual implementation must satisfy. Cycle 281's designs/driver.md named the rationale; cycle 304 names the contract; the eventual Phase 2-5 implementation will name the realization.
- The named-parameterized-prefix-shape (`watcher[<slug>]:`) extends cycle 300's named-prefix-discipline. Combined with cycle 300's named-systemd-template-units, the prefix IS named-instance-aware: when systemd instantiates `garden-watcher@endo-but-for-bots.service`, the script's `FEED_SLUG=endo-but-for-bots` constant matches the instance, and `journalctl --user -u garden-watcher@endo-but-for-bots.service` shows lines prefixed `watcher[endo-but-for-bots]:`. **§the-named-three-fold-instance-encoding** (systemd template + bash constant + log prefix all carry the slug).
