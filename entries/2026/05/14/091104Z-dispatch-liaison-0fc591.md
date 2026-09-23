---
ts: 2026-05-14T09:11:04Z
kind: dispatch
role: liaison
project: garden
to: "*"
refs:
  - entries/2026/05/14/090813Z-message-liaison-1bc419.md
  - entries/2026/05/14/061959Z-result-liaison-7675d7.md
---

# Dispatch: gardener shortens dispatch-root naming + pins per-role identity in dispatch-prepare

Dispatch root: `dispatches/gardener--shorten-dispatch-root-and-identity-discipline--20260514-091104--0fc591/`. Two related dispatch-worktree improvements, one engagement.

## Issue 1: dispatch-root path overruns UNIX-socket 108-char limit

A fixer dispatched to PR #135 (`fixer--pr-135-panel-fix--20260514-084845--f3e898/project/...`) could not run the endo daemon's tests locally because the daemon's `endo.sock` path computed under the project worktree was 144+ chars before the test slug, well over the `sockaddr_un` 108-char limit. Every endo.test.js test failed with `ENOENT` before any assertion ran.

The current dispatch-root scheme is `dispatches/<role>--<purpose>--<UTC-ts>--<id>/` (40-60 chars). The fixer's proposal: drop the directory name's metadata to `<role>--<id>` (~13 chars) or even just `<id>` (6 chars); the journal entry is the canonical index for role/purpose/timestamp, so the directory name does not need to repeat that information.

The 36-50 chars saved bring the daemon-socket path back under the limit for typical test slugs.

Source: [`entries/2026/05/14/090813Z-message-liaison-1bc419.md`](090813Z-message-liaison-1bc419.md) (the fixer's full diagnosis).

## Issue 2: dispatch worktrees inherit parent shell's git identity

The fixer for #244 (prettier-fix) earlier today committed as `kriskowal <main.barn5084@fastmail.com>` rather than `kriscendobot`. The dispatch-prepare script does not set per-dispatch `user.name` / `user.email`; per-role identity is a runtime concern that the fixer did not enforce, and the worktree inherited the parent shell's `~/.gitconfig` (which carries the maintainer's name from prior interactive use).

Source: [`entries/2026/05/14/061959Z-result-liaison-7675d7.md`](061959Z-result-liaison-7675d7.md) § Discipline observation.

## Per-action authorization

Standing on the garden repo (commit + push to `main`, edit `roles/`, `skills/`, top-level docs, top-level scripts). No project-side actions.

## Task

### Issue 1: shorten dispatch-root naming

1. **Decide the new naming scheme.** Candidates:
   - `dispatches/<role>--<id>/` (~13 chars; preserves role-in-name for `ls`-time human eyeballing, drops purpose + timestamp).
   - `dispatches/<id>/` (6 chars; smallest; drops role too — journal entry IS the index).
   - Other shortening (e.g., abbreviate `dispatches/` to `d/`).
   
   The gardener picks. Document the rationale (path-length budget at typical test-slug sizes, audit-via-journal-not-dirname justification, any tradeoffs).

2. **Update `skills/dispatch-worktree/dispatch-prepare.sh`.** Rewrite the `NAME=` line and any references to `${PURPOSE}` / `${TS}` in the script. The script's stdout (the absolute path of the dispatch root) is the orchestrator's contract; the change is purely in what string the path's basename is.

3. **Update `skills/dispatch-worktree/dispatch-teardown.sh`** if it parses the directory name (likely it does not; it just receives the absolute path).

4. **Update every doc that names the current `<role>--<purpose>--<UTC-ts>--<id>` pattern**: `CLAUDE.md` § Dispatch contract, `WORKTREES.md` § Per-dispatch worktree triple, `skills/dispatch-worktree/SKILL.md`, `README.md` § Design § Dispatch contract (just added today).

5. **Update the dispatch prompt template in `CLAUDE.md`.** The template names `dispatch-root=<absolute path>` which is path-agnostic, but any example dispatch-root strings should be updated to the new shape.

6. **Leave existing dispatch directories alone.** Already-named directories stay on disk under their old names until torn down; the change is for *new* dispatches only. No retroactive rename.

### Issue 2: pin per-role identity in dispatch-prepare

7. **Decide the identity-pinning shape.** Candidates:
   - The dispatch-prepare script accepts an optional `<identity>` argument (`kriscendobot` or `kriskowal` per CLAUDE.md, defaulting to `kriscendobot`) and runs `git config user.name <name> && git config user.email <email>` inside each worktree (garden, journal, project).
   - The dispatch-prepare script always sets the bot identity (`kriscendobot`), and the boatman (the only role that uses the maintainer identity) overrides at commit-time per its existing `identity_switch_authorized: true` discipline.
   
   Option (b) is simpler. The boatman already opts-in explicitly. The gardener picks but should justify.

8. **Update `skills/dispatch-worktree/dispatch-prepare.sh`** to set the bot identity in each created worktree. The values likely live in a small lookup or hard-coded constants (`kriscendobot` / `main.barn5084@fastmail.com` per the current bot's commit history). If the maintainer's email and the bot's email are identical (which the #244 commit suggests), the only differentiator is the author *name*, which is what the dispatch-prepare must set.

9. **Update `roles/boatman/AGENT.md`** to call out the identity-override expectation: the boatman, when dispatched with `identity_switch_authorized: true`, must `git config user.name kriskowal` (and any email change) in the worktree before rewriting commits to the maintainer identity. Cite the new dispatch-prepare default in the role file.

10. **Update `roles/COMMON.md`** (or wherever the identity discipline currently lives) to name the new default: "every dispatch worktree pins the bot identity by default; only the boatman with explicit per-action authorization overrides."

11. **Surface a one-line `notes-from-the-field` row in `skills/dispatch-worktree/SKILL.md`** dated 2026-05-14 citing #244's discipline lapse as the precipitating evidence.

## Out of scope

- No retroactive history rewrite on the #244 commit (the kriskowal-authored prettier commit). Force-pushing a no-op author change is not worth the CI re-run cost.
- No PR edits on any external repo.
- No re-dispatch of existing in-flight subagents. Future dispatches pick up the new dispatch-prepare automatically.

## Commits

- One commit for the dispatch-root rename + all doc updates (the change is one logical unit).
- One commit for the identity-pinning change + all doc updates.

Push at end. Journal result entry.

## Report

≤ 400 words:
- The chosen dispatch-root scheme (with one-line rationale).
- The chosen identity-pinning shape (with one-line rationale).
- Files added or substantially revised (one line per).
- One-line confirmation that the next dispatch-prepare call produces a short dispatch root and pins the bot identity.
- One-line `Self-improvement: ...` per `skills/self-improvement/SKILL.md`.
