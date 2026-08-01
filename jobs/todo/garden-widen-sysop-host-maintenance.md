---
role: gardener
handler-timeout: 7200
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Repository: https://github.com/kriscendobot/garden. Land on main2 (no PR — CLAUDE.md
§ Conventions). Design first, then implement, in this one job.

# Widen the sysop to a host-directed MAINTENANCE op class

## Motivation — two live cases, one missing capability

The sysop (`scripts/jobs/sysop.sh`, `designs/sysop.md`) is the fleet's only host-addressed
channel (`host/<GARDEN>` bus kind) and exists for the unattended-follower case. Its
vocabulary is closed: `set-workers`, `drain`, `reset-failed`, `restore`, `unit`, `deploy`.
Two real needs fall outside it, both requiring a human to physically sit at a host:

1. **Root-repo object-store repair (the trigger case, 2026-08-01).** Host
   `endolin-garden-ece02cb4` (`/home/kris/garden`) reports its object store
   UNMAINTAINABLE: `git gc` fails with `fatal: gc is already running on machine
   'endolin-garden-ece02cb4' pid 3728245 (use --force if not)`. State: **51 packs**
   (past the guard's ceiling of 50), 8 loose, 0 stale gc.log, and — importantly —
   **0 missing objects**, so this is a stale `gc.pid` lock, NOT corruption. While gc
   cannot run, git's automatic cleanup stays disabled, packs grow unbounded, and every
   git call in that repo pays for it — including every journal sync, since `journal/` is
   a worktree of it. That host runs the fleet's workers.

   `garden-root-repo-guard` already detects this and deliberately refuses to repair it:
   it will not act destructively unattended. That refusal is correct and must be
   preserved — the point of this work is to give the MAINTAINER a way to authorize the
   escalation for a named host, not to make the guard bolder.

2. **Local-model provisioning.** Already scoped by the parked orchestration
   `sysop-local-model-provisioning` (children `design-sysop-local-model-op`,
   `build-sysop-local-model-op`), motivated by needing `qwen3.6` (~22 GB) present on
   both endolin hosts.

## Reconcile, do not duplicate

Read the parked `design-sysop-local-model-op` body first. Produce **ONE** coherent
widening covering both cases rather than a second competing design. If a single
`maintain`-style op class subsumes model provisioning, say so and state plainly what
should happen to the parked orchestration (retire it, or keep the build child pointed at
your design). Do not leave two overlapping designs on the board.

## Design questions to settle

- **Delegation, not reimplementation.** Every existing sysop op delegates to the
  hardened same-host tool. A repo-maintenance op should invoke `root-repo-guard`'s
  existing repair path with an authorized-escalation flag — not grow its own gc logic.
  Decide the flag's shape and where the escalation is checked.
- **Destructive or not?** `gc --force` overrides a lock that MIGHT belong to a live gc.
  Decide whether this joins `unit`/`deploy` in requiring maintainer attestation
  (`authorized_by:` on `maintainers/allowlist`) on top of the issuer gate
  (`config/sysop-issuers`). Argue from consequence. Note the distinction the trigger case
  makes clear: a stale lock with 0 missing objects is a very different risk from a store
  with genuinely unreachable history, where the guard's back-up-refs-first recipe applies
  and no automation should decide to drop history.
- **Liveness check before force.** Confirming the recorded pid is actually dead is the
  difference between a safe unlock and clobbering a running gc. Decide whether the op
  does this itself and what it does when the pid IS alive.
- **Async/bounded.** gc on a 51-pack repo is slow. The sysop's ops are otherwise fast and
  idempotent within a tick; reuse whatever start/poll shape the model-provisioning design
  settles on rather than inventing a second one.
- **Scope boundary.** Name explicitly which repo-maintenance actions are IN (e.g. unlock
  + bounded gc) and which stay permanently OUT (anything that drops refs or history).

## Constraints (non-negotiable)

Preserve every sysop property: deterministic, **no `claude`**, claims no jobs, runs on
EVERY host, NOT leader-gated, still ticks under drain, host-scoped by construction (reads
only `msgs/host/<its-own-GARDEN>`, mutates only its own host), idempotent, recorded to
`sysop-log/<GARDEN>/<msgid>.md`, and acked. Ferry and any identity switch remain
permanently out of the vocabulary — this must not widen that surface.

## Verify

Hermetic tests for the new op: the already-healthy no-op path, the pid-still-alive
refusal, the trust-gate refusal, and the bounded-timeout path. Shell syntax on every
edited script. Do NOT run a real `gc --force` against `$GARDEN_ROOT` from a test.

## Report

Name the landed main2 revision, the exact `send-host-op.sh` invocation an operator would
run to repair `endolin-garden-ece02cb4`, and what still needs a human. State what you did
about the overlapping parked orchestration.

<!-- garden-reaped: 0 -->
