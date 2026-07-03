Empty inbox. The work is complete.

## Completion report

**Job:** Mirror the rc!=0 branch's elapsed-constancy escalation into the exit-0-unsatisfying branch of `scripts/jobs/gardener.sh` so a wedged exit-0 job surfaces a kind:error early instead of burning a silent 5-cycle reaper-poison window.

**What I did:**
- Studied both branches: the exit-0-unsatisfying path (requeue on clean-exit-without-sentinel, silent until the reaper's 5-cycle poison) and the rc!=0 transient path's existing elapsed-constancy early-escalation (lines ~646–717), plus the supporting helpers `prior_transient_elapsed_series` and `elapsed_within_band` in `common.sh`.
- Inserted a mirrored elapsed-constancy block into the exit-0 branch, right after the reap-now hint stamping. Once the trailing `GARDEN_ELAPSED_CONSTANCY_CYCLES`-cycle elapsed window agrees within `GARDEN_ELAPSED_CONSTANCY_TOLERANCE_PCT`, it escalates **one** gardener-inbox kind:error flagging a likely wedged child (the xs2rust-endor-press wedge), plus a matching journal note.

**Key design choices:**
- **Reused `prior_transient_elapsed_series`** — the existing exit-0 progress note already carries the `job <base> handler exited … elapsed=<N>s` anchor the helper greps, so no new note format or state was needed.
- **No rc/capture gate** (unlike the rc!=0 branch): a clean exit-0 produces no failure output by construction, and there is only one kind to watch, so the `is_external_kill_rc`/`is_handler_timeout_rc`/`[ -s "$capture" ]` exclusions have no analogue here.
- **Distinct dedup marker** (`elapsed-constancy exit0-wedge-suspect: <base>`) so a job that flaps between exit-0 and rc!=0 failures surfaces each kind independently.
- **Reaper stays the sole requeue writer** — the gardener only escalates a warning; requeue ownership is unchanged.
- Non-integer tunable disables the check (guards against crashing the per-job loop), matching the existing pattern.

**Verification:** `bash -n` clean. Shellcheck flags only the intentional unquoted `$window0` word-split (identical to the existing rc!=0 `$window`). Exercised the series reconstruction + band logic against a synthetic clone: near-constant elapsed (2050 vs 2040) correctly escalates, varied elapsed (blip) correctly does not, and the full-window requirement means the first escalation fires at cycle 3 — ahead of the cycle-4→5 poison.

**Committed & pushed** to `main2` as `b1be55b53` (CAS push succeeded first attempt).

**Follow-ups:** None required. Behavior is gated by the same env knobs (`GARDEN_ELAPSED_CONSTANCY_CYCLES=2`, `GARDEN_ELAPSED_CONSTANCY_TOLERANCE_PCT=15`) already used by the rc!=0 branch, so it ships enabled by default.
