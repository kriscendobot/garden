Work complete and pushed to `main2`.

## Completion report

**Job:** Fix the elapsed-constancy overrun-suspect path in `scripts/jobs/gardener.sh` so a confirmed deterministic overrun poisons early, and add a very-short-elapsed floor that reclassifies sub-few-second transient-signature crashes as real failures.

**What changed (pushed as `0d1909e84` on `main2`):**

1. **Early-poison on confirmed constancy** (`gardener.sh`): When the elapsed-constancy window confirms a deterministic overrun, the gardener now stamps — on *every* confirming cycle — the same `garden-deadline-overrun` counter the rc=124 wall-hit path uses (via `stamp_deadline_overrun_hint`), so the reaper poisons after `GARDEN_REAP_OVERRUN_THRESHOLD` (2) instead of burning all ~5 `GARDEN_REAP_POISON_THRESHOLD` cycles. The loud kind:error stays deduped to once per base; only the counter increments each cycle (it *must* accumulate to reach the threshold). This ends the wasted ~5×TTL that hit the four 1–2s jobs in the batch.

2. **Reason-tagged commit** (`common.sh`): `stamp_deadline_overrun_hint` gained an optional third `reason` arg (default `handler wall-clock overrun`); the constancy caller passes `elapsed-constancy deterministic overrun` so the git audit trail distinguishes the two callers of the shared counter. The marker itself is identical (the reaper only knows the one counter).

3. **Very-short-elapsed floor** (`gardener.sh`): New tunable `GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS` (default 5). A transient-claude signature appearing below the floor cannot have come from a started `claude -p` reaching the API (CLI cold-start alone takes seconds), so it is reclassified a **real deterministic failure outright** and escalates immediately rather than requeuing transiently. Applied to the whole signature set on the cold-start argument; set to 0 to disable. The two changes are complementary: the floor catches fast (<5s) deterministic crashes; constancy catches slow-but-constant recurring overruns.

**Tests:** Extended `elapsed-constancy-classifier-test.sh` with early-poison-stamp assertions (SUBTEST 2 f/g) and a new SUBTEST 6 covering the floor reclassification + `floor=0` disable (25 pass). Because their stubs exit instantly (a test artifact orthogonal to elapsed), `claude-session-limit-classifier-test.sh` and `completion-signal-test.sh` SUBTEST 4 now set `GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS=0` to isolate the signature-classification axis. Verified green: elapsed-constancy, claude-session-limit, completion-signal, timeout-classifier, signal-kill, empty-output, productive-cycle, reaper-poison-park, handler-budget, fleet-brake, gardener-identity, gardener-worktree.

**Follow-ups:** None required. Note the reaper's poison-notice message for a constancy-stamped job will read "deadline-overrun" (it shares the counter) — the accurate framing is still delivered separately by the constancy kind:error and the reason-tagged commit, so no reaper change was needed; a dedicated poison signature for the constancy case could be a future refinement if the conflation ever confuses triage.
