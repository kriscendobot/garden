---
section: event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
source: endo-but-for-bots--llm-designs-workers-panel
topics: [daemon, chat-ui, tooling]
status: current
title: The §test-plan-with-honest-uncertainty
parent: endo-but-for-bots--llm-designs-workers-panel--event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
---

§Test plan covers five integration scenarios + one UI test:

- Probe reports values within expected range under idle and
  loaded conditions (unit test)
- Tenant list includes the eval formula's pet name
  (integration)
- Worker logs filtered by worker pet name contain only
  entries from that worker (integration)
- Retention path from a worker traces back to a pet store
  root (integration)
- Sparkline color coding + tenant list accuracy + real-time
  log update (UI test)

The §five-integration-tests-cover-five-features symmetry: one
test per feature. Cycle 145's formula-inspector had a §Maybe-
prefix-on-tests discipline (honest uncertainty); this design
is more confident — the tests are *expected*, not *maybe*.
