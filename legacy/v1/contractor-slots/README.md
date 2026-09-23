# Contractor slot index

The contractor-slot directory carries the [general-contractor](../../roles/general-contractor/AGENT.md) role's per-host slot files. Each host has at most three slots; each slot file is the authoritative state for one PR pipeline the contractor is currently driving.

The shape mirrors `journal/presence/` and `journal/inboxes/`: one directory per host, one file per slot, plus a `history/` archive for completed slot lifecycles.

## Path

```
contractor-slots/<host>/slot-<N>.md           # N is 1, 2, or 3
contractor-slots/<host>/history/<YYYY-MM-DD>-slot<N>-pr<num>.md
contractor-slots/<host>/history/<YYYY-MM-DD>-slot<N>-stalled.md
```

`<host>` is `hostname -s`, matching the convention used by `worktrees/<host>/`, `inboxes/<host>/`, and `presence/<host>/`.

## Frontmatter schema

```yaml
---
slot: <N>                              # 1, 2, or 3
status: empty | in-flight | stalled    # the slot's current lifecycle state
design_path: <path>                    # design document on the roadmap branch, or null when empty
pr_number: <int>                       # the slot's PR on the active repo, or null
current_stage: <stage>                 # builder | assayer | cleaner | judge | fixer | weaver | shepherd | awaiting-dispatch-return | un-drafted, or null
in_flight_dispatch: <short-id>         # the open dispatch's short-id, or null
last_update: <ISO>                     # UTC, bumped each cycle that touches this slot
started_at: <ISO>                      # UTC, set when the slot moves out of `empty`
host: <hostname>                       # the host whose contractor owns this slot
stack:                                 # populated only when the PR is a stacked build
  base: <branch>
  prs:
    - { number: <int>, head_sha: <sha> }
walked_chain:                          # the design-dependency-walk's chain, for audit
  - <design-path>
---

<body: prose summarizing the slot's design, dependency state, and any
notes the next cycle should pick up>
```

The body is free-form prose. The frontmatter is the machine contract.

## Lifecycle

- **empty**: the slot has no design assigned. The next contractor cycle's refill step picks one (preferring to adopt a stuck PR, otherwise picking from the roadmap branch via the design-dependency-walk).
- **in-flight**: the slot owns a PR that has not yet been un-drafted. The next contractor cycle's advance step dispatches the next-stage-owed per `skills/pr-creation-flow/SKILL.md` § The next-stage-owed heuristic.
- **stalled**: the slot was in-flight but the contractor's stall-detection threshold elapsed (60 minutes without a dispatch result, then 120 minutes for the hard clear). The contractor writes a `message` to `liaison` describing the stall, archives the slot file to `history/`, and resets the live slot to `status: empty`.

Termination of a successful slot:

1. The judge runs `gh pr ready <N>` and un-drafts the slot's PR.
2. The contractor reads the un-drafted state on its next cycle.
3. The contractor copies the slot file to `history/<YYYY-MM-DD>-slot<N>-pr<num>.md` with `status: un-drafted` and the terminal stage recorded.
4. The contractor resets the live slot file to `status: empty`, `design_path: null`, `pr_number: null`, `current_stage: null`, `in_flight_dispatch: null`.

The history archive is append-only; entries there are not edited after they are written. A maintainer auditing past contractor work walks `history/` to see which designs the contractor shipped over its adoption window.

## Concurrency and producers

- The contractor on `<host>` is the only producer of `contractor-slots/<host>/slot-<N>.md` files. A second contractor session on the same host refuses adoption (per `roles/general-contractor/AGENT.md` § Slot model).
- The `history/` archive is also produced by the contractor; no other role writes there.
- Other roles do not consume the slot files as of this README's authoring date. The contractor's `in_flight_dispatch` field is the only cross-role-visible signal; a future steward extension that wanted to avoid dispatching against a contractor-owned PR could read it (the rule would live in `roles/steward/AGENT.md` § Subordinate roles dispatched, not here).

## Per-host tenants

- **endolinbot**: typical contractor host as of 2026-05-15. Slot files appear here when a liaison session on `endolinbot` adopts contractor posture.
- **kmkmbp2021**: the maintainer's host. A contractor session on the maintainer's host runs alongside any boatman dispatches the host may originate; the two are independent.

New hosts join the index automatically; the contractor creates the host directory on its first cycle if absent.
