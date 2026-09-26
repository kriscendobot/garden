Inbox empty. Work complete.

---

## Completion report: `improve-bound-gardener-handler-runtime`

**What I did**

Bounded every gardener job-handler invocation with a `timeout` at the single call site in `scripts/jobs/gardener.sh`, rather than inside individual handlers, so the cap covers `handlers/gardener-claude.sh`'s unbounded `claude -p`, the gardening state machine, and any future handler uniformly.

**What changed** (commit `551fc3ead` on `origin/main2`)

- **`scripts/jobs/gardener.sh`**
  - New env knob `GARDEN_HANDLER_TIMEOUT` (default `2400`s), documented next to the other `GARDEN_*` defaults with the **`GARDEN_HANDLER_TIMEOUT < GARDEN_CLAIM_TTL`** invariant (3600s) and its rationale (comfortably above `GARDEN_DEPLOY_DRAIN_TIMEOUT`=600s).
  - The handler call is now `timeout --signal=TERM "$GARDEN_HANDLER_TIMEOUT" "$GARDEN_JOB_HANDLER" ...`, with a call-site comment stating the invariant and explaining why it closes the duplicate-claim hole (no handler outlives the reaper's stale-claim window).
- **`scripts/jobs/test/timeout-classifier-test.sh`** + **`timeout-handler-stub.sh`** (new, alongside `signal-kill-classifier-test.sh`): asserts a `124` capture is classified **real, not transient** — both at the pure-helper level (`is_external_kill_rc 124` false, `is_transient_empty_failure 124` false, while `143` stays transient) and end-to-end through the real `gardener.sh` with a tiny `GARDEN_HANDLER_TIMEOUT` against a hanging handler (timeout fires → rc=124 → inbox escalation + `kind:error` entry, job left in `doin`). 8/8 pass.

**Verification**

- No classifier-helper change was needed: rc=124 is absent from both `is_external_kill_rc` (143/130/137) and `is_transient_empty_failure` (143/130/137/offline), so a `timeout` expiry already falls through to the real-failure escalation branch — exactly the deliberate discrimination the spec wanted (deploy-drain rc=143 stays transient; self-hang rc=124 surfaces now instead of TTL-requeuing for ~5h).
- New test: 8 passed, 0 failed. Existing `signal-kill-classifier-test.sh`: 13 passed, 0 failed (shared path untouched). `bash -n` clean.

**Process note**

My first edits landed in the root checkout (the deployed, read-only tree); I corrected this by re-applying the hunks on a fresh isolated worktree off `origin/main2` under `$GARDEN_SCRATCH`, ran the tests there, committed with explicit pathspecs, pushed `HEAD:main2`, then reverted the root tree (now clean) and tore the scratch worktree down.

**Follow-ups**

- None required. The change reaches this host on the next `deploy-garden.sh`. The pre-existing "OPEN — failed-job lane" question (whether a deterministically-failing job should move to a dedicated `jobs/failed/` lane vs. stay in `doin` for the reaper) is unchanged by this work; a `124` self-hang now lands in that same existing lane, so this makes the case for that decision slightly more pressing but does not alter it.
