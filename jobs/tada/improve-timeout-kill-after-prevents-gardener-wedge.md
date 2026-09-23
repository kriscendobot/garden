Pushed cleanly to `main2` as `a89e9bcda`. Writing the completion report.

---

## Completion report

**Job:** `improve-timeout-kill-after-prevents-gardener-wedge` — harden the gardener handler runtime bound so a SIGTERM-ignoring handler can't wedge the worker.

**What I did**
- Added `--kill-after="$GARDEN_HANDLER_KILL_AFTER"` to the single-call-site handler bound in `scripts/jobs/gardener.sh:163` (`timeout --signal=TERM --kill-after=<grace> "$GARDEN_HANDLER_TIMEOUT" …`). Without it, a handler that ignores SIGTERM (hard deadlock / uninterruptible child) made `timeout` block forever and wedged the worker past `GARDEN_HANDLER_TIMEOUT`, since the reaper's claim-TTL only requeues the *job*, never the stuck *process*.
- Introduced the `GARDEN_HANDLER_KILL_AFTER` knob (default **60s**) and updated the documented invariant to `GARDEN_HANDLER_TIMEOUT + GARDEN_HANDLER_KILL_AFTER < GARDEN_CLAIM_TTL` (2400 + 60 < 3600). Rewrote the call-site comment.
- **Verified the semantics empirically** before editing: a SIGTERM-respecting handler dies at the deadline → `timeout` returns **124**; a SIGTERM-ignoring handler is SIGKILLed after the grace → **137**. Both are already transient (124 via `is_handler_timeout_rc`, 137 via `is_external_kill_rc`), so the job's "pair with the rc=124 classification change" note holds and **no new classification branch was needed**.
- Test coverage: `scripts/jobs/test/timeout-classifier-test.sh` SUBTEST 1 now asserts rc=137 is an external-kill transient (and not a handler-timeout); added **SUBTEST 3** with a new SIGTERM-ignoring stub (`timeout-ignore-term-handler-stub.sh`) that wraps the whole `gardener.sh` run in an outer `timeout` and proves the worker **returns** rather than blocking forever, surfaces rc=137, and is classified transient (no inbox escalation, job left in doin). **18/18 pass.**

**Mid-job event:** A peer (`6b0c315cf`, "classify handler-timeout rc=124 as a transient wall-clock kill") — the exact sibling change the job referenced — landed on `main2` while I worked, causing a rebase conflict against my original (which assumed rc=124 still escalated as REAL). I reset onto the new base and re-applied my changes integrated with the new `is_handler_timeout_rc` world, so both expiry paths are now consistently transient.

**Result:** Committed `a89e9bcda` and pushed to `origin/main2` (fast-forward, clean).

**Follow-ups:** None required. The pre-existing `OPEN — failed-job lane` design question (gardener.sh) is untouched and out of scope here. The standalone `*-test.sh` files have no central registry needing a new entry.
