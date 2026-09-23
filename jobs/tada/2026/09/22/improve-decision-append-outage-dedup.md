Pushed to `main2` on the first attempt.

## Completion report

**Job:** `improve-decision-append-outage-dedup` — dedup the recurring fail-open warnings in `scripts/jobs/decision-append.sh`.

**Problem:** During a persistent journal outage, `append_decision` fails on every invocation and the script emitted an identical `WARN: decision … not recorded (fail-open)` line each time — one per controller actuation. Since decision recording is observability-only, those repeats are pure noise.

**What I did:**
- Added a **host-scoped outage latch** under `$GARDEN_STATE/decisions/outage/` (keyed by `$GARDEN`, overridable via `GARDEN_DECISION_OUTAGE_DIR` for tests):
  - `note_outage_drop` — on the *edge* (latch absent) writes the `.since`/`.count` markers and emits the **single opening WARN**; while the latch persists it just increments the drop count silently.
  - `note_outage_clear` — on a successful write, if a latch is open, emits **one recovery summary** naming the drop count and outage-open time, then clears the markers. Cheap one-`test` no-op otherwise (safe on the happy path).
  - Wired into the existing fail-open dispatcher: `if ! ( append_decision ); then note_outage_drop; else note_outage_clear; fi`. Every path is best-effort and never fails the caller, preserving the fail-open contract.
- Added two tests to `scripts/jobs/test/decision-ledger-test.sh`: (1) two offline appends warn exactly once with the drop count reaching 2; (2) a reachable-journal write emits exactly one recovery summary naming "2 fail-open decision drop(s)" and clears the latch.

**Verification (executed):**
- `bash scripts/jobs/test/decision-ledger-test.sh` → `RESULT: 10 passed, 0 failed` (8 pre-existing + 2 new).
- `shellcheck -x scripts/jobs/decision-append.sh` → clean (only the pre-existing SC1091 info about resolving `common.sh` from cwd).

**Changed files:** `scripts/jobs/decision-append.sh`, `scripts/jobs/test/decision-ledger-test.sh`. Committed and pushed to `origin/main2` (rebase CAS, first attempt).

**Follow-ups:** none. The latch mirrors the local-log/observability character of the existing warning rather than escalating to the maintainer inbox (`alert_maintainer_edge`), matching the job's "observability-only" framing; if a future maintainer wants outages surfaced to the inbox instead, that would be a separate, deliberate escalation.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-decision-append-outage-dedup.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1091512 cached reads)
- Output: 8903 tokens
- Cost: $1.4188219999999998
- Wall-clock: 134s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
