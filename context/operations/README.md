# operations/ — day-2 procedure, picked by symptom or intent

Command-level operator procedure for a **running** instance: everything the
liaison executes on demand after the first run. Pick a child by what you are
trying to do or what is wrong. This tree holds the *how-to*; the *why* is
`designs/`, and each page routes there for rationale rather than repeating it,
and to the owning skill where a skill already encodes the procedure (restore,
schedule). The conversational first-run tour is the sibling tree,
`../first-run/README.md`; the command-level substance behind its
"start the garden" stage lives here in [starting.md](starting.md).

## Pick by intent

- **[starting.md](starting.md)** — *"start the garden" / bring up a fresh
  instance.* Linger, install and enable units, size the pool, designate the
  leader on a first host, the liaison's three Monitors and their singleton
  rules, and the optional armings (issue inbox, bulletin PAT). This is the
  agent-facing detail the liaison runs for tutorial stage 4 and any later
  re-start — not a human checklist.

- **[leader-follower.md](leader-follower.md)** — *"add a second host" /
  "hand off leadership" / "which services run where."* Leader-marker semantics,
  what runs on followers vs. the leader, follower stand-up, and the
  drain→stand-down→re-point handoff. No automatic failover. Routes to
  `designs/multibot-leader-follower.md` for rationale.

- **[scaling.md](scaling.md)** — *"scale up/down" / "pause the fleet."* Sizing
  the pool, `set-gardeners` per host, and `drain on/off` — when to prefer which.

- **[deploy.md](deploy.md)** — *"an upgrade is ready" / "what is the root
  checkout."* The deliberate deploy: the upgrade-ready signal, `deploy-garden.sh`,
  and why the root checkout is a deployed version, not a dev tree.

- **[schedules.md](schedules.md)** — *"run something weekly / once at a time."*
  Recurring and one-shot schedules. Routes to `skills/schedule/SKILL.md`.

- **[health.md](health.md)** — *"a unit failed" / "recover after an outage" /
  "what are the reaper, deadmail, poison."* Failed-unit checks, the restore
  engagement (routes to `skills/restore/SKILL.md`), and the self-healing
  services in one paragraph each.

## Convention

Within-tree cross-references are relative; cross-tree references (skills,
designs, roles) are repo-root paths. A new operational topic lands as a new leaf
with a row above; split this directory only when this README stops routing
cleanly.
