---
ts: 2026-05-15T03:14:29Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 107
    role: target
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: base
refs:
  - entries/2026/05/15/022448Z-message-liaison-ef7995.md
  - entries/2026/05/15/023109Z-result-fixer-186277.md
  - entries/2026/05/15/025204Z-result-fixer-346b46.md
---

# Dispatch: fixer rebases #107 + shepherds CI + retcons (multi-stage)

Dispatch root: `dispatches/fixer--2d2bbd/`. Project worktree on `endojs/endo-but-for-bots@design/random-pure-rand-v8-interface` (current head `d24a854d6` after today's earlier reshape).

Maintainer directive (2026-05-15): *"For https://github.com/endojs/endo-but-for-bots/pull/107, please make sure you have fetched actual, synced master, rebased and resolved conflicts. When it gets past the shepherd, retcon (per the retcon skill). Let me know when it's ready on the bulletin."*

Multi-stage sequence (single fixer dispatch handles all stages):

1. **Fetch + sync.** Fetch `endo-upstream` (the upstream `endojs/endo` remote on the bots bare). Sync the local `master` ref with `endo-upstream/master`. The bots-fork's `master` should track upstream master.

2. **Rebase #107 on its base.** #107's base is `kriskowal-random-chacha12` (= #75's branch). #75 was reverse-ferried earlier today and now has head `8eb479120` (per the recent fixer result at `025204Z-result-fixer-346b46.md`). Rebase #107 onto the current `kriskowal-random-chacha12` head.

3. **Resolve conflicts** per `skills/conflict-resolution/SKILL.md`. Likely areas: yarn.lock (regenerate), any API-shape conflicts with the new random/chacha12 final form (the earlier reshape fixer already aligned to it; this rebase verifies and re-aligns if needed).

4. **Push** with `--force-with-lease=design/random-pure-rand-v8-interface:d24a854d6`.

5. **Shepherd** — watch CI converge to green via `gh pr checks 107 --watch`. Treat `test-ocapn-guile-interop` as gating signal.

6. **When CI green: retcon** per `skills/retcon/SKILL.md`. Sensibly-grouped commits: one per affected package, separate `chore: Update yarn.lock`, conventional-commit messages, implementation+test combined. Reset to base, restage in clean commit shape, verify net-diff invariance, force-push.

7. **Liaison adds the bulletin row** once retcon completes and CI re-converges green on the retconned shape. Fixer reports back; liaison handles the bulletin.

## Per-action authorization

Standing on endo-but-for-bots: force-push to `design/random-pure-rand-v8-interface`. READ-ONLY on `endojs/endo`.

## Per today's self-improvement

(Filed at `015257Z`): commit + push BEFORE extended local validation at every push point. If the dispatch's session ends mid-validation, the bytes survive in origin.

## Out of scope

- No comment on #107.
- No upstream interaction.
- No un-draft.

## Report

≤ 500 words: rebase outcome (conflicts encountered), shepherd outcome (CI status), retcon outcome (final commit list with one-line per commit), net-diff invariance verified (yes/no), head SHA after retcon push, one-line `Self-improvement: ...`. The liaison adds the bulletin row from this report.
