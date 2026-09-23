# Design: journal contention watch (anomaly detection on latency and retries)

| Created | 2026-09-23 |
| Author | designer |
| Status | Proposed |

Code to be built (by `build-journal-contention-watch`):
- Instrumentation helpers in [`scripts/jobs/common.sh`](../scripts/jobs/common.sh):
  a single cheap recorder `contention_record` plus wrap points inside the existing
  `clone_lock`, `_journal_git_fetch`/`bounded_fetch`, the CAS push loops via
  `commit_and_push`, and `start_journal_outage_cooldown`/`journal_outage_active`.
- `scripts/jobs/journal-contention-watch.sh` (the per-host checker) and its unit pair
  `scripts/systemd/garden-journal-contention-watch.{service,timer}`.
- A read-only probe `scripts/jobs/journal-contention-probe.sh`.
- Alerting via [`scripts/jobs/watchdog-notice.sh`](../scripts/jobs/watchdog-notice.sh).

This is the **sibling** of [comment-latency-watch](comment-latency-watch.md)
(kriscendobot/garden#110): it reuses that design's host-local heartbeat, the
`watchdog-notice.sh` coalesced-alert shape, and the "runs during drain, watches its
own liveness" posture. Where comment-latency-watch measures the **outward** path
(comment → reactji), this one measures the **inward** substrate every job rides: the
journal clone's locks, fetches, pushes, and outage latch.

## Problem

The journal machinery is built to *tolerate* contention and measures none of it
(job brief, "What exists today"). Every defense degrades silently:

- `clone_lock` waits `GARDEN_LOCK_WAIT`×`GARDEN_LOCK_RETRIES` (60s × 3), steals a
  stale holder, or `die`s — each leaving only a log line.
- CAS push loops retry up to 50× (`cursor-set.sh`, `set-workers.sh`,
  `reaper.sh` `GARDEN_REAP_PUSH_ATTEMPTS`) with classification already present
  (`journal_push_is_cas_contention`/`_server_rejection`/`_definite_failure`), but
  the retry counts are never recorded.
- The shared outage latch (`journal_outage_active`, `GARDEN_JOURNAL_OUTAGE_COOLDOWN_SECS`
  120s, capped 900s) makes every cursor consumer skip **quietly**.
- `sync_clone`/`ensure_clone` fetches are bounded by `GARDEN_FETCH_TIMEOUT` (45s)
  but nothing watches the *approach* to that cap, and nothing tracks clone size.

Incidents this must catch early (2026-09-22/23):

- A **105G leader state clone** made its fetch exceed the 45s cap, so
  `is-main-host.sh` served a stale ref and reported "follower" on the true leader
  for hours. → a slow-fetch / oversized-clone signal.
- A **6.6G cursors clone**'s slow fetch latched the shared outage cooldown, so every
  comment watcher dropped every directive for ~4.5h while systemd logged success. →
  a stuck-latch / silent-skip signal.
- **Journal churn** (~10k no-op commits/day, since fixed in `74461976fd`/`3c696ea6c8`)
  raised push-race contention fleet-wide. → a push-attempt drift signal.

The through-line: the failure mode is a **slow creep toward a cap** that flips a
silent exit path, not a loud crash. So drift detection — not just spike detection —
is the requirement.

## Design

### 1. Instrumentation points and signals

One recorder, called from the existing hot functions. Overhead is a single bash
builtin read of `$EPOCHREALTIME` (no fork) plus one append to a host-local file
(atomic for a sub-`PIPE_BUF` line on a local fs), gated by
`GARDEN_CONTENTION_INSTRUMENT` (default `1`):

```
contention_record <clone> <signal> <value>      # append "<epoch> <value>" to a ring
```

Files live at `$GARDEN_STATE/journal-contention/<signal>/<clone-slug>`. Writers only
**append**; the checker trims each ring to `GARDEN_CONTENTION_RING` lines (default
512) each tick, so writers never pay a rewrite and inter-tick growth is bounded to
`rate × cadence`. `<clone-slug>` is the clone dir path sanitized (the same
`tr -c 'A-Za-z0-9' '_'` shape `_clone_lock_envkey` uses), so per-caller/per-clone
rings stay separate.

| Signal | Wrap point | Value recorded |
| --- | --- | --- |
| `lock-wait` | `clone_lock` | seconds from first `flock -w` attempt to acquisition |
| `lock-steal` | `clone_lock` (stale-reclaim branch) | `1` per steal |
| `lock-giveup` | `clone_lock` (die / soft-exit branch) | `1` per give-up |
| `fetch` | `_journal_git_fetch` (and `bounded_fetch` for bare clones) | seconds elapsed + rc (`0`/`124`/`137`/other) |
| `push-attempts` | CAS loop exit (via `commit_and_push` caller) | attempt count for the transaction |
| `push-class` | commit_and_push rejection | `cas`/`server-reject`/`definite-fail`, classified by the existing predicates |
| `outage-latch` | `start_journal_outage_cooldown` (winner only) | `1` per latch, tagged with the window secs |
| `outage-skip` | `journal_outage_active` short-circuit | `1` per quiet skip |

Clone **size** is not a hot-path signal: the checker measures it per tick (below),
so writers never pay a `du`/`count-objects`.

The push-attempt count is already in scope in each CAS loop (`$attempt`); the build
adds one `contention_record` at loop exit and one `push-class` record per classified
rejection, reusing `journal_push_is_cas_contention`/`_server_rejection`/`_definite_failure`.
No new classification logic, so the recorder and the retry logic cannot drift.

### 2. Storage: host-local, bounded, no journal churn

All signal rings and the checker's derived stats live under `$GARDEN_STATE`
(host-local, never committed) — the journal was just rebuilt to escape churn, so
there are **no per-event or per-tick journal writes**. The only journal writes are
`watchdog-notice.sh` alerts, which fire on anomaly, not on tick. A fleet-wide
periodic summary is **declined**: the read-only probe (section 8) plus the bulletin
give the cross-host view without reintroducing a write cadence; an hourly summary
commit would be `24 × hosts` new commits/day for a view a read already provides.

### 3. Anomaly detection: baseline, hard guards, drift

Per signal, over a trailing window (`GARDEN_CONTENTION_WINDOW`, default the last 256
samples), the checker computes a **rolling median + MAD** and a **p95**, each paired
with an **absolute floor** so a quiet baseline never pages on a single blip.

**Hard guards** (page regardless of baseline — these are the incident classes):

| Guard | Threshold |
| --- | --- |
| Fetch near cap | any sample ≥ `0.70 × GARDEN_FETCH_TIMEOUT` (≥ **31.5s** at the 45s cap), or window p95 ≥ that |
| Lock give-up | any `lock-giveup` sample (the `die`/soft-exit) |
| Excess steals | `lock-steal` count > `GARDEN_CONTENTION_MAX_STEALS` (default 3) per window |
| Stuck latch | an outage episode continuously latched > `GARDEN_CONTENTION_LATCH_MAX` (default **600s / 10 min**) — see §4 |
| Push wedge | any transaction reaching the 50-attempt CAS cap, or any `definite-fail` push class |
| Oversized clone | bytes ≥ `GARDEN_CONTENTION_CLONE_MAX_BYTES` (default **4 GiB**), or `gc.log` present, or packs ≥ `GARDEN_CONTENTION_MAX_PACKS` (default **1000**) |

The clone guard was recalibrated on 2026-09-23 after the first deploy flagged ~40
healthy clones at a 50-pack threshold. The measured population: on the leader, 121
healthy per-service clones at 0–128 packs (median 6, p90 40), sizes up to ~240 MB
plus one compact 1-pack 1.9 GB clone; on the follower, healthy clones at 51–71 packs
and ≤ 335 MB, pathological clones at 4.2–90 GB with 1,391–20,536 packs (the leader's
earlier pathological `ci-watcher/verify` held 40,806). Size and `gc.log` are the real
signals; pack count stays only as a backstop an order of magnitude above the healthy
maximum, so the automatic remedy never churn-rebuilds a healthy clone.

Samples older than `GARDEN_CONTENTION_MAX_AGE` (default 6h) are ignored, so a single
past give-up does not keep a condition open forever. Only rings whose slug lies under
this garden root are analyzed; a foreign path's rings (a test fixture sourcing
`common.sh` against the default state) are purged, and a test context
(`GARDEN_TEST=1`) with no explicit `GARDEN_CONTENTION_DIR` records nothing.

