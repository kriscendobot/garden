---
created: 2026-05-12
updated: 2026-06-03
author: liaison, gardener
---

# Worktree management

All worktrees the garden uses live under the garden root. Three kinds:

1. **Journal** (`journal/`). A worktree of *this* repo on the orphan branch `journal`. Created once per machine. Never delete unless intentionally archiving the garden's history.
2. **Fork worktrees** (`worktrees/<owner>-<repo>/<name>/`). Worktrees added from a bare clone at `worktrees/<owner>-<repo>.git/`. Created and collected on demand.
3. **Per-dispatch worktrees** (`dispatches/<role>--<short-id>/{garden,journal,project}/`). Created by the orchestrator (liaison or steward) immediately before a subagent is dispatched and torn down when the subagent returns. See *Per-dispatch worktree triple* below.

## Bootstrap (run once)

Run from the garden root:

```sh
# Initial commit on garden main (if not already present), needed before adding worktrees.
git add -A
git commit -m "garden: initial scaffold"

# Create the journal as an orphan-branch worktree.
git worktree add --detach journal
git -C journal checkout --orphan journal
git -C journal rm -rf . 2>/dev/null || true
mkdir -p journal/entries
git -C journal commit --allow-empty -m "journal: initialized"
```

After bootstrap:

- `journal/` is at the orphan branch `journal`, sharing zero history with `main`.
- `git branch` shows both `main` and `journal`.
- `git worktree list` shows both checkouts.

## Adding a fork worktree

Run from the garden root:

