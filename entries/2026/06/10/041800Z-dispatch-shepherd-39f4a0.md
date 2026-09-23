---
ts: 2026-06-10T04:18:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: shepherd
dispatch_root: /home/kris/dispatches/shepherd--39f4a0
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4662462430
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/10/041600Z-result-fixer-c39b42.md
---

# dispatch: shepherd — verify CI convergence on PR #5 after fixer's yarn.lock fix

Follow-on dispatch after fixer `c39b42` landed `cc64691f78`
(`chore: Update yarn.lock`, 286+/20-) on
`mirror/12527-endo-sync-refresh`. The YN0028 immutable-lockfile
gate is cleared on all four formerly-red checks.

This shepherd verifies convergence + classifies the remaining
`test-dapp (node-new)` failure as the MAINTAINERS-documented
expected-fail.

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#5`, DRAFT, head
  `mirror/12527-endo-sync-refresh` at
  `cc64691f782122000d3f1405b253cb1df1178363` (`cc64691f78`).
- **CI**: 7 SUCCESS, 4 pending (`flake-check`, `gotest`,
  `build (node-new)`, `golangci-lint (no-failure)`), 1 FAILURE
  (`test-dapp (node-new)`).
- **`test-dapp (node-new)` framing** (per fixer result):
  documented in agoric-sdk `MAINTAINERS.md` as expected-fail on
  the node-new matrix until a companion `agoric/documentation`
  PR lands. NOW actually reaches the test-dapp logic (no longer
  YN0028); the prior shepherd's caveat ("install gate hits
  first; framing not applicable") is resolved.

## Task

In your `project/` worktree on `mirror/12527-endo-sync-refresh`
at `cc64691f78`:

1. **Poll CI to convergence** per
   `garden/skills/pr-ci-watch/SKILL.md`. Watch the 4 pending
   checks to terminal state.
2. **Verify `test-dapp (node-new)` failure** actually matches
   the MAINTAINERS expected-fail framing now: pull the log and
   confirm it reaches the test-dapp logic (not the YN0028 gate).
   If yes → `environment-acknowledge`. If no → escalate
   `next: fixer`.
3. **Classify any new failures** from the 4 pending jobs:
   - Flake-shaped: `gh run rerun --failed` up to 2x.
   - Substance: in-scope shepherd fix OR `next: fixer`.
   - Environment-acknowledge: document the prior framing.
4. **Post a top-level convergence summary** on PR #5:
   per-check terminal state + per-failure classification +
   shepherd-side commits if any. End with: "CI in shape for
   review" if all green/acknowledge or "Escalating
   `next: fixer` for <reason>".
5. **Reply on kriskowal's directive comment** (`4662462430`)
   with one-line convergence summary.

## Authorizations (per-action, forwarded by liaison)

- **Re-run failed CI jobs** up to 2x.
- **Push small in-scope fix commits** to
  `mirror/12527-endo-sync-refresh` via `git push bot
  HEAD:mirror/12527-endo-sync-refresh` (append push only).
- **Top-level summary comment + directive reply** on PR #5.
- **Escalate `next: fixer`** if needed.
- Do NOT re-request review (PR is DRAFT).
- Do NOT mark ready.
- Do NOT amend builder, shepherd, or fixer commits.

## Out of scope

- Do NOT attempt the broader Endo-version bump (the fixer's
  result entry explains the deferred scope; would cascade 40+
  TS errors).
- Do NOT touch patches.
- Do NOT rebase.

## Deliverable

A `result` entry under `journal/entries/2026/06/10/` naming:

- Per-check terminal state.
- `test-dapp (node-new)` verification: does it actually match
  the MAINTAINERS expected-fail framing now?
- Re-runs issued (run-id + job + outcome).
- Shepherd-side commit SHAs (if any).
- Convergence-summary comment URL.
- Directive-reply comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: none` if the PR is in
  shape for maintainer review; `next: fixer` if escalation is
  needed.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
