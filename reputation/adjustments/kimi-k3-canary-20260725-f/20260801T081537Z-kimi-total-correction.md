---
base: kimi-k3-canary-20260725-f
agentic_dollars: 1.85
agentic_cents: 185
source: maintainer-authoritative-kimi-k3-total-5000-cents
allocation_batch: kimi-k3-total-correction-20260801
weight_method: mean-token-units-no-ledger-record
supersedes_batch: kimi-k3-credit-exhaustion-20260730
confidence: high
---
Append-only cost correction. The maintainer states the collective cost of all
Kimi work is $50.00. This batch re-allocates that authoritative total across
the 27 kimi-k3 engagements present in jobs/tada/, weighted by token units from
the usage ledger (the 3 canaries without a ledger record take the mean). It
supersedes kimi-k3-credit-exhaustion-20260730 ($58.84 across 24 bases) without
rewriting that batch or any raw event.
