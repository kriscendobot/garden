from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-09-17T16:53:23Z
doom_base: improve-elapsed-constancy-escalation-include-capture
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-09-17T16:53:23Z
last_seen: 2026-09-17T16:53:23Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/improve-elapsed-constancy-escalation-include-capture; it stays HELD until a human promotes it
(promote-plan.sh improve-elapsed-constancy-escalation-include-capture) or removes it, so nothing is lost.
Original job base: improve-elapsed-constancy-escalation-include-capture

--- original job body ---
---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/gardener.sh
Both elapsed-constancy early-escalation sites (the exit-0-unsatisfying branch ~line 944-977 and the rc!=0 overrun-suspect branch ~line 1465-1495) build a prose-only transcript for `report-error.sh` describing the symptom (near-constant elapsed across N cycles) but never include the actual handler output captured in `$capture` for that cycle — even though the rc!=0 branch's own gate (`[ -s "$capture" ]`) already confirms non-empty output exists at escalation time. `$capture` is an ephemeral `mktemp` file cleaned up each gardener cycle, so once the escalation fires this is the *last* moment the real stderr/stdout is available; a human or mentor triaging the resulting `elapsed-constancy-overrun-suspect`/`elapsed-constancy-exit0-wedge-suspect` inbox entry afterward has only the generic "died at a near-constant elapsed" prose and must guess the root cause blind. Concrete case: `improve-receipt-watcher-direct-dispatch` tripped exactly this overrun-suspect path twice (rc=1, elapsed=3s, both a kimi-k3 attempt and an opus fallback) with `usage_measurement` recording `source:none` (zero output captured by any usage-accounting layer) — the only path left to diagnose it is gone. Fix: append a bounded tail of `$capture` (e.g. last 40-60 lines, redacting nothing since this is the bot's own handler output) into both escalation transcripts before calling `report-error.sh`, so the inbox entry itself carries the evidence needed to triage.
