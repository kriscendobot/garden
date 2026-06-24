---
source: designs/daemon-xs-worker-metering.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-xs-worker-metering.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
status_at_ingest: Complete
genre: §endo-but-for-bots-design §sibling-design-trio
cycle: 184
lane: designs
status: current
title: §Seven-phases-all-Complete
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter
---

| Phase | What | Status |
|-------|------|--------|
| 1 | Machine metering API + 9 unit tests | Complete |
| 2 | Crank-level metering in reactive pump loop | Complete |
| 3 | Supervisor MeterState + 11 codec round-trip tests | Complete |
| 4 | Admission gate (route_message check + pending_delivery buffer) | Complete |
| 5 | Rate limiting (lazy refill + ready_time scheduling) | Complete |
| 6 | Snapshot integration (SuspendedWorker.meter) | Complete |
| 7 | JS manager integration (controlPowers extensions) | Complete |

§Status-Complete with the Status section enumerating each
phase + file paths + test counts (9 metering + 11 codec round-
trip = 20+ tests).

§The-§C-helpers section names §custom-fxAbort (longjmp for
recoverable aborts instead of `exit()`) — §a-non-obvious-C-
contribution required to make the §hard-limit-termination
recoverable-at-the-supervisor-level.

§Compare-to-cycle-180-hex-package's §design-phase-after-
implementation-phase. §This-design-shipped-with-Status-Complete-
and-named-phase-completions-with-file-paths-in-the-Status-
section. §The-design-document-is-the-archive-of-validated-
disciplines.
