---
ts: 2026-06-15T20:57:00Z
kind: dispatch
role: steward
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: fixer
dispatch_root: /home/kris/dispatches/fixer--ba72cd
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4712352532
---

# dispatch: fixer — drive PR #5 type-check jobs to green per kriskowal

Maintainer directive (kriskowal on PR #5, 2026-06-15T20:55:07Z):

> @kriscendobot Please address the remaining issues, which appear to all be guarded type mismatches as above. Continue until all type checks pass in all jobs. The documentation job is expected to fail.

Per investigator 582439's prior analysis, the `endowments.js:233` case was identified as "guarded type mismatch" (TS stricter generic inference of `defineExo`/`exo` overloads — runtime correct, TypeScript can't prove it). The maintainer extrapolates: the remaining type-check failures across all jobs are likely the same pattern. Apply targeted casts / `@ts-ignore` (per memory: `@ts-ignore` preferred over `@ts-expect-error` for these guarded-mismatch cases per prior copilot review) until all type-check jobs pass.

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#5`, DRAFT, head `f295e0d7ab`, base `master-57c6564`.

## Task

In your `project/` worktree at `f295e0d7ab`:

1. Enumerate the failing type-check jobs from CI: `gh pr checks 5 --repo kriscendobot/agoric-sdk` to identify which jobs are failing.
2. For each failing type-check job, fetch its log (`gh run view --log-failed`) and identify the TS errors.
3. For each error, classify:
   - **Guarded type mismatch** (the maintainer's framing): runtime is correct, TS overload signatures can't prove it. Apply `@ts-ignore` with a brief comment naming the guard.
   - **Real defect**: fix it.
   - **Documentation job**: expected to fail — leave it alone per maintainer.
4. Iteration loop: edit → run local `yarn lint:types` (per-workspace) → commit → push → wait for CI → check next batch. Plan for several iterations if the cascade is wide.
5. After type checks pass in ALL non-doc jobs, post a top-level summary on PR #5 at-mentioning @kriskowal:
   - Per-job resolution summary.
   - All commit SHAs.
   - Note that the documentation job is expected red per maintainer.
6. Re-request review from kriskowal.

## Authorizations

- Push commits to `mirror/12527-endo-sync-refresh` (append only; no force).
- Top-level summary comment.
- Re-request review.
- Do NOT touch upstream Agoric/agoric-sdk.

## Out of scope

- Do NOT modify substance (runtime behavior); only type-level edits (casts, `@ts-ignore`).
- Do NOT modify the documentation job's expected failure.
- Do NOT pursue test-fast-usdc-deploy structural impasse (per prior fixer 38fcec's report — that needs maintainer decision).

## Watch out for

- **`@ts-ignore` over `@ts-expect-error`** per copilot guidance: the `@ts-expect-error` directive fails if the error stops occurring, so prefer `@ts-ignore` for brittleness-tolerant cases.
- **Stop and surface** if a TS error is genuinely a runtime defect rather than a guarded mismatch.
- **Multiple lint-types jobs**: the PR may have lint-types or lint-rest or lint-primary jobs; address each.

## Deliverable

A `result` entry under `journal/entries/2026/06/15/` naming:

- Pre/post head SHAs.
- Per-job resolution mapping.
- Commit SHAs.
- Final CI state (lint:types green; doc job expected red).
- PR #5 comment URL + re-request-review URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: liaison` (maintainer reviews + decides un-draft / ferry).

End your turn with a concise summary back to the orchestrator.
