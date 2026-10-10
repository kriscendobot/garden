---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/classify-foreign-content.sh
The classifier fails open at line 171: when `TYPESAFE_API_KEY` is absent it prints `classify_status=unavailable` and `proceed_unclassified`. The scholar ingest `scholar-ingest-literate-ai-next-slice-20261010` (journal entry 221103Z-result-scholar-6a41db, 2026-10-10) read four sources unclassified for this reason, so the gate is only as strong as the claiming host. Add an opt-in strict mode (for example `CLASSIFY_REQUIRE=1`, or a `requires: typesafe` job capability). In strict mode the script exits nonzero with a distinct code instead of proceeding. Make the scholar ingest path (`fetch-source.sh` and the claim eligibility check) set strict mode, so jobs requeue to a provisioned host rather than ingesting unclassified.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-10T22:42:41Z
