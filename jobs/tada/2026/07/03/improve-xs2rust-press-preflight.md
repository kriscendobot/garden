Inbox empty. Work is complete.

## Completion report

**Job:** `improve-xs2rust-press-preflight` — author/improve the preflight gate for the `xs2rust-endor-press` schedule.

**What I found (state had diverged from the spec):**
- The schedule `journal/schedules/xs2rust-endor-press.md` exists on `journal2` and names `preflight: gardening/xs2rust-endor-press-preflight.sh`.
- A peer had already committed a *first* version of the script (`adb542d64`), so the "missing script / WARN not-found" premise was already partly resolved. But that version gated **only** on a `xs2rust-endor-press-*` driver already being live (a double-stacking guard). It explicitly *declined* to gate on the build chain — which is exactly the waste this job targets. So this was an **improve**, not a create.

**What I changed** (`scripts/jobs/gardening/xs2rust-endor-press-preflight.sh`, pushed to `main2` as `0e1d7a0ad`):
- Extended the gate to **exit 2 (no work)** when the `xs2rust-endor` branch is already owned by a live worker, per the spec:
  1. a `xs2rust-endor-build-stage2*` / `xs2rust-endor-build-stage3*` job in-flight in `jobs/doin/`, **or**
  2. such a build job live on the message bus (an inbox exists for it — same predicate as `inbox-list.sh`, read from the same clone), **or**
  3. (kept) a `xs2rust-endor-press-*` driver already live in `todo/` or `doin/` — don't stack two drivers.
- **Fail open (exit 0)** on everything else — including a build job merely *queued* in `todo/` (branch not owned yet) and any stalled/reaped chain — so progress is never starved.
- Rewrote the header to explain the new rationale (save a Fable dispatch per idle cadence; the driver can only observe-and-defer while a builder owns the branch, per the 2026-07-03 05:07Z progress entry).

**Verification:** `shellcheck` clean except two benign pre-existing notes (SC1091 un-followed source; SC2034 `GARDEN_TAG`, which `common.sh`'s `log()` consumes). `bash -n` passes. Ran an 8-case functional test against a synthetic board — all exit codes match the contract (empty→0, build-in-doin→2, stage2b→2, build-on-bus→2, press-in-doin→2, press-in-todo→2, unrelated→0, build-only-queued-in-todo→0).

**Effect:** silences the recurring `WARN ... preflight ... not found/executable` in the scheduler tail and moves the "chain is live → defer" decision off the dispatched Fable agent into deterministic code.

**Follow-ups:** none required. Note the schedule cadence is `30m` (not literally hourly as the job prose says); the gate is cadence-agnostic, so no change needed.
