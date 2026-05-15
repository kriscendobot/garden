---
ts: 2026-05-15T03:42:00Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 258
    role: target
---

# Dispatch: weaver changes #258 base from llm to master, rebases on actual/master

Dispatch root: `dispatches/weaver--f02db9/`. Project worktree on `endojs/endo-but-for-bots@ci/ocapn-guile-interop-resilience-iii` (current head `19959e999`).

Maintainer directive (2026-05-15): *"Please change the merge base from llm to master and rebase on actual/master (which should be in sync with local master). https://github.com/endojs/endo-but-for-bots/pull/258"*

#258 is `ci(ocapn-guile-interop): cache the Guix runtime store across runs (iteration III)`. Currently based on `llm`; should be based on `master`.

Note: local `master` (`c2fc02eb`) is currently behind `endo-upstream/master` (`0ec70c6dd`). The first step is fetch + sync local master, then rebase.

## Task

1. **Fetch upstream + sync local master.** `git fetch endo-upstream master` then update local `master` ref to point at `endo-upstream/master`. (The bare's `master` should track upstream; the multi-stage fixer for #107 is doing the same fetch concurrently — fetch is idempotent.)

2. **Change PR base.** `gh pr edit 258 -R endojs/endo-but-for-bots --base master`. This updates GitHub's view of the merge base.

3. **Rebase locally onto the new master.** From the project worktree on `ci/ocapn-guile-interop-resilience-iii`:
   - `git fetch endo-upstream master`
   - `git rebase endo-upstream/master` (= the synced local master content)
   - Resolve conflicts per `skills/conflict-resolution/SKILL.md`. Likely: `.github/workflows/test-ocapn-guile-interop.yml` if other PRs have touched it on master.

4. **Per today's self-improvement** (filed at `015257Z`): commit + push BEFORE extended local validation.

5. **Push** with `--force-with-lease=ci/ocapn-guile-interop-resilience-iii:19959e999412501b21a699ec88201af65ac02813 origin HEAD:refs/heads/ci/ocapn-guile-interop-resilience-iii`.

6. **Watch CI converge** via `gh pr checks 258 --watch`. `test-ocapn-guile-interop` is the gating signal (the very thing this PR is iterating to make resilient).

## Per-action authorization

Standing on endo-but-for-bots: change PR base + force-push to `ci/ocapn-guile-interop-resilience-iii`. READ-ONLY on `endojs/endo`.

## Out of scope

- No comment on #258.
- No upstream interaction.
- No code changes to the resilience logic (rebase + base change only).
- No un-draft (#258 is already non-draft).

## Report

≤ 300 words: base-change outcome, rebase outcome (conflicts encountered + resolution), head SHA after push, CI status, one-line `Self-improvement: ...`. The liaison updates the bulletin row for #258.
