---
created: 2026-05-13
updated: 2026-06-24
author: liaison, gardener
---

# Skill: conflict-resolution

Resolve every merge or rebase conflict by reading both sides. Never `--ours`,
never `--theirs`, never `-X ours` / `-X theirs`. Consumed by the weave/rebase
job a gardener claims.

## The rule

When git stops with a conflict, read both sides of every hunk, understand what
each branch intended, and write a resolution that honors both. `--ours` and
`--theirs` are right about 5% of the time and wrong the rest, and you cannot
tell which without reading both sides.

A real conflict is two intentions touching the same lines. The resolution that
matters is usually a *third* state (both intentions woven together), not either
input verbatim.

## Procedure

1. List conflicted files:

   ```sh
   git status --short | grep '^UU\|^AA\|^DD\|^AU\|^UA'
   ```

2. For each conflicted file, look at three things in order:
   - The conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`) in the working tree.
   - `git log -1 --stat HEAD -- <file>`: what the rebase target was doing.
   - `git log -1 --stat MERGE_HEAD -- <file>` (merge) or
     `git log -1 --stat REBASE_HEAD -- <file>` (rebase): what your branch was
     doing.

3. Open both authors' commits: `git show <sha>:<file>`. Often the conflict is
   mechanical (same constant renamed in two places) but the markers make it look
   semantic.

4. Write the resolution as if authoring the file from scratch knowing both
   intents. If genuinely incompatible, prefer the side that fits the project's
   current direction and note the trade-off so the other author can review.

5. `git add <file>` and continue (`git rebase --continue` or
   `git merge --continue`).

## When `--ours` / `--theirs` might be acceptable

Three narrow cases, and even here read both sides first to confirm:

- **Generated files** (`yarn.lock`, `package-lock.json`, `dist/*`): drop both
  sides and regenerate. For lockfiles, see [yarn-lock-separate-commit].
- **CHANGELOG.md maintained by Changesets**: release tooling owns it; drop one
  side and let the release flow regenerate.
- **Whitespace-only conflicts from a Prettier rerun**: rerun Prettier; the
  conflict vanishes.

In all three you are deleting both sides and recomputing, not choosing one. The
dishonest shortcut is pretending this applies elsewhere.

## Pitfalls

- **Resolving by markers alone.** The markers show disagreement, not intent.
  Skim the surrounding function and the commit messages from both sides.
- **Silent loss.** A resolution that drops one side's added function is a
  regression even if the file compiles. Run the affected package's tests after
  every conflicted file.
- **Repeated `git rebase --abort` cycles.** Two aborts is a signal that a merge
  commit may be more honest than a rebase. Surface the choice to the supervising
  gardener (emit it as a `loop`/decision signal, or message the maintainer via
  the bus) rather than thrash.
- **Rename conflicts.** `git status` shows `UA` or `AU` markers; both sides may
  have edited the file under different paths. Read with extra care.
- **HEAD semantics differ.** During rebase, `HEAD` is the rebase *target* and
  `REBASE_HEAD` is your branch's commit being replayed. During merge, `HEAD` is
  yours and `MERGE_HEAD` is incoming. Don't confuse them.
- **A clean rebase can still break the PR's invariant.** An enforcement check
  (lint, policy script, schema validator) may fail because the new base added a
  file the check covers. Run the PR's own enforcement against the rebased tree
  before pushing.
- **Two sides each add a new parameter to the same signature.** The most common
  trivial-looking conflict and the most error-prone. Keep both, order
  defensibly (preserve the base side's slot to avoid breaking pre-existing call
  sites, append the PR side's new param), and check positional consumers in any
  shared implementation so a placeholder for the new base-side param lands too.

## Notes from the field

- _2026-05-13_: adopted from a reference garden. The reference's session
  examples were pruned; the abstract rules stay, specific PR lore lives in the
  journal.
- _2026-06-24_: migrated into v2. The only rewire is the "surface the choice"
  pitfall: a v1 dispatched weaver surfaced to its dispatcher; a v2 gardener
  surfaces via the supervisor `loop` signal or the message bus.
