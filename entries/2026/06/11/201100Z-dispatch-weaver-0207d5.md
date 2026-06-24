---
ts: 2026-06-11T20:11:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: weaver
dispatch_root: /home/kris/dispatches/weaver--0207d5
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4684506028
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/10/181800Z-result-fixer-d6af77.md
---

# dispatch: weaver — rebase + drop ava ^7.0.0 commit on PR #5 per kriskowal directive

Maintainer directive on PR #5 (kriskowal at 2026-06-11T20:07:08Z,
issue comment `4684506028`):

> > Recommend a fixer revert the ava ^7.0.0 commit on this mirror,
> > then re-ferry to #12527.
> 
> @kriscendobot Let's try that. Please rebase on master and remove
> the ava ^7 commit.

The 👀 reactji is on the directive comment
(`reactions/368907907`).

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#5`, DRAFT, base `master-57c6564`,
  head `mirror/12527-endo-sync-refresh` at `02782246bb` (after
  prior weaver d3a4e9's rebase). 68 SUCCESS, 12 SKIPPED, 1 FAILURE
  (test-dapp node-new env-acknowledge).
- **Upstream Agoric/agoric-sdk master**: still at `57c65644e1`
  (0 commits ahead of current PR base). The "rebase on master"
  framing is a no-op for base movement; the substantive action is
  the commit drop.
- **Commit to drop**: `cf798d660e`
  (`chore(deps): restore ava ^7.0.0 across workspaces`) — added
  by fixer `d6af77` on 2026-06-10 to restore ava ^7.0.0 across
  29 package.json files (the cherry-pick from #12527 had
  inadvertently downgraded ava to ^6.4.1).
- **Other fixer commits to preserve**:
  - `c81cab79cf` (`chore: Update yarn.lock` — the canonical
    lockfile reconciliation).
  - `b69f426410` (`chore(a3p-integration): refresh yarn.lock
    and pin @endo/promise-kit / ses`).
  - Plus the weaver d3a4e9's conflict resolutions (PSM
    cross-cut) and the original 9 cherry-picked Endo-sync
    commits.

## Task

The drop is mid-history, so `git rebase --interactive` (skipping
the drop commit) OR `git rebase --onto` with selective range is
the right shape. The yarn.lock commits after the drop may need
regeneration since they were authored against the now-removed
ava state.

Per `garden/skills/frozen-base-branch/SKILL.md` (rebase
discipline) and `garden/skills/conflict-resolution/SKILL.md` as
needed.

In your `project/` worktree on `mirror/12527-endo-sync-refresh`
at `02782246bb`:

1. **Identify the commit ladder** since the frozen base
   `master-57c6564`:
   `git log master-57c6564..HEAD --oneline`. Confirm
   `cf798d660e` is in the list and identify its position.
2. **Rebase interactively** dropping `cf798d660e`:
   `git rebase --interactive 57c65644e1^` (or the PR's merge
   base with master). In the rebase editor, change `cf798d660e`'s
   line from `pick` to `drop`. Keep all other commits as
   `pick`.
3. **Resolve any conflicts** that arise from the drop. The
   most likely conflict shapes:
   - **yarn.lock**: the subsequent `c81cab79cf` and
     `b69f426410` commits modified the lockfile assuming ava
     ^7.0.0 was restored. Without that restore, the lockfile
     state diverges. Resolution: regenerate yarn.lock by
     running `corepack yarn install --immutable` after the
     drop; if `--immutable` fails (because the lockfile now
     diverges from package.json), run `corepack yarn install`
     to regenerate the lockfile, then squash that
     regeneration into the existing yarn.lock commit (use
     `git rebase --continue` after `git commit --amend`).
   - **package.json files**: the 29 files the dropped commit
     restored to ava ^7.0.0 will revert to ava ^6.4.1 (the
     pre-d6af77 state from the original cherry-picks). Verify
     no other commit re-references the ^7.0.0 state.
4. **Verify post-rebase** locally:
   - `corepack yarn install --immutable` must pass.
   - `corepack yarn build` for smoke.
   - The dropped commit must NOT appear in the new commit
     ladder.
5. **Force-with-lease push** to
   `mirror/12527-endo-sync-refresh` with lease anchor
   `02782246bb5abb4af012fae35b3072b9d82b7998` (full 40-char
   SHA).
6. **Post a reply** on kriskowal's directive comment
   (`4684506028`):
   - Pre/post head SHAs.
   - Confirmation `cf798d660e` is dropped.
   - Notes on any conflict resolutions (especially yarn.lock
     state changes).
   - First-look CI state after the rebase push.
   - Note: re-ferry to upstream #12527 is a separate boatman
     dispatch from the credentialed host (endolinbot can't
     ferry).

## Authorizations (per-action, forwarded by liaison)

- **Force-with-lease push** with lease anchor
  `02782246bb5abb4af012fae35b3072b9d82b7998`.
- **Push to bot remote** (`git push bot
  HEAD:mirror/12527-endo-sync-refresh --force-with-lease`).
- **Reply on the directive comment**. Standing maintainer-
  facing authority through this liaison dispatch.
- Do NOT re-request review (PR is DRAFT).
- Do NOT mark ready.
- Do NOT attempt the upstream re-ferry from this host
  (endolinbot can't ferry to Agoric/agoric-sdk).

## Out of scope

- Do NOT add new substance.
- Do NOT rebase onto a moving target if upstream master has
  moved during the dispatch (lock to `57c65644e1` as the
  rebase base — the current frozen-base snapshot).
- Do NOT amend the original cherry-picked Endo-sync commits.
- Do NOT touch the patch set unless rebase conflicts force it.
- Do NOT post a CI convergence summary; that's a follow-on
  shepherd's concern if CI needs work.

## Deliverable

A `result` entry under `journal/entries/2026/06/11/` naming:

- Pre/post head SHAs.
- Per-commit ladder before vs after (showing the drop).
- yarn.lock state changes (and how they were resolved).
- Post-rebase local `yarn install --immutable` + `yarn build`
  result.
- First-look CI state.
- The reply URL on the directive comment.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: shepherd` if CI needs
  watching; `next: none` if CI shape is documented; note
  that upstream re-ferry is a separate engagement (boatman
  from credentialed host).

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
