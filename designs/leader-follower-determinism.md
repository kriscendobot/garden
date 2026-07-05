---
created: 2026-07-05
updated: 2026-07-05
author: gardener (job design-leader-follower-determinism)
---

# Leader/follower determinism: the epoch-fenced handoff state machine

| Created | 2026-07-05 |
| Author  | gardener |
| Status  | Proposed (design accepted gates the staged build plan below) |

Supersedes the transition mechanics of
[multibot-leader-follower.md](multibot-leader-follower.md) (which remains the
authority on WHICH services are singletons and which are per-host local-infra).
Tracks issue [kriskowal/garden#11](https://github.com/kriskowal/garden/issues/11)
and the maintainer directive behind job `design-leader-follower-determinism`:
the leader marker has flapped, handoffs have raced, and the transition must
become reliable and fully deterministic, driven entirely by propagation of the
leader state in the journal.

Leadership **designation stays manual** (no automatic failover; that remains the
harder follow-on). What changes is that the **transition itself** becomes a
deterministic state machine: every host derives its role from the journal, a
deterministic per-host sentinel executes the mechanical steps, and a duplicate
leader is detected and demoted rather than silently double-posting.

## 1. Why the current mechanism flaps (failure inventory)

Grounding: `scripts/jobs/common.sh` (`leader_host`, `is_main_host`),
`scripts/jobs/is-main-host.sh`, `scripts/jobs/set-main-host.sh`,
`scripts/jobs/drain-fleet.sh`, `scripts/jobs/identity-drift-guard.sh`, the
leader-only units in `scripts/systemd/`, `roles/liaison/AGENT.md` § Stand up /
stand down, and the `garden` launcher.

1. **The marker is a bare name.** The journal `leader` file holds one `GARDEN`
   identity string. Nothing distinguishes two instances that share the name
   (the endolinbot2 regression class), and nothing sequences successive
   designations. A mis-pointed marker or a duplicated shard name yields two
   hosts whose predicates both answer "leader", undetected.
2. **Re-pointing the marker is instantaneous for the new leader and lazy for
   the old.** `set-main-host.sh` flips the name in one commit. The new leader's
   next predicate read answers "leader" immediately, while the old leader keeps
   answering "leader" from its TTL cache (`GARDEN_LEADER_TTL`, 30 seconds) and
   then finishes whatever tick was already in flight. That is a structural
   two-leader overlap window on every handoff, bounded only by luck: cache age,
   timer phase, and tick duration.
3. **The safe ordering exists only as prose.** The drain, stand-down-Monitors,
   re-point sequence in `roles/liaison/AGENT.md` is executed by an LLM liaison
   following documentation. Steps get skipped, reordered, or interleaved with
   the other host's steps. Nothing in the journal encodes "a handoff is in
   progress", so no script can enforce the ordering.
4. **The predicate fails open.** `GARDEN_LEADER_DEFAULT=leader` makes a host
   that cannot determine the leader (cold start, unreadable journal, empty
   marker) run the singletons. Two hosts in that state are two leaders.
5. **The stale-cache fallback never expires.** On a journal outage the
   predicate serves the last cached verdict indefinitely. A demoted or
   partitioned old leader keeps acting as leader for as long as the outage
   lasts, plus one TTL after it heals.
6. **The liaison Monitors are singletons by documentation only.** Nothing
   detects two live maintainer-inbox Monitors; nothing forces an orphaned one
   on a demoted host to go quiet.
7. **The handoff is coupled to draining the gardener pool.** Gardeners are
   CAS-safe on every host and never needed draining for a leadership move; the
   coupling adds manual steps to the critical path and more chances to
   half-execute the ceremony.

Every one of these is closed below. Items 1 and 4 and 5 are closed by state
shape and predicate changes; 2 and 3 by the two-phase handoff and the sentinel;
6 by self-gating Monitor commands; 7 by decoupling.

## 2. Design at a glance

- The journal `leader` file becomes a small structured **leader record** with a
  `state` (`stable` or `handoff`), a monotonically increasing **epoch**, and a
  per-epoch **instance binding**. All writes to it are CAS pushes to
  `origin/journal2`, the same serialization point as everything else.
- Every instance owns a **unique instance identity**: a UUID minted once at
  container creation into the gitignored `$GARDEN_ROOT/.garden-instance`
  (mirroring how `.garden` captures the `GARDEN` shard name).
- The predicate `is_main_host` answers "leader" only for the instance that is
  **bound** to the current epoch of a **stable** record. During a handoff the
  predicate answers "follower" on every host, so the inter-leader gap contains
  zero leaders, never two.
- A new deterministic per-host unit, **`garden-leader-sentinel`** (timer plus
  oneshot, no LLM), executes every mechanical transition: it quiesces and
  releases on the outgoing leader, binds the epoch and heartbeats on the
  incoming leader, and detects and reports duplicate leaders everywhere.
- The leader **heartbeats its instance identity** into the journal; any host
  that finds the marker naming its `GARDEN` but an epoch bound to a different
  instance knows deterministically that it is the duplicate: it stays follower
  and reports loudly.
- The liaison's leader-only Monitors become **self-gating** (their watch
  commands consult the predicate), so an orphaned Monitor goes silent by
  itself; the liaison ceremony becomes convenience, not the safety mechanism.

