---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardener.sh
When an Anthropic handler exits 0 without the completion sentinel, include its report/envelope tail alongside captured stdout when checking deterministic provider-outage signatures. The current handler writes its diagnostic JSON to the report, leaving stdout empty; correlated quota/API cuts across hosts therefore miss the per-provider cooldown and repeatedly requeue panel jobs. Add a regression test covering an exit-0 quota envelope.
