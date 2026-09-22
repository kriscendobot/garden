---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: fixer
tier: mentat
dispatch: manual
handler-timeout: 10800
---
Make the rolling deploy SKIP peers that the journal shows are offline, instead of
wedging the whole fleet behind an unreachable follower. MAINTAINER DIRECTIVE
(kriskowal, 2026-09-22).

## The wedge (diagnosed 2026-09-22, and it has bitten twice)

`scripts/jobs/rolling-deploy.sh` has NO offline-skip. It releases the roll token to
the next follower in sorted order and waits. An unreachable follower never deploys
the target, so after the deploy budget it is treated as a FAILED CANARY -> bounded
retries -> terminal HALT, and the LEADER NEVER ADVANCES. A host that cannot
participate at all is therefore indistinguishable from a host that participated and
broke — and the second reading blocks everyone.

Observed: `oros-studio-garden-ce242c49` has been offline since 2026-09-19. The
rolling deploy of `e43c28386fae` passed its first canary
(`endolin-garden2-5bcdff64`), then released to oros in sorted order and halted
there. The same host had already halted an earlier roll on 2026-09-20. The fleet sat
29-35 commits behind until a human-directed job unwedged it by ARCHIVING oros's host
record (`hosts/.archived-oros-studio-garden-ce242c49`) and clearing its stale
release token — a per-host manual workaround, not a fix. The next offline follower
wedges the roll again.

Related precedent, same family, already fixed — read it before designing, and make
the two compose rather than collide: `845b1895e2` ("break the canary-drain
self-exclusion deadlock") added drain PROVENANCE (`source:` in the draining marker,
`drain_source`/`drain_is_roll_induced`, failing safe toward operator) plus bounded
canary retries. That fixed a host that was DRAINED. This is a host that is GONE.

## The liveness evidence — use the right signal

THE HEARTBEAT IS `budget/live/<pool>/<host>`, which carries `sampled_at` and is
refreshed by `garden-budget-refresh.timer` on a ~5-minute cadence. Current values
make the discrimination trivial:

    endolin-garden-ece02cb4     sampled_at: 2026-09-22T20:30:53Z   (live)
    endolin-garden2-5bcdff64    sampled_at: 2026-09-22T20:12:27Z   (live)
    oros-studio-garden-ce242c49 sampled_at: 2026-09-19T22:17:05Z   (~3 days stale)

DO NOT USE `fleet/health/<host>` AS A LIVENESS SIGNAL. It is NOT a heartbeat: it is
written only by `deploy-garden.sh` and `self-deploy.sh`, i.e. on deploy events. A
dead host's record simply freezes at whatever it last said — oros's still reads
`roll_status: deployed`, `unit_failures: 0`, `first_bad_unit: -`, which LOOKS
HEALTHY three days after the host went silent. Any check keyed on it is fooled by
construction. (Whether `fleet/health` should also carry a periodic tick is a fair
question; if you add one, it is additive and the heartbeat above remains the
authority for this decision.)

Consider corroborating signals where cheap, but pick ONE authority and say why:
the sysop ack path is a strong secondary (oros never acked a `set-workers` op sent
2026-09-21T20:33:27Z; its newest `sysop-log` entry is 2026-09-17T23:59), and claim
activity is another.

## Tasks

1. Add an offline predicate keyed on heartbeat staleness, with the threshold as a
   tunable and a defensible default. Size it well clear of the ~5-minute refresh
   cadence so ordinary jitter, a slow tick, or a brief network blip never marks a
   live host offline — but far below the ~3 days this went unnoticed.
2. `follower_hosts()` / the roll's canary selection must SKIP an offline peer:
   do not release the token to it, do not start its deploy budget, do not count it
   as a failed canary, and do not let its absence halt the roll. Skipping must be
   VISIBLE, not silent — the roll's log and completion record should say which peers
   were skipped and why.
3. Distinguish the three states explicitly in code and in the operator-facing
   output, because they demand different responses:
     - OFFLINE (no heartbeat)        -> skip, alert, do not halt
     - DRAINED (marker present)      -> existing behavior; honor operator drains
     - PRESENT BUT FAILING VALIDATION -> a real failed canary; halt as today
   Do NOT weaken case 3. A genuinely broken canary must still stop the roll — that
   safety property is the whole point of canarying, and losing it would be a far
   worse regression than the wedge being fixed.
4. ALERT on an offline peer via `watchdog-notice.sh`, coalesced: ONE keyed notice
   per host per episode, closed with `--recovered` when the heartbeat resumes.
   There is currently NO host-liveness watchdog at all — a host went silent for
   three days and nothing fired — so this is the first alert of its kind. Every
   existing watchdog keys on a condition being OBSERVED; this one must key on the
   ABSENCE of observation.
5. Decide what happens when an offline peer RETURNS. Its heartbeat resumes; should
   it rejoin the canary rotation automatically? Note the manual workaround left
   oros's host record ARCHIVED, so it will NOT rejoin on its own even once healthy.
   Say whether your change should un-archive it, whether that is a separate operator
   act, and make the answer explicit rather than leaving a host silently
   decommissioned.
6. Handle the all-followers-offline case: if every follower is offline, the leader
   has no canary. Do NOT advance the leader unvalidated — that is the existing,
   correct posture (`designs/follower-self-deploy.md`) — but make the resulting hold
   legible rather than a silent stall, and say how an operator clears it.

## Validate

Regression tests pinning: an offline peer is skipped and the roll completes; a
DRAINED peer keeps today's behavior; a present-but-failing canary still HALTS the
roll; and an offline peer whose heartbeat resumes is handled per your item-5
decision. Include a test that a fresh-but-briefly-late heartbeat does NOT trip the
offline predicate.

Update `designs/follower-self-deploy.md` to record the offline-skip semantics.