## 3. Journal state shape

Two files at the journal root, both written only by CAS pushes to
`origin/journal2`.

### 3.1 The leader record (`leader`)

Line 1 is preserved as a bare `GARDEN` identity for compatibility: it names the
**acting** leader as legacy readers should see it (the outgoing leader during a
handoff, the designated leader when stable). Subsequent lines are `key: value`
fields. A record with only line 1 (the current format) is read as
`state: stable`, `epoch: 0`, unbound; the v2 parser accepts it, so rollout does
not require a flag day.

Stable:

```
endolinbot
state: stable
epoch: 12
leader: endolinbot
bound_instance: 6f9c2a4e-8b1d-4e0a-9c3f-2d7b8a1c5e40
bound_at: 2026-07-05T18:20:11Z
predecessor: kriscendo
transitioned_at: 2026-07-05T18:19:40Z
transitioned_by: endolinbot
```

Handoff (line 1 stays the OUTGOING leader, so a legacy predicate keeps the old
leader in place until the release commit, exactly the safe reading):

```
endolinbot
state: handoff
epoch: 13
from: endolinbot
to: kriscendo
initiated_at: 2026-07-05T18:19:02Z
initiated_by: endolinbot
```

Rules:

- `epoch` increases by exactly one at each handoff initiation, force
  designation, and bootstrap write. It never decreases and never repeats.
- `bound_instance` is absent when a stable epoch is fresh; exactly one instance
  ever binds a given epoch (§ 5.2). The bind is a CAS edit of this file.
- Writers: `set-main-host.sh` (bootstrap, initiate, force, abort) and
  `leader-sentinel.sh` (release, bind). Nothing else writes the record.

### 3.2 The leader heartbeat (`leader-heartbeat`)

Written only by the bound leader's sentinel, on a slow cadence
(`GARDEN_LEADER_HEARTBEAT_SECS`, default 600) to bound journal commit noise:

```
epoch: 12
instance: 6f9c2a4e-8b1d-4e0a-9c3f-2d7b8a1c5e40
garden: endolinbot
at: 2026-07-05T18:30:00Z
```

The heartbeat is the **observability and last-resort detection** layer, not the
safety mechanism (the bind is). It lets the bulletin show leader liveness, lets
a maintainer see at a glance which instance is leading, and catches the
corruption case where something other than the bound instance is writing as
leader (§ 5.3). Because failover stays manual, a stale heartbeat alerts a
human; it never triggers an automatic takeover.

## 4. Instance identity (the container-minted UUID)

The maintainer suggested minting a UUID when the docker container is built.
Evaluated options:

- **Baked into the image at `docker build`**: wrong granularity. One image
  serves many containers; two instances created from the same image would share
  the identity, which is precisely the collision the mechanism must break.
- **`/etc/machine-id` inside the container**: per-container and stable across
  restarts, but it dies with `./garden reset` (container removal), is invisible
  host-side, and has no analogue on a non-docker host or a `GARDEN=<name>`
  parallel pool run from a checkout.
- **A gitignored per-instance file in the garden root, seeded at container
  creation** (chosen): mirrors exactly how `.garden` already captures the
  `GARDEN` shard identity in the `garden` launcher. The home directory is the
  bind mount, so the identity survives `./garden reset` and container
  recreation, which is correct: the same garden directory IS the same logical
  instance. Two different checkouts (or two hosts) can never share it, even
  when they mistakenly share a `GARDEN` name, which is the duplicate case the
  detector must catch.

