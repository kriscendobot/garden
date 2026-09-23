---
ts: 2026-05-15T02:20:23Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: target
  - repo: endojs/endo
    pr: 3256
    role: source
---

# Dispatch: fixer rebases #109 (syrup-frame), regenerates yarn.lock, amends yarn.lock commit, shepherds CI

Dispatch root: `dispatches/fixer--a80ce6/`. Project worktree on `endojs/endo-but-for-bots@feat/syrups-package` (head `45ec2797a` from today's earlier retcon).

Maintainer directive (2026-05-15): *"Please sync our mirror of https://github.com/endojs/endo/pull/3256, rebase, regenerate yarn.lock, amend the yarn.lock commit, and shepherd through CI. Please post to bulletin when done so I can ferry from another session."*

#109 is the bots-side mirror of endo#3256 (syrup-frame). The retcon weaver `7d2857` earlier today landed three commits:
1. `245600748` feat(syrup-frame): add @endo/syrup-frame package
2. `069c24d6b` feat(ocapn): add opt-in syrups framing to TCP-testing netlayer
3. `45ec2797a` chore: Update yarn.lock

After rebase on `endo-upstream/master`, the yarn.lock needs regeneration. The user specifically wants the regenerated yarn.lock **amended into the existing third commit** (rather than appearing as a fourth commit). This preserves the retcon's commit shape: per-package + single yarn.lock commit.

## Per-action authorization

Standing on endo-but-for-bots: push with `--force-with-lease=feat/syrups-package:45ec2797a`. No upstream interaction.

## Task

1. **Fetch** `endo-upstream/master`.
2. **Rebase** `git rebase endo-upstream/master`. Resolve any conflicts per skill.
3. **Regenerate yarn.lock**:
   - If the rebase produced a conflicted yarn.lock, resolve by `git checkout --theirs yarn.lock` then `yarn install`.
   - Otherwise: `yarn install` to regenerate.
4. **Amend into the yarn.lock commit** (commit 3 of 3):
   - During rebase: if the third commit's yarn.lock content needs updating, use `git rebase -i` and `e` (edit) on the third commit; after the edit, `git commit --amend --no-edit yarn.lock`; `git rebase --continue`.
   - Or simpler post-rebase: if the three commits replayed but yarn.lock needs further regeneration, `git rebase -i HEAD~1` on the yarn.lock commit, run `yarn install`, `git add yarn.lock && git commit --amend --no-edit`, `git rebase --continue`.
   - Result: branch has three commits, same shape as before, with the third commit's yarn.lock content updated.
5. **Per today's self-improvement** (filed at `015257Z`): commit + push BEFORE extended local validation.
6. Push with `--force-with-lease`.
7. Watch CI converge; treat `test-ocapn-guile-interop` as gating signal.

## Out of scope

- No new feature commits.
- No comment on #109 or upstream #3256.
- No upstream ferry (the maintainer ferries from another session).

## Report

≤ 300 words: rebase outcome (conflicts), yarn.lock regeneration shape, the three commit SHAs after push, CI status, one-line `Self-improvement: ...`. The liaison adds a bulletin row for ferry handoff when CI green.
