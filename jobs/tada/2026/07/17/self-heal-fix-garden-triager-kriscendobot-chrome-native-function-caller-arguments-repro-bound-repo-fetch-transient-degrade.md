Empty inbox. Work is complete.

## Completion report

**Job:** Fix `scripts/jobs/triager.sh` so a transient steady-state clone fetch degrades to a clean skip-this-tick instead of a FATAL that marks the unit Failed and fires self-heal.

**What I found:** The steady-state fetch was already *bounded* (the `timeout --kill-after` + `GARDEN_FETCH_RETRIES` loop at ~line 128), but it discarded stderr (`2>/dev/null`) and still `die`d on **any** non-zero rc — so the observed rc-124/`Terminated` wall-clock kill (and any transport blip) crash-looped the unit on every network stall.

**What I changed:**
- `scripts/jobs/triager.sh` — the fetch loop now captures the final attempt's stderr into a temp file, and on exhausted-retry failure **classifies** it, mirroring the sibling `ci-watcher.sh`'s `is_transient_net_error` degrade:
  - Transient — rc 124/137 (SIGTERM/SIGKILL wall-clock kill) **or** an `is_transient_net_error` / `_fetch_stderr_is_offline` (`GARDEN_OFFLINE_SIGNATURES`) stderr match → `log "WARN: ..."` + `exit 0` (retry next tick), exactly like the transient-tolerant clone-provision path at lines ~95–104.
  - Structural — anything else → still `die "fetch failed for $slug"` (a real fault is surfaced, not masked).
  - Temp file is cleaned up on both the success and failure paths.
- `scripts/jobs/test/triager-test.sh` — rewrote test M (which asserted the old always-die behavior) into three sub-cases via a parameterized fetch shim: **M1** transient stderr signature → clean skip; **M2** rc-124 wall-clock kill → clean skip (the `Terminated`+FATAL self-heal signature is gone); **M3** structural error (`Authentication failed`) → still dies, still retries through the budget, cursor never advanced.

**Verification:** `bash -n` clean on both files; full `triager-test.sh` suite green (90 passed, 0 failed).

**Committed & pushed:** `bc53b0dcae` to `origin/main2` (rebase-CAS, landed on first attempt).

**Follow-ups:** None. Inbox drained (empty).
