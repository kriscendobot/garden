Inbox empty. The design is complete and pushed.

## Completion report

**Job:** `design-liveness-progress-over-elapsed-deadlines` — designer job, produce a design (not implementation) replacing elapsed-deadline reaping with liveness+progress detection and budget-aware deferral.

**What I did.** Read the full reaping/budget spine before writing: `reaper.sh` (doom/requeue path, `reap_age_threshold`, live-PID guard, productive/outage/reap-now markers), `common.sh` (`applied_handler_budget`/`job_handler_budget_base` invariant, `job_cycle_productive`, the marker family, kimi-fallback plumbing), `gardener.sh` (wall-clock `timeout`, productive-cycle snapshotting, deadline-overrun stamping), `deadline-nudge.sh`, the `usage/<base>.jsonl` per-engagement ledger (`usage-append.sh`/`usage_ledger_stage_row`), `usage-meter.sh`'s weekly window, and the four referenced commits. Confirmed the `budget/bucket.json` token bucket is **design-only** (not yet in `scripts/`), so I anchored "refresh" on the implemented `usage-meter.sh` window instead and named the bucket as the eventual carrier.

**What changed.**
- New `designs/liveness-progress-reaping.md` (Status: Proposed), covering all five required sections plus the #903 walk, a "what it doesn't solve / where it's more permissive" section, and named staged jobs.
- Indexed it in `designs/README.md`.
- Committed and pushed to `main2` (`b580e3d51a`, clean push on first attempt).

**Load-bearing design decisions.**
- **The invariant (§3) is held by construction:** requeue-safety stays a pure time+PID function, untouched; only the reaper's *destination choice* for an already-dead, already-safe claim changes. No new "alive in `doin/`" state is invented, so duplicate concurrent execution remains impossible.
- **Signals are all already produced, no LLM, no new API calls:** HEAD advance (durable, strong), per-cycle `output_tokens` delta from `usage/<base>.jsonl` (liveness — rules out the wedged case), mtime advisory-only (a wedged-but-logging job can spoof it, so it never gates a doom).
- **Honest limit stated up front:** no cheap signal separates a spinner from a worker; the notional token budget *bounds* the spinner rather than detecting it.
- **Fail-safe migration:** `progress_verdict = unknown` → today's exact doom; Phases 0–3 each independently revertible; `GARDEN_PROGRESS_DOOM=off` kill-switch.

**Follow-ups (named for the liaison to post).** Four staged children — `build-progress-verdict-observability` (Phase 0, shadow-log), `build-notional-token-budget` (Phase 1), `build-progress-disposition-flip` (Phase 2), `build-budget-refresh-promoter` (Phase 3) — suggested as a serial `orch-liveness-progress-reaping` orchestration (`on-child-failure: halt`). No implementation done, per the job's instruction.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-liveness-progress-over-elapsed-deadlines.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 39 tokens (1874152 cached reads)
- Output: 25178 tokens
- Cost: $2.6526349999999996
- Wall-clock: 395s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
