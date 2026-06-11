---
ts: 2026-06-11T01:45:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--ee7c36
prs:
  - repo: endojs/endo-but-for-bots
    pr: 379
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/379
  - https://github.com/endojs/endo-but-for-bots/pull/379#pullrequestreview-4473004836
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/10/234200Z-result-fixer-1a126e.md
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/10/232410Z-result-fixer-a8a6ac.md
---

# dispatch: fixer — fix the SES TDZ-enforcement defects on PR #379 per kriskowal CHANGES_REQUESTED

Maintainer directive (kriskowal at 2026-06-11T01:43:29Z, review
`4473004836` on PR #379):

> The follow-up design looks good. I find it preferable to fix
> the defects we've discovered in this exploration, with the
> added tests introduced without the `.failing` caveats. Please
> dispatch an agent to address both issues. Address each issue
> in separate commits.

Translation: the construction-time-notifiers design doc is
accepted; **fix the SES module-instance machinery** so the
prior fixers' `.failing` tests pass without the caveat. Two
issues, separate commits.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#379`, OPEN (not DRAFT),
  base `master`, head `fix/issue-59-star-export-cycle` at
  `0c46da953138535a68208aba0b615a9b66255088` (`0c46da953`).
- **The two `.failing` tests** in
  `packages/ses/test/import-gauntlet.test.js`:
  1. **Star-reexport variant** (added by fixer `a8a6ac` at
     `30664c3c2`): renamer-first × `const` and × `let` cells
     marked `.failing` because SES does NOT enforce TDZ for
     cross-module reads through a namespace import during a
     cycle (`r.y` returns `undefined` instead of raising
     `ReferenceError`).
  2. **Named-reexport variant** (added by fixer `1a126e` at
     `0c46da953`): same failure mode for
     `export { y } from './export-renamer.js'`.
- **The design doc** at
  `packages/ses/designs/construction-time-notifiers.md`
  (created by fixer `1a126e`) sketches a two-pass redesign of
  the module-instance lifecycle. The fixer concluded the
  redesign is feasible but did NOT itself close the TDZ
  divergence — fixer noted "redesign does not by itself close
  the divergence."

## Task — fix the underlying defects

The maintainer is asking to actually fix the bugs, not just
document them. The fix may or may not require the
construction-time-notifiers redesign. The fixer's prior
analysis suggests the redesign is one approach but not the
only one; investigate alternatives if the redesign is too
broad for this PR.

In your `project/` worktree on `fix/issue-59-star-export-cycle`
at `0c46da953`:

### Phase 1 — Diagnose the TDZ divergence

1. **Re-read the design doc**
   `packages/ses/designs/construction-time-notifiers.md` for
   the prior fixer's analysis of the module-instance
   lifecycle and the two-pass redesign sketch.
2. **Read the SES module-instance machinery**:
   - `packages/ses/src/module-instance.js` (or wherever the
     binding setup happens — grep for the `notifier` /
     `bind` / `setLocal` patterns).
   - `packages/ses/src/module-link.js`
   - `packages/ses/src/module-load.js`
3. **Identify the bug**: when does the namespace import's
   property lookup happen? Why does it return `undefined`
   instead of throwing `ReferenceError`? Likely the namespace
   import reads the binding's *initialized*-but-not-*assigned*
   state and returns `undefined` because the binding's
   notifier hasn't been wired yet OR because the binding's
   "live" status is inferred from the notifier's existence.

### Phase 2 — Fix the star-reexport variant (issue 1)

Implement the smallest fix that makes the star-reexport
`.failing` cells pass. Likely shape:
- Mark the binding as TDZ from the moment the module
  instance is constructed.
- Have the namespace-import accessor throw when the binding
  is in TDZ state.
- Wire the notifier such that *assignment* (not
  initialization) is what clears TDZ.

Commit: `fix(ses): enforce TDZ for cross-module namespace
reads during cycle (star reexport)`.
- Include the test.failing → passing conversion in the same
  commit.

### Phase 3 — Fix the named-reexport variant (issue 2)

If the Phase 2 fix is general enough, the named-reexport
case may already pass. If it doesn't, identify the
named-reexport-specific code path (probably the
`re-export-from-name` resolution) and apply the same TDZ
discipline there.

Commit: `fix(ses): enforce TDZ for cross-module named-reexport
reads during cycle`.
- Include the test.failing → passing conversion.

### Phase 4 — Verify + push

1. Run `corepack yarn workspace ses test`. Confirm:
   - All previously-passing tests still pass.
   - The 3 previously-`.failing` cells now pass without the
     `.failing` modifier.
   - No regressions.
2. Run pre-push-gates. Address probe findings if any.
3. Push to `fix/issue-59-star-export-cycle` (append push
   only).
4. Reply on the review `4473004836` (top-level PR comment if
   review-replies aren't supported) at-mentioning kriskowal,
   naming both addressing commit SHAs.
5. Re-request review from kriskowal.

## Authorizations (per-action, forwarded by liaison)

- **Push commits** to `fix/issue-59-star-export-cycle`
  (append push only; do NOT amend prior commits; do NOT
  force-push).
- **Top-level comment** on PR #379 with addressed-items
  summary. Standing.
- **Re-request review** from kriskowal.
- **Modify the design doc**
  `packages/ses/designs/construction-time-notifiers.md` if
  the fix changes its assumptions — the doc may need
  updating to reflect what was actually implemented vs the
  redesign sketch.

## Out of scope

- Do NOT rebase or force-push.
- Do NOT amend the prior fixers' commits.
- Do NOT pursue the full construction-time-notifiers
  redesign unless it's the simplest fix. The maintainer
  accepted the design doc as a separate follow-up; this
  dispatch is about fixing the immediate defects.
- Do NOT touch other SES surfaces beyond what's needed to
  fix the TDZ enforcement gap.

## Deliverable

A `result` entry under `journal/entries/2026/06/11/` naming:

- Pre/post branch tip SHAs.
- The two substance commit SHAs (one per issue).
- Diagnosis of the TDZ divergence root cause (where in the
  module-instance machinery the bug lived).
- Per-fix description: what code changed, why, how it makes
  the .failing test pass.
- Test result (the previously-`.failing` cells now passing;
  no regressions in the existing test suite).
- pre-push-gates result.
- The reply URL.
- Re-request-review URL/status.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
