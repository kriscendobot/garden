---
created: 2026-05-13
updated: 2026-05-14
author: liaison
---

# Skill: worktree-per-pr

Adopted from `references/endo-but-for-bots/skills/worktree-per-pr.md` and adapted for this garden's per-dispatch worktree contract.

In this garden, each dispatched subagent operates inside a per-dispatch worktree triple created by `skills/dispatch-worktree/dispatch-prepare.sh`. The triple's `project/` directory is the equivalent of the reference's per-PR worktree. The orchestrator (liaison or steward) creates the triple before dispatch and tears it down after return.

See `garden/WORKTREES.md` § Per-dispatch worktree triple for the lifecycle.

## When to use

Every dispatched subagent operates outside the orchestrator's seat, full stop. Three lanes:

1. **Mutating subagents** (fixer, weaver, shepherd, conductor, designer): work inside `<dispatch-root>/project/`, the project worktree the orchestrator prepared.
2. **Read-only subagents** (any jury seat reading the diff: assessor, stylist, archivist, curator, locksmith, saboteur): the orchestrator (or the judge, when the seats are dispatched as a panel) still prepares a project worktree (detached HEAD, never committed); the dispatch brief notes the read-only posture.
3. **API-only subagents** (monitor, review-queue): the dispatch prep is called without the project arguments; the agent's work is journal-and-API-only.

## Layout

```
<dispatch-root>/
  garden/    detached worktree of garden's main branch (read-only by convention)
  journal/   detached worktree of garden's journal branch (journal commits)
  project/   detached worktree of <owner>/<repo>@<branch>, when applicable
```

Your cwd as a subagent is `project/` if a project worktree exists, otherwise the dispatch root itself.

## Detached HEAD pattern

All three sub-worktrees are detached. Commits go to `HEAD`, pushes use `git push origin HEAD:<branch>`:

```sh
git fetch origin <branch>
git rebase origin/<branch>     # if local commits to keep
git push origin HEAD:<branch>  # push the detached commit
```

For a fork PR's head branch (not on `origin`):

```sh
git fetch <fork-remote> <pr-head-branch>
git reset --hard <fork-remote>/<pr-head-branch>
# ...work, commit...
git push --force-with-lease <fork-remote> HEAD:<pr-head-branch>
```

The orchestrator names the remote in the dispatch brief.

## Lifecycle

The orchestrator owns the lifecycle:

```sh
DISPATCH_ROOT=$(skills/dispatch-worktree/dispatch-prepare.sh <role> <purpose> [<owner>/<repo> <branch>])
# ... dispatch the subagent with $DISPATCH_ROOT in the prompt ...
skills/dispatch-worktree/dispatch-teardown.sh "$DISPATCH_ROOT"
```

The subagent never creates or removes worktrees. Standing exceptions (monitor and review-queue poll daemons; long-lived `worktrees/<owner>-<repo>/watch-<slug>--monitor--<ts>/` checkouts that host polling state) are documented in `WORKTREES.md` § Standing exceptions.

## Pitfalls

- **Long worktree paths and Unix domain sockets.** Daemon-class tests that bind sockets under `<worktree>/.../tmp/...` can exceed Linux's 108-byte `sockaddr_un` cap. Keep purpose slugs short (under ~16 chars) when daemon tests are involved.
- **Reused worktrees can hold stale absolute paths.** Yarn 4's portable store leaves cross-worktree references in `node_modules/.bin/*` shims and `.pnp.cjs` after a sibling worktree disappears. A first `npx corepack yarn install` in the fresh dispatch root rewrites them. In this garden, per-dispatch worktrees are fresh per dispatch, so the issue mainly arises with standing monitor worktrees that share a parent repo across dispatches.
- **`git stash` as a baseline-test trick is the failure mode itself.** Losing rename detection on `git mv`-staged files; the subsequent `git stash pop` reverts files and emits a flurry of "user/linter edited" reminders. Prefer `git diff HEAD~1` to inspect changes, `git show HEAD~1:<path>` to read a parent version, or a separate `git worktree add --detach <tmp> <sha>` for a full-tree baseline.
- **Do not write to the orchestrator's seat.** The garden's own `main` and `journal` checkouts live under the garden root; a subagent never edits them. Per-dispatch `garden/` and `journal/` worktrees are how the subagent reads roles, writes journal entries, and stays out of the orchestrator's tree.

## Notes from the field

- _2026-05-13_: adopted and reshaped for this garden. The reference assumed a single shared `~/endo-wt/pr-<N>/` worktree across roles (builder creates, fixer reuses, conductor cleans up); this garden's per-dispatch contract creates a fresh `project/` per dispatch under the dispatch root. The continuity of state across a PR's life is therefore in the journal index entry at `journal/worktrees/<host>/<name>.md`, not in the worktree's directory contents.
