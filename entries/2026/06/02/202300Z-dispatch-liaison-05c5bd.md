---
ts: 2026-06-02T20:23:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--05c5bd
prs:
  - repo: endojs/endo-but-for-bots
    pr: 387
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/387#issuecomment-...20:21:50Z
---

# dispatch: fixer — retcon #387 per kriskowal "Then, please retcon."

kriskowal issue comment at 20:21:50Z on #387: "Then, please retcon."
Following the two feedback-carry commits I landed (`dda872eb0` gibson042
shell-script feedback; `9e3cde0f2` `.engines` -> `.bench-engines` rename),
collapse the per-package change set into the canonical retcon shape per
`skills/retcon/SKILL.md`.

## Current commit graph

`fix-benchmark-wget-engines-master` head `9e3cde0f2`:
```
9e3cde0f2 fix(benchmark): rename .engines -> .bench-engines per kriskowal #387
dda872eb0 fix(benchmark): carry gibson042 shell-script feedback from endo#3294
c786ba635 chore: Update yarn.lock
03165ef12 fix(benchmark): install xs/v8 via direct download, drop esvu
814dfa1fd (master-814dfa1)
```

## Expected post-retcon shape

Two commits on top of `master-814dfa1` (the frozen base):
```
<new>  chore: Update yarn.lock
<new>  fix(benchmark): install xs/v8 via direct download instead of esvu
master-814dfa1
```

The first commit folds in all .sh / README / non-yarn-lock changes from
all four current commits, including the gibson042 shell-script feedback
and the `.engines` -> `.bench-engines` rename. The second commit is the
yarn.lock-only delta.

Use the retcon skill: reset the branch to the base, restage non-yarn-lock
changes per-package as one commit, then yarn.lock as a separate commit.
Net-diff invariant must hold against the prior head `9e3cde0f2`:

  diff <(git diff master-814dfa1..9e3cde0f2 -- ':!yarn.lock' | sha256sum) \
       <(git diff master-814dfa1..HEAD     -- ':!yarn.lock' | sha256sum)
  # and
  diff <(git diff master-814dfa1..9e3cde0f2 -- yarn.lock | sha256sum) \
       <(git diff master-814dfa1..HEAD     -- yarn.lock | sha256sum)

Both should match.

## Procedure (high-level)

1. Reset working tree to `master-814dfa1`, keeping `9e3cde0f2`'s net file
   state in the index/working tree.
2. Stage all non-yarn-lock paths; commit:
   ```
   fix(benchmark): install xs/v8 via direct download instead of esvu
   ```
3. Stage `yarn.lock`; commit:
   ```
   chore: Update yarn.lock
   ```
4. Verify net-diff invariant against `9e3cde0f2`.
5. Force-with-lease push: `git push origin
   HEAD:fix-benchmark-wget-engines-master --force-with-lease=fix-benchmark-wget-engines-master:9e3cde0f2`.

## Per-action authorizations

- All operations in retcon skill. Authorized.
- Force-with-lease push using `9e3cde0f2` as lease anchor. Authorized.
- No PR comments.

## Not authorized

- Plain `--force` (use `--force-with-lease`).
- Un-draft / re-draft.
- Merge.
- PR comments.
- Modifications outside the per-package collapse (no new code).

## Dispatch protocol

Read in order:
1. garden/roles/COMMON.md
2. garden/roles/fixer/AGENT.md
3. garden/skills/retcon/SKILL.md
4. Other skills just-in-time.

Project worktree on `fix-benchmark-wget-engines-master` (head `9e3cde0f2`).

## Report

A `result` journal entry. Include: new head SHAs (two commits), per-commit
file count, net-diff invariant sha256 results, force-with-lease push
outcome, and any deviations from `skills/retcon/SKILL.md`.
