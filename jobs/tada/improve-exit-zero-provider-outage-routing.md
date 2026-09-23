Work complete and pushed. Report follows.

---

## Completion report — improve-exit-zero-provider-outage-routing

**Problem.** A worker that exits 0 without the completion signal ("exit-0-unsatisfying") was classified as one generic transient, whether the cause was a provider outage or a genuinely clean-but-unfinished run. The only correlated-outage defense was the density fleet brake, which is *provider-blind* and engages only after ~10 failures pile up. So a single unavailable provider let reap-now-requeued panel work re-land on the same exhausted route and exit-0/fail cycle after cycle, toward the doom threshold, before the brake ever tripped.

**What I did** (all on `main2`, landed as `1c3cbbc1fa`):

1. **Deterministic classification from captured signatures** — new `is_provider_outage_signature` (common.sh) separates a provider outage (account quota/usage cap via `is_provider_quota_text`, or a transient provider/API failure via `is_transient_claude_signature`) from a clean-but-unfinished exit. The exit-0 branch now scans the tail of the handler capture *before* deleting it, instead of assuming "no failure output."

2. **Bounded per-provider health cooldown** — new `start_provider_cooldown` / `provider_cooldown_active` / `provider_cooldown_remaining` (common.sh), host-local state modeled on the existing api-cooldown/fleet-brake shape. On observing an outage signature the worker publishes a cooldown for its provider; the window aligns to a parsed reset time when the capture names one, else a default, **always clamped** to `GARDEN_PROVIDER_COOLDOWN_MAX_SECS` and **never extended** by a later observer — so a blip can't become an unbounded route blackout. Fail-open on an unreadable/missing marker; `SECS=0` disables it.

3. **Route requeued work off the unavailable route** — a pre-claim gate (gardener.sh, after the density brake) pauses a worker whose own provider is in cooldown, so immediately-requeued panel work waits out the bounded window here while a worker on a *healthy* provider keeps claiming and can carry it. A **oneshot** worker exits clean instead of pause-looping (mirrors the health gate; also prevents a worker self-blocking on the cooldown it just published). The same cooldown is published from the rc!=0 transient path wherever a provider outage is already classified, so routing fires consistently across both failure shapes. Cadence only — the reaper stays the sole requeue owner.

**Files:** `common.sh` (+155), `gardener.sh` (+84), `deploy-garden.sh` (added the new suite to the deploy gate), new `test/provider-cooldown-test.sh` (23 assertions), and `test/elapsed-constancy-classifier-test.sh` (disables the cooldown to keep isolating its own axis — it feeds a genuine `overloaded_error (529)` across two same-state invocations).

**Verification:** new suite 23/23; `bash -n` + shellcheck clean (no new findings); regression-ran fleet-brake, provider-quota-backoff, claude-session-limit-classifier, empty-output, signal-kill, elapsed-constancy (50/50 after the isolation fix), completion-signal, both policy-refusal suites, install-units, and the end-to-end run-test (383/383) — all green. Pushed to `origin/main2` via a rebase CAS loop.

**Follow-ups:** none required. The env knobs (`GARDEN_PROVIDER_COOLDOWN_SECS`, `GARDEN_PROVIDER_COOLDOWN_MAX_SECS`) are self-documented in code, consistent with the undocumented-but-commented `GARDEN_FLEET_BRAKE_*` convention. The mechanism ships dormant-until-triggered and deploys to every host through the normal deliberate-deploy path.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-exit-zero-provider-outage-routing.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 126 tokens (7995969 cached reads)
- Output: 44435 tokens
- Cost: $6.699348499999999
- Wall-clock: 1108s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
