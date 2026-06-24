---
ts: 2026-05-15T03:37:30Z
kind: dispatch
role: steward
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: target
refs:
  - entries/2026/05/15/033624Z-result-fixer-3bae7e.md
---

# Dispatch: fixer rebases PR #75 onto current master + shepherds CI (per maintainer directive)

Dispatch root: `dispatches/fixer--a7435a/`. Project worktree on `endojs/endo-but-for-bots@kriskowal-random-chacha12`.

## The directive

Maintainer at ~03:30Z: "https://github.com/endojs/endo-but-for-bots/pull/75 needs attention. The merge base shifted under it, so we need to make sure master is in sync and rebase. We also need to shepherd through CI."

`master` is already in sync as of `fixer--3bae7e` at 03:36Z (ferried `endo-upstream/master` → `origin/master`, head now `0ec70c6dd`, 31 commits brought in). The rebase + shepherd remain.

## Per-action authorization

- Rebase `kriskowal-random-chacha12` onto `origin/master @ 0ec70c6dd`. Force-push under kriscendobot identity (the bot owns the commits — author is kriscendobot per `gh pr view 75`).
- Shepherd: watch CI runs; if any flake matches the `test-ocapn-guile-interop` substitute-server signature (covered by the shepherd-ignore broadcast at `013250Z-message-steward-bf3c7e.md`), treat that check as pass-equivalent. For genuine flakes, re-run; for genuine failures, surface as a `message` back to steward.

## Task

### Step 1 — Rebase

- `git fetch origin master kriskowal-random-chacha12`
- `git checkout --detach origin/kriskowal-random-chacha12`
- `git rebase origin/master`. Resolve any conflicts surfacing from the upstream sync.
- If conflicts exceed your confidence, stop at impasse and surface back with the conflict list.
- `git push origin HEAD:kriskowal-random-chacha12 --force-with-lease`.

### Step 2 — Shepherd

Per `skills/pr-ci-watch/SKILL.md` (or equivalent shepherd discipline):

- After push, wait for CI to trigger. Use `gh pr checks 75 -R endojs/endo-but-for-bots --watch` or poll-equivalent.
- If `test-ocapn-guile-interop` fails: pass-equivalent per the standing shepherd-ignore broadcast (in force until #258 merges).
- If other check fails as transient (esvu install error, network glitch, etc.): `gh run rerun --failed`.
- If genuine failure (logic error from rebase, test regression from upstream changes): stop at impasse, surface with the failing test name + log excerpt.
- If all gating checks green (modulo the standing ignore): report DONE.

## Conflict handling

- Conflicts in `packages/random/**` or `packages/chacha12/**`: these are #75's own surfaces; hand-resolve to preserve PR intent.
- Conflicts in other packages: prefer upstream verbatim if change is package-level cleanup; surface impasse if substantive.

## Out of scope

- No edit to PR title/body unless rebase forces it (it doesn't).
- No retcon (the maintainer didn't ask; the rebase is straight-line).
- No comment on PR #75 unless reporting impasse.

## Commits

- N rebased commits (preserving authors per upstream history).
- Single force-push with lease pinned to the current head SHA.

## Report

≤ 500 words. Number of rebased commits, conflict count, any rerun actions taken in the shepherd step, final CI state (green / blocked-by-shepherd-ignore / impasse), final head SHA on `kriskowal-random-chacha12`, and one-line `Self-improvement: ...`.