Mechanism:

- File: `$GARDEN_ROOT/.garden-instance`, one UUID line, gitignored (add to
  `.gitignore` alongside `.garden`).
- Seeded by the `garden` launcher at container creation, host-side, only when
  absent (the same move as `.garden` and `.claude/settings.json`), from
  `uuidgen` or `/proc/sys/kernel/random/uuid`.
- Self-minting fallback: a `common.sh` helper `instance_identity()` reads the
  file and, when absent, mints and writes it atomically (noclobber), covering
  non-docker hosts and pre-existing containers. Every consumer goes through the
  helper.
- A parallel pool run from the same checkout shares the file, which is
  harmless: it also shares `GARDEN_STATE` and the systemd manager, so it is the
  same instance for every purpose this design cares about.

## 5. The state machine

### 5.1 States and derived host roles

Fleet state is the leader record; there are exactly two:

- **Stable(leader L, epoch E, bound I or unbound)**
- **Handoff(from, to, epoch E)**

Each host derives its role as a pure function of (record, own `GARDEN`, own
instance identity). No timing, restart order, or step interleaving enters the
derivation:

| Record | Condition | Host role |
| --- | --- | --- |
| any | `GARDEN` not named | **follower** |
| Handoff | `from` = mine | **stepping-down** (sentinel quiesces, then releases) |
| Handoff | `to` = mine | **becoming-leader** (predicate still follower; wait) |
| Stable | leader = mine, unbound | **becoming-leader** (sentinel races to bind) |
| Stable | leader = mine, bound = my instance | **leader** |
| Stable | leader = mine, bound = another instance | **duplicate** (stay follower, report loudly) |

A new `scripts/jobs/leader-role.sh` prints the derived role
(`leader | follower | becoming-leader | stepping-down | duplicate`) as the
single derivation point for Monitors, the bulletin, and humans.

### 5.2 Transitions

All record writes are CAS pushes; a lost race refetches and re-derives.

- **T1 Bootstrap.** No record exists: stand-up runs
  `set-main-host.sh $GARDEN`, which writes Stable(me, epoch 1, unbound).
  Concurrent bootstraps CAS-race; first push wins, losers become followers.
  This replaces fail-open as the single-host story (§ 6.3).
- **T2 Re-designate to the current leader.** No-op (unchanged).
- **T3 Initiate handoff.** Record is Stable(old) and `set-main-host.sh <new>`
  names a different host: write Handoff(from=old, to=new, epoch+1). From this
  commit on, every fresh predicate read everywhere answers follower.
- **T4 Release.** The OUTGOING leader's sentinel observes Handoff(from=me),
  quiesces this host (§ 5.4), then CAS-writes Stable(to, same epoch, unbound).
  Only the from-host's sentinel performs T4; that is what makes "old has fully
  stopped" a precondition of "new may start" rather than a hope.
- **T5 Bind.** A host whose sentinel observes Stable(leader=me, unbound)
  CAS-writes `bound_instance: <my instance>` into the record. The CAS
  guarantees at most one bind per epoch; the loser of a bind race reads the
  winner's instance and derives **duplicate**.
- **T6 Heartbeat.** The bound leader's sentinel refreshes `leader-heartbeat`
  when it is older than the cadence.
- **T7 Force.** `set-main-host.sh --force <new>`: write Stable(new, epoch+1,
  unbound) directly, from any state. This is the maintainer's recovery for a
  dead outgoing leader and the ONLY transition that skips the quiesce proof;
  its safety rests on the maintainer's assertion that the old host is down.
  A zombie that later returns reads an epoch bound to another instance,
  derives duplicate, stays follower, and reports (§ 5.5 makes even its stale
  cache safe past one TTL).
- **T8 Abort.** `set-main-host.sh --abort` while Handoff: CAS back to
  Stable(from, same epoch, unbound). The from-host's sentinel re-binds on its
  next tick and leadership never moved.

### 5.3 Duplicate-leader detection and deterministic resolution

Two complementary checks, both in the sentinel, both deterministic plain code:

