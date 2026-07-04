---
model: fable
priority: high
---
# Designer (Fable): make the leader/follower state machine FULLY DETERMINISTIC

**This is garden self-infrastructure work on the garden's OWN repo.** Land the
design doc directly on `main2` (no PR — the no-self-PR convention, CLAUDE.md
§ Conventions). Follow-on *build* jobs implement the scripts/units it specifies.

## The problem (maintainer, kriskowal)

The leader/follower transition has been too much the subject of **random failures
and non-determinism** (the leader marker has "flapped"; handoffs have raced). Make
it **reliable and fully deterministic going forward**, driven **entirely by
propagation of the leader state in the journal**. Take a **holistic** view of
**all** the services and the patterns they execute during a leader/follower
transition — not a point fix to one script.

## Required invariants

1. **Safety — at most one leader RUNNING at any instant.** During a graceful
   handoff there must be **no overlap window** where two hosts run the singleton
   services (double-posting foreman/scheduler/bulletin/deadmail/reaper/etc. is the
   failure class to kill). Specify the exact ordering that makes overlap
   impossible, not merely unlikely.
2. **Liveness — exactly one leader in the STABLE state.** When the system settles,
   one and only one host is leader; no state where zero or two persist.
3. **Determinism — the whole transition is a function of journal state.** Every
   host's role (follower / becoming-leader / leader-stable / stepping-down) is
   derived from the propagated `leader` marker (and whatever additional journal
   state you introduce), with no dependence on timing races, restart order, or
   manual step interleaving.

## Fault detection for duplicate leaders (explicitly requested)

Add a **split-brain detector**: cross-reference a **fully unique per-instance
identity** so two hosts both believing they are leader is **detected and
surfaced** (and one steps down deterministically), never silent. The maintainer's
suggestion: **have the docker container mint a UUID when it is built**. Evaluate
feasibility and pick a mechanism — e.g. `uuidgen` / `/proc/sys/kernel/random/uuid`
/ a build-time layer / `/etc/machine-id`, baked into the image or written to a
gitignored per-instance file at creation (mirror how `$HOME/.garden` already
captures the `GARDEN` shard identity in the `garden` docker script). The leader
should **heartbeat its unique instance-id into the journal** under the leader
claim; a host that reads the marker naming its `GARDEN` identity but a **different
instance-id** than its own is a duplicate/stale-leader condition — detect, surface
to the maintainer, and resolve deterministically. This closes the current hole
where two instances sharing a `GARDEN` name (or a mis-pointed marker) run
duplicate singletons undetected.

## Ground yourself FIRST (read before designing)

- `designs/multibot-leader-follower.md` — the current design (author: gardener;
  states the manual-designation, no-failover, watch-raises-leader contract).
- `scripts/jobs/is-main-host.sh` + `is_main_host` in `scripts/jobs/common.sh` — the
  predicate (used both as systemd `ExecCondition=` and in-process).
- `scripts/jobs/set-main-host.sh` — the manual CAS write of the `leader` marker.
- `scripts/jobs/drain-fleet.sh` — the drain half of the handoff.
- The **leader-only singleton units** (all carry `ExecCondition=is-main-host`):
  `garden-{foreman,scheduler,deadmail,reaper,follow-up,proxy,mentor,mirror-closer,
  orchestrate,issue-inbox,library-source-drift-scan,mention-watcher}` plus the
  templated `garden-{comment-watcher,ci-watcher,triager}@`. Note the two
  **in-process gated** singletons that do NOT restart on transition:
  `bulletin.sh` (continuous) and the `watchman.sh` broadcast.
- The **liaison Monitors** (the stand-up/stand-down surface): the every-host
  **leader-marker watch** that raises the new leader, the **leader-only
  maintainer-inbox Monitor**, and the **deploy-on-upgrade Monitor**
  (`roles/liaison/AGENT.md` § Stand up / stand down).
- CLAUDE.md § **Leader and follower hosts (multibot)**, § **Bringing up local
  systemd services** (steps 5–8), and the handoff contract there.
- The `garden` docker script (`./garden`) — for the container-UUID-at-build angle
  and how `$HOME/.garden` / `--hostname` / `GARDEN` identity are established today.

## Deliverable

A design doc (amend/supersede `designs/multibot-leader-follower.md`, or a new
`designs/leader-follower-determinism.md` that the old one points to) that:

- Specifies the **complete state machine**: states, the journal state that encodes
  each, and every transition — with the **exact drain → stand-down Monitors →
  re-point marker → raise new leader** ordering proven to leave **no two-leader
  overlap window**. Keep leadership designation **manual** (no automatic failover
  is in scope) but make the **transition itself** deterministic and safe.
- Defines the **journal state shape** the machine propagates (the authoritative
  `leader` marker and any lease/heartbeat/instance-id fields you add), noted as CAS
  writes to `origin/journal2` (the same serialization point everything else uses).
- Specifies the **duplicate-leader detector** and the **unique instance-id**
  mechanism (container-build UUID), including where it is minted, how it rides the
  journal, who checks it, and the deterministic resolution when a duplicate is
  found.
- Enumerates **how each service participates** (ExecCondition re-evaluation cadence
  vs. in-process gating vs. the liaison Monitors) so nothing is left implicit.
- Names **kill/rollback criteria** and a **staged build plan** of follow-on jobs,
  each **sized to fit one handler wall**, so the implementation can be orchestrated
  (`skills/orchestration/SKILL.md`) after the design is accepted.

## Report

Post your completion report with the design doc path + commit sha on `main2`, and
the proposed staged build-plan (so the liaison/steward can orchestrate the
implementation). Style rules apply (no em-dashes, no Latin shorthand).
