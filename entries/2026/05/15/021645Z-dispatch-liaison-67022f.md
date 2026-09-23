---
ts: 2026-05-15T02:16:45Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 244
    role: target
  - repo: endojs/endo-but-for-bots
    pr: 243
    role: source-of-content
---

# Dispatch: fixer rebases #244 on actual/master, fixes lint, shepherds CI

Dispatch root: `dispatches/fixer--67022f/`. Project worktree on `endojs/endo-but-for-bots@chore/eslint-numeric-separators-style-master` (head `9686ce25`).

Maintainer directive (2026-05-15): *"Please dispatch to sync our mirror of [endojs/endo-but-for-bots#243], rebase on actual/master, and shepherd through CI. There is a lint error. Post to bulletin when done, since I will need to dispatch a ferry from another session."*

#244 is the master-base mirror of #243 (which is on llm). The user said #243; the rebase-on-actual/master + ferry framing fits #244 (the master-base version is what ferries upstream).

#244's head `9686ce25` has not moved since 06:13Z. The upstream `endo-upstream/master` has advanced substantially since (including the SECURITY.md uniformity ferry, #3262 guile resilience, eslint-plugin-import-x migration upstream). A rebase picks up all of that.

## Per-action authorization

Standing on endo-but-for-bots: push with `--force-with-lease` to `chore/eslint-numeric-separators-style-master`. No upstream interaction.

## Task

1. **Fetch** `endo-upstream/master` from the bots bare (`git fetch endo-upstream master`).
2. **Rebase** `git rebase endo-upstream/master` onto the branch. Resolve conflicts per `skills/conflict-resolution/SKILL.md`.
3. **Investigate the lint error.** The maintainer flagged a lint failure. Run `yarn lint` locally; capture the specific error. Fix it. Common shapes for this PR (the underscored-thousands autofix): prettier-format drift on previously-autofixed files, or a per-file rule conflict.
4. **Per today's self-improvement** (filed at `015257Z`): commit + push BEFORE extended local validation. The retcon-weaver and earlier prettier-fix recoveries both leaned on this.
5. **Push** with `--force-with-lease=chore/eslint-numeric-separators-style-master:9686ce25 origin HEAD:refs/heads/chore/eslint-numeric-separators-style-master`.
6. **Watch CI converge.** `gh pr checks 244 --watch`. Treat `test-ocapn-guile-interop` as a gating signal (broadcast retired). All other checks should pass.
7. **Report back to the liaison** — the liaison will add the bulletin row for the ferry handoff.

## Out of scope

- No comment on #244 or upstream.
- No upstream ferry from this dispatch (the maintainer ferries from another session per the directive).
- No un-draft (the maintainer-side review proceeds after the bulletin row).

## Report

≤ 300 words: rebase outcome (conflicts), lint error + fix shape, head SHA after push, CI status, one-line `Self-improvement: ...`. The liaison adds a bulletin row pointing at the ready-for-ferry state.
