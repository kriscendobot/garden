---
title: "`garden/scripts/daemons/{start,stop}.sh + config.sh.example` (daemon-management triple ingest)"
section-slug: garden--scripts-daemons-start-and-stop-pair--five-cycles-with-garden-source-ingest-and-set-uo-pipefail-and-systemd-template-units
source-slug: garden--scripts-daemons-start-and-stop-pair
url: https://github.com/kriskowal/garden/blob/main/scripts/daemons/start.sh
authors: [Endo project (collective; the garden's named-role-as-author convention)]
repo: kriskowal/garden
path: scripts/daemons/{start.sh, stop.sh, config.sh.example}
total-lines: 174 (81 start + 69 stop + 24 config-example)
ingest-cycle: 300
ingest-date: 2026-06-11
lane: chat
scope: full
parent: garden--scripts-daemons-start-and-stop-pair--five-cycles-with-garden-source-ingest-and-set-uo-pipefail-and-systemd-template-units
---

A 81+69+24=174-line cluster of bash scripts implementing **the-named-host-local-daemon-management-discipline** for the garden's driver lanes and per-feed watchers, layered on top of systemd's `--user` manager. The fifth garden source ingested. **§five-cycles-with-garden-repo-source-ingest** (281 + 297 + 298 + 299 + 300). **§the-named-cycle-300-IS-the-named-three-hundredth-cycle-milestone**.

The cycle 297 WORKTREES.md and cycle 299 CLAUDE.md both *reference* the daemon scripts in prose; cycle 300 *ingests their source*. **§the-named-design-to-implementation-bridge-across-multiple-cycles** (296 + 297 + 298 + 299 + 300): the prose names the contract; the scripts realize it.
