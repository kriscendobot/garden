---
ts: 2026-05-14T20:37:14Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 247
    role: target
---

# Dispatch: cleaner advances #247 in the PR-creation-flow chain

Dispatch root: `dispatches/cleaner--2ea353/`. Project worktree on `endojs/endo-but-for-bots@feat/eventual-send-test`.

Manual dispatch by the liaison: #247 (Cut 5 builder) opened at 19:50Z and has been sitting in draft for ~47 minutes without the chain advancing. The steward's last entry was a `tick` at 19:18:53Z; it appears to have either scheduled a long idle wakeup or terminated. Rather than wait, dispatching the cleaner directly.

Per the new flow (gardener `fbb472` landed minutes ago): builder → cleaner → judge → fixer-loop → judge un-drafts. #247 is at the cleaner step.

## #247 shape

- Title: `feat(eventual-send,eventual-send-test): break devDep cycle via @endo/eventual-send-test (Cut 5 of #206 design)`.
- Two commits: the design implementation + `chore: Update yarn.lock`.
- New package `packages/eventual-send-test/` with 64 passing tests.
- Removes two devDeps (`@endo/lockdown`, `ses`) from `packages/eventual-send/package.json`.

## Per-action authorization

Standing on endo-but-for-bots: push coverage commits + yarn-lock churn to `feat/eventual-send-test`.

## Task

Run the cleaner role per `roles/cleaner/AGENT.md` against the two affected packages: `@endo/eventual-send` and the new `@endo/eventual-send-test`.

- Coverage pass per `skills/coverage-driven-testing/SKILL.md`. Run `c8` against the new and modified packages; baseline current numbers; iterate on integration tests for any uncovered reachable code; delete code that is verifiably dead per the four criteria.
- Both `@endo/eventual-send` (whose test surface shrank when 8 files moved to the new package — verify nothing got orphaned) and `@endo/eventual-send-test` (the new package itself).
- Push commits per `skills/yarn-lock-separate-commit/SKILL.md` (lockfile churn separate from any other commit, if a new test dep is needed).
- Per the new flow: **cleaner does NOT un-draft**. The judge un-drafts after the panel loop terminates. Push coverage commits, watch CI converge to green or only documented pre-existing red, then return.

## Out of scope

- No source changes to `@endo/eventual-send`'s production code (this is a cleaner, not a fixer).
- No un-draft.
- No comment on the PR.

## Report

≤ 300 words: coverage delta per affected package, dead-code deletions (count), CI status after push, one-line `Self-improvement: ...`.