```sh
# Clone bare once per fork:
git clone --bare https://github.com/<owner>/<repo>.git \
  worktrees/<owner>-<repo>.git

# Once per bare clone: set the fetch refspec. A bare clone has no
# `remote.origin.fetch` refspec by default, so `git fetch origin` updates only
# FETCH_HEAD and leaves the `origin/*` remote-tracking refs frozen at clone
# time. A later dispatch that detaches at `origin/master` would then recompute
# onto a stale tip.
git -C worktrees/<owner>-<repo>.git config remote.origin.fetch \
  '+refs/heads/*:refs/remotes/origin/*'
# Consequence to understand: with this refspec, `git fetch origin` routes every
# branch created AFTER the clone into `refs/remotes/origin/*`, not
# `refs/heads/*`. Only branches present at clone time (notably `master`) keep a
# `refs/heads/` head. A bare branch name therefore does not resolve for a
# post-clone branch. `dispatch-prepare.sh` accounts for this: before
# `worktree add --detach <path> <branch>` it fetches the target branch
# explicitly into `refs/heads/<branch>` (`+refs/heads/<branch>:refs/heads/<branch>`)
# so the bare name resolves whether the branch is original-clone or post-clone.

# Once per bare clone: tell git to ignore our metadata directory in every
# worktree created from it. The per-worktree `.git` is a *file* (worktree
# pointer), not a directory, so the usual `<worktree>/.git/info/exclude`
# trick does not work; append to the bare clone's shared exclude instead.
echo '.garden/' >> worktrees/<owner>-<repo>.git/info/exclude

# For each working checkout:
NAME="<purpose-slug>--<role>--$(date -u +%Y%m%d-%H%M%S)"
git --git-dir=worktrees/<owner>-<repo>.git worktree add \
  worktrees/<owner>-<repo>/$NAME <branch>

# Then the dispatcher writes the journal index entry at
# journal/worktrees/<host>/<name>.md (see "Worktree state lives in the journal" below).
```

## Naming convention

```
worktrees/<owner>-<repo>/<purpose-slug>--<role>--<YYYYMMDD-HHMMSS>
```

- `<owner>-<repo>` mirrors the upstream slug, e.g. `anthropics-claude-code`.
- `<purpose-slug>`: kebab-case, what this worktree exists for (`fix-pagination`, `watch-main`, `try-rewrite`).
- `<role>`: primary occupying role (`monitor`, `implementer`, `reviewer`).
- timestamp: UTC, ensures uniqueness across concurrent dispatchers without coordination.

Example: `worktrees/anthropics-claude-code/watch-main--monitor--20260512-142345/`.

The `--` separators are deliberate: filenames contain no other double-dashes, so a quick `awk -F'--'` parses fields cleanly.

## Worktree state lives in the journal

Every fork worktree has a single authoritative state file: an entry in the journal index at:

```
journal/worktrees/<hostname>/<worktree-name>.md
```

There is no per-worktree TOML. Agents read and update the journal entry directly, fetch / rebase / push per `skills/journal-sync/SKILL.md`. Concurrent edits from different machines merge cleanly because each worktree has its own file.

See `journal/worktrees/README.md` for the schema (path, repo, branch, role, status, heartbeat, task, prs across multiple repos) and the lifecycle (create / heartbeat / status change / PR binding / collect). Collection sets `status: collected`; the entry is retained for historical lookup.

Inside the worktree itself, `.garden/` may still hold role-private high-frequency state (e.g., the `.garden-monitor/<repo>/` polling state used by the github-activity-poll skill). That state stays local to the worktree, never committed upstream, never authoritative for cross-machine state. Add `.garden/` to the bare clone's `info/exclude` (per the bare-clone setup above) so the role-private state is invisible to the upstream's working tree.

## Lifecycle and collection

A worktree is **collectable** when ALL of:

- The journal index entry's `status` is not `active` and not `reserved`,
- `git -C <worktree> status --porcelain` is empty (no uncommitted changes),
- `git -C <worktree> log @{u}..` is empty, or the branch is local-only and has been merged or abandoned,
- The journal index entry's `last_heartbeat` is older than 1 hour (default idle threshold; tunable per role).

Collection procedure:

1. Write a `worktree` journal entry (`kind: worktree`, body: "collected `<name>`, last activity `<ts>`, reason `<...>`").
2. From the garden root: `git --git-dir=worktrees/<owner>-<repo>.git worktree remove <path>`.
   Never `rm -rf`. Git tracks the worktree in its admin tree, and `worktree remove` keeps that consistent.

If `worktree remove` complains about uncommitted changes you did not expect, stop and investigate. That may be in-progress work the metadata is wrong about.

## Reservation

An agent that wants exclusive access to a worktree sets `status: reserved` in its journal index entry before it begins work, and back to `active` or `idle` when done. Other agents skip reserved worktrees when looking for collectable candidates or when they would otherwise consider piggybacking on an existing checkout.

Reservation is cooperative (no lock), so reserve only as long as you need.

## Per-dispatch worktree triple

Every subagent dispatched via the `Agent` tool runs in its own per-dispatch worktree triple, created by the orchestrator before the dispatch and torn down when the subagent returns. This is how "subagents should be as independent as possible" is mechanized: each subagent reads its own copy of `roles/`, writes journal entries from its own copy of `journal/`, and (when applicable) operates on its own copy of the upstream fork. No two subagents share filesystem state during a dispatch.

### Layout

```
dispatches/<role>--<short-id>/
  garden/    # detached worktree of garden's `main` branch
  journal/   # detached worktree of garden's `journal` branch
  project/   # (only when applicable) detached worktree of the fork@branch
```

- `<role>`: the dispatching role (`monitor`, `boatman`, `review-queue`, etc.).
- `<short-id>`: 6 hex chars, generated by `dispatch-prepare.sh` and reused as the matching journal `dispatch` entry's short-id so the directory and the journal entry cross-reference cleanly.

The directory name is intentionally short. Earlier the scheme was `<role>--<purpose>--<UTC-YYYYMMDD-HHMMSS>--<short-id>/`, but that pushed deep project paths (notably endo daemon UNIX sockets under `project/packages/daemon/tmp/<slug>/endo.sock`) past the 108-char `sockaddr_un` limit. The full role, purpose, and timestamp metadata live in the matching `dispatch` journal entry, which is the authoritative index; the directory is just a unique handle for the worktree triple.

All three sub-worktrees are checked out in **detached-HEAD** so the subagent can `git fetch` and rebase or reset its HEAD freely without competing for branch ownership with the orchestrator's own checkouts. Commits and pushes use the detached-HEAD form:

```sh
git fetch origin <branch>
git rebase origin/<branch>     # if the subagent has local commits to keep
git push origin HEAD:<branch>  # push the detached commit back to the branch
```

### Lifecycle

The orchestrator calls helper scripts; the subagent never creates or removes worktrees itself.

```sh
# Before invoking the Agent tool:
DISPATCH_ROOT=$(skills/dispatch-worktree/dispatch-prepare.sh <role> <purpose> [<owner>/<repo> <branch>])

# Pass $DISPATCH_ROOT into the subagent's prompt as the dispatch root.
# (See CLAUDE.md § Dispatch prompt template for the wording.)

# After the subagent returns:
skills/dispatch-worktree/dispatch-teardown.sh "$DISPATCH_ROOT"
```

The scripts and their procedural detail live in `skills/dispatch-worktree/` (see [skills/dispatch-worktree/SKILL.md](skills/dispatch-worktree/SKILL.md) for inputs, outputs, contract guarantees, identity pinning, and pitfalls). In summary: `dispatch-prepare.sh` creates the directory, runs `git worktree add --detach` for garden and journal, and (if a project repo and branch are named) for the project. For the project worktree it first fetches the target branch into the bare clone's `refs/heads/<branch>`, so the bare branch name resolves even though the `+refs/heads/*:refs/remotes/origin/*` fetch refspec (see *Adding a fork worktree* above) routes post-clone branches into `refs/remotes/origin/*` rather than `refs/heads/*`. It also pins the bot identity (read from `<garden-root>/.git/config`'s local `user.name` and `user.email`) into each sub-worktree's local config, so a subagent's commits cannot drift to the parent shell's global identity. It prints the dispatch root path on stdout. `dispatch-teardown.sh` runs `git worktree remove --force` for each sub-worktree, then removes the dispatch root directory. It is idempotent: missing pieces are tolerated.

### Standing exceptions

A few daemons and long-lived state holders are *not* per-dispatch entities and are not torn down between dispatches:

- The **bash poll daemons** under `skills/github-activity-poll/monitor-poll.sh` and `skills/review-queue-poll/review-queue-poll.sh`. They are not subagents (no LLM involvement) and own state that must survive across LLM ticks (ETag, last-seen event id, the review-queue's canonical set).
- The **standing monitor worktrees** at `worktrees/<owner>-<repo>/watch-<slug>--monitor--<ts>/` exist solely as the host directory for `.garden-monitor/<owner>-<repo>/` polling state. They are referenced by the daemons, not by the LLM dispatches.

LLM monitor and review-queue dispatches still receive a per-dispatch garden+journal worktree triple. They typically do not need a project worktree (the events they react to arrive via the GitHub API, and the journal carries the durable record), so dispatch-prepare is called without the project arguments for those roles.

If you find yourself wanting to grow per-dispatch state inside a standing worktree, that is a sign the design has drifted; route it through a journal entry instead.