**Baseline anomalies** (page only when the trailing signal exceeds baseline *and*
its floor, guarding against a quiet-baseline false page):

- `lock-wait` p95 ≥ `median + 3×MAD` **and** ≥ `GARDEN_LOCK_WAIT` (60s): a full
  wait window means real contention.
- `push-attempts` p95 ≥ `median + 3×MAD` **and** ≥ 5: normal is 1.
- `fetch` p95 ≥ `median + 3×MAD` **and** ≥ 15s (below the hard-guard 31.5s, so a
  climbing trend is caught before it reaches the cap).

**Drift** (the actual failure mode — a slow creep toward the cap): the checker splits
the window into an oldest third and a newest third and raises a drift notice when the
newest-third median ≥ `1.5 ×` the oldest-third median **and** the newest-third median
≥ a per-signal floor (`fetch` 10s, `lock-wait` 20s, `push-attempts` 3). Drift for
`fetch` additionally projects: if the current slope reaches `0.70 × cap` within 24h,
it pages as drift even without the 1.5× rise. The floor gates both paths: a fetch
rising from 1.2s to 2.1s is weather, however steep its projection. Fetch drift also
needs at least `GARDEN_CONTENTION_DRIFT_MIN_SAMPLES` (12) samples spanning
`GARDEN_CONTENTION_DRIFT_MIN_SPAN` (1h), so a short-lived per-job inbox clone never
qualifies. This is what turns the 105G-clone creep into a warning well before the
fetch flips the stale-ref path.