1. **The bind check (the resolver).** Any host that derives **duplicate**
   (marker names its `GARDEN`, epoch bound to a different instance) IS the
   duplicate, by construction: the bound instance won the CAS. Resolution needs
   no negotiation: the predicate already answers follower for it (§ 5.5), so
   its singletons never start; the sentinel's job is to make the condition
   LOUD. It posts a `kind: error` maintainer-inbox report plus a greppable
   `kind: error` journal entry, deduplicated by a signature marker under
   `$GARDEN_STATE`, exactly the shape `identity-drift-guard.sh` established
   (fire on the first tick of a distinct condition, stay quiet until it
   changes or clears). The report names both instance identities, both hosts'
   `hostname -s` where known, and the epoch, and prescribes the fix (rename
   the shard, or re-point the marker).
2. **The heartbeat cross-check (the tamper alarm).** The bound leader verifies
   each tick that `leader-heartbeat` carries its own instance for the current
   epoch. A fresh foreign heartbeat under my bound epoch means something is
   writing as leader without holding the bind (manual edit, code regression):
   report `kind: error` the same way. The bind stays authoritative; the
   foreign writer's own sentinel derives duplicate and demotes.

This closes the requested hole end to end: two instances sharing a `GARDEN`
name race the bind, exactly one wins, the loser is deterministically demoted
and the maintainer is told, never silence.

### 5.4 The step-down quiesce (what "released" proves)

On observing Handoff(from=me), the sentinel executes, in order:

1. **Confirm with a fresh read** (never the cache) that the record is
   Handoff(from=me); otherwise re-derive and exit.
2. **Delete this host's predicate cache** (`$GARDEN_LEADER_CACHE`). Every
   subsequent predicate evaluation on this host misses the cache, fresh-reads
   the record, sees Handoff, and answers follower. With the fail-closed
   default (§ 5.5), even an unreachable journal now answers follower here.
3. **Wait for every leader-only unit to be inactive**: poll
   `systemctl --user is-active` across the full leader-only set (foreman,
   scheduler, deadmail, reaper, follow-up, proxy, mentor, mirror-closer,
   orchestrate, issue-inbox, library-source-drift-scan, mention-watcher, and
   the instantiated comment-watcher@, ci-watcher@, triager@ units) until none
   reports `active` or `activating`. systemd holds a unit in `activating`
   through its `ExecCondition` phase, so this wait atomically covers "the
   predicate answered leader a moment ago and the tick is about to run": any
   such activation is visible to the poll and completes before the wait ends.
   New activations after step 2 fresh-read, fail the condition, and
   deactivate, so the wait converges. The wait is bounded
   (`GARDEN_STEPDOWN_TIMEOUT`, generous, default 900 seconds); on expiry the
   sentinel does NOT release; it reports a wedged handoff (§ 5.6).
4. **Stop, then start, `garden-bulletin`** (and `garden-watchman` if active).
   `systemctl stop` is synchronous, so this positively terminates any bulletin
   tick that began under an earlier leader verdict; the restarted bulletin
   fresh-reads, derives follower, and idles. This is the quiesce for the two
   in-process-gated services that never restart on marker changes.
5. **CAS-write the release**: the record becomes Stable(to, epoch, unbound).
   If the CAS loses (a concurrent `--force` or `--abort` landed), refetch and
   re-derive; the release is abandoned if the record no longer says
   Handoff(from=me).

The liaison's leader Monitors are the one surface systemd cannot quiesce; § 7
makes them self-gating so their residual overlap is one Monitor poll and their
actions (a maintainer-inbox reply, a deploy of the local host) are annoying
duplicates at worst, never board or journal corruption. The release
deliberately does not gate on them.

### 5.5 The hardened predicate

`leader_host()` grows into a record read; `is_main_host()` becomes: **leader
if and only if a sufficiently fresh view of the record is
Stable(leader = my `GARDEN`, bound = my instance)**. Precisely:

- The cache (`$GARDEN_LEADER_CACHE`) stores the full derivation tuple (state,
  leader or from/to, epoch, bound instance), not just a name.
