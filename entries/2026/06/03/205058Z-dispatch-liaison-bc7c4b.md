---
ts: 2026-06-03T20:50:58Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: weaver
dispatch_root: /home/kris/dispatches/weaver--bc7c4b
prs:
  - repo: endojs/endo-but-for-bots
    pr: 388
    role: target
  - repo: endojs/endo-but-for-bots
    pr: 389
    role: target
  - repo: endojs/endo-but-for-bots
    pr: 392
    role: target
  - repo: endojs/endo-but-for-bots
    pr: 393
    role: target
  - repo: endojs/endo-but-for-bots
    pr: 394
    role: target
refs:
  - entries/2026/06/03/204957Z-result-shepherd-9985b3.md
  - entries/2026/06/03/051106Z-result-weaver-59079d.md
---

# dispatch: weaver — gateway-package stack cascade-rebase (phase-2 → phase-6)

Shepherd `9985b3` classified #394's 10 CI failures as stale-
base-induced and surfaced `next: weaver` cascade-rebase. Per
memory `feedback_shepherd_to_fixer_auto_chain.md` extended to
weaver, the steward auto-dispatches.

#343's foundation was already rebased onto `llm-720a396` (head
now `23bc11a9e`); the middle phases each need to rebase onto
their parent's NEW head.

## Cascade order (must be sequential)

| PR | Branch | Current head | Current base | New base |
|---|---|---|---|---|
| #388 | `design/gateway-package-phase-2` | `741890f1d` | `design/gateway-package` | `23bc11a9e` (rebased #343) |
| #389 | `design/gateway-package-phase-3` | `bc807ca78` | `design/gateway-package-phase-2` | new phase-2 head |
| #392 | `design/gateway-package-phase-4` | `ee8297f0c` | `design/gateway-package-phase-3` | new phase-3 head |
| #393 | `design/gateway-package-phase-5` | `04eedbedf` | `design/gateway-package-phase-4` | new phase-4 head |
| #394 | `design/gateway-package-phase-6` | `a57332f69` | `design/gateway-package-phase-5` | new phase-5 head |

Each rebase must complete (push + new head SHA recorded)
BEFORE the next rebase can proceed.

Note: the GitHub PR `base` field already names the parent phase
branch — that's good (the base will auto-shift as you push the
new parent head). You may need to verify; if a PR was
explicitly based on a frozen-base-snapshot, an extra `gh pr
edit --base` may be required.

## Procedure per phase

1. Fetch the parent branch's current head.
2. Check out the child branch.
3. Rebase the child onto the parent's NEW head.
4. Resolve conflicts per `garden/skills/conflict-resolution/
   SKILL.md` (weave intents; no `--ours`/`--theirs`).
5. Force-with-lease push child using its current head as the
   lease anchor.
6. Record new head SHA + commit count replayed + conflict
   notes.
7. Proceed to next phase.

## Per-action authorizations

- Rebase each of phase-2 through phase-6 onto the respective
  new parent head. Authorized.
- Force-with-lease push each branch using its current head as
  the lease anchor. Authorized.
- Resolve conflicts per skill. Authorized.

## Not authorized

- Modifying any branch other than the 5 named.
- Force-pushing without a lease anchor.
- Editing source content beyond rebase replay.
- Un-drafting / re-drafting / merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/weaver--bc7c4b/garden/roles/COMMON.md`
2. `/home/kris/dispatches/weaver--bc7c4b/garden/roles/weaver/AGENT.md`
3. `garden/skills/conflict-resolution/SKILL.md`
4. `garden/skills/frozen-base-branch/SKILL.md` if a PR uses
   a frozen-base-snapshot.

Project worktree at `project/` on
`design/gateway-package-phase-2` (refetch to current
`741890f1d`).

## Report

A `result` journal entry. Include a per-PR table with:
- Pre-rebase head SHA.
- Post-rebase head SHA.
- Number of commits replayed.
- Conflict-resolution summary per phase.
- Force-push exit code per phase.
- Whether `gh pr edit --base` was needed.

If any phase fails (substantial conflict, base diverged
unexpectedly), STOP the cascade at that phase and surface the
problem. The remaining phases can be picked up in a follow-up
dispatch.
