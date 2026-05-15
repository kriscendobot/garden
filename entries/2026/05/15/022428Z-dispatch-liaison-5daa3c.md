---
ts: 2026-05-15T02:24:28Z
kind: dispatch
role: liaison
project: agoric-sdk
to: "*"
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 1
    role: target
  - repo: Agoric/agoric-sdk
    pr: 12659
    role: source
---

# Dispatch: shepherd drives kriscendobot/agoric-sdk#1 CI to green

Dispatch root: `dispatches/shepherd--5daa3c/`. Project worktree on `kriscendobot/agoric-sdk@feat/migrate-eslint-plugin-import-x` (head `638a578f`).

Maintainer directive (2026-05-15): *"Please shepherd https://github.com/kriscendobot/agoric-sdk/pull/1"*

PR #1 is the bots-side mirror of Agoric#12659 (eslint-plugin-import-x migration) — earlier today's builder dispatch `0d4cad` landed three commits (`0ab4e7bbb` aliasing, `ede0da6d5` lint cleanups, `638a578f` yarn.lock). kriskowal reviewed and the fixer `43c1f9` later replied to the catalog.yml question (the repo has no catalog file; the alias is in root devDependencies).

CI rollup at dispatch time: **24 SKIPPED, 69 SUCCESS, 1 FAILURE** (`lint-primary` job at <https://github.com/kriscendobot/agoric-sdk/actions/runs/25886309121/job/76089967851>). The shepherd diagnoses the lint failure + drives the chain to green.

## Per-action authorization

Standing on kriscendobot/agoric-sdk (the bot's own fork): push, comment, re-run jobs. READ-ONLY on Agoric/agoric-sdk.

## Task

Per `roles/shepherd/AGENT.md`:

1. **Diagnose the lint-primary failure**. `gh run view 25886309121 --log-failed -R kriscendobot/agoric-sdk`. Capture the actual failure-line.

2. **Decide flake vs substantive**:
   - **Flake-shaped** (transient, infra, retryable): re-run with `gh run rerun --failed`. Per the standing instruction, `test-ocapn-guile-interop` failures are gating in this repo just like any other (no operational-flake broadcast on agoric-sdk).
   - **Substantive** (real lint error from the diff): fix in code. Common shapes for this PR: import-x@4's stricter resolver surfacing new rule violations the earlier builder dispatch didn't catch. Apply the fix in a new commit on the same branch; force-push with `--force-with-lease`.

3. **Per today's self-improvement** (filed at `015257Z`): commit + push BEFORE extended local validation.

4. **Watch CI converge** to green via `gh pr checks 1 -R kriscendobot/agoric-sdk --watch`. Other 69 checks should remain SUCCESS; the 24 SKIPPED are normal (CI workflow conditions).

5. **Standing comment** authorization permits posting a one-line summary on the PR if the fix is non-obvious; optional.

## Out of scope

- No comment on upstream `Agoric/agoric-sdk#12659`. The boatman ferries the bot-side work upstream later.
- No un-draft (PR is the contractor's / maintainer's call when ready).

## Report

≤ 300 words: failure diagnosis (substantive vs flake), fix shape, head SHA after push, CI status (green or remaining issues), one-line `Self-improvement: ...`.
