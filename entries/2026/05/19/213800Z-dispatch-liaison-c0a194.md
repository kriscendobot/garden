---
ts: 2026-05-19T21:38:00Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: investigator
refs:
  - https://github.com/endojs/endo-but-for-bots/issues/260
prs:
  - repo: endojs/endo-but-for-bots
    issue: 260
    role: source
---

# Dispatch: investigator isolates suspected macos-15 CI flake per maintainer ask on #260

Dispatch root: `dispatches/investigator--c0a194/`. Project worktree on `endojs/endo-but-for-bots@master` (head `0ec70c6dd`).

Maintainer directive at [#260 issuecomment-4457142808](https://github.com/endojs/endo-but-for-bots/issues/260#issuecomment-4457142808): *"Please run a mac os action on actual master a dozen times and record whether it passes or fails each time. I think you can drive the single action on an arbitrary commit manually with the gh command."*

Prior context on the thread:
- Kris kriskowal proposed the trial after spotting a likely flake at [endojs/endo run 25895561930 job 76107780104](https://github.com/endojs/endo/actions/runs/25895561930/job/76107780104?pr=3263).
- kumavis suggested ([4456597105](https://github.com/endojs/endo-but-for-bots/issues/260#issuecomment-4456597105)) the kumavis pattern: a branch that disables every other job and runs the same one a dozen times.
- The bot's prior same-hash retry-divergence analysis ([4456562761](https://github.com/endojs/endo-but-for-bots/issues/260#issuecomment-4456562761)) on a 48 h window found N=0 divergence in M=2 same-hash double-runs — but those were on a PR with deterministic regressions, not master. The two suspected macOS-only flakes from the parent survey were never re-tried at the same hash, so the data is silent on whether retry would have flipped them.

The maintainer wants empirical data: at a fixed master HEAD, does the `test (20.x, macos-15)` job in `ci.yml` produce different outcomes across ~12 independent CI runs?

## Target job

The CI workflow `.github/workflows/ci.yml` defines a `test` job with a `strategy.matrix` running across Node 18.x/20.x/22.x/24.x × ubuntu-latest/macos-15. The cell of interest is **`test (20.x, macos-15)`** (the job that's been firing intermittently on master and on several PRs over the last 48 h).

The workflow's `on:` trigger is `push: branches:[master]` + `pull_request` — **no `workflow_dispatch`**. So `gh workflow run` against master won't fire it. The cleanest paths forward (your call):

- **Branch-with-twelve-empty-commits.** Push twelve sibling branches off `master@0ec70c6dd` (e.g. `probe/macos-ci-flake-260-{01..12}`), each with one empty commit. Each branch triggers exactly one `pull_request` workflow run if a PR exists, or one `push` run if pushed to a branch tracked by the workflow (the current `push` trigger is `branches: [master]` only, so push to `probe/*` won't trigger `push`-based CI — you'd need a PR to fire `pull_request`). Twelve draft PRs is a lot of noise on the project.
- **One branch + `workflow_dispatch` injection.** On a single throwaway branch (e.g. `probe/macos-ci-flake-260`), add `workflow_dispatch:` to `ci.yml`'s `on:` block and `git push` once. Then fire `gh workflow run ci.yml --ref probe/macos-ci-flake-260` twelve times. The runs all execute against the same tree (which is identical to `master@0ec70c6dd` modulo the one-line workflow edit). Concurrent runs do NOT cancel each other if you also delete the `concurrency` block on this branch (or change the group key to include `github.run_id`); otherwise they queue serially, which is fine, just slower.
- **Branch + minimized workflow + workflow_dispatch.** As above but additionally delete every job from `ci.yml` on the branch *except* `test`, and restrict the strategy matrix to `node-version: [20.x]` and `os: [macos-15]`. Twelve fires now each run a single macos-15 job, fast, no noise, no cross-cell confounders. This is the kumavis pattern from his comment. **Recommended.**

Whichever path you pick, document the choice in your result entry with rationale.

## Task

Read `garden/roles/COMMON.md` + `garden/roles/investigator/AGENT.md` first.

1. **Confirm target SHA**: the project worktree is checked out at `master@0ec70c6dd`. Verify this is still `origin/master` HEAD; if it's drifted, refetch and refresh to the actual current master HEAD before the experiment, so the "actual master" framing the maintainer asked for holds.

2. **Pick a shape** (A / B / C above) and document the choice.

3. **Implement**:
   - Push the throwaway branch(es) under the bot identity.
   - Fire CI twelve times against the chosen target SHA.
   - Wait for all twelve runs to complete (poll via `gh run list -R endojs/endo-but-for-bots -w "CI" --branch probe/macos-ci-flake-260 --json status,conclusion,databaseId` or similar).

4. **Tabulate**:
   - For each of the twelve runs, the conclusion of the `test (20.x, macos-15)` job specifically (not the workflow's overall conclusion if you keep other cells — the maintainer asked specifically about the macOS cell).
   - For failures, the failure signature (test name(s), file path) extracted from the job log. Group failures by signature.
   - Compute pass rate (k/12) with a binomial confidence interval if you feel like it — but at minimum, the raw 12-row table.

5. **Severity assessment per the investigator role norms**:
   - If 12/12 pass: not a flake at this hash — the prior reports were transient infrastructure noise, deterministic differences elsewhere, or PR-side defects. **Bug? No.**
   - If 12/12 fail with the same signature: deterministic regression on master (severity: bug). Open question for the orchestrator: was a recent merge the cause?
   - If 1 ≤ k ≤ 11 failures with the same signature: real flake (severity: footgun). Surface umbrella: the failure mode, likely class of root cause (timing, filesystem, network, runner image), and a list of concrete fix candidates (longer timeout, deflake the specific test, pin a dependency, etc.).
   - If failures with mixed signatures: multiple flake families — report each separately.

6. **Cite each probe**. For each finding, name the run IDs that support or kill the hypothesis. A bare conclusion without its probe is worse than no report.

## Per-action authorization

- **Push authorization** on `endojs/endo-but-for-bots`: you MAY push to throwaway branches matching the prefix `probe/macos-ci-flake-260*` (any suffix). One-shot, scoped to this dispatch. No force-pushes to master or to any maintained branch.
- **Comment authorization** on `endojs/endo-but-for-bots`: standing per CLAUDE.md § Pre-staged authorizations. You MAY post one summary comment on issue [#260](https://github.com/endojs/endo-but-for-bots/issues/260) presenting the tabulation + severity verdict. The maintainer asked for this empirical data in-thread, so posting the answer back to the thread is the correct surface.
- READ-ONLY on `endojs/endo`. No comment on upstream PR #3263 or any other endojs/endo surface, even though it appeared in the thread as a flake exemplar.

## Out of scope

- No PR opening from the throwaway branch(es). The deliverable is the tabulation, not a workflow edit.
- No `master` push. The throwaway branch is for triggering CI, not for landing.
- No upstream ferry. No comment on `endojs/endo`.
- No fix attempt for whatever flake the experiment reveals. Surface as fix candidates; the orchestrator dispatches a builder if warranted.
- No CI changes that would alter how master itself runs. Your edits live on the `probe/*` branch only and are torn down with the branch at the end (you delete it, or note it for the orchestrator to delete; either way the branch should NOT be left dangling indefinitely).

## Report

≤ 500 words in the result entry. Include:
- Shape chosen (A/B/C) + rationale.
- The 12-row table (run ID, conclusion of the macos-15 job, failure signature if any).
- Pass-rate summary.
- Severity assessment + concrete fix candidates (if any).
- The issue-comment URL where you posted the summary.
- One-line `Self-improvement: ...`.

Plus the `result` journal entry per `skills/journal-sync/SKILL.md`. Large enough? Drop a topic file under `journal/projects/endo-but-for-bots/macos-ci-flake-260.md` per `skills/context-library/SKILL.md` (the canonical record of the trial, with the full per-run logs cited by URL).

The liaison adds a bulletin row on return.