- A cached tuple answers the leader question only while fresh
  (age < `GARDEN_LEADER_TTL` on this host's own clock). A **stale cache may
  answer "follower" but never "leader"**: when the journal is unreachable and
  the cache is stale, the verdict is follower. This kills failure 5 (the
  partitioned zombie leader): a partitioned leader's singletons pause within
  one TTL. The cost is nil in practice, because every singleton's work needs
  the journal or GitHub anyway; ticks that would have failed now skip cleanly.
- `state: handoff` answers follower for every host, including `from` and `to`.
- `Stable` with the record naming my `GARDEN` but unbound, or bound to another
  instance, answers follower (becoming-leader and duplicate respectively).
- `GARDEN_LEADER_DEFAULT` flips to `follower` (fail closed). The
  no-information case stops meaning "run the singletons" and starts meaning
  "bootstrap has not designated a leader yet"; T1 makes designation a stand-up
  step (auto-run when no record exists), so single-host bring-up stays
  zero-thought (§ 6.3).
- `GARDEN_LEADER` env stays as the operator/test override, now accepting the
  tuple semantics (`GARDEN_LEADER=<name>` implies stable and bound-to-me for
  tests).

Legacy single-line records parse as Stable(name, epoch 0, unbound). Note the
consequence: the moment predicate v2 deploys, an unbound epoch answers
follower, so the sentinel (which performs T5) must deploy in the same stage as
the predicate change or before it. The staged plan (§ 9) orders this.

### 5.6 Wedge detection (liveness watchdog, still no auto-failover)

The sentinel on EVERY host checks the record's age each tick:

- Handoff older than `GARDEN_HANDOFF_WEDGE_SECS` (default 1800): report once
  (deduplicated by signature) to the maintainer inbox, naming the from and to
  hosts and prescribing the deterministic exits: wait, `--abort`, or `--force`.
  The from-host's own sentinel additionally reports its step-down timeout the
  moment it expires (§ 5.4 step 3).
- Stable but unbound older than the same bound: the designated leader's
  sentinel is not running or cannot push; report the same way (this catches
  "re-pointed the marker at a host that is down", today's silent
  singletons-all-stopped state).
- Stable, bound, but heartbeat stale beyond 3 cadences: report leader-liveness
  doubt. Failover remains a human decision with `--force`.

## 6. Why the invariants hold

### 6.1 Safety: at most one leader running at any instant

Assumptions: `origin/journal2` history is linear (push CAS); instance
identities are unique per checkout (122 random bits); each host's cache-age
measurement and its own quiesce run on the same local clock (monotonic
elapsed time only; no cross-host clock comparison anywhere in the design);
systemd reports a unit `activating` from `ExecCondition` onward.

A singleton action runs on a host only inside a window opened by a true leader
verdict: a oneshot tick runs between its `ExecCondition` success and unit
deactivation; a bulletin tick runs between its in-loop gate check and tick end.
A true verdict requires a fresh (age < TTL) view of Stable(leader = my
`GARDEN`, bound = my instance).

*Within one epoch*: the bind is one CAS field; at most one instance is ever
bound to epoch E. Two simultaneous true verdicts in epoch E would require two
hosts each equal to the one bound instance, contradicting uniqueness.

*Across epochs*: suppose instance A holds a true verdict for epoch E and
instance B for epoch F > E, overlapping in time. Stable(F) can exist only by
T4 (release), T7 (force), or T1 (bootstrap, no prior record, vacuous here).
Under T4, the release commit was written by A itself (the epoch-E bound
instance is the Handoff `from`), and A wrote it only AFTER deleting its cache
(no fresh-leader verdict possible thereafter: every fresh read is at or past
the Handoff commit its own confirm-read fetched), AFTER every leader-only unit
on A was inactive (so no action window opened by an earlier verdict was still
running; `activating` visibility closes the condition-passed-but-not-started
race), and AFTER a synchronous bulletin stop (closing the in-process window).
So at the first instant any host can read Stable(F), A has no open action
window and can never open one for epoch E again. Under T7 the proof is
explicitly delegated to the maintainer's dead-host assertion; if the assertion
was wrong, A's overlap is bounded by one TTL (its stale cache may answer
leader for at most TTL, after which fail-closed staleness forces follower),
and A is then deterministically demoted and reported as duplicate. There is no
third path to Stable(F).

Residual, accepted and bounded: the liaison Monitors (one Monitor poll of
overlap, self-gated, non-corrupting actions) and the `--force` misuse window
(one TTL, then detected and reported). Neither can double-post board or
journal singleton work, which is the failure class this design kills.

### 6.2 Liveness: exactly one leader when stable

