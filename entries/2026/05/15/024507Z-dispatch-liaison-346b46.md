---
ts: 2026-05-15T02:45:07Z
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

# Dispatch: fixer syncs #75 from upstream #3232 (reverse-ferry), rebases, resolves conflicts, pre-ferry

Dispatch root: `dispatches/fixer--346b46/`. Project worktree on `endojs/endo-but-for-bots@kriskowal-random-chacha12` (current head `5382bf3e`).

Maintainer directive (2026-05-15): *"Please sync https://github.com/endojs/endo/pull/3232 back to https://github.com/endojs/endo-but-for-bots/pull/75 and rebase, resolve conflicts, and post to bulletin so I can ferry."*

#3232 is the upstream chacha12 PR (branch `kriskowal-random-chacha20` on `endojs/endo`, head `f87bf8425`, force-pushed since last fetch). The maintainer presumably has edits on the upstream side that need to come back to our bots-side #75. Reverse-ferry shape: upstream→bot.

The bots bare's `endo-upstream/kriskowal-random-chacha20` is now at `f87bf8425` (force-fetched).

## Per-action authorization

Standing on endo-but-for-bots: force-push to `kriskowal-random-chacha12` with `--force-with-lease=kriskowal-random-chacha12:5382bf3e`. READ-ONLY on `endojs/endo`.

## Task

1. **Inspect both branches' divergence**: `git log --oneline endo-upstream/kriskowal-random-chacha20` and `git log --oneline 5382bf3e`. Compute the merge-base and the per-side new commits.

2. **Decide sync shape** (gardener-style choice):
   - **Reset to upstream**: `git reset --hard endo-upstream/kriskowal-random-chacha20` — replaces bot-side content wholesale with upstream's (the maintainer's latest edits become canonical).
   - **Rebase bot-side onto upstream**: preserves bot-side-only commits (e.g., today's earlier fixer commit `b0d9f31ce` simplifying the magic-multiplier test) on top of upstream's head.
   
   The user said "rebase, resolve conflicts" — that strongly suggests the rebase path. Apply rebase semantics: bring upstream's history forward, then replay any bot-side-only commits on top.

3. **Resolve conflicts** per `skills/conflict-resolution/SKILL.md`. yarn.lock conflicts: regenerate via `yarn install`. Source conflicts: read both sides; the bot-side commits represent feedback applied to the bot-side (e.g., the simplified test) — keep those on top unless upstream supersedes them.

4. **Per today's self-improvement** (filed at `015257Z`): commit + push BEFORE extended local validation.

5. **Push** with `--force-with-lease`.

6. **Watch CI converge**; treat `test-ocapn-guile-interop` as gating signal.

## Out of scope

- No comment on #75 or upstream #3232.
- No upstream ferry from this dispatch (the maintainer ferries from another session per the directive).

## Report

≤ 300 words: sync shape (reset vs rebase), commits absorbed from upstream (one line per), bot-side commits preserved (if any), conflicts encountered, head SHA after push, CI status, one-line `Self-improvement: ...`. The liaison adds the ferry bulletin row.
