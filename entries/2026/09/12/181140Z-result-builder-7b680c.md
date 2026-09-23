---
kind: result
role: builder
host: endolin-garden-ece02cb4
at: 2026-09-12T18:11:42Z
---
Completed `diagnose-panel-seat-error-rate` with a durable diagnosis and a small,
evidence-backed recorder fix on `main2`.

Root cause and evidence:

- Corrected the premise at journal commit
  `454d3e0edaf7267c5bc82ba95aeb92d83f619040`: 87 of 444 records had the generic
  `disposition: error`, but only 14 had every seat classified as `error`.
- Twelve of those 14 were seven-seat design records in one 2026-08-31 burst. Each
  landed within 22 seconds of its panel stage being requeued after the supervising
  gardener returned `exit-0-unsatisfying`. PR #1018's completed retry report and
  PR #241's surviving seat transcripts show the panels were torn down mid-flight.
- A process-group SIGTERM reproduction exited 143 with empty blocks and `pending`
  statuses, reproducing the old all-seat-error record shape. The causal chain is
  supervisor exit, panel interruption, then recorder misclassification. The
  all-seat record did not make the handler fail.
- PR #893 was a separate, genuine shared quota incident: its stage report preserves
  the weekly-limit response from 27 of 28 seats. PR #867 lacks enough retained
  detail to classify.
- The 73 generic-error records containing real seat verdicts do not prove a
  decider failure. Commit `6e393da9e7` fixes a real decider `set -e` retry bug, but
  the discarded historical stderr cannot establish its frequency.

Changes pushed in `401b0ccc55`:

- Added `designs/panel-seat-error-rate-diagnosis.md` and corrected the affected
  claims in `designs/cybernetics-audit.md`.
- Panel signal exits now record disposition `interrupted` and their exit code.
  Seats still marked `pending` record as `interrupted`, not provider errors.
- Added a hermetic SIGTERM regression and removed the unsupported claim that the
  decider path caused the dominant historical cluster.

Verification:

- `panel-run-record-test.sh`: 32 passed, 0 failed. The new negative run was
  observed failing before explicit signal handling, then passed with exit 143,
  `disposition: interrupted`, and two interrupted seat classes.
- Decider, parallel fan-out, seat retry, and seat timeout suites: 42 passed,
  0 failed.
- Committed-diff pre-push probes: 6 passed. `local-verify.sh` exited 0.
- `origin/main2` resolves to `401b0ccc5525977fa21c4bfd17cfe5d4af0feee2`.

Follow-ups:

- Withdrew the incorrectly framed `fix-panel-error-mode-a-budget-overrun` plan.
- Parked `make-panel-stage-survive-supervisor-session-exit` behind maintainer
  go-ahead to give panel execution durable lifetime ownership or partial-seat
  resume. Raising the 7,200-second budget is explicitly out of scope because the
  measured sessions ended after 41 to 261 seconds.
- The already-blocked `cybernetics-rec6-panel-error-retry` job can now consume this
  diagnosis and route `interrupted`, `seat-error`, and `decider-error` as bounded
  infrastructure retries rather than review verdicts.

Self-improvement: Recomputing the exact seat-vector predicate exposed a denominator
error and prevented the generic record disposition from being mistaken for seven
independent provider responses.
