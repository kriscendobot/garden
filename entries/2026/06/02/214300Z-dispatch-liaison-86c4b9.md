---
ts: 2026-06-02T21:43:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--86c4b9
prs:
  - repo: endojs/endo-but-for-bots
    pr: 244
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/244
  - https://github.com/endojs/endo/pull/3263 (upstream — must be ferried back)
---

# dispatch: fixer — rebase + retcon #244 (mirror of endo#3263) per user directive

User directive: "Please rebase and retcon our mirror of
https://github.com/endojs/endo/pull/3263. Leave a note on the journal
when done that this needs to be ferried back."

Per memory rule `feedback_rebase_on_master_implies_sync.md` ("on
endo-but-for-bots PRs, 'please rebase' is the compound: sync bot-master
to current endo-upstream/master, then rebase, then conflict-resolve,
then retcon"), execute the full compound chain.

## Current state

- `origin/master` (endo-but-for-bots bot-master): `814dfa1f` (stale).
- `endo-upstream/master` (endojs/endo upstream-master): `3c5753b6`
  (ahead — chore: dependency maintenance #3292 plus 8 more commits).
- PR #244 (`chore/eslint-numeric-separators-style-master`): head
  `63a1a6068`, base `master`, OPEN, non-draft, no review decision.
- Three commits on the PR branch atop `814dfa1f`:
  ```
  63a1a6068 chore(syrup-frame): drop separators on 4-digit literals to satisfy numeric-separators-style (#244)
  30bb6725d chore: Update yarn.lock
  7f07c1428 chore(marshal,cli): exempt comparison literals from numeric-separators rule
  ```

## Procedure

### 1. Sync bot-master to upstream-master

Force-push `endo-upstream/master` to `origin/master` on
endo-but-for-bots, using the current bot-master SHA (`814dfa1f`) as the
lease anchor per memory rule `feedback_bot_master_reset_to_actual.md`:

```
git fetch endo-upstream master                                                # update endo-upstream/master
git push origin endo-upstream/master:master --force-with-lease=master:814dfa1fdab4b3d6b8443a808a233e20263ef638
```

If `force-with-lease` rejects (someone else updated origin/master in
the meantime), DO NOT plain-force. Stop and report.

### 2. Rebase PR #244 onto the new master

```
git checkout chore/eslint-numeric-separators-style-master
git fetch origin master
git rebase origin/master
```

Resolve any conflicts per `garden/skills/conflict-resolution/SKILL.md`
(no `--ours`/`--theirs`; weave both intents). Likely conflicts on
`yarn.lock` (rerun `corepack yarn install` to regenerate after the
upstream's dependency churn).

### 3. Retcon to canonical 2-commit shape

Per `garden/skills/retcon/SKILL.md`, after the rebase is conflict-free,
collapse to the canonical retcon shape:

```
<new>  chore: Update yarn.lock
<new>  chore(eslint-plugin): require underscore-delimited groups in numeric literals
```

The implementation commit should fold in:
- `7f07c1428`'s eslint-plugin rule + marshal/cli literal exemptions
- `63a1a6068`'s syrup-frame separator fix

The yarn.lock commit is the post-rebase yarn.lock delta only.

Verify the net-diff invariant against the prior PR head `63a1a6068`:
```
diff <(git diff <new-base>..<new-prior-head>     -- ':!yarn.lock' | sha256sum) \
     <(git diff <new-base>..<post-retcon-HEAD>  -- ':!yarn.lock' | sha256sum)
```
should NOT match exactly (because the base changed under us — the
upstream dependency churn isn't going away), so use a content-equivalent
check: confirm the implementation commit's set of touched non-yarn.lock
files matches the original three commits' set.

### 4. Force-with-lease push

```
git push origin HEAD:chore/eslint-numeric-separators-style-master \
  --force-with-lease=chore/eslint-numeric-separators-style-master:63a1a6068
```

## Per-action authorizations

- `git fetch endo-upstream master`. Authorized.
- Force-with-lease push of `endo-upstream/master` to bot-master with
  the prior bot-master SHA as lease anchor. Authorized.
- Rebase + conflict-resolution on the PR branch. Authorized.
- `corepack yarn install` to regenerate yarn.lock. Authorized.
- Retcon. Authorized.
- Force-with-lease push to PR branch using `63a1a6068` as lease
  anchor. Authorized.
- No PR comments (the user will see the new commit).

## Not authorized

- Plain `--force` (use `--force-with-lease` with the named anchors).
- Un-draft / re-draft / merge.
- PR comments.
- Touching files outside what the rebase + retcon naturally produces.

## Dispatch protocol

Read in order:
1. garden/roles/COMMON.md
2. garden/roles/fixer/AGENT.md
3. garden/skills/conflict-resolution/SKILL.md
4. garden/skills/retcon/SKILL.md
5. garden/skills/yarn-lock-separate-commit/SKILL.md
6. Other skills just-in-time.

Project worktree on `chore/eslint-numeric-separators-style-master` (head
`63a1a6068`).

## Report

A `result` journal entry. Include: new bot-master SHA, new PR head SHA
(post-retcon), the two new commit SHAs in the retcon, conflict
resolution notes, yarn.lock regeneration outcome, both force-with-lease
push outcomes, and any deviations.

## Notes for the orchestrator (not the fixer)

After the fixer returns, the liaison will write a separate journal
entry tagged as a "ferry-back" reminder: the new #244 head must be
carried back to upstream endojs/endo#3263 via the boatman from the
credentialed host (kmkmbp2021) per `roles/boatman/AGENT.md` § Host
preconditions. This dispatch handles the mirror side only.
