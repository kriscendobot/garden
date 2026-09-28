---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 14400
token-budget: 800000
---
# Standing automation: derotate a silent host's worker capacity, auto-restore on heartbeat

## Maintainer directive (kriskowal, 2026-09-28)

> Let's take oros-studio out of rotation and automatically add it back when
> it starts posting again.

I already took the immediate manual action: `config/worker-leveling`'s
`oros-studio-garden-ce242c49` row is zeroed (`0 0`, was `4 0`), commit
message explains why (silent since ~2026-09-27T17:00Z, no claims). **This
job's task is to build the STANDING automation** so this becomes
self-correcting for any host, going forward, without a human noticing and
intervening by hand again — and to have that automation recognize and take
over management of oros-studio's current zeroed state correctly.

## Reuse existing liveness detection — do not reinvent it

`scripts/jobs/rolling-deploy.sh` already has exactly the primitive needed:
`host_heartbeat_epoch <host>` (reads the freshest `budget/live/*/<host>`
snapshot timestamp — the same heartbeat every host already publishes),
`GARDEN_HOST_OFFLINE_AFTER` (default 30 min offline threshold), and the
`HOST_LIVENESS_DETAIL` diagnostic. It already drives an analogous
auto-recover behavior for the DEPLOY-CANARY rotation (the
`rolling-deploy-host-offline-<host>` `alert_maintainer`/
`alert_maintainer_clear` pair, "heartbeat resumed for X; it is PRESENT again
and will automatically rejoin the canary rotation"). Read that code path in
full before designing anything new. This job needs the SAME liveness signal
applied to a DIFFERENT rotation — `config/worker-leveling` capacity — not a
second, independently-drifting notion of "offline."

## What to build

A leader-only deterministic (no-LLM) tick — likely a new small script +
systemd timer/unit pair (`garden-worker-derotate` or similar; check whether
folding it into an existing leader-only cadence, e.g. alongside
`budget-refresh.sh`'s 5-minute cadence, is cleaner than a new standalone
timer — your call, but match the fleet's existing convention for where
leader-only capacity-adjustment logic lives, `budget-level.sh` is the
closest sibling to study) that, for each host currently declared in
`config/worker-leveling`:

1. **Checks liveness** via `host_heartbeat_epoch`/the offline threshold
   (reuse the function, don't reimplement it — extract/share it from
   `rolling-deploy.sh` if it isn't already in a shared location like
   `common.sh` or `usage-meter.sh`).
2. **On a present→offline transition**: record the host's CURRENT
   `worker-leveling` row values (so they can be restored exactly, not
   guessed — store them in a marker, mirroring
   `worker_model_unsupported_latch`'s `reason=`/metadata-file shape, e.g.
   under `$GARDEN_STATE` or a dedicated journal path — your call on
   host-local vs. journal-durable state, but a LEADER-ONLY marker that must
   survive a leader handoff argues for journal-durable, same reasoning
   CLAUDE.md's foreman-brake section already gives for why THAT flag is
   journal-backed and not host-local), zero its `worker-leveling` row, and
   post ONE coalesced maintainer notice (edge-triggered, matching
   `alert_maintainer`'s existing dedup shape — do not spam one notice per
   tick).
3. **On an offline→present transition, ONLY for a host this mechanism
   itself zeroed** (check the recorded marker/reason — never restore a
   host's capacity that a human zeroed for an unrelated reason; that
   distinction matters and getting it wrong would silently override a
   deliberate operator decision): restore the exact saved prior values,
   clear the marker, and post the matching recovery notice (mirroring
   "heartbeat resumed for X; it is PRESENT again...").
4. **Take over oros-studio's current state correctly.** Its row is already
   `0 0` as of this job's posting, done by hand, not yet marked by your new
   mechanism. On this job's first tick after landing, it should either (a)
   recognize the host is currently offline and write the "this mechanism
   owns it, prior value was 4 0" marker retroactively so a future heartbeat
   correctly restores to `4 0` (not to `0 0`), or (b) if oros-studio has
   ALREADY resumed heartbeating by the time you run this, restore it to
   `4 0` immediately as part of landing. Check its live heartbeat state
   before deciding which applies; report which happened.

## Boundaries

- Leader-only (`is_main_host` gate, matching every other singleton
  fleet-config-mutating service).
- Never touches a host's OWN local worker-count declaration
  (`hosts/<host>`'s `monks:`/`clerics:` lines) — those stay host-owned per
  the existing convention (`set-workers.sh` refuses cross-host writes).
  `config/worker-leveling`'s per-host CAP is the fleet-shared ceiling this
  mechanism legitimately owns adjusting; the host's own declared count still
  self-governs within whatever cap is live.
- Fail toward SAFE, not toward capacity: an unreadable/ambiguous heartbeat
  read should never zero a host it can't confirm is actually offline, and
  should never restore a host it can't confirm is actually back (mirror
  `budget-level.sh`'s own fail-open-but-freeze-loudly posture for a broken
  read, not a silent guess either direction).

## Tests

Cover: present→offline zeroes and records the prior value; offline→present
(mechanism-owned) restores exactly; offline→present for a host zeroed by a
human for an unrelated reason does NOT auto-restore; a broken/unreadable
heartbeat read neither zeroes nor restores. Run the full relevant suite
before completing.

## Land

Direct to `main2`, no PR, per CLAUDE.md's own-repo convention, unless this
surfaces real open questions (plausible: journal-durable vs. host-local
marker placement, whether to fold into an existing timer or add a new one).

## Report

State plainly what happened to oros-studio's row as a result of this job
landing (restored to `4 0`, or marked for future auto-restore at `4 0`,
whichever applies), and confirm the maintainer-notice dedup behavior with a
concrete before/after.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-28T14:33:01Z
