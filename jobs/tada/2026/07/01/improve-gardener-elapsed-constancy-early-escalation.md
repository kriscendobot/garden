Done. The change is committed and pushed to `origin/main2` (commit `a38c91bbe`), rebased cleanly over a concurrent update, and the test passes on the rebased tree.

---

## Completion report

**Job:** `improve-gardener-elapsed-constancy-early-escalation` — implement the elapsed-constancy early-escalation that gardener.sh's transient-branch comments described but never coded.

**What I did**

In `scripts/jobs/gardener.sh`, inside the transient-classification branch (after the reap-now hint, job still left in `doin`), I added a deterministic, read-only "is this actually stuck?" check:

1. **Recover prior elapsed** — greps this gardener-clone's already-synced progress journal entries for prior cycles' `elapsed=<N>s` notes on the same `$base` (new `common.sh` helper `prior_transient_elapsed_series`). No new state, no CAS — the reaper stays the sole requeue writer.
2. **Judge constancy** — appends the current `elapsed`, takes the trailing N-cycle window, and fires only when `cycle >= 2`, the window agrees within a ±tolerance band (new helper `elapsed_within_band`), the rc is **not** `is_external_kill_rc`/`is_handler_timeout_rc`, and the capture is non-empty (i.e. a transient-claude-signature / claude-CLI failure, not a deploy/drain/OOM/offline blip that legitimately varies in elapsed).
3. **Escalate once** — emits ONE gardener-inbox `kind:error` via `report-error.sh` flagging "likely deterministic overrun classified transient, not a blip" with the elapsed series, plus a matching journal `kind:error` narration. The job stays in `doing` (requeue ownership unchanged). Dedup on the escalation entry's marker (visible cross-cycle after the clone's claim-time sync) makes it fire at most once per base.

This surfaces a genuinely-stuck transient-classified job (e.g. the `garden-issue-9-run-contract-control-upgrade-test-to-completion` case dying rc=1 at ~472s every cycle) in ~2 cycles instead of ~5, off a human/watchman grep.

**Gating:** `GARDEN_ELAPSED_CONSTANCY_CYCLES` (N, default 2; 0/1 or a misconfigured non-integer disables it) and `GARDEN_ELAPSED_CONSTANCY_TOLERANCE_PCT` (default 15).

**Tests:** New `elapsed-constancy-classifier-test.sh` (+ `elapsed-constancy-handler-stub.sh`) — 19 assertions across pure helpers, the integration escalation (job stays in doin), the disable gate, the dedup guard, and the first-pass (cycle 0) no-escalation guard. All pass. The five sibling classifier tests (session-limit, timeout, signal-kill, empty-output, completion-signal) still pass — no regression; those exercise cycle 0 or excluded rcs, so the new check doesn't fire.

**Follow-ups / notes**
- The check keys off the transient note's `elapsed=Ns` and `job <base> handler exited` text; if that note wording is ever restructured, `prior_transient_elapsed_series`'s grep anchors should move with it.
- Offline (rc=75) empty-capture transients are deliberately excluded via the non-empty-capture gate, slightly narrower than the literal "not external-kill/timeout" phrasing in the spec, to avoid false positives on connectivity blips — documented inline.
- The pre-existing OPEN failed-job-lane question (doin vs a dedicated failed lane) is untouched; this only escalates a warning, it does not change requeue ownership.
