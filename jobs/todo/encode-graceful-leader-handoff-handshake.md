# Encode the incoming-initiated, confirmed leader-handoff handshake

**Garden's own repo** (`kriskowal/garden`, `main2`): isolated worktree off
`origin/main2`, push directly, no PR (garden-infra convention).

## Why

Maintainer directive (kriskowal, 2026-07-10): assuming leadership should be a
**coordinated, confirmed handshake initiated by the incoming leader** — signal the
current leader, wait for them to indicate their singletons have stopped, arm yours,
then signal that you have assumed leadership. The current standing docs describe
only the **leader-initiated** form (the outgoing leader drains, stands down its
Monitors, then re-points the marker). Document the incoming-initiated handshake so
it is clear going forward.

## The protocol to document (reconciled with the gating mechanics)

Key reconciliation the docs must make explicit: **systemd singletons are
marker-gated** (foreman, scheduler, watchers, bulletin, …) — they flip atomically
the instant the `leader` marker is re-pointed, so neither leader stops them by hand.
The ONLY singletons needing manual stand-down (the real double-act hazard) are the
**two liaison Monitors** (maintainer-inbox + deploy-on-upgrade), which live in a
liaison's Claude session, not systemd. So the confirmed handshake exists chiefly to
sequence those two Monitors and to give a clean, observable cutover.

Document this ordered handshake (incoming = the host taking over; outgoing = current
leader):

1. **Incoming signals** the outgoing leader on the liaison bus
   (`send-msg.sh role/liaison <request>`): "I am assuming leadership; please stand
   down your two liaison Monitors and confirm ready."
2. **Outgoing** optionally drains, **stands down its maintainer-inbox +
   deploy-on-upgrade Monitors**, and **replies on `role/liaison`** with an explicit
   readiness confirmation (e.g. "singletons stopped, ready for handoff"). Its
   systemd singletons need no manual stop — they stop when the marker moves next.
3. **Incoming re-points the marker** to itself
   (`set-main-host.sh <incoming>`) ONLY after the step-2 confirmation — atomically
   stopping the outgoing host's systemd singletons and starting the incoming host's.
4. **Incoming arms** its maintainer-inbox + deploy-on-upgrade Monitors, lifts any
   drain, and drains its liaison bus.
5. **Incoming signals** "leadership assumed" on `role/liaison`.
- **Invariant:** the outgoing Monitors are down (step 2) before the marker moves
  (step 3) before the incoming Monitors come up (step 4) → **never two live
  maintainer-inbox Monitors**. The incoming liaison MUST NOT move the marker before
  the step-2 confirmation.
- **Fallback (no confirmation / dead leader):** if the outgoing leader cannot
  confirm (crashed, unattended), this reduces to the existing manual designation —
  re-point the marker by hand, accepting that the outgoing host's liaison Monitors
  (if its session is somehow still live) must be stood down out-of-band. Keep the
  "manual, no automatic failover" statement.

## Where to write it

- **`context/operations/leader-follower.md`** — the full contract. Add the
  incoming-initiated confirmed handshake alongside (or as the primary form of) the
  existing "clean handoff contract", with the marker-gating reconciliation and the
  invariant above.
- **`roles/liaison/AGENT.md`** § Stand up / stand down — expand the "hand off
  leadership to `<host>`" / "assume leadership" bullet to name the 5-step handshake
  and point to the context page. Add "assume leadership" as recognized vocabulary if
  it is not already.
- Keep both tight and consistent; do not duplicate the full steps in two places —
  the context page holds the contract, the liaison bullet holds the pointer + the
  one-line invariant.

## Skills

- [self-improvement](../../skills/self-improvement/SKILL.md),
  [context-library](../../skills/context-library/SKILL.md),
  [relative-paths](../../skills/relative-paths/SKILL.md),
  [em-dash-style](../../skills/em-dash-style/SKILL.md),
  [no-latin-shorthand](../../skills/no-latin-shorthand/SKILL.md).

## Done

`context/operations/leader-follower.md` and `roles/liaison/AGENT.md` document the
incoming-initiated, confirmed 5-step leader-handoff handshake with the
marker-gating reconciliation, the no-two-Monitors invariant, and the dead-leader
fallback — committed and pushed to `main2`. The `tada` report gives the SHA and the
files touched.
