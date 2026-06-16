---
ts: 2026-06-16T03:38:00Z
kind: dispatch
role: steward
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: fixer
dispatch_root: /home/kris/dispatches/fixer--3723ee
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/16/030805Z-result-fixer-d8a32b.md
---

# dispatch: fixer — CLASS D REGRESSION on PR #5 (post-d8a32b absorb)

**OODA cycle 2 on PR #5** classified `lint-primary` and several test-* jobs as **Class D regression**: previously-green jobs (e.g., test-cosmic-swingset that cleared via cb7a05's SES-2 alignment) are now red after fixer d8a32b's absorb of upstream PR #12734.

## Prime suspect

Fixer d8a32b's 3 absorb commits over `c2de346cc5`:
- `3a6be3fa1b` fix(deps): absorb upstream Endo sync from Agoric#12734
- `aee8f7a92c` fix(types): absorb upstream type fixes from Agoric#12734
- `edf76d44cb` chore: Update yarn.lock

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#5`, DRAFT, head `edf76d44cb`.
- **Failing**: lint-primary, lint-rest, test-cosmic-swingset (both), test-dapp (expected), test-inter-protocol (both), test-portfolio-contract (both), test-quick + test-quick2, test-solo (both), test-swingset matrix (many).

## Known lint-primary errors (18 total)

- `packages/swingset-runner/src/slogulator.js`: `'n-readlines' should be listed in the project's dependencies` (`import/no-extraneous-dependencies`).
- `packages/vats/src/types.ts`: 4× `Import in body of module; reorder to top` (`import/first`).

Many test-* failures are probably fail-fast cancellations cascading from lint-primary's exit.

## Task

In your `project/` worktree at `edf76d44cb`:

1. **Diagnose**:
   - `git log c2de346cc5..HEAD` to see the 3 absorb commits.
   - `git diff c2de346cc5..HEAD -- packages/swingset-runner/ packages/vats/` to see what changed in the regressed files.
   - Read `gh run view 27591352979 --log-failed` for each failing job to identify TS / runtime errors.
   - Classify each failing job as either:
     - **Cascade** (cancellation due to lint-primary fail-fast — should clear after lint-primary fix).
     - **New regression** (real new failure introduced by d8a32b's absorb).
2. **Fix lint-primary**:
   - `packages/swingset-runner/src/slogulator.js`: add `n-readlines` to that package's `package.json` dependencies (probably moved out during absorb).
   - `packages/vats/src/types.ts`: reorder imports to top per `import/first` rule.
3. **Verify** locally:
   - `corepack yarn workspace @agoric/swingset-runner lint:eslint`.
   - `corepack yarn workspace @agoric/vats lint:eslint`.
   - `corepack yarn lint:primary` if a workspace-root script exists.
4. **For real new regressions** (non-cascade), apply targeted fixes per the OODA-loop's tractable-fix discipline.
5. Run pre-push-gates.
6. Commit per regression (one cohesive commit per file or per class):
   - `fix(swingset-runner): restore n-readlines dependency after absorb`
   - `fix(vats): reorder imports per import/first after absorb`
7. Push to `mirror/12527-endo-sync-refresh` (append only).
8. Post a top-level comment on PR #5 at-mentioning @kriskowal:
   - Regression analysis (cascade vs new).
   - Per-fix SHA.
   - Note that Float*Array endow + dual-AVA fix + absorb-from-12734 are preserved.

## Authorizations

- Append-push.
- Top-level comment.
- Do NOT revert d8a32b's absorb wholesale — fix the regressions surgically.

## Out of scope

- Do NOT touch upstream Agoric/agoric-sdk.
- Do NOT pursue test-dapp Class A (expected fail).
- Do NOT revert Float*Array endow or dual-AVA fix.

## Deliverable

A `result` entry under `journal/entries/2026/06/16/` naming:

- Pre/post head SHAs.
- Per-regression classification (cascade vs new).
- Fix SHAs.
- Test results.
- pre-push-gates result.
- PR #5 comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: ooda-observation` when CI settles.

End your turn with a concise summary back to the orchestrator.
