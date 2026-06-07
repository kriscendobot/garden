---
ts: 2026-06-07T05:54:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: builder
dispatch_root: /home/kris/dispatches/builder--f2fd55
refs:
  - https://github.com/endojs/endo/pull/3295
---

# dispatch: builder — validate lint-on-master claim via a no-changes PR

User directive (2026-06-07): *"Please create a PR that validates the
claim made in https://github.com/endojs/endo/pull/3295 that lint in
CI on master is currently broken, by creating a no-changes PR based
on actual/master and checking whether any failures occur in CI."*

The bot fork's `master` was synced to upstream's `4a04d078` earlier
this cycle (yesterday's fixer `f1c59f` ran `git push --force-with-
lease=master:... origin endo-upstream/master:master`). Bot master
at `4a04d078` IS the actual upstream master state. A no-changes PR
based on this master will exercise CI on what upstream calls
"master is broken" without any local content interfering with the
signal.

Upstream's PR endo#3295
(`fix(eslint-plugin): drop conflicting project parser option`) is
the fix being proposed; the user wants to validate the broken-state
hypothesis before the fix lands.

## State at dispatch time

- **Bot master** (`endojs/endo-but-for-bots@master`): `4a04d078`
  (in sync with `endojs/endo@master`).
- **Upstream PR `endo#3295`** head: `b3592c93` (the proposed fix).

## Task

In your `project/` worktree on bot master:

1. **Create a probe branch** off `origin/master`:
   `git checkout -b ci/validate-lint-master-20260607` (or a name
   the repo convention prefers; mechanical short slug is fine).
2. **Add an empty commit** (or a trivially-no-changes commit; for
   example, a comment-only update to a top-level doc that the
   workflow's `paths-ignore` does NOT exclude) so the PR has
   something to point at:
   - Preferred: `git commit --allow-empty -m "ci: validate lint on
     master (no-changes probe for endo#3295)"`.
   - Alternative if `--allow-empty` doesn't trigger CI: a single
     whitespace change to `README.md` or `.github/AGENTS.md`.
   The goal is a PR object that CI will exercise; the content
   itself must be a no-op so the lint state observed is
   master's, not the probe's.
3. **Push** the branch: `git push origin HEAD:ci/validate-lint-master-20260607`.
4. **Open the PR DRAFT**:
   ```
   gh pr create -R endojs/endo-but-for-bots --base master \
     --head ci/validate-lint-master-20260607 --draft \
     --title "ci: validate lint on master (probe for endo#3295)" \
     --body <body>
   ```
   Body should:
   - One-line statement of intent: "no-changes probe to validate
     upstream `endo#3295`'s claim that lint on master is broken".
   - Cite the upstream PR's URL.
   - Cite the bot master tip SHA (`4a04d078`) for traceability.
   - Note "expected outcome: lint fails; result confirms the
     upstream claim. If lint passes, the upstream PR's premise is
     wrong, or the master tip has moved past the broken state."
   - "Steward will close this PR after CI converges; do not merge."

## Authorizations (per-action, forwarded by steward)

- **Push** the probe branch. Implicit.
- **Open the DRAFT PR**. Implicit.
- **Post the draft-PR body** (`endo-but-for-bots` standing broad-
  comment authorization).

## Out of scope

- Do NOT shepherd CI to green. The goal is to OBSERVE the CI
  outcome, not fix it.
- Do NOT touch any source files in a substantive way.
- Do NOT merge or close the PR; the steward (or user) will do
  that once the validation signal is captured.

## Deliverable

A `result` entry under `journal/entries/2026/06/07/` naming:

- The probe branch name and tip SHA.
- The opened PR number and URL.
- The body text of the PR description.
- A `Self-improvement: ...` line.

A follow-on steward action after CI converges will record the
validation outcome in a separate result entry citing the
observed check states; you do not need to wait for CI yourself.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
