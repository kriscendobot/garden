---
ts: 2026-06-15T05:57:00Z
kind: dispatch
role: steward
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: shepherd
dispatch_root: /home/kris/dispatches/shepherd--6c7667
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 2
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/2
  - https://github.com/kriscendobot/agoric-sdk/pull/2#issuecomment-4655714594
---

# dispatch: shepherd — explain failing CI on PR #2 per kriskowal

Maintainer directive (kriskowal on PR #2, 2026-06-09T03:20Z):

> @kriscendobot rsvp
> > Please explain the failing CI checks.

(Now 6 days later; user re-rsvp'd 2026-06-15T05:55Z.)

PR #2 (kriscendobot/agoric-sdk integrate/xsnap-pub-pr-50) is DRAFT. Several CI
jobs hit "24h0m1s" timeouts — meaning they ran the full 24h limit, not real
test failures. This is unusual; either workflow is hanging on infrastructure
or jobs were started long ago and finally timed out.

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#2`, DRAFT, head `f2a3b6501`.
- **Title**: chore(xsnap): pin xsnap submodule at agoric-labs/xsnap-pub#50 mirror for evaluation
- **CI**: golangci-lint passes (4m13s); test-cosmic-swingset matrix + test-quick (xs) all show "24h0m1s" duration (CI runner timeout).

## Task

In your `project/` worktree:

1. Read the failing job logs (gh run view).
2. Diagnose: are the tests hanging on a deadlock, infinite loop, or process leak? Or is this an old run that was never canceled?
3. Trigger fresh CI runs if appropriate (push an empty commit, or `gh workflow run`).
4. Post a top-level comment on PR #2 at-mentioning @kriskowal with the explanation: what's failing, why (if known), and recommended next step.

## Authorizations

- `gh run rerun` failed jobs.
- Push an empty/whitespace commit to trigger fresh CI if needed.
- Top-level comment on PR #2 @-mentioning @kriskowal.
- Do NOT mark PR ready/un-ready.
- Do NOT push substantive code (this is investigative shepherd, not fixer).

## Out of scope

- Do NOT touch upstream Agoric/agoric-sdk (boatman territory).

## Deliverable

A `result` entry under `journal/entries/2026/06/15/` naming:

- Per-failing-job diagnosis.
- Any reruns/triggers applied.
- PR #2 explanatory comment URL.
- Recommended next stage (`next: fixer`, `next: nothing`, or `next: liaison` for maintainer decision).
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator.
