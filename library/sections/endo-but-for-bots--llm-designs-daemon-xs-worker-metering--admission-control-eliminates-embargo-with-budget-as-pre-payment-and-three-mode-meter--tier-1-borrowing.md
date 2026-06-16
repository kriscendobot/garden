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
title: §Tier-1 borrowing
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter
---

- §admission-control-eliminates-embargo (worst-case-coverage at
  delivery eliminates the need for output buffering)
- §exploit-a-pre-condition-to-eliminate-a-mechanism (sibling
  to cycle 182's §exploit-the-pre-jump-window)
- §budget-as-pre-payment-not-post-payment (actual cost may be
  much less than guaranteed cost; leaves budget for next)
- §hard-limit-as-termination-not-pause (XS state after abort
  unreliable; snapshot infrastructure provides re-creation)
- §three-mode-meter (Measurement default / Quota / Rate-limited)
- §named-modes-as-discriminated-union
- §lazy-rate-limit-refill (compute-on-demand; no background
  timer)
- §ready_time-as-tokio-scheduling-hint (single wake-up rather
  than polling)
- §burst-ceiling-prevents-budget-hoarding (structural bound)
- §meter-config-once-not-per-crank (admission gate lives in
  supervisor)
- §custom-fxAbort-via-longjmp (recoverable abort instead of
  process exit)
- §design-evolution-record-in-prompt-section (preserves both
  earlier-rejected-approach and the realization)
