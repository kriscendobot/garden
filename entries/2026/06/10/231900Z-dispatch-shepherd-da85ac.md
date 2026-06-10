---
ts: 2026-06-10T23:19:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: shepherd
dispatch_root: /home/kris/dispatches/shepherd--da85ac
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/10/222951Z-result-weaver-d3a4e9.md
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/10/181800Z-result-fixer-d6af77.md
---

# dispatch: shepherd — drive PR #5 CI to terminal-classified after weaver rebase

Re-dispatch after shepherd `e70ca8` terminated early without
completing convergence work. CI is now much closer to terminal.

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#5`, DRAFT, base
  `master-57c6564`, head `mirror/12527-endo-sync-refresh` at
  `02782246bb5abb4af012fae35b3072b9d82b7998` (`02782246bb`).
- **CI**: 63 SUCCESS, 3 pending, 2 FAILURE.
  - `test-dapp (node-new)` — MAINTAINERS-documented expected-
    fail per `MAINTAINERS.md` § Syncing Endo dependency
    versions. Environment-acknowledge.
  - `test-quick (node-old)` — to classify. Per prior fixer
    d6af77's notes, this test had a prior `before('bootstrap')`
    snapshot-lock timeout on the node-new matrix; node-old
    completed in 9 min then. May be a flake (timeout, runner
    pressure) or a real regression.

## Task

In your `project/` worktree on the rebased head:

1. **Wait for the 3 pending checks** to terminal state (if any
   become FAILURE, also classify).
2. **Diagnose `test-quick (node-old)`**:
   - `gh run view <run-id> --log-failed --repo kriscendobot/agoric-sdk`
   - Pre-count error lines (memory: pre-count via `grep -c error`).
   - Compare against prior fixer's notes (snapshot-lock timeout
     pattern in `packages/portfolio-deploy/test/portfolio.test.ts`).
3. **Classify**:
   - **Flake-shaped** (timeout, snapshot-lock contention):
     `gh run rerun --failed` up to 2x. The prior fixer
     mentioned a similar test-quick failure that cleared on
     rerun.
   - **Substance, escalate** `next: fixer` if it's a real
     regression.
4. **Re-verify `test-dapp (node-new)`**: confirm it still
   reaches the actual test-dapp logic (matches MAINTAINERS
   framing), not an install gate.
5. **Post a top-level convergence summary** on PR #5 listing
   per-check terminal state + classifications. End with: "CI
   in shape for review" if green/acknowledge OR "Escalating
   `next: fixer` for <reason>".

## Authorizations (per-action, forwarded by liaison)

- **Re-run failed CI jobs** up to 2x per job.
- **Push small in-scope fix commits** to
  `mirror/12527-endo-sync-refresh` via `git push bot
  HEAD:mirror/12527-endo-sync-refresh` (append push only).
- **Top-level summary comment** on PR #5.
- **Escalate `next: fixer`** if needed.
- Do NOT re-request review (PR is DRAFT).
- Do NOT mark ready.
- Do NOT amend prior commits.

## Out of scope

- Do NOT rebase further.
- Do NOT touch the patch set.

## Deliverable

A `result` entry under `journal/entries/2026/06/10/` (or 11) naming:

- Per-check terminal state.
- Per-failure classification.
- Re-runs issued (run-id + job + outcome).
- Shepherd-side commit SHAs (if any).
- Convergence-summary comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: none` if review-ready;
  `next: fixer` if escalation needed.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
