---
ts: 2026-05-15T02:25:35Z
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

# Dispatch: fixer rebases #253 (broader package-uniformity), shepherds CI

Dispatch root: `dispatches/fixer--c48b01/`. Project worktree on `endojs/endo-but-for-bots@chore/package-uniformity-master` (head `8c4e0571`, base `master`).

Maintainer directive (2026-05-15): *"Please sync our mirror and shepherd through CI https://github.com/endojs/endo/pull/3258. Post a bulletin when done since I will need to ferry it back."*

#253 is our master-base broader package-uniformity PR (the build-uniformity work that broadens endo#3258's narrower SECURITY.md-only check). CI currently: 26 SUCCESS / 1 FAILURE. The fixer rebases on `endo-upstream/master`, addresses the failure, shepherds to green. Liaison adds a bulletin row for the maintainer's ferry from another session.

## Per-action authorization

Standing on endo-but-for-bots: push with `--force-with-lease=chore/package-uniformity-master:8c4e0571`.

## Task

1. Fetch `endo-upstream/master` (the bots bare's remote name for upstream endo).
2. `git rebase endo-upstream/master`. Resolve conflicts per skill (especially around the script + ci.yml hook).
3. Diagnose the 1 FAILURE: `gh pr view 253 -R endojs/endo-but-for-bots --json statusCheckRollup --jq '.statusCheckRollup | map(select(.conclusion=="FAILURE"))'`. Likely shape: a per-package drift the script catches that the original builder didn't fix, OR the rebase brings new packages that need their SECURITY.md / LICENSE / package.json fields aligned to skel.
4. **Per today's self-improvement** (filed at `015257Z`): commit + push BEFORE extended local validation.
5. Push with `--force-with-lease`.
6. Watch CI converge; treat `test-ocapn-guile-interop` as gating signal.

## Out of scope

- No upstream comment.
- No upstream ferry (the maintainer ferries from another session).

## Report

≤ 300 words: rebase outcome, failure diagnosis, fix shape, head SHA after push, CI status, one-line `Self-improvement: ...`. The liaison adds a bulletin row for ferry handoff.
