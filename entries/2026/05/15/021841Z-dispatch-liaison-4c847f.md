---
ts: 2026-05-15T02:18:41Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: target
  - repo: endojs/endo
    pr: 3232
    role: source
---

# Dispatch: fixer rebases #75 on actual/master, resolves yarn.lock conflict, shepherds CI

Dispatch root: `dispatches/fixer--4c847f/`. Project worktree on `endojs/endo-but-for-bots@kriskowal-random-chacha12` (head `b0d9f31c`, base `master`).

Maintainer directive (2026-05-15): *"Please dispatch to sync our mirror of https://github.com/endojs/endo/pull/3232 and rebase, resolving the conflict in yarn.lock, and shepherd through CI. Post to bulletin when done, since I will need to ferry it from a different session."*

#75 is the bots-side mirror of endo#3232 (chacha12). Currently base master, head `b0d9f31c` (post the magic-multiplier test simplification from today's earlier CR fixer). The user says there's a yarn.lock conflict on rebase — likely a known re-roll needed after substantial master advancement.

After the rebase + shepherd, the liaison adds a bulletin row pointing at the ready-for-ferry state; kriskowal dispatches a ferry from another session.

## Per-action authorization

Standing on endo-but-for-bots: push with `--force-with-lease=kriskowal-random-chacha12:b0d9f31c`. No upstream interaction.

## Task

1. Fetch `endo-upstream/master` (the upstream).
2. `git rebase endo-upstream/master` onto the branch.
3. Resolve conflicts. For `yarn.lock` specifically: the typical resolution is to take both sides + `yarn install` to regenerate. If `yarn.lock` is the only conflict, the simplest path is `git checkout --theirs yarn.lock && yarn install && git add yarn.lock && git rebase --continue` (or analogous: drop the lockfile and regenerate from `package.json`s).
4. **Per today's self-improvement** (filed at `015257Z`): commit + push BEFORE extended local validation.
5. Push with `--force-with-lease`.
6. Watch CI; treat `test-ocapn-guile-interop` as gating signal.

## Out of scope

- No comment on #75 or upstream #3232 from this dispatch.
- No upstream ferry (the maintainer ferries from another session per the directive).

## Report

≤ 300 words: rebase outcome, conflicts encountered (especially yarn.lock resolution shape), head SHA after push, CI status, one-line `Self-improvement: ...`. The liaison adds a bulletin row for ferry handoff when CI green.
