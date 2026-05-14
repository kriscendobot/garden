---
ts: 2026-05-14T23:08:21Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 247
    role: target
---

# Dispatch: fixer responds to kriskowal's inline questions on PR #247

Dispatch root: `dispatches/fixer--2d7490/`. Project worktree on `endojs/endo-but-for-bots@feat/eventual-send-test` (head `ac989794`).

kriskowal submitted two `COMMENTED` reviews on #247 at 2026-05-14T23:07:11Z and 23:07:32Z (empty bodies; substance in inline threads). Four inline comments total:

**Substantive questions:**

1. [comment 3244147661](https://github.com/endojs/endo-but-for-bots/pull/247#discussion_r3244147661) on `packages/eventual-send-test/package.json:66`: *"We don't need to do this yet, but this pattern will not work for packages using a `sesAva` block. Please investigate whether we will need to create a package-specific set of ava config files, and if so, whether we can build on a base config."*

2. [comment 3244151411](https://github.com/endojs/endo-but-for-bots/pull/247#discussion_r3244151411) on `packages/eventual-send-test/test/_get-hp.js:5`: *"Why can we not simply import E from `@endo/eventual-send` in tests?"*

**Nudges** (one nudge per substantive question):

3. comment 3244815559 on `packages/eventual-send-test/package.json:66`: *"Please respond."*
4. comment 3244814249 on `packages/eventual-send-test/test/_get-hp.js:5`: *"Please answer."*

## Per-action authorization

Standing on endo-but-for-bots: push fixup commits, reply on inline review threads, post top-level summary comment.

## Task

For each substantive question, the fixer chooses between (a) a substantive code change + thread reply with the commit SHA, or (b) a thread reply explaining the rationale of the current code if no change is warranted. Standing comment authorization permits both shapes.

### Question 1 (sesAva ava-config investigation)

Investigate whether `@endo/eventual-send-test` (or future sibling-test packages) using a `sesAva` block instead of plain `ava` will need a per-package set of ava config files. Read:
- The current `packages/eventual-send-test/package.json` ava block.
- The existing `harden-test` and `hex-test` packages' ava blocks for comparison.
- Any packages in the workspace that use `sesAva` (grep for `sesAva` or `ses-ava`).
- The `@endo/ses-ava` package's documented config surface.

Produce a finding: yes/no per-package ava config needed; if yes, a base-config inheritance shape that the sibling-test pattern can adopt. Reply on the thread with the finding. If the finding implies a follow-up PR, name it (don't open the follow-up from this dispatch).

### Question 2 (import E directly)

Explain why `_get-hp.js` resolves `@endo/eventual-send/src/local.js` via the `test-endo-eventual-send` exports condition instead of importing `E` from `@endo/eventual-send` directly. The Cut 5 builder's result entry (`195002Z-result-builder-90af84.md`) explains this: most tests CAN import `E` from the public surface, but two tests (`local.test.js` and `message-breakpoints.test.js`) reach internal symbols (`../src/local.js`, `../src/message-breakpoints.js`); the `_get-hp.js` shared fixture is shared between the public-surface tests and the internal-surface tests, so it goes through the test-condition path for uniformity. The fixer's reply explains this and either:
- (a) refactors `_get-hp.js` to import `E` from the public surface and only the two internal-surface tests use the test-condition (cleaner — `_get-hp.js` doesn't need the test condition), OR
- (b) leaves the current shape and replies with the rationale.

Read the actual code to determine if (a) is feasible without breaking the two internal-surface tests' import paths.

## Out of scope

- No un-draft toggle (the PR is already non-draft; nothing to toggle).
- No re-request kriskowal review (the standing review-state advances on its own after the fixer's pushes/replies).
- No upstream comment.

## Report

≤ 300 words: per-question disposition (code-change vs thread-reply), commit SHAs if any, the sesAva finding (one line), the import-E disposition (one line), one-line `Self-improvement: ...`.