The record always names exactly one leader. Handoff is transient by
construction: T4 completes it when the from-host is alive (the sentinel is a
deterministic timer unit, not an LLM), and T7/T8 complete it by hand
otherwise, with § 5.6 guaranteeing the maintainer HEARS about a wedge instead
of discovering silence. Stable-unbound converges by T5 within one sentinel
tick of the designated host. The deliberate zero-leader intervals (during
handoff, during a leader-side journal outage) are the safety trade taken
knowingly; both surface in the bulletin and § 5.6 rather than passing silently.

### 6.3 Determinism: a function of journal state

Every host role is the § 5.1 pure function of (record, `GARDEN`, instance).
Every transition is either a maintainer command (T1 initiation at stand-up,
T2, T3, T7, T8) or a sentinel action that is itself a pure function of the
record plus local unit states (T4, T5, T6, the detectors). Restart order
cannot matter: no state lives in process memory; a sentinel that dies mid-T4
re-derives Handoff(from=me) on its next tick and re-runs the quiesce, whose
steps are all idempotent. Manual interleaving cannot matter: the only manual
inputs are CAS record writes, and every racer re-derives after a lost CAS.
Single-host behavior is preserved by T1: bring-up designates the sole host,
after which it binds and leads exactly as today, minus the fail-open hazard.

## 7. How each service participates (nothing implicit)

- **Timer-fired leader-only oneshots** (foreman, scheduler, deadmail, reaper,
  follow-up, proxy, mentor, mirror-closer, orchestrate, issue-inbox,
  library-source-drift-scan, mention-watcher, comment-watcher@, ci-watcher@,
  triager@): mechanism unchanged (`ExecCondition=is-main-host.sh`,
  re-evaluated every firing, promotion and demotion with no restart). They
  inherit the hardened verdict for free. Their re-evaluation cadence is their
  timer interval; the quiesce wait (§ 5.4) is what synchronizes their tail on
  the outgoing leader.
- **`garden-bulletin`** (continuous) and the **watchman broadcast half**:
  in-process `is_main_host` gate unchanged, hardened verdict inherited. Their
  positive quiesce on step-down is the sentinel's synchronous stop/start
  (§ 5.4 step 4). The watchman's fast-forward/maintenance half stays
  every-host, untouched.
- **`garden-leader-sentinel`** (NEW; every host; per-host local-infra; timer
  plus oneshot; no LLM; cadence about 60 seconds): performs T4, T5, T6, both
  duplicate detectors, and the wedge watchdog. It is the only component that
  writes the record besides `set-main-host.sh`, and the only one that touches
  other units (stop/start bulletin during step-down).
- **The gardener pool**: unaffected; runs on every host; CAS claim dedup is
  its own safety. **Leadership handoff no longer drains gardeners.** Draining
  remains the separate `drain-fleet.sh` surface, used when a HOST is being
  retired or quiesced, not when leadership moves.
- **The liaison leader-marker watch** (every host): watches
  `leader-role.sh` output instead of the raw marker. On `becoming-leader` or
  `leader`: stand up the leader Monitors. On `stepping-down`, `duplicate`, or
  `follower`: stand them down. The watch remains what raises a new leader's
  human-facing surface; the singletons no longer depend on it.
- **The liaison maintainer-inbox Monitor**: becomes self-gating; its watch
  command runs the predicate first and prints nothing on a non-leader
  (`maintainer-watch.sh` gains the in-script gate). An orphaned Monitor on a
  demoted host goes silent within one poll, closing the by-documentation hole.
- **The deploy-on-upgrade Monitor**: acts only on its local host, so
  duplicates across hosts cannot conflict; it stays armed per the existing
  liaison guidance and needs no gate. Enumerated here so nothing is implicit.
- **Every-host local-infra** (gardener-scaler, upgrade-monitor, clone-keeper,
  journal-worktree-keeper, repo-watcher, unblock, watchman maintenance half,
  identity-drift-guard): untouched. `identity-drift-guard.sh` remains the
  complementary detector for `GARDEN` versus `hostname -s` drift; the bind
  detector covers the shared-`GARDEN`-name case drift cannot see. The guard's
  leader-impact wording updates to speak the new role vocabulary.
- **`set-main-host.sh`**: grows the T1/T3/T7/T8 verbs and the structured
  record writer; refuses a plain re-point while a handoff is in flight
  (`--abort` or `--force` are the explicit exits).
- **`install-units.sh` / stand-up**: installs the sentinel like any per-host
  unit; stand-up bootstraps the record (T1) when none exists.

## 8. Kill and rollback criteria

