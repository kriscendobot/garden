---
ts: 2026-06-10T22:56:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--a8a6ac
prs:
  - repo: endojs/endo-but-for-bots
    pr: 379
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/379
  - https://github.com/endojs/endo-but-for-bots/pull/379#pullrequestreview-4472225008
---

# dispatch: fixer — add TDZ-observing tests on PR #379 per kriskowal CHANGES_REQUESTED

Maintainer-feedback dispatch per the `PullRequestReviewEvent` at
2026-06-10T22:54:02Z on `endojs/endo-but-for-bots#379`
("fix(ses): cyclic star export with renaming reexport (issue #59)
- refresh for #3276 feedback").

Review `4472225008` (kriskowal, state CHANGES_REQUESTED, full body):

> @kriscendobot Please create additional tests that vary by
> whether the renamer or star exporter are imported first from
> main.js, and also vary by whether the binding is a const, let,
> or var. In all cases that it is possible, attempt to observe
> the value after it has been linked with its cyclic module but
> before it has been assigned or bound. This may be an
> observation of an exception while the binding is temporally
> dead (TDZ).

No inline comments tied to this review; substance is in the
review body. The "@kriscendobot" at-mention shape applies.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#379`, OPEN (not DRAFT), base
  `master`, head `fix/issue-59-star-export-cycle` at
  `f1a7dfb606227ffb89a07301b5fe1dc80c9891a2` (`f1a7dfb60`).
  `reviewDecision: CHANGES_REQUESTED`.

## Task — add TDZ-observing tests

The ask is a test-matrix expansion. The combinatorial axes:

1. **Import order from `main.js`**: renamer-first vs
   star-exporter-first.
2. **Binding form**: `const`, `let`, `var`.

That gives a 2x3 = 6-test matrix. For each cell, the test should
attempt to **observe the value during the linked-but-not-bound
TDZ window**. The expected observation in most cells is a
`ReferenceError` (the standard TDZ throw for `let`/`const`); for
`var`, the binding is initialized to `undefined` rather than TDZ
so the observation differs.

In your `project/` worktree on `fix/issue-59-star-export-cycle`
at `f1a7dfb60`:

1. **Read the PR's existing tests** to understand the test
   harness shape. Look in `packages/ses/test/` for the
   star-export cycle tests this PR added/modified. Find the
   existing test that exercises the renamer-reexport-of-star-
   export cycle so the new tests can follow its structure.
2. **Read the PR body and prior reviews** for context on what
   the fix is doing structurally — this will help shape the
   new test cells. The PR title says "refresh for #3276
   feedback" so PR #3276's review may have established the
   testing conventions.
3. **Add the 6 test cells** in a new or existing test file
   (probably a sibling to the existing cycle test). For each:
   - Set up the cyclic-import shape (renamer module +
     star-exporter module + main.js).
   - Vary the import order in `main.js` per the axis.
   - Declare the binding (`const`/`let`/`var`) in the relevant
     module per the axis.
   - Observe the value during the linked-but-not-bound window
     — most easily via a function call that reads the binding
     before the body that assigns it has executed. The test
     asserts on the observation:
     - For `let`/`const`: expect `ReferenceError` (TDZ).
     - For `var`: expect `undefined` (var is hoisted as
       undefined).
4. **Title each test** per
   `garden/skills/test-title-spec-spelling/SKILL.md` discipline.
   Title shape examples (the fixer adapts):
   - `'observes ReferenceError when const binding is read before
     assignment with renamer imported first'`
   - `'observes undefined when var binding is read before
     assignment with star exporter imported first'`
5. **Run** `corepack yarn workspace ses test` to confirm the
   new tests pass on the current fix.
6. **Run pre-push-gates** in `project/` and confirm clean.
7. **Commit** with a conventional commit message like
   `test(ses): TDZ-observing tests for cyclic star-export +
   renaming reexport (closes kriskowal CHANGES_REQUESTED)`.
   Single commit (test-only addition).
8. **Push** to `fix/issue-59-star-export-cycle` via
   `git push origin HEAD:fix/issue-59-star-export-cycle`
   (append push only).
9. **Reply to the review** (`gh api
   repos/endojs/endo-but-for-bots/pulls/379/reviews/4472225008/replies`
   — note: replies on reviews may require a different endpoint;
   fall back to a top-level comment if the replies endpoint
   doesn't exist for reviews). The reply should:
   - At-mention `@kriskowal`.
   - Name the addressing commit SHA.
   - List the 6 test cells the new commit added (one line per
     cell).
   - Note the TDZ-vs-undefined observation per binding form.
10. **Re-request review** from kriskowal once the reply is
    posted.

## Authorizations (per-action, forwarded by liaison)

- **Push commits** to `fix/issue-59-star-export-cycle` (append
  push only).
- **Reply on the review** (or top-level comment on PR #379).
  Standing `endo-but-for-bots` broad-comment authorization.
- **Re-request review** from kriskowal once the response is
  complete.

## Out of scope

- Do NOT change the production fix code. The maintainer's ask
  is test-only.
- Do NOT rebase or force-push.
- Do NOT amend prior commits.
- Do NOT un-draft (PR is already non-draft).

## Deliverable

A `result` entry under `journal/entries/2026/06/10/` naming:

- Pre/post branch tip SHAs.
- The single commit SHA.
- The 6 test cells added (one line per cell, with title +
  expected-observation).
- `yarn workspace ses test` result.
- pre-push-gates result.
- The reply URL on the review.
- The re-request-review URL/status.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
