# Leader and follower hosts

Operating the garden across **more than one host**: which services run where,
how the leader is named, how a follower stands up, and how leadership hands off
cleanly. The garden is a leader/follower fleet — gardeners run everywhere and
race-claim safely; singleton services run only on the leader. This page is the
operator procedure; the rationale (why a marker and not a lease, the failover
follow-on) is `designs/multibot-leader-follower.md`. If your question is "I'm
adding a second host" or "how do I move leadership," you are here; single-host
bring-up is [starting.md](starting.md).

## The core invariants

- **Gardeners run on EVERY host**, leader and follower alike. Concurrent
  gardeners across hosts are safe: they race-claim jobs via the job board's
  git-push CAS, which dedups the work. More hosts = more concurrency, no
  duplication. A **follower** runs only the gardener pool plus per-host local
  infra.
- **Singleton services run ONLY on the leader.** None handle concurrent
  duplicates — two foremen double-pump, two schedulers double-dispatch, two
  watchers double-post, two liaison maintainer-inbox Monitors double-answer. The
  leader-only set includes `garden-foreman`, `garden-scheduler`,
  `garden-bulletin`, `garden-deadmail`, `garden-reaper`,
  `garden-deadline-nudge`, `garden-follow-up`, `garden-proxy`, `garden-mentor`,
  `garden-mirror-closer`, the
  `garden-{comment,ci}-watcher@*` / `garden-approval-reconciler@*` /
  `garden-triager@*` / `garden-mention-watcher` / `garden-issue-inbox` watchers,
  `garden-orchestrate`, and the **liaison maintainer-inbox and deploy-on-upgrade
  Monitors**.
- **Per-host local infra runs on every host** (not shared work):
  `garden-gardener@*`, `garden-gardener-scaler` (each host scales its own pool),
  `garden-upgrade-monitor`, `garden-clone-keeper`,
  `garden-journal-worktree-keeper`, `garden-repo-watcher`, `garden-unblock`, and
  the fast-forward/maintenance half of `garden-watchman` (its duplicate-prone
  reread broadcast is leader-only, gated in-process).

## The marker and the gate

The leader is named by a single journal file, **`leader`** (at the journal
root), holding the leader's `GARDEN` identity. This is the authoritative marker
(the older `hosts/main-host` path is stale legacy the predicate no longer
reads). The predicate `scripts/jobs/is-main-host.sh` (exit 0 = leader, 1 =
follower) compares `leader` to this host's `GARDEN`.

Each timer-fired singleton carries it as an `ExecCondition=`: on a follower the
timer still fires but the tick is **skipped cleanly** (condition-failed, never
marked Failed), and each firing re-evaluates — so promotion/demotion needs no
restart. The continuous bulletin and the watchman broadcast gate the same
predicate **in-process**.

## Follower stand-up

A follower brings up the **gardener pool and per-host local infra only** — it
**skips** the leader-only singletons and the maintainer-inbox Monitor. Its one
leader-facing duty is the **standing leader-marker watch** (Monitor): when the
marker comes to name this host, the liaison stands itself up as leader (arms the
maintainer-inbox and deploy-on-upgrade Monitors; the leader-only singletons
auto-start as `is-main-host` begins exiting 0; lift any drain if it is to run
gardeners).

## Designating and handing off leadership

Designation is **manual; there is no automatic failover.**
`scripts/jobs/set-main-host.sh [<host>]` CAS-writes the `leader` marker, and
because every liaison watches the marker, **re-pointing it raises the new
leader** (designating *is* raising). If the leader dies, singletons stay down
until the marker is re-pointed by hand.

### What actually needs sequencing (the marker-gating reconciliation)

The systemd singletons (foreman, scheduler, watchers, bulletin, the recovery
services) are **marker-gated**: each carries `is-main-host.sh` as an
`ExecCondition=`, so it flips **atomically the instant the marker moves**. The
outgoing host's singletons stop and the incoming host's start on the next timer
tick with **no manual intervention**. Neither leader stops them by hand, and
trying to would be redundant.

The **only** singletons that need a manual stand-down are the **two liaison
Monitors** (maintainer-inbox + deploy-on-upgrade), because they live inside a
liaison's Claude session rather than in systemd, so no `ExecCondition=` gates
them. Two live maintainer-inbox Monitors would double-answer a maintainer. The
confirmed handshake below therefore exists chiefly to **sequence those two
Monitors** and to give a clean, observable cutover.

### The incoming-initiated, confirmed handshake (primary form)

The preferred handoff is a coordinated handshake **initiated by the incoming
leader** (the host taking over), who signals the outgoing leader, waits for a
readiness confirmation, and only then moves the marker. In order (incoming = the
host assuming leadership; outgoing = the current leader):

1. **Incoming signals** the outgoing leader on the liaison bus
   (`scripts/jobs/send-msg.sh role/liaison <request>`): "I am assuming
   leadership; please stand down your two liaison Monitors and confirm ready."
2. **Outgoing** optionally drains (`scripts/jobs/drain-fleet.sh on`; see
   [scaling.md](scaling.md)), **stands down its maintainer-inbox and
   deploy-on-upgrade Monitors**, and **replies on `role/liaison`** with an
   explicit readiness confirmation (for example "singletons stopped, ready for
   handoff"). Its systemd singletons need no manual stop; they stop when the
   marker moves in the next step.
3. **Incoming re-points the marker** to itself
   (`scripts/jobs/set-main-host.sh <incoming>`) **only after the step-2
   confirmation**, atomically stopping the outgoing host's systemd singletons
   and starting the incoming host's.
4. **Incoming arms** its maintainer-inbox and deploy-on-upgrade Monitors, lifts
   any drain (`drain-fleet.sh off`), and reads its liaison bus to empty.
5. **Incoming signals** "leadership assumed" on `role/liaison`.

**Invariant:** the outgoing Monitors are down (step 2) **before** the marker
moves (step 3), which is **before** the incoming Monitors come up (step 4), so
there are **never two live maintainer-inbox Monitors**. The incoming liaison
**must not** move the marker before the step-2 confirmation.

### Fallback: no confirmation, or a dead leader

If the outgoing leader cannot confirm (crashed, or running unattended), the
handshake reduces to the existing **manual designation**: re-point the marker by
hand with `scripts/jobs/set-main-host.sh <new>`, accepting that if the outgoing
host's liaison session is somehow still live, its two Monitors must be stood down
out-of-band. This is the **manual, no-automatic-failover** path: designation
still *is* raising, and singletons stay down until the marker is re-pointed.

The liaison's stand-up / stand-down vocabulary (`roles/liaison/AGENT.md` §
Stand up / stand down) drives this surface. Lease-based election and automatic
failover are a documented follow-on in `designs/multibot-leader-follower.md` §
Designating the leader; the watch-raises-leader contract is what is live now.
With a single host named in the marker, behavior is unchanged.