Rollback is cheap by construction: line 1 of the record stays a bare acting
leader name, so the legacy predicate reads any v2 record correctly. Each stage
below is independently revertible.

Roll back (revert the predicate stage, disable the sentinel timer, restore
`GARDEN_LEADER_DEFAULT=leader`) if any of these appear and cannot be fixed
forward promptly:

- The sole leader's singletons stop while the record says it should lead
  (foreman or scheduler silent beyond 3 timer intervals with the board
  under-target, or the bulletin idling as follower on the designated leader).
- A handoff wedges with BOTH hosts healthy (step-down timeout without a
  discoverable stuck unit), twice.
- The sentinel crash-loops into systemd's start limit on any host.
- Journal commit noise from heartbeats is objectionable even at the slow
  cadence (mitigate first by raising `GARDEN_LEADER_HEARTBEAT_SECS`).

Kill switches short of rollback: `--force` and `--abort` exit any wedged
handoff; disabling `garden-leader-sentinel.timer` freezes the machine in its
current stable state (no binds, no releases, detection off) while leaving the
predicate and fleet running.

Operational precondition, enforced as a rollout gate rather than code: do not
initiate a v2 handoff (T3) until every host runs the v2 predicate and
sentinel. A legacy outgoing leader would never release (it has no sentinel);
§ 5.6 would report the wedge and `--force` recovers, but the point of the
staging below is never to be there.

## 9. Staged build plan (follow-on jobs, one handler wall each)

Ordered; 1 through 3 are strictly serial, 4 and 5 build on 3, 6 and 7 on 5,
8 is the acceptance gate. Post per the standing decomposition
(`skills/orchestration/SKILL.md`): parked children plus one orchestration job,
serial, halt on child failure.

1. **`leader-instance-identity`**: mint `.garden-instance` (launcher seeding
   at container creation, `instance_identity()` self-minting helper in
   `common.sh`, `.gitignore` entry, launcher usage text). No behavior change.
2. **`leader-record-v2-writer`**: `set-main-host.sh` writes the structured
   record; verbs for bootstrap, initiate-handoff, `--force`, `--abort`;
   line-1 compatibility; parser helpers in `common.sh` (read-side only, the
   predicate still reads line 1 at this stage). No behavior change for
   readers.
3. **`leader-predicate-v2`**: `leader_host`/`is_main_host` parse the record;
   the § 5.5 verdict table; tuple cache; stale-cache fail-closed; default flip
   to follower; T1 bootstrap auto-designation wired into stand-up and
   `install-units.sh` guidance. Ships DARK behind `GARDEN_LEADER_V2=1` so
   stage 4 can land before the verdict change arms (an unbound epoch must not
   strand the leader before the sentinel exists to bind it).
4. **`leader-sentinel-bind-heartbeat-detect`**: the unit and timer; T5 bind;
   T6 heartbeat; both § 5.3 detectors with deduplicated `kind: error`
   reporting; the § 5.6 watchdog. Arm `GARDEN_LEADER_V2` fleet-wide at the end
   of this stage.
5. **`leader-sentinel-stepdown`**: T4; the § 5.4 quiesce (cache delete, unit
   wait, bulletin stop/start, CAS release); step-down timeout reporting.
6. **`leader-monitor-self-gating`**: `leader-role.sh`; the in-script gate in
   `maintainer-watch.sh`; rewrite `roles/liaison/AGENT.md` stand-up,
   stand-down, and handoff vocabulary (role-based watch, handoff without
   gardener drain, `--force`/`--abort` recovery).
7. **`leader-docs-and-runbook`**: CLAUDE.md § Leader and follower hosts and
   bring-up steps; supersession pointers in
   `designs/multibot-leader-follower.md`; a handoff runbook with the rollback
   levers; `identity-drift-guard.sh` wording update.
8. **`leader-handoff-rehearsal`** (acceptance): from two parallel pools
   (distinct checkouts, `GARDEN=<a>`/`GARDEN=<b>`), exercise and record in the
   journal: bootstrap, a clean handoff both directions (asserting zero
   leader-only unit activity on the outgoing host after release, from
   journalctl), a deliberate shared-`GARDEN`-name duplicate (asserting
   exactly one bind winner and one loud report), `--abort`, and `--force`
   with a stopped from-host. Acceptance for the design's Status flip to
   Implemented.
