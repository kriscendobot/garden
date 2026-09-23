---
gate: orchestrated
orchestrated_by: journal-contention-watch
priority: normal
posted_by: producer
posted_at: 2026-09-23T17:20:43Z
---

---
role: designer
priority: high
posted_by: liaison
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: journal contention watch (anomaly detection on latency and retries)

Repo: the garden itself (`kriscendobot/garden`, `main2`). Output: `designs/journal-contention-watch.md`.
The builder job `build-journal-contention-watch` follows in orchestration `journal-contention-watch`.
**Sibling design to reuse, not duplicate:** `designs/comment-latency-watch.md` (on main2; PR
kriscendobot/garden#110). Share its host-local heartbeat/stats conventions and its
watchdog-notice alerting shape wherever they fit.

## Maintainer requirement (kriskowal, 2026-09-23)
"A journal contention watch, anchored around **anomaly detection for latency and retries**."

## What exists today (tolerates contention; measures nothing)
- `clone_lock` (`scripts/jobs/common.sh` ~3863): bounded `flock -w` waits (GARDEN_LOCK_WAIT ×
  GARDEN_LOCK_RETRIES), stale-holder steal, a SOFT one-shot mode, and `die` on give-up. Each wait
  leaves only a log line.
- CAS push retries (up to 50 in several producers; `cursor-set.sh`, `reaper.sh`, `set-workers` "lost a
  push race") with classification in `common.sh` ~4383 (`journal_push_is_cas_contention` /
  `_server_rejection` / `_definite_failure`). Retry counts are never recorded.
- The shared journal-outage cooldown latch (`journal_outage_active`, `common.sh` ~752): consumers skip
  QUIETLY while it is active.
- `state-clone-keeper.sh` reclaims leaked clones for INODE pressure only. It does not track clone
  size or fetch time.

## Incidents this must catch early (2026-09-22/23)
- A 105G leader state clone made its fetch exceed the 45s cap, so `is-main-host.sh` silently served a stale
  ref and reported "follower" on the true leader for hours.
- A 6.6G cursors clone's slow fetch latched the shared outage cooldown, so every comment watcher
  dropped every directive for ~4.5h while systemd logged success.
- Journal churn (~10k commits/day of no-op decisions, since fixed in 74461976fd / 3c696ea6c8)
  raised push-race contention fleet-wide.

## Design must settle
1. **Instrumentation points and signals:** lock wait duration (and steals and give-ups), `sync_clone`
   and `ensure_clone` fetch duration against the cap, push attempts per transaction and the class of
   each failure, outage-latch activations and their durations, and clone size (bytes and packs, plus
   whether `gc.log` is present). Name the exact functions to wrap, and keep the overhead negligible.
2. **Storage: host-local only**, bounded (a ring buffer or rolling window per signal and per clone
   or caller), under `$GARDEN_STATE`. **No per-event or per-tick journal commits**: the journal was
   just rebuilt to escape churn. If a fleet-wide view is wanted, specify at most a low-rate summary
   (for example hourly) and justify it.
3. **Anomaly detection:** a baseline per signal (for example a rolling median plus MAD, or p95 over a
   trailing window) with absolute floors so a quiet baseline does not page on noise. Include hard
   guards that page regardless of baseline: fetch time at or above ~70% of the cap, any lock give-up,
   a latch active beyond N minutes, a clone over a size threshold. Also detect **drift**: a slow creep
   toward the cap is the actual failure mode, so trend detection is required, not just spikes. State
   the numbers.
4. **Silent-skip visibility:** every quiet skip caused by the outage latch must be counted, and
   sustained skipping must surface. This is the 4.5h-incident class.
5. **Remediation hooks:** when a clone is oversized or its fetches are slow, say whether the checker
   triggers the proven safe remedy automatically (move the clone aside, let `ensure_clone` rebuild,
   delete the old copy in the background; see the memory notes and
   `designs/root-repo-guard.md` for the gc.log wedge) or only alerts. Prefer an automatic lossless
   remedy with an alert, matching the root-repo-guard posture.
6. **Where it runs:** instrumentation on EVERY host (contention is per host); the checker also
   per host, like `garden-root-repo-guard`, not leader-only. It must run while the fleet is drained,
   and its own liveness needs watching.
7. **Alerting:** `scripts/jobs/watchdog-notice.sh`, one coalesced notice per host, clone and
   class, closed with `--recovered`.
8. **Observability:** a read-only probe script that prints current per-clone latency, retry and
   size stats. Optionally feed the bulletin.

Follow `roles/designer/AGENT.md` for the open-questions carve-out. Settle everything that is
not a genuine maintainer decision.

**IMPORTANT, a known fleet bug:** when you finish, you MUST complete the job (report via the
normal completion path). Two designs today did their work but exited without completing, so the
reaper doomed a finished job and halted the orchestration.
