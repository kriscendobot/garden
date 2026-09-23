---
ts: 2026-06-15T06:21:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--56a06a
prs:
  - repo: endojs/endo-but-for-bots
    pr: 58
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/58
  - https://github.com/endojs/endo-but-for-bots/pull/58#pullrequestreview-4494865599
---

# dispatch: fixer — apply @endo/ses-ava unredacted-trace hack on PR #58

Maintainer review on PR #58 (kriskowal COMMENTED, 2026-06-15T06:19:38Z):

> There's a hack in `@endo/ses-ava` that allows the test harness to inspect the unredacted trace for an error, using the internal tables installed by SES. Are we using that hack here? Until we have a better (less tightly-coupled) option, we should.

PR #58 introduces error tracing across CapTP workers. The maintainer asks whether the existing `@endo/ses-ava` hack for unredacted error trace access is being used; if not, use it.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#58`, OPEN, not draft, reviewDecision CHANGES_REQUESTED, base `llm`, head `dc4412c23`.
- **Title**: feat(daemon,cli): error tracing across CapTP workers (#1879)

## Task

In your `project/` worktree at `dc4412c23`:

1. Investigate: what hack does `@endo/ses-ava` expose for unredacted-trace inspection? Search `packages/ses-ava/src/` for the API (likely something like `getUnredactedStack`, `tagToError`, `assertionError` access, or similar). Cite the API + location.
2. Inspect the error-tracing implementation in PR #58. Look at `packages/daemon/src/host.js` (the `makeTraceAggregator` cited in the last commit), `packages/daemon/test/` (any test exercising trace retrieval), and the cli's `endo trace` verb if applicable.
3. Determine: is the PR currently using the ses-ava hack to get unredacted traces in tests/runtime? Or is it using a different (perhaps stack-string-parsing) approach?
4. If the hack isn't used, apply it: import the right symbol from `@endo/ses-ava` and use it at the trace-retrieval sites. Add devDep if not present.
5. Run `corepack yarn workspace @endo/daemon test` and `corepack yarn workspace @endo/cli test`.
6. Run pre-push-gates.
7. Commit: `fix(daemon): use @endo/ses-ava unredacted-trace hack per kriskowal review` (or two commits if helpful).
8. Push to `feat/error-tracing-implementation` (append only).
9. Post a top-level comment on PR #58 at-mentioning @kriskowal answering the question (was the hack being used? if not, what was the alternative?) and noting the SHA of the fix (if applied).
10. Re-request review from kriskowal.

## Authorizations

- Push commits to `feat/error-tracing-implementation` (append only).
- Top-level comment on PR #58.
- Re-request review.

## Out of scope

- Do NOT redesign the error-tracing flow.
- Do NOT touch other PRs.

## Deliverable

A `result` entry under `journal/entries/2026/06/15/` naming:

- The ses-ava hack identified (API + source file).
- Was PR #58 using it? (yes / no, plus what it was using instead).
- Commit SHA if applied.
- Test results.
- pre-push-gates result.
- PR #58 comment URL + re-request-review URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: liaison`.

End your turn with a concise summary back to the orchestrator.
