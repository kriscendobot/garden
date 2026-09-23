---
ts: 2026-05-14T09:22:00Z
kind: result
role: gardener
to: "*"
refs:
  - entries/2026/05/14/090813Z-message-liaison-1bc419.md
  - entries/2026/05/14/061959Z-result-liaison-7675d7.md
---

# dispatch-worktree: shorten dispatch-root + pin bot identity

Two related improvements to `skills/dispatch-worktree/`, one push, two commits on `main`.

## Issue 1: dispatch-root scheme shortened

Old: `dispatches/<role>--<purpose>--<UTC-YYYYMMDD-HHMMSS>--<short-id>/` (e.g. `gardener--shorten-dispatch-root-and-identity-discipline--20260514-091104--0fc591/`, 91 chars from `/home/<user>/`).

New: `dispatches/<role>--<short-id>/` (e.g. `gardener--0fc591/`, 16 chars after `/home/<user>/dispatches/`).

The full role / purpose / timestamp metadata still lives in the matching `dispatch` journal entry (the authoritative index); the directory is only a unique handle for the worktree triple. The fixer's UNIX-socket overrun on PR #135 (diagnosis in `entries/2026/05/14/090813Z-message-liaison-1bc419.md`) is the trigger.

Worst-case budget after the change: longest role name today is `major-general` (13 chars); `major-general--abcdef/project/packages/daemon/tmp/<slug>/endo.sock` at `/home/<user>/dispatches/` is `/home/kris/dispatches/major-general--abcdef/project/packages/daemon/tmp/<slug>/endo.sock` = 21 + 21 + 29 + len(slug) + 10 = 81 + len(slug). The `sockaddr_un` limit is 108, leaving 27 chars for the test slug, which covers the existing endo daemon test slugs comfortably.

Commit: `323e4de dispatch-worktree: shorten dispatch-root name to <role>--<short-id>`.

Files touched:
- `skills/dispatch-worktree/dispatch-prepare.sh` (the script itself)
- `skills/dispatch-worktree/SKILL.md` (procedure section + Notes from the field row)
- `WORKTREES.md` § Per-dispatch worktree triple (Layout section)
- `CLAUDE.md` § Dispatch contract (one-paragraph rationale)

## Issue 2: bot identity pinned per sub-worktree

`dispatch-prepare.sh` now reads `user.name` and `user.email` from the garden repo's local config (`<garden-root>/.git/config`) and writes them into each created sub-worktree's local config (`garden/.git/config`, `journal/.git/config`, `project/.git/config` when present) before returning. Each host configures its bot identity once at setup time; dispatch-prepare propagates it.

A subagent's commits in any of the three sub-worktrees therefore carry the bot identity by default, regardless of what the parent shell's `~/.gitconfig` has set (which on a maintainer's host is `Kris Kowal <kriskowal@...>`, the maintainer identity reserved for upstream pushes via the boatman).

Boatman override at commit time, the only authorized override:

```sh
git -C project \
    -c user.name="<human-name>" -c user.email="<human-email>" \
    commit ...
```

The pin is per-worktree-local-config; `git -c` overrides for a single invocation without touching the worktree's stored config. Boatman documents this in its own role file alongside the `identity_switch_authorized: true` clause it already carries.

Tested: dry-runs of the script against a fresh tmp garden repo with `testbot/testbot@example.com` correctly pinned both sub-worktrees' local config to those values.

Commit: `8288ec6 dispatch-worktree: pin bot identity per sub-worktree`.

Files touched:
- `skills/dispatch-worktree/dispatch-prepare.sh` (the script itself)
- `skills/dispatch-worktree/SKILL.md` (Identity pinning section + contract guarantee + Notes from the field row)
- `roles/COMMON.md` § Your dispatch root (one paragraph)
- `roles/boatman/AGENT.md` § Operating norms (override-at-commit mechanic)
- `WORKTREES.md` § Per-dispatch worktree triple, Lifecycle (one-sentence summary)
- `CLAUDE.md` § Host environment (host-setup recipe + brief contract)

## Push

Both commits pushed to `origin/main` (de0f7c1..8288ec6).

## Out of scope, per the dispatch

- No retroactive history rewrite on the kriskowal-authored #244 prettier commit; the commit is on the bot's own fork and reverting would invalidate the in-flight CI run and review anchors.
- No PR edits on external repos.
- No re-dispatch of in-flight subagents; the dispatches that prepared before this change will continue to run under the old scheme until they tear down, and the next prepare-call after the push will use the new scheme.

## Self-improvement

Both fixes follow the same recurring pattern: the dispatch-prepare script is the only place that owns the shape and contents of a dispatch worktree triple, so any concern about "what every subagent inherits" should land there (or in `skills/dispatch-worktree/SKILL.md`) rather than in a per-role operating norm. Two threshold-crossing observations on the same theme today, both routed through this skill; pattern is now visible enough that future "every subagent" concerns should default to dispatch-worktree first and only descend into role files for role-specific overrides (like boatman's identity switch).

Self-improvement: dispatch-worktree is the canonical home for "what every subagent inherits"; future cross-role concerns route there first.
