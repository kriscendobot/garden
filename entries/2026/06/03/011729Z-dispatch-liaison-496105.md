---
ts: 2026-06-03T01:17:29Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: weaver
dispatch_root: /home/kris/dispatches/weaver--496105
prs: []
refs:
  - https://github.com/endojs/endo/pull/3294
---

# dispatch: weaver — sync bot-master to actual/master, weave bots/llm onto bot-master

User explicit ask:

> https://github.com/endojs/endo/pull/3294 has merged in
> endojs/endo proper. This will fix CI for many open PRs in
> endojs/endo-but-for-bots, provided that we weave actual/master
> into bots/llm and rebase the affected PRs.

The merge brings the benchmark-engines fix (direct XS/V8 download
replacing the test-xs esvu flake) into upstream. To propagate
that fix through the bot fork's open PRs, we need to:

1. Update `endojs/endo-but-for-bots:master` (bot-master) to
   mirror upstream `endojs/endo:master` (actual/master). Per
   memory `feedback_bot_master_reset_to_actual.md`: this is a
   force-push of upstream master to origin/master with the
   prior bot-master SHA as the lease anchor.
2. Weave `endojs/endo-but-for-bots:llm` (bots/llm) onto the
   updated bot-master. bots/llm is the long-lived bot-side
   feature trunk; rebasing it brings the #3294 fix into the
   base for every llm-derived PR.
3. Force-push bots/llm with the prior llm SHA as the lease
   anchor.

Current state (verified by liaison):
- **Upstream master**: `endojs/endo:master` = `ba26f4cdb`
  (`fix(benchmark): install xs/v8 via direct download instead of
  esvu (#3294)`)
- **bots/llm**: `endojs/endo-but-for-bots:llm` = `c85d618df`
  (stale, predates the upstream merge)
- **bots/master**: needs verification — likely stale relative
  to actual/master; the weaver confirms before pushing.

The second wave (per-PR rebases onto the new llm) is a
follow-up dispatch the steward triggers after this weaver
returns; this weaver's scope ends at the bots/llm force-push +
the PR-impact report.

## Procedure

1. From the dispatch root, fetch both upstreams:
   ```
   git -C project fetch origin master llm
   git -C project remote add upstream git@github.com:endojs/endo.git
                                                    # if not already set
   git -C project fetch upstream master
   ```
2. Read the three current heads:
   - `upstream/master`
   - `origin/master` (bot-master)
   - `origin/llm` (bots/llm)
3. **bot-master sync**: per memory rule, force-with-lease push
   `upstream/master` → `origin/master`:
   ```
   git -C project push --force-with-lease=master:<bot-master-prior-SHA> \
       origin upstream/master:master
   ```
   Use `<bot-master-prior-SHA>` you just read at step 2 as the
   lease anchor.
4. **bots/llm weave onto bot-master**:
   - Check out `origin/llm`.
   - Rebase onto `origin/master` (the freshly-synced bot-master).
   - Conflict-resolve per `garden/skills/conflict-resolution/
     SKILL.md` (no `--ours`/`--theirs` magic; weave intents).
     Expect possible conflicts on yarn.lock at minimum, and
     possibly on overlapping benchmark/engine files since the
     #3294 fix touched the same area as some bot-side PRs.
5. Force-with-lease push the rebased bots/llm:
   ```
   git -C project push --force-with-lease=llm:<llm-prior-SHA> \
       origin HEAD:llm
   ```
6. **Identify affected PRs**: scan open kriscendobot PRs whose
   bases are llm-derived snapshots (`llm-XXX`) or which are
   failing CI on the test-xs benchmark flake. Frame your report
   as a per-PR list. Use the steward queue context (#388, #389,
   #392, #393, #394, #401, #403, plus any others) and report
   which need rebasing onto the new bots/llm vs which are
   independent.

## Per-action authorizations

- Read both endojs/endo and endojs/endo-but-for-bots state.
  Authorized.
- Force-with-lease push `upstream/master` → `origin/master` (on
  endojs/endo-but-for-bots) using the prior bot-master SHA as
  anchor. Authorized.
- Rebase `origin/llm` onto the new `origin/master`. Authorized.
- Force-with-lease push the rebased bots/llm using the prior llm
  SHA as anchor. Authorized.
- Resolve conflicts per `skills/conflict-resolution/SKILL.md`.
  Authorized.

## Not authorized

- Pushing without `--force-with-lease` anchor. (The
  unconstrained `--force` form would race-clobber concurrent
  pushes.)
- Modifying PR branches in this dispatch. Per-PR rebases are a
  second-wave dispatch.
- Force-pushing to any branch other than `master` or `llm` on
  `endojs/endo-but-for-bots`.
- Merging.
- Posting PR comments. (The PR-impact report goes in your
  result journal entry; the steward decides what to post on
  the per-PR rebase dispatches.)

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/weaver--496105/garden/roles/COMMON.md`
2. `/home/kris/dispatches/weaver--496105/garden/roles/weaver/AGENT.md`
3. `garden/skills/conflict-resolution/SKILL.md`
4. Other skills referenced just-in-time.

Project worktree at `project/` on `llm` (detached at
`68246ad92`; refetch since the prepare script's snapshot may
be slightly stale).

## Report

A `result` journal entry. Include:

- Pre-sync SHAs (upstream/master, bot-master, bots/llm).
- Bot-master post-sync SHA + force-push exit code.
- Bots/llm post-rebase SHA + force-push exit code + conflict
  resolution summary (which files, which side prevailed and
  why).
- Per-PR affected-PR list with shape:
  ```
  - #N | base=<branch> | needs-rebase=yes/no | reason
  ```
- Any judgment calls (e.g., decisions on how to handle a
  conflict that wasn't obvious).
