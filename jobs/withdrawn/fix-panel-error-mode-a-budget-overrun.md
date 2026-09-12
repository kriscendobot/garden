---
withdrawn: true
withdrawn_reason: Diagnosis refuted budget overrun; recorder fix landed and remaining work is supervisor lifetime ownership
withdrawn_by: builder
withdrawn_at: 2026-09-12T18:10:30Z
withdrawn_from_gate: go-ahead
---

---
gate: go-ahead
priority: normal
posted_by: builder
posted_at: 2026-09-12T17:41:37Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix Mode A of the panel `disposition: error` rate: all-seats-error is a budget-overrun + recorder mislabel

Follow-up from diagnose-panel-seat-error-rate. That job found `disposition: error`
panel-run records split into TWO modes. Mode B (foreperson `claude -p` non-zero
exit aborting the panel under `set -e`) is FIXED (panel.sh, commit on main2). This
is the remaining Mode A.

## Established diagnosis (evidence, reproduced)

The "all seven seats error together" records (47/47 have `disposition: error`) are
NOT seven independent seat failures. They are the whole panel process being
SIGTERM-killed mid-fan-out:

- gardener.sh:545 wraps every stage handler in
  `timeout --foreground --signal=TERM --kill-after=... "$handler_budget"`. When the
  panel stage exceeds its budget (or the claim TTL), SIGTERM reaches panel.sh.
- panel.sh's EXIT trap (`emit_panel_record`) STILL RUNS on SIGTERM (verified), so it
  writes a record with the default `PANEL_DISPOSITION=error` and the per-seat block
  files that were created-but-not-yet-written (empty) by the in-flight `run_seat`
  fan-out.
- panel-run-record.sh `classify_seat` maps an EMPTY block to the verdict `error`, so
  every in-flight seat is recorded as `error`.
- Fingerprint that proves it: the all-error seat COUNT equals the seats dispatched
  before the kill — 7 for the design panel's single concurrency wave; 8 or 16 for the
  code panel (concurrency 8, i.e. whole waves); +1 when the related-design pre-pass
  force-added `integrator`. Never a partial/random count.

Reproduced by sending SIGTERM to panel.sh during the seat fan-out: exit 143, EXIT
trap fires, record-meta `disposition=error`, all in-flight blocks 0 bytes → all
seats classify as `error`.

## Why it matters / recommended fix (choose; all small-to-medium)

The stage is genuinely over budget, so on requeue it can overrun again →
requeue-exhausted → doomed → gauntlet halt (the stranded-at-panel cluster). Two
independent improvements, either/both:

1. RECORDER HONESTY (small): in panel.sh, distinguish an EXIT-trap-on-signal
   termination from a real terminal disposition. Set `PANEL_DISPOSITION=interrupted`
   (or similar) when the EXIT trap fires with rc indicating a signal (e.g. 143/137)
   and PANEL_DISPOSITION still at the default `error`. And/or make classify_seat
   distinguish a `pending`/`.status`-less in-flight block from a genuinely empty
   verdict so it records `interrupted`/`pending`, not `error`. This stops the
   mislabel and makes the metric trustworthy — but does not stop the overrun.

2. BUDGET FIT (medium, the real fix): the panel stage overruns its handler budget.
   Options: raise the panel stage's `handler-timeout`; raise GARDEN_PANEL_CONCURRENCY
   so a large code panel finishes in fewer waves; or CHECKPOINT completed seats so a
   requeue re-runs only the not-yet-done seats instead of the whole panel (the seat
   blocks are already per-seat files — a requeue could skip seats whose `.status` is
   `ok`). Measure a code-panel wall-clock against the applied budget first to size it.

Diagnose first for #2 (measure actual panel wall-clock vs GARDEN_APPLIED_HANDLER_BUDGET
on the fleet); #1 can land immediately as it is pure recorder honesty.
