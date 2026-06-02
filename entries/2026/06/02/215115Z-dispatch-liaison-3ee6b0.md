---
ts: 2026-06-02T21:51:15Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--3ee6b0
prs:
  - repo: endojs/endo-but-for-bots
    pr: 387
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/387
  - https://github.com/endojs/endo-but-for-bots/pull/387#discussion_r3344170182
---

# dispatch: fixer — #387 revert `.bench-engines` rename back to `.engines`, re-retcon

User explicit ask:

> Please dispatch an agent to address
> https://github.com/endojs/endo-but-for-bots/pull/387#discussion_r3344170182

The comment text (kriskowal, 2026-06-02T20:20:39Z):

> I did not recommend changing `.engines` to `.bench-engines`. Rather, I
> recommended the opposite. Please rebase that commit out.

## Background

The prior fixer dispatch (f22e80, 2026-06-02 earlier) misinterpreted
kriskowal's 02:39Z file-level ask ("Please rename `.engines`. Nothing
limits us from using engines for other workflows.") as "rename to a
benchmark-specific directory" and produced `.bench-engines`. The
maintainer's intent was the opposite: keep `.engines` as the generic
name precisely because nothing limits its reuse for other workflows.

Net effect required: reverse the rename across all three files
(install-engines.sh, run-tests.sh, README.md) and fold the reversal
into the existing implementation commit via retcon. The branch shape
should remain two commits atop `master-814dfa1`:

```
<new-impl-sha> fix(benchmark): install xs/v8 via direct download instead of esvu
<new-lock-sha> chore: Update yarn.lock
```

Current head: `a66f3c344`. Use this as the force-with-lease anchor.

## Concrete substitutions

In each of the three files, substitute `.bench-engines` → `.engines`:

- `packages/benchmark/install-engines.sh` (20 occurrences)
- `packages/benchmark/run-tests.sh` (2 occurrences)
- `packages/benchmark/README.md` (1 occurrence)

`git grep -n bench-engines -- packages/benchmark/` from the project
worktree at HEAD = `a66f3c344` confirms the full set. No other files
reference `.bench-engines`.

## Procedure

1. From `project/`, confirm HEAD is `a66f3c344` (already reset).
2. `git reset --soft master-814dfa1` (preserves the working tree at
   the current state, unstages the two-commit tip).
3. Substitute `.bench-engines` → `.engines` across the three benchmark
   files. Verify no `bench-engines` remains in `packages/benchmark/`.
4. Stage the implementation hunks (everything except `yarn.lock`):
   ```
   git add -p   # or git add packages/benchmark <other impl paths>
   git status   # confirm yarn.lock is the only thing left unstaged
   ```
   The implementation diff after the revert should be the original
   esvu→direct-download change (the eshost rename you reverted is now
   inside this single commit, not a separate rename commit).
5. Commit:
   ```
   git commit -m "fix(benchmark): install xs/v8 via direct download instead of esvu"
   ```
6. Stage `yarn.lock` separately. Commit:
   ```
   git commit -m "chore: Update yarn.lock"
   ```
7. Force-with-lease push using `a66f3c344` as anchor:
   ```
   git push --force-with-lease=fix-benchmark-wget-engines-master:a66f3c344 \
     origin HEAD:fix-benchmark-wget-engines-master
   ```

## Verification before push

- `git log --oneline master-814dfa1..HEAD` should show exactly two
  lines: implementation + yarn.lock.
- `git diff master-814dfa1..HEAD -- packages/benchmark/install-engines.sh`
  should NOT contain `.bench-engines` anywhere.
- `git grep -n bench-engines` should return zero matches.
- `git diff a66f3c344..HEAD` (across the whole tree) should be ONLY
  the `.bench-engines` → `.engines` reversal — no other content
  changes. (This is the retcon net-diff sanity check: the rewrite
  changes only what kriskowal asked to rebase out.)

## Per-action authorizations

- `git reset --soft master-814dfa1`. Authorized.
- Sed-style file edits in the three benchmark files. Authorized.
- Two commits: implementation, then yarn.lock. Authorized.
- `git push --force-with-lease=fix-benchmark-wget-engines-master:a66f3c344
  origin HEAD:fix-benchmark-wget-engines-master`. Authorized.

## Not authorized

- Touching files outside `packages/benchmark/` (no other paths
  reference `.bench-engines`).
- Un-drafting or re-drafting the PR.
- Posting PR comments other than a brief acknowledgment if you choose
  (optional — the maintainer asked for the rebase, not a discussion).
- Merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--3ee6b0/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--3ee6b0/garden/roles/fixer/AGENT.md`
3. `garden/skills/retcon/SKILL.md` (the rename reversal is itself a
   retcon — preserve the two-commit shape and net-diff invariant
   relative to the original esvu→direct-download intent).

Project worktree at `project/` on `fix-benchmark-wget-engines-master`
(head `a66f3c344`).

## Report

A `result` journal entry. Include:

- New head SHA after force-push.
- Pre-push verification outputs (`git log --oneline`, `git grep -c
  bench-engines`).
- The lease anchor used and the push command exit status.
- A note on whether you posted any acknowledgment comment.
