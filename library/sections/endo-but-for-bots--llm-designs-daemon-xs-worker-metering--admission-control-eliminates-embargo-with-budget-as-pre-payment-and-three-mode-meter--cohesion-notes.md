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
title: §Cohesion notes
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter
---

- §Sibling-design-pair with cycle 178 (worker-snapshot) +
  cycle 182 (worker-debugger). §The-trio-is-complete; this
  design cites both siblings in its Dependencies table.
- §Admission-control-eliminates-embargo is the §key-insight
  the design names explicitly — a §design-evolution-record in
  the Prompt section.
- §Budget-as-pre-payment-not-post-payment with §worst-case-
  coverage at delivery time = §no-rollback-needed.
- §Hard-limit-as-termination-not-pause depends on cycle 178's
  snapshot infrastructure for re-creation; the trio coheres.
- §Lazy-rate-limit-refill (on-demand vs background-timer) is
  the §third-flavor between cycle 156's GC-driven and cycle
  173's known-event-immediate.
- §Burst-ceiling-prevents-budget-hoarding is a §structural-
  bound-not-runtime-decision.
- §Three-modes (Measurement / Quota / RateLimited) with
  Measurement-as-default = §named-modes-as-discriminated-union.
- §Two-thread-architecture (supervisor tokio + XS thread)
  simpler than cycle 182's §six-layer-stack because the
  problem is simpler.
- §Seven-Design-Decisions in the §canonical-format.
- §Five-control-verbs + meter-report + meter-config = seven
  envelope verbs in the meter taxonomy.
- §Seven-phases-all-Complete with file paths + test counts
  in the Status section.
- §Six-known-gaps-honestly-disclosed.
- §custom-fxAbort C helper (longjmp instead of exit) is the
  §non-obvious-C-contribution making hard-limit-termination
  recoverable.
