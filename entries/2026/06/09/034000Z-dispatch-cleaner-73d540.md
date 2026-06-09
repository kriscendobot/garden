---
ts: 2026-06-09T03:40:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: cleaner
dispatch_root: /home/kris/dispatches/cleaner--73d540
prs:
  - repo: endojs/endo-but-for-bots
    pr: 60
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/60
  - https://github.com/endojs/endo-but-for-bots/pull/60#issuecomment-4655723320
---

# dispatch: cleaner — first stage of "rerun the improved gamut" on PR #60 (kriskowal directive)

User directive (kriskowal at-mention at 2026-06-09T03:21:48Z on PR #60,
issue comment `4655723320`):

> @kriscendobot This is pretty old. Please rerun the improved gamut.

PR #60 has been OPEN since 2026-04-27 with all CI green and no
review decision. The "improved gamut" framing per the orchestrator
vocabulary table (CLAUDE.md): *"the PR-creation-flow chain end to
end (skills/pr-creation-flow/SKILL.md). Reads PR #N's
next-stage-owed and dispatches the chain's stages sequentially
until termination."*

This dispatch is the **cleaner stage** — the chain's entry point
for a re-run. The steward dispatches subsequent stages (barrister
panel → fixer-loop → justice re-runs → un-draft if applicable)
based on the cleaner's findings.

The 👀 reactji is already on the maintainer's comment
(`reactions/367408568`); surveillance ack is in place.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#60`
  ("test(ses): replace deleted get-intrinsics test (closes #390)"),
  OPEN (not DRAFT), base `master`, head `design/issue-390-intrinsics-test`
  at `6744ef559fcc36f6e8255a29d7e3c283edf7764b` (`6744ef559`).
  `mergeable: MERGEABLE`, `mergeStateStatus: CLEAN`, `reviewDecision`
  empty (never reviewed).
- **CI**: all 26 checks SUCCESS (lint, build, test 18/20/22/24 ×
  ubuntu/macos, test-async-hooks, cover, test262, test-hermes,
  check-action-pins, viable-release, test-xs, test-ocapn-python).
  Convergent on this head; no shepherd needed at this stage.
- **Maintainer framing**: "pretty old" + "improved gamut" — the
  gamut has matured since this PR landed (panel kinds split into
  solicitor/barrister/justice on 2026-05-21, conductor
  unfreeze-before-merge rule landed 2026-06-06, etc.). The PR
  deserves a modern re-pass.

## Task

In your `project/` worktree on the `design/issue-390-intrinsics-test`
branch (currently at `6744ef559`):

1. **Read `garden/skills/pre-pr-checklist/SKILL.md` and
   `garden/skills/pr-formation/SKILL.md`** to refresh the modern
   PR hygiene standards. The PR predates several of these skills'
   current shape.
2. **Audit the PR body** (4041 chars per state probe) against the
   pr-formation skill. Check: summary present and accurate; what-
   lands enumeration matches the diff; regression-evidence section
   present and grounded; reviewer notes present; no stale
   references to mid-flight investigation framing. The PR closes
   issue #390 — confirm the closes-issue link survives any rewrite.
3. **Audit the diff** against the modern hygiene skills:
   - `garden/skills/changeset-discipline/SKILL.md`
   - `garden/skills/rename-discipline/SKILL.md`
   - `garden/skills/em-dash-style/SKILL.md`
   - `garden/skills/no-latin-shorthand/SKILL.md`
   - `garden/skills/relative-paths/SKILL.md`
   - `garden/skills/test-title-spec-spelling/SKILL.md`
   The PR is a single test-file replacement (per its title) so the
   audit surface should be small.
4. **Rebase on current `master`** if `git fetch origin master &&
   git merge-base --is-ancestor origin/master HEAD` reports the
   branch is behind. The PR base is the live `master` branch (not
   a frozen-base), so a rebase is the natural form. Resolve
   conflicts per `garden/skills/conflict-resolution/SKILL.md` if
   any arise (none expected given the merge state CLEAN).
5. **Commit your hygiene changes** with conventional-commit messages
   scoped per the kind of change. PR-body edits don't take a
   commit (use `gh pr edit`); diff-level cleanups each get their
   own conventional commit, batched by category. Per the maintainer's
   "improved gamut" framing, don't fold multiple hygiene categories
   into one mega-commit — each category gets its own commit so the
   panel can read the trail.
6. **Push** to `design/issue-390-intrinsics-test`. Append push if
   no rebase; force-with-lease push (lease anchor `6744ef559`) if
   a rebase moved the branch.
7. **Post a short top-level comment** on PR #60 summarizing the
   hygiene-pass findings (what was already clean; what was tightened;
   any structural concerns surfaced for the next-stage panel) and
   naming the new head SHA. End the comment with one line:
   "Next stage: barrister panel."

## Authorizations (per-action, forwarded by steward)

- **Push commits** to `design/issue-390-intrinsics-test` (append OR
  force-with-lease against `6744ef559`). Implicit in the cleaner
  dispatch.
- **Edit the PR body** via `gh pr edit` if structural rewrite is
  warranted. The cleaner role's standing PR-formation authority
  covers this.
- **Top-level summary comment** on PR #60. Standing
  `endo-but-for-bots` broad-comment authorization.

## Out of scope

- Do NOT request review or un-draft transitions (the PR is already
  not-draft; the gamut chain's other stages own those transitions).
- Do NOT touch CI workflow files or the .github/ tree.
- Do NOT enlarge the PR's substance beyond hygiene; the
  maintainer's framing is "rerun the improved gamut", not "expand
  the PR". Substance additions need a separate fixer or builder
  dispatch.
- Do NOT mark the PR DRAFT just to trigger the gamut. The chain
  runs against non-draft PRs too; the gamut's terminal step
  (un-draft via judge) is a no-op here.

## Deliverable

A `result` entry under `journal/entries/2026/06/09/` naming:

- Pre/post branch tip SHAs (and whether a rebase moved the branch).
- The hygiene-pass commits (SHA + scope per commit).
- PR-body edits made (before/after diff summary).
- Per-skill audit results: passed | tightened-and-now-passes |
  needs-panel-attention (with brief note).
- The top-level summary comment URL.
- **Recommended next stage** (most likely `barrister` panel, but
  state explicitly so the steward dispatches cleanly).
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator dispatches the next gamut stage (barrister panel) and
tears down your dispatch root on return.
