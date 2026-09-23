---
ts: 2026-06-03T03:21:12Z
kind: dispatch
role: liaison
host: endolinbot
repo: kriskowal/garden
project: garden
to: conductor
dispatch_root: /home/kris/dispatches/conductor--812315
prs:
  - repo: kriskowal/garden
    pr: 3
    role: target
refs:
  - https://github.com/kriskowal/garden/pull/3
  - https://github.com/kriskowal/garden/pull/3#pullrequestreview-4415169045
---

# dispatch: conductor — merge garden #3 onto main

Maintainer directive (kriskowal, review `4415169045`, APPROVED,
2026-06-03T03:19:57Z):

> Let's conduct this onto main.

Garden PR #3 is APPROVED. PR is DRAFT presently — the conductor
needs to un-draft (`gh pr ready 3`) before merge if the
PR-creation-flow chain didn't already do so (it didn't, since
this is garden's own PR and follows the design-PR exception).

## Per-action authorizations

- `gh pr ready 3 --repo kriskowal/garden` (un-draft) if needed.
  Authorized.
- Merge garden #3 onto main per the conductor's canonical merge
  norm. (Per memory `feedback_no_merge_method_in_conductor_
  prompts.md`, this dispatch does NOT name the merge method.
  Conductor decides.) Authorized.

## Not authorized

- Force-pushing main.
- Re-drafting.
- Closing without merging.
- Modifying any files outside what's needed for the un-draft +
  merge.

## Notes / non-blocking follow-ups

One inline comment landed with the APPROVED review at
`scripts/watcher/endo-but-for-bots/watcher.sh:1` (comment
`3345691562`):

> This can presumably be parameterized to a generic github
> watcher, on the repository org/name.

Non-blocking; the review is APPROVED. Suggestion for a future
refactor: rename `scripts/watcher/endo-but-for-bots/` to a
generic `scripts/watcher/github/` (or similar) that takes
`org/repo` as a runtime parameter. Surface this in your result
entry so the steward can queue a follow-up builder dispatch
post-merge.

## Garden-PR specifics

Garden has no PR workflow for its own repo as a rule
(`CLAUDE.md` § Conventions); garden designs are the named
exception. This is the first design PR going through merge.
Standard `gh pr merge` should work; if anything garden-meta
specific arises, surface it.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/conductor--812315/garden/roles/COMMON.md`
2. `/home/kris/dispatches/conductor--812315/garden/roles/conductor/AGENT.md`
3. Other skills referenced just-in-time.

Project worktree at `project/` on `design/driver` (head
`1ddf76235` per liaison's check).

## Report

A `result` journal entry. Include:

- Merge SHA on main.
- Merge method used.
- The follow-up watcher-parameterization note for the steward
  to queue.
- Whether you needed to un-draft first.
