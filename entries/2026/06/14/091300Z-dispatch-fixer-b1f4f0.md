---
ts: 2026-06-14T09:13:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--b1f4f0
prs:
  - repo: endojs/endo-but-for-bots
    pr: 442
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/442
  - https://github.com/kriskowal/garden/blob/journal/jobs/open/20260614T090132Z--7e80fa--endo-but-for-bots-442-summary-fix.md
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/14/090300Z-result-barrister-9c09ea.md
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/14/090825Z-result-appellate-98a88d.md
---

# dispatch: fixer — apply summary-fix job 7e80fa on PR #442 (daemon-cas)

Apply the two summary-fix items the barrister + appellate consolidated into job
`7e80fa` for PR #442:

1. Wrap `packages/daemon-cas/test/content-store.test.js` in `@endo/ses-ava` (`wrapTest(rawTest)`).
2. Strengthen the `joinPath`-only-path-primitive assertion: invoke all four CAS ops (`store`, `fetch`, `has`, `remove`) on the same store and assert `joinCalls >= 4` (currently `>= 1` after one `store`).

Read the full job body at `journal/jobs/open/20260614T090132Z--7e80fa--endo-but-for-bots-442-summary-fix.md` for the exact rationale and suggested commit-message shapes.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#442`, DRAFT, base `llm-c85d618`, head `f472c43c5`.
- **Cleaner already passed** (`a28714`); barrister already passed (`9c09ea`, COMMENTED on `f472c43c5`).
- **Appellate already passed** (`98a88d`), promoted item 2 from follow-up to summary-fix.
- **Followup ledger** at `projects/endo-but-for-bots/followups/endo-but-for-bots--442.md` now carries 2 items (the helper extraction + the Phase 5 XS coverage).

## Task

In your `project/` worktree at `f472c43c5`:

1. **Claim** job 7e80fa via `garden/skills/job-board/claim-job.sh` (or note that the orchestrator has bypassed the claim race by dispatching you directly; either way, do not work around the claim guard — if the claim fails because another consumer beat you to it, stop and report).
2. **Apply item 1**: edit `packages/daemon-cas/test/content-store.test.js`, swap `import test from 'ava';` for the `wrapTest` triple-line shape per the job body. Verify `npx ava` still passes (9/9 expected).
3. **Apply item 2**: edit the joinPath test (around lines 294-317). Extend the single `store(...)` to also call `fetch`, `has`, `remove` against the same store, then change `t.true(joinCalls >= 1, ...)` to `t.true(joinCalls >= 4, ...)`. Verify the test still passes.
4. **Commit** per item:
   - `chore(daemon-cas): wrap tests in @endo/ses-ava`
   - `test(daemon-cas): exercise joinPath across all four CAS ops`
5. **Run** `corepack yarn workspace @endo/daemon-cas test` to confirm the suite passes.
6. **Run pre-push-gates** in `project/`.
7. **Push** to `feat/daemon-cas-extraction` (append only).
8. **Reply** with a top-level comment on PR #442 at-mentioning `@kriskowal`:
   - 2 commit SHAs.
   - Item-by-item resolution.
   - Local test result.
   - pre-push-gates result.

## Authorizations

- Push commits to `feat/daemon-cas-extraction` (append only).
- Top-level summary comment on PR #442.
- Move the job entry from `journal/jobs/open/` to `journal/jobs/claimed/` per `skills/job-board/SKILL.md`.

## Out of scope

- Do NOT rebase or force-push.
- Do NOT touch packages outside `packages/daemon-cas/`.
- Do NOT mark PR ready (the orchestrator runs `gh pr ready 442` after CI confirms green).
- Do NOT re-request review (the maintainer reviews on un-draft).

## Deliverable

A `result` entry under `journal/entries/2026/06/14/` naming:

- Pre/post head SHAs.
- The 2 commit SHAs.
- Item-by-item file + line resolution.
- Test results.
- pre-push-gates result.
- The PR #442 comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: orchestrator un-drafts PR #442 after CI green; then conductor for merge`.

End your turn with a concise summary back to the orchestrator.
