---
ts: 2026-06-04T00:02:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: weaver
dispatch_root: /home/kris/dispatches/weaver--55a546
prs:
  - repo: endojs/endo-but-for-bots
    pr: 411
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/411
  - https://github.com/endojs/endo-but-for-bots/pull/411#issuecomment-4617623942
  - https://github.com/endojs/endo/pull/3297
---

# dispatch: weaver — #411 sync bot-master to upstream + rebase (zizmor fix merged upstream as #3297)

Maintainer directive (kriskowal, #411 comment `4617623942`,
2026-06-03T23:42:07Z):

> Please rebase on master. The zizmor CI has been addressed.

Per memory `feedback_rebase_on_master_implies_sync.md`,
"rebase on master" = compound: sync bot-master to upstream
first, THEN rebase the PR.

## State

- **Upstream master** (`endojs/endo:master`): `07aff334e`
  — `chore(ci): fix zizmor warning (#3297)` (the zizmor fix
  the maintainer mentions).
- **Bot-master** (`endojs/endo-but-for-bots:master`):
  `ba26f4cdb` — stale, predates the upstream fix.
- **#411 head**: `58c53d5a0` on
  `ci/cache-playwright-browsers`.
- **#411 base**: `master-ba26f4c` (frozen base).
- **My #421 zizmor fix DRAFT**: CLOSED unmerged (the
  maintainer landed #3297 upstream instead, which is fine —
  upstream-side fix is cleaner).

## Procedure

### Step 1: Sync bot-master

Per memory `feedback_bot_master_reset_to_actual.md`:
force-with-lease push upstream/master to bot-master.

```
git -C project remote add upstream git@github.com:endojs/endo.git  # if not present
git -C project fetch upstream master
git -C project push --force-with-lease=master:ba26f4cdb origin upstream/master:master
```

### Step 2: Rebase #411

After bot-master = `07aff334e`:
- Decide: rebase onto the new frozen-base snapshot
  `master-07aff33` OR onto bare `master`.
- The PR was opened with frozen-base `master-ba26f4c`; new
  snapshot `master-07aff33` matches the convention.
- Push new frozen base if not already present.
- Rebase `ci/cache-playwright-browsers` onto `master-07aff33`.
- Force-with-lease push using `58c53d5a0` as lease anchor.
- `gh pr edit 411 --base master-07aff33` to update PR base.

### Step 3 (if conflicts): resolve

Expected: clean replay. The PR's diff is small
(`.github/workflows/browser-test.yml` + `browser-test/
package.json` + `browser-test/package-lock.json`). The
upstream zizmor fix likely touches `.github/workflows/`
also; if conflicts, weave both intents.

## Per-action authorizations

- Sync bot-master via force-with-lease push of
  `upstream/master` to `origin/master`. Authorized.
- Push new frozen-base `master-07aff33`. Authorized.
- Rebase + force-with-lease push of
  `ci/cache-playwright-browsers`. Authorized.
- `gh pr edit 411 --base master-07aff33`. Authorized.
- Resolve conflicts. Authorized.

## Not authorized

- Force-push without lease anchor.
- Modifying source content beyond rebase replay + conflict
  resolution.
- Un-drafting / merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/weaver--55a546/garden/roles/COMMON.md`
2. `/home/kris/dispatches/weaver--55a546/garden/roles/weaver/AGENT.md`
3. `garden/skills/conflict-resolution/SKILL.md`
4. `garden/skills/frozen-base-branch/SKILL.md`
5. Other skills referenced just-in-time.

Project worktree at `project/` on `ci/cache-playwright-browsers`
(refetch — head should be `58c53d5a0`).

## Report

A `result` journal entry. Include:

- Bot-master pre-sync / post-sync SHAs.
- Pre-rebase head + post-rebase head for #411.
- New frozen-base name + SHA.
- Conflict-resolution summary (if any).
- Force-push exit codes.
- `gh pr edit --base` exit code.
- Whether the PR's mergeable-state should now be MERGEABLE
  and CI should be green.
