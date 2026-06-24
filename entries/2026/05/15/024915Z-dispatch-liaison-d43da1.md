---
ts: 2026-05-15T02:49:15Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 253
    role: target
  - repo: endojs/endo
    pr: 3258
    role: source
---

# Dispatch: fixer ferries #3258 back to #253 (reverse-ferry), shepherds CI

Dispatch root: `dispatches/fixer--d43da1/`. Project worktree on `endojs/endo-but-for-bots@chore/package-uniformity-master` (current head `56f9d425`).

Maintainer directive (2026-05-15): *"Please ferry https://github.com/endojs/endo/pull/3258 back and shepherd through CI, then post a bulletin since I will need to ferry it back."*

Reverse-ferry: upstream→bot. Upstream `endojs/endo#3258` was force-pushed; new title is `chore: enforce general package uniformity across workspace` (head `e98151eda`). Our bot-side #253 has the broader package-uniformity work at `56f9d425`; the upstream now matches the broader scope (the maintainer adopted our work upstream and may have applied edits).

Sync upstream's content back to bot-side; shepherd to green; bulletin row for the maintainer to re-ferry.

## Per-action authorization

Standing on endo-but-for-bots: force-push to `chore/package-uniformity-master` with `--force-with-lease=chore/package-uniformity-master:56f9d425`. READ-ONLY on `endojs/endo`.

## Task

1. **Inspect both branches' divergence**: `git log --oneline 56f9d425` and `git log --oneline endo-upstream/chore/security-md-uniformity` (which is now at `e98151eda` post the maintainer's force-push). Compute merge-base + per-side new commits.

2. **Decide sync shape**:
   - **Reset to upstream**: if trees match modulo commit-boundary changes (same pattern as the #244 reverse-ferry earlier today).
   - **Rebase**: if bot-side has commits worth preserving on top.
   
   The maintainer's "ferry back" framing suggests reset; the upstream branch is the authoritative shape now.

3. **Per today's self-improvement** (filed at `015257Z`): commit + push BEFORE extended local validation.

4. **Push** with `--force-with-lease`.

5. **Watch CI converge**; treat `test-ocapn-guile-interop` as gating signal.

## Out of scope

- No comment on #253 or upstream #3258.
- No upstream re-ferry from this dispatch (the maintainer ferries from another session per the directive).

## Report

≤ 300 words: sync shape, commits absorbed, bot-side commits preserved (if any), conflicts encountered, head SHA after push, CI status, one-line `Self-improvement: ...`. The liaison adds the bulletin ferry row.
