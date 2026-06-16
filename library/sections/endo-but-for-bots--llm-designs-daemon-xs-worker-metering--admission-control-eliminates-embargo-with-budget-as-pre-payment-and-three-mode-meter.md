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
kind: index
section_count: 18
---

Sections:

- [Admission control eliminates embargo, with budget-as-pre-payment, hard-limit-as-termination, and three-mode meter (Measurement / Quota / Rate-limited)](endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter--admission-control-eliminates-embargo-with-budget-as-pre-payment-hard-limit-as-te.md)
- [§The-§Key-Insight-section (the design names it explicitly)](endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter--the-key-insight-section-the-design-names-it-explicitly.md)
- [§The-architectural-invariant (admission control)](endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter--the-architectural-invariant-admission-control.md)
- [§Three-modes (the meter mode lattice)](endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter--three-modes-the-meter-mode-lattice.md)
- [§Layered-architecture (the two-thread spine)](endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter--layered-architecture-the-two-thread-spine.md)
- [§Budget-as-pre-payment-not-post-payment (Decision 5)](endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter--budget-as-pre-payment-not-post-payment-decision-5.md)
- [§Hard-limit-as-termination-not-pause (Decision 2)](endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter--hard-limit-as-termination-not-pause-decision-2.md)
- [§Lazy-rate-limit-refill (Decision 3)](endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter--lazy-rate-limit-refill-decision-3.md)
- [§Burst-ceiling-prevents-budget-hoarding (Decision 4)](endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter--burst-ceiling-prevents-budget-hoarding-decision-4.md)
- [§meter-config-once-not-per-crank (Decision 7)](endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter--meter-config-once-not-per-crank-decision-7.md)
- [§Seven-Design-Decisions (the canonical format)](endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter--seven-design-decisions-the-canonical-format.md)
- [§Five-control-verbs + §meter-report (the verb taxonomy)](endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter--five-control-verbs-meter-report-the-verb-taxonomy.md)
- [§Snapshot-integration (Phase 6, the trio cohesion)](endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter--snapshot-integration-phase-6-the-trio-cohesion.md)
- [§Seven-phases-all-Complete](endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter--seven-phases-all-complete.md)
- [§Five-known-gaps-with-§add-if-a-consumer-asks-discipline](endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter--five-known-gaps-with-add-if-a-consumer-asks-discipline.md)
- [§Cohesion notes](endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter--cohesion-notes.md)
- [§Tier-1 borrowing](endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter--tier-1-borrowing.md)
- [§Synthesis-target](endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter--synthesis-target.md)
