CI is GREEN (rc 0). All four must-fix items applied and pushed.

## Completion report

**Job:** endojs/endo-but-for-bots PR #1158 gauntlet — FIX stage, round 6. This is a design-document PR (`designs/exo-db.md`, "define portable passable databases").

**Panel-6 must-fix items applied** (commit `3ef23a584` on `kriscendobot:design/exo-db`):

1. **critic — `dropTable` retention leak:** Added a table-scoped cleanup to the "Daemon formulas and durable references" section. `dropTable` now records a `(database formula, table ordinal)` pending-drop intent, removes the logical table, then walks the `(database formula, table ordinal, *, *)` ledger slice and releases every retention it names (mirroring the per-row protocol lifted one level). Includes crash coverage via step-5 reconciliation and live-failure recovery via the step-4 retry/sweep path.

2. **skeptic — step-4 live-failure recovery:** Stated the recovery story explicitly. Step 4 does not clear the intent until it succeeds, leaving the same surviving-intent/over-retention state a crash leaves; the mutation-queue turn retries step 4 with backoff (idempotent), and a **periodic in-process reconciliation sweep** drains any still-surviving intent on a bounded timer — so a long-lived, never-restarting daemon converges back without waiting for restart. Extended decision 8's acceptance to the step-4 case.

3. **skeptic — test-catalog gap:** Added Verification-plan bullets asserting `QueryError`/`SchemaError`/`LimitExceededError`/`TableExistsError`/`TableMissingError` each surface their named hardened error (on SQLite and the DynamoDB plan compiler), a direct test of the reject-not-emulate adapter invariant (including the materialize-partial secondary-index case), and a `dropTable` table-scoped retention-release test with a crash variant.

4. **skeptic — reconciliation exposure scope:** Made step 5 per-formula ("before exposing *a given* database exo, replay only *that formula's* intents") and added a paragraph stating reconciliation is gated per formula, not process-wide: opening formula B never blocks on formula A's recovery, and the O(mutations in flight) cost is per formula.

**Verification:** No forbidden Unicode punctuation introduced. Pushed as review-feedback follow-up (`ba78af62d..3ef23a584`). CI watched to terminal, bounded — **rc 0, GREEN** (5/5 checks, 0 failed).

Did not re-run the panel (the driver re-posts panel-7).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1158-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1231249 cached reads)
- Output: 11065 tokens
- Cost: $1.5309275
- Wall-clock: 542s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