**Flapping guard.** Hard guards page on the **first** confirming tick (they are the
incident classes; fast detection wins). Baseline and drift anomalies page only after
**2 consecutive** confirming checker ticks, so ordinary weather does not flap.

### 4. Silent-skip visibility

Every `outage-skip` is counted per episode (an episode = back-to-back latch windows
with skips, closed after a full tick with no skip). The checker surfaces:

- **stuck latch** — an episode continuously latched > `GARDEN_CONTENTION_LATCH_MAX`
  (10 min). This is the 4.5h class: the latch keeps re-arming (each window ≤ 900s)
  while a bloated clone's fetch never completes, so consumers skip quietly forever.
  Caught an order of magnitude sooner than 4.5h.
- **skip volume** — total `outage-skip` count over the window, reported by the probe
  even below the paging threshold, so sustained quiet skipping is always visible.

This directly answers the "systemd logged success while every directive was dropped"
incident: the skip is now counted, and a sustained latch pages.

### 5. Remediation: automatic lossless clone rebuild, with an alert

Matching the **root-repo-guard** posture (prefer an automatic lossless remedy over a
bare alert), the checker rebuilds an oversized / gc.log-wedged / slow-fetching
per-instance clone rather than only alerting:

1. Acquire `clone_lock <clone>` (so no producer races the swap; if it cannot be
   acquired promptly, defer to the next tick — never force).
2. Rename the clone aside to `<clone>.contention-old.<ts>` (atomic, lossless).
3. Let the next `ensure_clone <clone>` rebuild a fresh clone via its atomic
   sibling-temp path (already the self-heal primitive `sync_clone` uses for a corrupt
   clone — it subsumes clearing `gc.log`).
4. Delete the moved-aside copy in the **background** (`rm -rf` detached), so a 100G
   unlink never blocks the tick.
5. Alert via `watchdog-notice.sh` (remedy applied), closed `--recovered` once the
   fresh clone's fetch is back under the cap.

