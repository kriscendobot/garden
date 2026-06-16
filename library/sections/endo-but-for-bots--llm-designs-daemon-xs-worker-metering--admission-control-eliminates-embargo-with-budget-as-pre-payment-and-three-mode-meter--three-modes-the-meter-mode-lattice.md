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
title: §Three-modes (the meter mode lattice)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter
---

| Mode | Behavior |
|------|----------|
| **Measurement** (default) | Steps counted per crank; no enforcement. Limit=0 means callback always returns true. |
| **Quota** | Fixed budget; messages buffered until budget ≥ hard_limit. Hard-limit-exceed = worker terminated. |
| **Rate-limited** | Quota plus automatic accumulation at `rate` computrons/sec, clamped at `burst`. |

§Three-modes-from-simplest-to-most-complex. §Measurement-as-
default — §zero-overhead-except-callback (interval=10000 means
one function call per ~10000 bytecode dispatches). §Rate-
limited-builds-on-quota by adding §lazy-refill.

§Compare-to-cycle-167-where/index.js's §four-state-domains
(durable / ephemeral / sock / cache). §Cycle-184-has §three-
modes; cycle 167 had §four-state-domains. §The-pattern-is
§named-modes-as-discriminated-union — make the dimensions of
the problem space explicit.

§Compare-to-cycle-180-hex-package's §three-way-classification-
of-sites (migration / boundary / non-byte-array). §Three-way-
classification is the canonical-Design-Decisions count.
