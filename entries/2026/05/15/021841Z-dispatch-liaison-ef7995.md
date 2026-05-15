---
ts: 2026-05-15T02:18:41Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 107
    role: target
---

# Dispatch: weaver rebases #107 (pure-rand v8 adapter) on its final base

Dispatch root: `dispatches/weaver--ef7995/`. Project worktree on `endojs/endo-but-for-bots@design/random-pure-rand-v8-interface`.

Maintainer directive (2026-05-15): *"Please dispatch a rebase on https://github.com/endojs/endo-but-for-bots/pull/107 and shepherd through CI. The underlying random and chacha12 libraries merged and are in their final forms, so we can reshape this fastcheck package."*

#107's current base is `kriskowal-random-chacha12` (the bots-side #75 branch). #75 has its final-form code at head `b0d9f31c` post today's CR fixer. The user's framing implies #107 should rebase onto the current `kriskowal-random-chacha12` head to pick up the final random+chacha12 API.

## Per-action authorization

Standing on endo-but-for-bots: push with `--force-with-lease` to `design/random-pure-rand-v8-interface`.

## Task

1. Fetch `origin/kriskowal-random-chacha12` (the current #75 head).
2. `git rebase origin/kriskowal-random-chacha12` onto the branch.
3. Resolve conflicts per `skills/conflict-resolution/SKILL.md`. The reshape the user mentions ("we can reshape this fastcheck package") may surface as code-level conflicts where the old #107 used pre-final random/chacha12 API and the new base has the final shape.
4. **Per today's self-improvement** (filed at `015257Z`): commit + push BEFORE extended local validation. Bytes survive in origin if the dispatch ends mid-validation.
5. Push with `--force-with-lease`.
6. Watch CI; treat `test-ocapn-guile-interop` as gating signal (broadcast retired).

## Note on "reshape"

The maintainer mentioned reshape — substantive code-level work to align the fastcheck package with the final random/chacha12 API. If the rebase reveals API mismatches the weaver cannot mechanically resolve, surface them as a `message` to liaison and stop. A follow-up fixer dispatch handles the reshape; the weaver's job is the rebase.

## Out of scope

- No major code reshape beyond what's required by the rebase conflicts. The weaver mechanically resolves; substantive reshape is the fixer's surface.
- No upstream interaction.

## Report

≤ 300 words: rebase outcome, head SHA after push, conflicts encountered (one line per), reshape warranted (yes/no), CI status, one-line `Self-improvement: ...`.