Scope is strictly the **per-instance `$GARDEN_STATE` clones** (`*/journal`,
`*/verify`, leader/producer clones). The **shared root repo** and its `journal/`
worktree are left to [root-repo-guard](root-repo-guard.md) — two actuators must not
fight over one repo. Backoff mirrors root-repo-guard: at most one rebuild per clone
per `GARDEN_CONTENTION_REMEDY_INTERVAL` (default 6h). A kill-switch
`GARDEN_CONTENTION_REMEDY=0` degrades to alert-only. The remedy runs even while the
fleet is draining (a per-service clone is not the deploy's tree), unlike
root-repo-guard's maintenance which defers to the deploy.

### 6. Where it runs, and what watches the watcher

- **Instrumentation on every host** — contention is per-host (each host's clones,
  locks, and latch are its own).
- **The checker on every host**, like `garden-root-repo-guard`, **not** leader-only:
  a follower's clone can bloat independently, and the incident's stale-ref flip
  happened *on the leader while it thought it was a follower*. Gated on nothing but
  its own unit; **no `is-main-host` gate, no `fleet_draining` guard** (a drained host
  is exactly when a wedged clone must still be surfaced and rebuilt).
- **Cadence** `GARDEN_CONTENTION_CADENCE` default 300s (slower than the producers it
  observes; anomalies are minutes-scale).
- **Tick deadline.** The unit's `TimeoutStartSec=240` must never be the thing that
  ends a tick: a SIGTERM mid-tick loses the heartbeat and every notice and remedy
  after the killed clone. The script owns a shorter budget
  (`GARDEN_CONTENTION_TICK_BUDGET`, default 210s) and stops starting clone work once
  less than `GARDEN_CONTENTION_RESERVE` (20s) of it remains. Each clone's
  `count-objects` read is bounded by the remaining budget; a timeout defers that
  clone rather than reading it as 0 bytes. A clone rebuild starts only with
  `GARDEN_CONTENTION_REMEDY_MIN` (120s) left, its fetch retries trimmed to fit, and
  otherwise records `remedy: deferred-deadline` with no backoff stamp so the next tick
  retries it. Deferred clones are written to `deferred` and run first next tick, so a
  slow tail is never starved; their confirm counters and open notices are left
  untouched. The heartbeat records `outcome: partial-poll` and `deferred_clones`, and
  two consecutive partial ticks open `journal-contention-watch-overrun`.
- **Its own liveness** follows comment-latency-watch's three turtles: (1) systemd
  `Restart=on-failure` + timer re-arm; (2) it writes its own host-local heartbeat
  (`$GARDEN_STATE/journal-contention-watch/heartbeat`), whose staleness the probe and
  bulletin surface; (3) a dead host is dominated by the louder peer-offline alarm.
  The honest limit is identical: it cannot page about its own total death from
  inside itself, but a live-host silent checker is caught by its stale heartbeat in
  the probe/bulletin read.

### 7. Alerting

All through `watchdog-notice.sh`: one coalesced notice per open condition, amended as
it persists, closed with `--recovered`. Never one message per tick. Keys are per host
+ clone + class:

| Key | Condition |
| --- | --- |
| `journal-fetch-slow-<clone>` | fetch at/over the 31.5s hard guard, or the baseline anomaly |
| `journal-fetch-drift-<clone>` | fetch median creeping toward the cap (§3 drift) |
| `journal-lock-contention-<clone>` | a lock give-up, excess steals, or the lock-wait baseline anomaly |
| `journal-push-contention-<clone>` | a CAS-cap wedge, `definite-fail` class, or the push-attempt anomaly |
| `journal-outage-stuck` | an outage episode latched > 10 min (host-level key) |
| `journal-clone-oversized-<clone>` | clone over the size/packs/gc.log guard; body states the remedy taken |
| `journal-contention-checker-stale` | the checker's own heartbeat is stale (surfaced by the probe/bulletin, not self-posted) |

Each body names the clone, the offending signal, the observed value against its
threshold, and — for the oversized case — the remedy applied.

**Storm guard.** When more than `GARDEN_CONTENTION_STORM_MAX` (5) clones hit the same
class in one tick, the checker opens ONE `journal-contention-storm-<class>` summary
instead of the individual keys: a class-wide burst has one shared cause (or a
miscalibrated threshold), not N faults. An open notice whose key is no longer
evaluated (clone gone, samples aged out, foreign slug purged) is closed with
`--recovered`, so a rule change retires the notices the old rule opened.

### 8. Observability

- `scripts/jobs/journal-contention-probe.sh` — read-only, safe any time. Prints, per
  clone: lock-wait p50/p95, fetch p50/p95 against the cap, push-attempt p50/p95 and
  class counts, outage skip count and current latch state, clone size / packs /
  gc.log presence, and the checker's heartbeat age.
- The **bulletin** includes a one-line summary (worst clone by fetch-p95-vs-cap and
  any open contention notice), reusing `bulletin.sh`'s existing feed shape.

## Ownership map

Boundaries the design spans:

| Boundary | Mechanism | Policy | Durable state | Commit/lifecycle authority | Value crossing |
| --- | --- | --- | --- | --- | --- |
| Producer ↔ instrumentation | `contention_record` append | record iff `GARDEN_CONTENTION_INSTRUMENT` | `$GARDEN_STATE/journal-contention/<signal>/*` (host-local ring) | producer appends; checker trims | `<epoch> <value>` sample |
| Checker ↔ rings/stats | read + trim + derive | rolling median/MAD, p95, drift | derived stats under `$GARDEN_STATE` (host-local) | checker | anomaly verdict per signal |
| Checker ↔ clone (remedy) | `clone_lock` + rename-aside + `ensure_clone` rebuild | auto-remedy, idle-only, 6h backoff | the per-instance clone dir | checker (holds the lock across the swap) | a fresh, fast clone |
| Checker ↔ journal notices | `watchdog-notice.sh` | one keyed notice per condition | `inbox/maintainer/unread/watchdog-*.md` (journal) | checker opens/amends/closes | the maintainer-facing anomaly |

Four ownership questions:

- **Persistent state.** The journal owns only the durable maintainer alert.
  Everything the instrumentation and checker compute is host-local and
  reconstructible by design (a lost ring re-fills within a window), to avoid churn.
- **Commit/discard.** The checker decides when a condition is open vs recovered
  (notice) and when a clone is beyond remedy threshold (rebuild). A producer only
  decides *that* it contended (appends a sample); it never alerts.
- **Restart/replay.** All host-local state is a cache; losing it re-derives on the
  next ticks (idempotent, window-bounded). Notices survive a checker restart because
  they live in the journal and `watchdog-notice.sh` amend-or-post is idempotent. A
  remedy interrupted mid-swap is safe: `ensure_clone` treats a `.git`-less dir as a
  poisoned partial clone and re-clones (existing behavior).
- **Execution classification.** The checker is a deterministic, no-LLM daemon (like
  the sysop, root-repo-guard, and comment-latency-watch). No model runs in the
  observe or remedy path.

Inner/outer naming check: the daemon **observes** contention and **remediates** a
clone; it does not own the lock, the fetch, or the push. It is named
`journal-contention-watch` (a watcher), and the recorder is `contention_record` (a
sensor), never `contention_manager`. The producers keep owning their own
lock/fetch/push; the watch only reads their samples and rebuilds a clone that has
gone bad.

## Test plan

- Unit: `contention_record` appends one line and is a no-op when
  `GARDEN_CONTENTION_INSTRUMENT=0`; the checker trims a ring to `GARDEN_CONTENTION_RING`.
- Unit: median/MAD, p95, and oldest-third/newest-third drift over synthesized sample
  windows, at the floors and the hard-guard boundaries (31.5s fetch, 60s lock,
  50-attempt push, 2 GiB clone).
- Unit: the flapping guard — a baseline anomaly pages only on the 2nd consecutive
  confirming tick; a hard guard pages on the 1st.
- Integration (stubbed): the **4.5h replay** — a run of re-arming outage latches with
  skips produces exactly one `journal-outage-stuck` notice, not one per tick, and
  clears on recovery.
- Integration (stubbed clone): an oversized/`gc.log`-wedged clone triggers the
  rename-aside + `ensure_clone` rebuild + background delete + one
  `journal-clone-oversized-<clone>` notice, and `--recovered` once the rebuilt clone's
  fetch is back under the cap; the 6h backoff suppresses a second rebuild.
- Integration: instrumentation is behavior-preserving — the existing
  `clone_lock`/`sync_clone` tests pass unchanged with recording enabled, and the
  overhead per call is a single `$EPOCHREALTIME` read plus one append.
