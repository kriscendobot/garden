---
ts: 2026-06-03T05:02:35Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: weaver
dispatch_root: /home/kris/dispatches/weaver--59079d
prs:
  - repo: endojs/endo-but-for-bots
    pr: 343
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/343
  - https://github.com/endojs/endo-but-for-bots/pull/343#issuecomment-4609224477
  - entries/2026/06/03/050035Z-result-shepherd-797060.md
---

# dispatch: weaver — #343 rebase onto fresh llm-720a396 (per shepherd escalation)

Shepherd `797060` classified all 10 #343 CI failures as
stale-base-induced and surfaced verdict `next: weaver` (rebase
#343 onto a refreshed frozen-base snapshot of current
`origin/llm` head `720a39600`).

Per memory `feedback_shepherd_to_fixer_auto_chain.md` (extended
to shepherd→weaver), the steward auto-dispatches.

Maintainer's prior in-session authorization ("weave actual/master
into bots/llm and rebase the affected PRs") covers this rebase
explicitly. #343 IS one of the affected PRs.

## Diagnosis (per shepherd, confirmed)

- PR #343 base: `llm-b1c3f4d` (frozen, predates the bots/llm sync).
- Current `origin/llm`: `720a39600` (synced by weaver `496105`
  earlier this session; carries the upstream #3294 merge plus
  the `makeClient` → `makeOcapn` rename in
  `packages/ocapn/test/netlayer-tcp-syrup.test.js`).
- Both fixes (`2ecf40ed8` for makeClient, `04083b872`/`ba26f4cdb`
  for test-xs engines) are present on `720a39600` but absent on
  `b1c3f4d`.
- PR #343's own diff does NOT touch `packages/ocapn/` or
  `packages/benchmark/` — the failures are purely from base
  staleness.

## Procedure

1. **Create the new frozen-base snapshot**: push the current
   `origin/llm` head (`720a39600`) as a new branch
   `llm-720a396` on origin. Per
   `garden/skills/frozen-base-branch/SKILL.md`:
   ```
   git push origin 720a39600:refs/heads/llm-720a396
   ```
   (If it already exists, no-op.)

2. **Rebase #343**: from the worktree on
   `design/gateway-package` (head `89d68e71e`), rebase onto
   `origin/llm-720a396` (which is `720a39600`).

3. **Resolve conflicts** per `garden/skills/conflict-resolution/
   SKILL.md` if any. Expectation per shepherd: clean replay
   (PR #343's diff is design-doc oriented, doesn't touch
   ocapn/benchmark).

4. **Update #343's base on GitHub** from `llm-b1c3f4d` to
   `llm-720a396` (via `gh pr edit 343 --base llm-720a396`).
   The base change tells GitHub the PR is now stacked on the
   fresh frozen base.

5. **Force-with-lease push** the rebased branch using
   `89d68e71e` as the lease anchor.

## Per-action authorizations

- Push `720a39600` as new branch `llm-720a396` on
  endojs/endo-but-for-bots. Authorized.
- Rebase `design/gateway-package` onto `origin/llm-720a396`.
  Authorized.
- Force-with-lease push `design/gateway-package` using
  `89d68e71e` as anchor. Authorized.
- `gh pr edit 343 --base llm-720a396`. Authorized.

## Not authorized

- Modifying any other PR's branch (each affected PR is its own
  weaver dispatch).
- Modifying #343's source content beyond the rebase replay.
- Force-pushing without `--force-with-lease` anchor.
- Un-drafting / re-drafting / merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/weaver--59079d/garden/roles/COMMON.md`
2. `/home/kris/dispatches/weaver--59079d/garden/roles/weaver/AGENT.md`
3. `garden/skills/frozen-base-branch/SKILL.md`
4. `garden/skills/conflict-resolution/SKILL.md`
5. Other skills referenced just-in-time.

Project worktree at `project/` on `design/gateway-package`
(refetch — head should be `89d68e71e`).

## Report

A `result` journal entry. Include:

- Pre-rebase head SHA (the lease anchor).
- Post-rebase head SHA.
- Number of commits replayed.
- Conflict-resolution summary (expected: none).
- Force-push exit code.
- `gh pr edit --base` exit code.
- Note that the gateway-package stack (phases 2-10) will need
  cascade-rebases as a follow-up.
