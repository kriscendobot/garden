---
ts: 2026-06-17T23:17:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--1081b6
model: sonnet
prs:
  - repo: endojs/endo-but-for-bots
    pr: 452
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/452
  - https://github.com/endojs/endo-but-for-bots/pull/452#discussion_r3432011511
  - https://github.com/endojs/endo-but-for-bots/pull/452#discussion_r3432013979
---

# dispatch: fixer — #452 Copilot ask: cancel AND dropLiveValue

Copilot bot review at 23:15:01Z (comment id 3432011511) on
`packages/daemon/src/daemon.js` line 5149:

> `context.cancel(...)` tears down formula lifecycles, but it
> does not clear the daemon's live-value caches (`refForId` /
> `idForRef`). Previously this dispose path used
> `dropLiveValue`, which *did* clear those mappings; leaving
> them can keep stale gateway/presence refs reachable via
> marshalling and undermine the "re-dial from scratch"
> behavior after a disconnect. Consider cancelling the context
> *and* dropping the live value for the peer formula id.

Kumavis at 23:15:40Z (id 3432013979) replied "@kriscendobot " —
direct ping to address.

## Real issue

Option A's implementation in builder bcdbd8 commit `fc5fe2271`
replaced `dropLiveValue(context.id)` with
`context.cancel(new Error('peer connection lost'))`. The
investigator's report (and the dispatch brief) framed this as a
swap, but Copilot is right: BOTH are needed.

- `context.cancel(...)` triggers the formula's disposal cascade
  via `thisDiesIfThatDies` (revoking dependent remote presences).
- `dropLiveValue(context.id)` clears the daemon's caches
  (`refForId` / `idForRef`) so that stale refs aren't reachable
  via marshalling.

The clean fix: do BOTH in the dispose callback.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#452`, READY, base `llm`,
  head `kriskowal-iroh-heartbeat` at `b7d23855e`.

## Task

In your `project/` worktree at `b7d23855e`:

1. Locate the dispose callback at `packages/daemon/src/daemon.js`
   ~line 5149 (around where `context.cancel(new Error('peer connection lost'))`
   was added).
2. Add `dropLiveValue(context.id)` BEFORE or AFTER the
   `context.cancel(...)` call — both orders work; use judgment
   (probably AFTER cancel so the cancellation cascade fires
   first, then the cache mappings are cleared). Document the
   choice in the commit message.
3. Update the relevant test (`packages/daemon/test/peer-formula-revocation.test.js`
   or wherever the Option A tests live) to assert that
   `refForId.get(peerId)` is undefined post-disconnect (or
   equivalent assertion on the cache invariants).
4. Reply inline on Copilot comment id 3432011511 confirming the
   fix and citing the new commit SHA. Acknowledge Copilot was
   right.
5. Run `corepack yarn workspace @endo/daemon test` (or the
   targeted test file).
6. Run pre-push-gates.
7. Commit + push to `kriskowal-iroh-heartbeat` (append only).

## Authorizations

- Push commits to `kriskowal-iroh-heartbeat` (append only).
- Inline reply on comment 3432011511.

## Out of scope

- Do NOT rebase or force-push.
- Do NOT re-request review.
- Do NOT mark PR draft.
- Do NOT touch #442, #449, #451.
- A barrister panel (`barrister--d0e483`) is running in parallel
  on this same PR; do NOT modify its work or pre-empt its
  verdict.

## Deliverable

A `result` entry under `journal/entries/2026/06/17/` naming:
- Pre/post head SHAs.
- Per-commit substance.
- Test results.
- Pre-push-gates result.
- The inline reply URL.
- A `Self-improvement: ...` line — likely related to the
  builder dispatch brief framing the swap incorrectly.
- **Recommended next stage**: depends on barrister verdict;
  default `next: liaison`.

End your turn with a concise summary back to the orchestrator.
