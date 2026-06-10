---
ts: 2026-06-10T22:25:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: weaver
dispatch_root: /home/kris/dispatches/weaver--d3a4e9
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4675167395
---

# dispatch: weaver — rebase PR #5 (agoric-sdk mirror) on upstream master per kriskowal directive

Maintainer directive on PR #5 (kriskowal at 2026-06-10T22:17:29Z,
issue comment `4675167395`):

> Please rebase on upstream master and resolve conflicts.

The 👀 reactji is on the directive comment
(`reactions/368409836`).

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#5`
  ("chore(deps): mirror Agoric/agoric-sdk#12527 (Endo sync) on
  current master"), DRAFT, base `master-daf7a86`, head
  `mirror/12527-endo-sync-refresh` at
  `b69f426410f1849fa41e03f8fec7ba48449c10b9` (`b69f426410`).
- **Upstream Agoric/agoric-sdk master**: at
  `57c65644e1863ee11eb668b24da90af8da28b67b` (`57c65644e1`),
  **71 commits ahead** of the current frozen base.
- **Current PR head commit ladder** (builder + fixer1 + fixer2 +
  shepherd):
  - 9 cherry-picked commits from upstream PR #12527 (builder
    1f1de6's mirror of the Endo sync)
  - 1 `chore: Update yarn.lock` (fixer c39b42's YN0028 fix)
  - 3 commits (fixer d6af77's ava-version restore +
    yarn.lock + a3p resolutions: `cf798d660e`, `c81cab79cf`,
    `b69f426410`)
- **CI on `b69f426410`**: was 68/1 (the 1 being MAINTAINERS-
  documented `test-dapp (node-new)`).

## Task

Per `garden/skills/frozen-base-branch/SKILL.md` § Rebase: move
both base and head.

In your `project/` worktree at `b69f426410`:

1. **Fetch upstream**: ensure the bot worktree has fresh
   `origin/master` (Agoric/agoric-sdk) and `bot/...` refs
   (kriscendobot/agoric-sdk).
2. **Push the new frozen base** to the bot fork:
   - `git push bot 57c65644e1863ee11eb668b24da90af8da28b67b:refs/heads/master-57c65644`
   - This creates the new frozen-base branch on the bot fork.
3. **Rebase the PR head onto the new base**:
   `git rebase --onto master-57c65644 master-daf7a86 mirror/12527-endo-sync-refresh`
   - Resolve conflicts per
     `garden/skills/conflict-resolution/SKILL.md`. Likely
     conflict surfaces:
     - **yarn.lock files** — almost certainly conflicting.
       Reconcile by re-running the lockfile fix the fixer
       c39b42 + d6af77 did: minimal `yarn install` + commit
       the reconciled lockfile. The lockfile commits in the
       current series serve as the recipe.
     - **`package.json` workspaces** — if upstream master
       bumped ava or Endo dependencies, the fixer d6af77's
       `chore(deps): restore ava ^7.0.0 across workspaces`
       commit may be a no-op (upstream caught up) or partially
       redundant. Resolve by accepting upstream's version
       (newer) AND keeping the cherry-picked Endo changes.
     - **xsnap METER_TYPE** — if upstream bumped, take upstream.
     - **SwingSet snapshots** — regenerate as needed.
     - **Patches** — verify each patch still applies; rebase
       any that conflict with upstream changes.
   - For each non-trivial conflict, prefer to **understand and
     merge intents** rather than blind `--ours`/`--theirs`.
4. **Verify post-rebase**: `corepack yarn install --immutable`
   must pass locally (mimics the CI YN0028 gate). Then
   `corepack yarn build` for a smoke check.
5. **Force-with-lease push** to `mirror/12527-endo-sync-refresh`
   with lease anchor `b69f426410f1849fa41e03f8fec7ba48449c10b9`
   (full 40-char SHA).
6. **Retarget the PR base**:
   `gh pr edit 5 --repo kriscendobot/agoric-sdk --base master-57c65644`.
7. **Reply on the directive comment** (`4675167395`) with the
   rebase outcome: pre/post head SHAs, base bump, key
   conflict-resolution notes, post-rebase first-look CI status.

## Authorizations (per-action, forwarded by liaison)

- **Push the new `master-57c65644` branch** to the bot fork
  (creates the frozen-base snapshot).
- **Force-with-lease push** to `mirror/12527-endo-sync-refresh`
  with lease anchor `b69f426410f1849fa41e03f8fec7ba48449c10b9`.
- **Retarget PR base** via `gh pr edit --base master-57c65644`.
- **Reply on the directive comment** on PR #5. Standing
  maintainer-facing authority through this liaison's dispatch.
- Do NOT re-request review (PR is DRAFT).
- Do NOT mark the PR ready.
- Do NOT push to upstream Agoric/agoric-sdk.

## Out of scope

- Do NOT amend or change PR substance beyond what's needed to
  resolve rebase conflicts.
- Do NOT drive CI to green after the push; if CI fails on the
  rebased tips, that's a follow-on shepherd's concern. Name it
  in your result.
- Do NOT touch the patch set unless rebase conflicts force it.
- Do NOT retcon the commit ladder; the maintainer asked for a
  rebase, not a re-organization.

## Deliverable

A `result` entry under `journal/entries/2026/06/10/` naming:

- Pre/post head SHAs.
- Base bump: `master-daf7a86` → `master-57c65644` (with full
  upstream SHA `57c65644e1`).
- Per-conflict resolution notes (one line per substantive
  conflict; "none" or "trivial lockfile auto-merge" if clean).
- Post-rebase local `yarn install --immutable` + `yarn build`
  result.
- The `gh pr edit --base` outcome.
- The reply URL on the directive comment.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: shepherd` if CI needs
  watching after the push; `next: none` if CI is already in
  shape.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
