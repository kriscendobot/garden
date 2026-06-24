---
ts: 2026-05-15T02:43:11Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 244
    role: target
  - repo: endojs/endo
    pr: 3263
    role: source
---

# Dispatch: fixer syncs #244 from upstream #3263 (reverse-ferry), shepherds CI

Dispatch root: `dispatches/fixer--e72e0c/`. Project worktree on `endojs/endo-but-for-bots@chore/eslint-numeric-separators-style-master` (current head `746beaf4`).

Maintainer directive (2026-05-15): *"Please sync https://github.com/endojs/endo/pull/3263 back to https://github.com/endojs/endo-but-for-bots/pull/244 and shepherd through CI, then post to bulletin."*

#3263 is the upstream-side version of #244 (`chore(eslint-plugin): require underscore-delimited groups in numeric literals`, branch `kriskowal-eslint-numeric-separators-style` on `endojs/endo`, currently at head `b583f925`, authored by kriskowal). The maintainer presumably applied review feedback / edits on the upstream branch; sync those back to our bots-side mirror so they stay in lockstep.

## Per-action authorization

Standing on endo-but-for-bots: force-push to `chore/eslint-numeric-separators-style-master` with `--force-with-lease=chore/eslint-numeric-separators-style-master:746beaf4`. READ-ONLY on `endojs/endo`.

## Task

1. **Fetch the upstream branch** into the worktree: `git fetch endo-upstream kriskowal-eslint-numeric-separators-style` (the bots bare's remote is named `endo-upstream`; the branch is now available locally per the liaison's pre-fetch).

2. **Decide sync shape**. Two approaches:
   - **Reset to upstream content**: `git reset --hard endo-upstream/kriskowal-eslint-numeric-separators-style`. Pure mirror — bot-side branch's commits are replaced wholesale by upstream's. Simplest if the bot's `endolinbot`-authored commits don't need to be preserved.
   - **Rebase keeping bot-side commits on top**: rebase any bot-side-only commits onto upstream. Right when there are bot-side-specific edits to retain.
   
   Inspect both branches' commit histories (`git log --oneline 746beaf4` and `git log --oneline endo-upstream/kriskowal-eslint-numeric-separators-style`) to decide. If the bots-side branch has commits not on upstream (e.g., the prettier-format fix from earlier today), preserve them; if the upstream branch is a superset of the bots-side, reset.

3. **Per today's self-improvement** (filed at `015257Z`): commit + push BEFORE extended local validation.

4. **Push** with `--force-with-lease=chore/eslint-numeric-separators-style-master:746beaf4 origin HEAD:refs/heads/chore/eslint-numeric-separators-style-master`.

5. **Watch CI converge.** `test-ocapn-guile-interop` is a gating signal (broadcast retired).

## Out of scope

- No comment on #244 or upstream #3263.
- No upstream interaction (the maintainer's ferry direction is upstream-to-bot here, but the reverse-ferry doesn't go back up).
- No un-draft (#244 is already non-draft).

## Report

≤ 300 words: sync shape (reset vs rebase), commits absorbed from upstream (one line per), bot-side commits preserved (if any), head SHA after push, CI status, one-line `Self-improvement: ...`. The liaison adds/updates a bulletin row for the post-sync state.
