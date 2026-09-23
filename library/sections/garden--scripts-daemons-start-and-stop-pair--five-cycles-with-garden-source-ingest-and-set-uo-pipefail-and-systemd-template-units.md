---
title: "garden/scripts/daemons/{start,stop}.sh + config.sh.example — five-cycles-with-garden-repo-source-ingest; the-named-deliberate-`set -uo pipefail`-WITHOUT-`-e` (distinct from cycle 298's `set -euo pipefail`); systemd `--user` instance-template-units; host-local-gitignored-config + checked-in `.example`; `shellcheck disable=SC2034`-WITH-justification; `exit 64` extends cycle 298; named-graceful-fallback (`exit 0`) when config missing"
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
kind: index
section_count: 4
---

Sections:

- [`garden/scripts/daemons/{start,stop}.sh + config.sh.example` (daemon-management triple ingest)](garden--scripts-daemons-start-and-stop-pair--five-cycles-with-garden-source-ingest-and-set-uo-pipefail-and-systemd-template-units--garden-scripts-daemons-start-stop-sh-config-sh-example-daemon-management-triple.md)
- [Key moves](garden--scripts-daemons-start-and-stop-pair--five-cycles-with-garden-source-ingest-and-set-uo-pipefail-and-systemd-template-units--key-moves.md)
- [Cross-cycle pattern accumulation](garden--scripts-daemons-start-and-stop-pair--five-cycles-with-garden-source-ingest-and-set-uo-pipefail-and-systemd-template-units--cross-cycle-pattern-accumulation.md)
- [Notes](garden--scripts-daemons-start-and-stop-pair--five-cycles-with-garden-source-ingest-and-set-uo-pipefail-and-systemd-template-units--notes.md)
