---
ts: 2026-06-02T05:23:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--4f3198
prs:
  - repo: endojs/endo-but-for-bots
    pr: 387
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/387
  - https://github.com/endojs/endo-but-for-bots/pull/387#issuecomment-4598921412
---

# dispatch: fixer — #387 retcon per kriskowal directive

kriskowal directive on #387 (05:15:49Z): "Please retcon."

Per orchestrator vocabulary, this maps to `skills/retcon/SKILL.md`: reset
branch + restage per-package, separate `chore: Update yarn.lock`,
implementation+tests combined; net diff invariant.

## Current state (head `dceb649b3`)

Three commits atop `master-814dfa1`:

```
dceb649b3  chore(benchmark): rename .bench-engines cache to .engines  ← fixer follow-up
6884ae242  chore: Update yarn.lock
0784dc3eb  fix(benchmark): install xs/v8 via direct download, drop esvu
```

The `.bench-engines` rename was a fixer-applied follow-up addressing
kriskowal's earlier inline comment. It belongs in the canonical
`fix(benchmark):` commit, not as a separate chore. The retcon's job:
collapse the rename into the implementation commit, leaving the canonical
two-commit shape:

```
NEW-HEAD  fix(benchmark): install xs/v8 via direct download, drop esvu
          (with rename folded in; the new working-tree diff includes
          .engines paths from the start, no .bench-engines anywhere)
NEW-LOCK  chore: Update yarn.lock
```

## Task

Per `skills/retcon/SKILL.md`:

1. Read `skills/retcon/SKILL.md` for the canonical procedure.
2. Reset the branch to base `master-814dfa1`
   (sha `814dfa1fd`).
3. Re-stage the net diff in the canonical shape:
   - One implementation commit:
     `fix(benchmark): install xs/v8 via direct download, drop esvu`
     containing the substantive fix INCLUDING the
     `.bench-engines` → `.engines` rename folded in (paths/strings/comments
     start with `.engines` from the outset).
   - One lockfile commit: `chore: Update yarn.lock`.
4. Force-push (`--force-with-lease` with `dceb649b3` as the lease anchor)
   to `endojs/endo-but-for-bots:fix-benchmark-wget-engines-master`.

### Net-diff invariant verification

Before pushing, verify the working-tree diff at the new HEAD matches the
working-tree diff at the old HEAD (`dceb649b3`):

```
# Old:
git diff 814dfa1fd dceb649b3 -- > /tmp/old-net.diff
# New (after retcon):
git diff 814dfa1fd HEAD -- > /tmp/new-net.diff
diff /tmp/old-net.diff /tmp/new-net.diff   # should be empty
```

If the diffs differ, the retcon has introduced or lost content — STOP
and report rather than pushing.

### Local verification

- `sh -n` on the touched shell scripts exits 0.
- `git grep -n bench-engines` returns zero matches.
- `corepack yarn install` exits cleanly (lockfile is consistent with the
  package.json state after the retcon).

## Per-action authorizations

- Reset the branch and rebuild commits. Authorized (retcon = rewrite).
- Edit files in `packages/benchmark/` and `packages/hex/` as needed.
  Authorized.
- Force-with-lease push to
  `endojs/endo-but-for-bots:fix-benchmark-wget-engines-master`
  with `dceb649b3` as the lease anchor. Authorized.

## Not authorized

- Resolving review threads (steward does that after fixer reports).
- Un-drafting (preserve DRAFT state).
- Merging.
- Modifying files outside the net diff of the original three commits.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--4f3198/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--4f3198/garden/roles/fixer/AGENT.md`
3. `garden/skills/retcon/SKILL.md`

Project worktree at `project/` on `fix-benchmark-wget-engines-master`
(head `dceb649b3`, base `814dfa1fd` = `master-814dfa1`).

## Report

A `result` journal entry. Include: new head SHA after push, per-commit
file lists, net-diff invariant verification outcome, `git grep -n
bench-engines` exit code, push outcome (success or non-fast-forward
rejection), and any PR comments posted (expected: none).
