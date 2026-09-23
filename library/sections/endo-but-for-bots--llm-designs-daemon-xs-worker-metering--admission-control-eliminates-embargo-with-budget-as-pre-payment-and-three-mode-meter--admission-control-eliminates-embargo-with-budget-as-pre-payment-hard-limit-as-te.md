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
title: Admission control eliminates embargo, with budget-as-pre-payment, hard-limit-as-termination, and three-mode meter (Measurement / Quota / Rate-limited)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter
---

> §Designs-lane after cycle 183's chat-lane. §The-eighteenth-
> consecutive designs/chat alternation cycle (166-184). §Status:
> **Complete** — all seven phases implemented and tested.
> §This-ingest-completes-the-§xs-worker-capability-trio with
> cycle 178 (snapshot) + cycle 182 (debugger).

`daemon-xs-worker-metering.md` (829 lines, Created 2026-04-17,
Status **Complete**) designs measurement, quota enforcement,
and rate limiting for XS workers' computrons (the "computation
step" count XS already maintains via `meterIndex`).

§The-design-is-a §three-design-sibling-trio member:

| Cycle | Design | Status | Capability |
|-------|--------|--------|------------|
| 178 | daemon-xs-worker-snapshot | In Progress | suspend/resume |
| 182 | daemon-xs-worker-debugger | In Progress | inspect/control |
| **184** | **daemon-xs-worker-metering** | **Complete** | **measure/quota/rate-limit** |

§All-three-extend the cycle 176 endor Rust supervisor with
non-obvious worker-level capabilities; §all-three-use-the-
envelope-bus as the control plane. §The-metering-design is the
only one currently Complete.

§The-single-most-structurally-interesting-move is §admission-
control-eliminates-embargo combined with §budget-as-pre-
payment-not-post-payment. §The-architectural-insight: ensure
budget ≥ worst-case-cost before delivery, so the simpler
invariant ("no embargo needed") holds — any crank that
completes normally is fully paid for at delivery time.
