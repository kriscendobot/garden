Inbox empty. Work is complete.

## Completion report

**Job:** `improve-triager-pacing-contention` — add a shared cooldown/readiness gate so concurrent per-repo triager ticks stop contending on the one shared pace clone and emitting warnings for the nonessential pacing refresh.

**What I did**

Every per-repo `garden-triager@<slug>` on a host shares ONE pace clone (`$GARDEN_STATE/triager-pace/journal`). When many ticks come due together (their timers spread over a 30s `RandomizedDelaySec` window then drift), each independently takes that clone's `clone_lock` just to compute a next wake — a nonessential optimization. Even with the existing soft-lock (`GARDEN_CLONE_LOCK_SOFT`), a herd repeatedly contends on the one lock and latches per-repo WARNs.

I added a **host-shared, short cooldown gate** in front of the refresh in `scripts/jobs/triager.sh`:

- New helper `triager_pace_gate_open()` — an `flock`'d expiry stamp at `$GARDEN_STATE/triager/pace/refresh-gate` (host-shared, *not* per-slug), mirroring `common.sh`'s existing `start_journal_outage_cooldown` idiom exactly (blocking flock held only for a `sed`+`printf`, atomic check-and-re-arm).
- Wired into `triager_pace_schedule()` **before** the `ensure_clone`/`sync_clone` block: at most one tick per `GARDEN_TRIAGE_PACE_COOLDOWN` (default **30s**) window actually touches the pace clone; every other concurrent/near-term tick skips the refresh cleanly — no clone lock, no warning, no journal round-trip — logs a single info line, and keeps the fixed timer cadence. A later tick refreshes once the gate expires.
- Fails **open** toward refreshing on a disabled/unparseable cooldown or an unwritable state dir; `GARDEN_TRIAGE_PACE_COOLDOWN=0` disables the gate entirely (pre-gate behavior). Normal event triage and the steady fetch are untouched — only the optional wake computation is gated.
- New knob documented; header comment block extended to explain the herd-collapse.

**Tests** (`scripts/jobs/test/triager-pacing-test.sh`)

- Added a gate test: three same-window ticks → projector called **once**, the other two gate-skipped.
- Added a disabled-gate test: cooldown 0 → every tick refreshes.
- Pinned the pre-existing warning-latch dedup test to `GARDEN_TRIAGE_PACE_COOLDOWN=0` so it keeps isolating the *latch* dedup (the gate would otherwise skip its second tick via shared state).

**Verification**
- `bash scripts/jobs/test/triager-pacing-test.sh` → **8 passed, 0 failed**.
- `bash scripts/jobs/test/triager-test.sh` → **143 passed, 0 failed** (no regression).
- `bash -n scripts/jobs/triager.sh` clean; shellcheck shows only pre-existing info-level notes.

**Committed & pushed** as `28ba4fd23a` to `origin/main2` (rebase-CAS, pushed on first attempt). Inbox drained (empty).

**Follow-ups:** none required. Default cooldown of 30s is a starting value; if a busy host with a slow journal still shows overlap, `GARDEN_TRIAGE_PACE_COOLDOWN` can be raised per-host without code change.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-triager-pacing-contention.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (2167764 cached reads)
- Output: 30117 tokens
- Cost: $2.860293
- Wall-clock: 443s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
