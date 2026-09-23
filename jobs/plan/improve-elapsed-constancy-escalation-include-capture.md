---
gate: deferred
priority: normal
tier: minion
token-budget: 100000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: transient
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-09-17T16:53:14Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-09-17T16:53:14Z
---

---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/gardener.sh
Both elapsed-constancy early-escalation sites (the exit-0-unsatisfying branch ~line 944-977 and the rc!=0 overrun-suspect branch ~line 1465-1495) build a prose-only transcript for `report-error.sh` describing the symptom (near-constant elapsed across N cycles) but never include the actual handler output captured in `$capture` for that cycle — even though the rc!=0 branch's own gate (`[ -s "$capture" ]`) already confirms non-empty output exists at escalation time. `$capture` is an ephemeral `mktemp` file cleaned up each gardener cycle, so once the escalation fires this is the *last* moment the real stderr/stdout is available; a human or mentor triaging the resulting `elapsed-constancy-overrun-suspect`/`elapsed-constancy-exit0-wedge-suspect` inbox entry afterward has only the generic "died at a near-constant elapsed" prose and must guess the root cause blind. Concrete case: `improve-receipt-watcher-direct-dispatch` tripped exactly this overrun-suspect path twice (rc=1, elapsed=3s, both a kimi-k3 attempt and an opus fallback) with `usage_measurement` recording `source:none` (zero output captured by any usage-accounting layer) — the only path left to diagnose it is gone. Fix: append a bounded tail of `$capture` (e.g. last 40-60 lines, redacting nothing since this is the bot's own handler output) into both escalation transcripts before calling `report-error.sh`, so the inbox entry itself carries the evidence needed to triage.
