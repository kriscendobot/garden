---
role: designer
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-28T01:19:23Z -->

role: designer
# Design the sysop: a per-host daemon that receives and executes host-local
# system operations off the bus

Maintainer directive (kriskowal, 2026-07-28): *"Having a systemd unit on each host
that is solely responsible for receiving and handling system operations would be
handy, if we don't have one. We can call it the sysop, operator, or something
similar."*

Land a design doc at `designs/sysop.md` in the garden repo (`main2`, DIRECT push,
NO PR per CLAUDE.md § Conventions). **Design only — no implementation.** The build
is a separate orchestrated child that follows this one.

## The gap this closes (verified 2026-07-28, do not re-litigate)

A host-directed operation today has NO deterministic delivery path:

- **The bus cannot address a host.** `scripts/jobs/send-msg.sh` accepts exactly
  `role/<name>`, `job/<base>`, `broadcast` and hard-fails anything else
  (`die "illegal address '$addr'"`). There is no `host/<GARDEN>` address.
- **No role owns host operations.** `proxy` answers gating questions; `watchman`
  broadcasts library changes; `foreman` pumps an idle board; `orchestrator`
  sequences jobs. None execute host-local operations.
- **The job board cannot pin a job to a host.** No `only_host`/affinity field, so a
  job that must run on host X cannot be guaranteed to land there.
- **So the only route is an ATTENDED liaison.** Live case: ps23 declared
  `gardeners: 8` and held 43 of 45 in-flight claims; the maintainer asked to throttle
  it to 2. `set-workers.sh` correctly refuses cross-host writes
  (*"a host may set only its own worker counts"*), so the liaison could only send a
  `role/liaison` message and hope someone was sitting at ps23. On an unattended host
  the directive simply waits.

## The invariant to PRESERVE, not bypass

`set-workers.sh`'s cross-host refusal is CORRECT and must stay. The sysop does not
circumvent it — the sysop **runs on the target host**, so `hosts/<GARDEN>` is written
by its own host and the invariant holds by construction. Any design that has one host
write another's state is wrong. Say this explicitly in the doc.

## Required design decisions

1. **Name.** `sysop` is the recommendation — `operator` reads as a near-synonym of
   the existing `orchestrator` and will be confused with it in conversation and in
   `roles/`. Pick one, justify it in a sentence, use it consistently.
2. **Addressing.** Specify the `host/<GARDEN>` bus address: the send path, the read
   path, and the path-segment validation (the existing code deliberately allows
   exactly one segment after the kind so a relpath cannot escape `msgs/` — preserve
   that property). Note that `<GARDEN>` identities contain `-` and `.` and must stay
   filesystem- and git-ref-safe.
3. **Operation vocabulary — a CLOSED SET, never arbitrary shell.** This is the
   security crux. Enumerate the ops with exact argument grammar and bounds, e.g.
   set worker counts (per kind, with the existing floor-of-1 and the
   refuse-scale-to-0 rule), drain on/off, restore, reset-failed, deploy,
   start/stop a named garden unit. For each, say what it may NOT do.
4. **Refusals — state them as hard invariants.** The sysop must never: execute
   arbitrary commands or a shell string from a message; run `claude -p` or any LLM
   on message content; touch credentials; perform a ferry or any identity switch
   (`identity_switch_authorized` is maintainer-only and must remain un-originable by
   an agent); or run git inside `$GARDEN_ROOT`. Parsing is DETERMINISTIC, in plain
   code, before anything executes — the same no-LLM-before-the-gate shape the
   mention-watcher and issue-inbox gates use.
5. **Trust model.** The bus is `journal2`, so the practical boundary is "anyone who
   can push to the journal" — i.e. the whole fleet, including a confused or
   compromised agent. Decide what that means: which senders may issue ops (maintainer
   allowlist? any garden instance? a dedicated key?), whether destructive ops
   (deploy, stop-unit) need a stricter gate than benign ones (set-workers), and how a
   replayed or duplicated message is made idempotent. Justify the choice against the
   blast radius, and compare with `designs/issue-inbox.md` and
   `designs/auto-provision-fork-watchers.md`, whose sender-gate shape is the
   precedent to follow or consciously depart from.
6. **Unit shape.** Runs on EVERY host, leader and follower — an unattended follower
   is the entire motivation, so it must NOT be gated by `is-main-host.sh`. Timer
   cadence vs. long-poll; interaction with `drain-fleet.sh` (a drained host must
   still accept `drain off`, or the fleet can be wedged undrainable — call this out);
   behavior during a deploy.
7. **Observability + ack.** Every accepted op, every refusal, and every parse failure
   is logged. Decide the ack: a reply on the bus, a journal record, or both, so a
   sender can tell "done" from "never arrived" — the failure mode that motivated
   this whole request.

## Definition of done

`designs/sysop.md` committed and pushed to `main2`, covering all seven decisions
above with the gap analysis and the preserved invariant stated. Explicitly list what
is OUT of scope for the first build. Do not write implementation code, unit files, or
role/skill files — the follow-on build job does that from this doc.

<!-- garden-reaped: 0 -->
