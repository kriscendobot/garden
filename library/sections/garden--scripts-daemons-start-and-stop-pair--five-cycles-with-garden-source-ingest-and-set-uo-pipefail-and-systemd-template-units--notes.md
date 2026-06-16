---
title: Notes
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

- Cycle 300 IS the **three-hundredth** cycle of the librarian's one-source-per-cycle cadence. The chat-lane / designs-lane alternation continues unbroken (designs cycle 299; chat cycle 300; the next cycle 301 IS designs-lane).
- The five-cycle garden-meta cluster (281+297+298+299+300) IS now the library's largest single-repo cluster.
- Three of the five garden ingests are now source files (298 dispatch-prepare/teardown; 300 daemons start/stop/config); two are designs/standing-reference docs (281 designs/driver.md; 297 WORKTREES.md); one IS project instructions (299 CLAUDE.md). **§the-named-five-into-three-source-and-two-document-and-one-instructions split**.
- The named-deliberate-`set -uo pipefail`-WITHOUT-`-e` choice (cycle 300) IS the second deliberate bash-strictness stance surfaced in the library; cycle 298 named `set -euo pipefail` as the first shape; cycle 300 names `set -uo pipefail` as the deliberate alternative. The two together form **§the-named-bash-strictness-discipline-IS-context-determined-not-universal**.
- The named-host-local-gitignored-config + checked-in-`.example` template-pair IS a pattern that recurs across many projects but IS named explicitly here for the first time in the library.
- The named-shellcheck-suppression-WITH-justification IS a deliberate methodological choice that contrasts with cycle 298's named-no-shellcheck-suppressions; both are valid stances, cycle-context-determined.
