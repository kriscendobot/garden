---
ts: 2026-06-17T22:50:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: builder
dispatch_root: /home/kris/dispatches/builder--bcdbd8
model: sonnet
prs:
  - repo: endojs/endo-but-for-bots
    pr: 452
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/452
  - https://github.com/endojs/endo-but-for-bots/pull/452#issuecomment-4736196756
  - https://github.com/endojs/endo-but-for-bots/pull/452#issuecomment-4736157998
  - entries/2026/06/17/224150Z-result-investigator-5fffb9.md
---

# dispatch: builder — #452 Option A (destroy peer formula on connection loss)

Kumavis at 22:48:06Z (id 4736196756): **"implement option A"** —
direct authorization. Refers to the investigator findings posted
at 22:41:45Z (id 4736157998).

## Option A per the investigator

Replace `dropLiveValue(context.id)` with
`context.cancel(new Error('peer connection lost'))` in the
`dialAttempt` dispose callback at `packages/daemon/src/daemon.js`
~line 5141.

This cancels the peer formula's context, which cascades via
`thisDiesIfThatDies` to all dependent remote presences,
revoking them. Next use of any remote presence reincarnates the
peer formula and re-dials.

Investigator also noted (paraphrased): "after Option A,
`currentGatewayP` is also no longer meaningful and the
resilient-dial wrapper can simplify." Use judgment on whether to
simplify in the same commit or land Option A first and propose
simplification as follow-up.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#452`, READY (not draft), base
  `llm`, head `kriskowal-iroh-heartbeat` at `c08a2262c`
  (post-rebase).
- **Mergeable**: yes (`UNSTABLE` = CI still running).
- **Iroh heartbeat additions** + rebased onto live `llm`.

## Task

In your `project/` worktree at `c08a2262c`:

1. Read `garden/roles/builder/AGENT.md`.
2. Read the investigator findings comment in full
   (`gh api repos/endojs/endo-but-for-bots/issues/comments/4736157998 --jq '.body'`).
3. Locate the dispose callback at daemon.js ~line 5141 (search
   for `dropLiveValue` in `packages/daemon/src/daemon.js`).
4. Replace the `dropLiveValue` call with the `context.cancel`
   call per Option A.
5. Audit the `ResilientPeerGateway` shape (around daemon.js
   :5119-5341): after Option A, the one-shot `currentGatewayP`
   may be dead code, the `isAbandonError` retry may be
   unreachable, and the resilient-dial wrapper may collapse to
   a thin wrapper. Decide whether to simplify in the same PR
   (consistent with Option A's contract) or land Option A
   minimally and surface the simplification as follow-up. If
   minimal: leave a comment in the code that the
   `currentGatewayP` re-dial path is now unreachable and
   warrants follow-up.
6. **Add tests**: extend `packages/daemon/test/iroh-heartbeat.test.js`
   or add a new test file that covers:
   - Connection-loss triggers peer formula cancellation (the
     dispose callback's new behavior).
   - Dependent remote presences are revoked (verify via
     `thisDiesIfThatDies` cascade).
   - Next use after disconnect reincarnates the peer formula
     and re-dials (an end-to-end test if feasible).
7. Run `corepack yarn workspace @endo/daemon test` (specifically
   the iroh-related ava files).
8. Run pre-push-gates.
9. Commit per logical unit:
   - `feat(daemon): destroy peer formula on connection loss (Option A)`
   - `test(daemon): cover peer-formula revocation on iroh connection loss`
   - (optional) `refactor(daemon): simplify ResilientPeerGateway after Option A`
10. Push to `kriskowal-iroh-heartbeat` (append only — do NOT
    rebase, do NOT force-push).
11. Post a top-level summary comment on PR #452 at-mentioning
    `@kumavis`:
    - Cite the commit SHAs.
    - Confirm Option A landed.
    - Note any simplification choices (and rationale if deferred).
    - Test results.

## Authorizations

- Push commits to `kriskowal-iroh-heartbeat` (append only).
- Top-level summary comment on PR #452.

## Out of scope

- Do NOT rebase or force-push.
- Do NOT re-request review.
- Do NOT mark PR draft.
- Do NOT touch #449 or #442.

## Deliverable

A `result` entry under `journal/entries/2026/06/17/` naming:

- Pre/post head SHAs.
- Per-commit substance.
- Files modified/added.
- Test results.
- Pre-push-gates result.
- The PR comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: cleaner` for #452 to re-gamut
  on the expanded scope (Option A + tests).

End your turn with a concise summary back to the orchestrator.
