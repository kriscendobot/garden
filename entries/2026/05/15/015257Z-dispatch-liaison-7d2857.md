---
ts: 2026-05-15T01:52:57Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: target
---

# Dispatch: weaver rebases #109 on actual/master, then retcons the commits

Dispatch root: `dispatches/weaver--7d2857/`. Project worktree on `endojs/endo-but-for-bots@feat/syrups-package` (current head `6917e083`, base `master`).

Maintainer directive at [#109 issuecomment-4456197902](https://github.com/endojs/endo-but-for-bots/pull/109#issuecomment-4456197902) (2026-05-15T01:52:03Z): *"Please rebase on actual/master for the guile CI job fix. Then retcon the commits."*

Two-step sequence using the verbs encoded today:

1. **Weave (rebase) on `actual/master`** — the upstream `endojs/endo:master` (the bots bare's remote is named `endo-upstream`). The guile CI job fix landed upstream as #3262 (`ci(ocapn-guile-interop): reorder substitute servers and widen sturdyref wait`, tip `0ec70c6dd`); rebasing #109 onto upstream master picks that up.
2. **Retcon** the rebased commits per `skills/retcon/SKILL.md`. Sensibly-grouped: one commit per affected package, separate `chore: Update yarn.lock`, conventional-commit messages, implementation+test combined.

Per the retcon skill's disambiguation note: "when the maintainer wants both, weave first then retcon" — the order in the directive is correct.

## Per-action authorization

Standing on endo-but-for-bots: push to `feat/syrups-package` with `--force-with-lease` (retcon requires force-push by nature; the lease anchor is `6917e083`). No upstream interaction (the rebase pulls from `endo-upstream/master` but pushes only to the bots-fork's own branch).

## Task

### Step 1 — Weave

1. Fetch `endo-upstream/master` from the bots bare (`git fetch endo-upstream master`).
2. `git rebase endo-upstream/master` onto `feat/syrups-package`. Conflict-resolve per `skills/conflict-resolution/SKILL.md` if needed.
3. Verify the rebased head includes the upstream Guile-interop resilience commit (`0ec70c6dd` ancestor).
4. Run `yarn install` (if needed) so the lockfile is in sync with the new base.

### Step 2 — Retcon

5. Read `skills/retcon/SKILL.md` for the procedure. Reset to merge-base (or upstream master, since that's the new base after the weave), keeping net diff as working tree.
6. Re-stage in sensibly-grouped commits:
   - One commit per affected package (typical scope: `@endo/syrup-frame`, `@endo/ocapn`, possibly others touched by #109).
   - Separate `chore: Update yarn.lock` commit.
   - Conventional-commit messages.
   - Implementation+test combined per package (single commit per package).
7. Verify net diff is invariant: `git diff <pre-retcon-SHA> HEAD` should be empty. The retcon skill names this as load-bearing.

### Step 3 — Push and report

8. `git push --force-with-lease=feat/syrups-package:6917e083 origin HEAD:refs/heads/feat/syrups-package`.
9. Watch CI on the new tip. `test-ocapn-guile-interop` should now pass (the upstream fix is in the new base).

## Out of scope

- No comment on #109 from this dispatch beyond the inline-reactji already posted from the liaison side.
- No upstream-side interaction.
- No re-request kriskowal review (the review state advances naturally on the new push).

## Report

≤ 300 words: rebase result (conflicts encountered, count), final commit list after retcon (one line per commit), net-diff-invariance verified (yes/no), head SHA after push, CI status (especially the guile-interop check), one-line `Self-improvement: ...` per `skills/self-improvement/SKILL.md`.
