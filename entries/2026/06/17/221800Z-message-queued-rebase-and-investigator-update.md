---
ts: 2026-06-17T22:18:00Z
kind: message
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 452
    role: subject
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/452#issuecomment-4736018123
  - https://github.com/endojs/endo-but-for-bots/pull/452#issuecomment-4735987527
---

# update: queued #452 rebase + investigator-scope refinement from kumavis 22:16:31Z

Kumavis at 22:16:31Z (id 4736018123) adds two asks on top of the
22:11:25Z reconnection-semantics ask:

> @kriscendobot rebase on llm
>
> when researching this answer
> https://github.com/endojs/endo-but-for-bots/pull/452#issuecomment-4735987527
> please look at how other networks do this, like the tcp network

Added 👀 reactji (id 371464929).

## Current PR #452 state

- `gh pr view 452` shows `mergeStateStatus: DIRTY`, `mergeable:
  CONFLICTING`. The `llm` ← `actual/master` merge at 21:31Z
  (commit f9ff85c5) presumably introduced conflicts with this
  branch's iroh-heartbeat additions.
- Head: `73c22d89c` (fixer da9e7d's lint-fix push at 22:11Z).
- Fixer da9e7d still in flight at notification time; last action
  was the 22:12:48Z top-level comment.

## Queued next actions (in order, after fixer da9e7d returns)

1. **Rebase on llm** (per kumavis ask). Likely a **weaver** dispatch
   since this is a `rebase` shape with potential conflicts (not a
   fixer-style targeted edit). If conflicts are simple, the weaver
   resolves; if substantive, the weaver returns and surfaces.
2. **Investigator dispatch** for the reconnection-semantics ask,
   now with refined scope: read `packages/daemon/src/` peer/host
   formula code paths AND read the `tcp` network's existing
   implementation (somewhere in the daemon's networking layer)
   for comparison. The investigator's report should answer:
   - How does the tcp network handle connection-loss-then-use?
   - Does it teardown the peer formula and reconnect on next use?
   - Should iroh adopt the same pattern, or does iroh's different
     transport semantics call for a different shape?

The investigator dispatch supersedes the one queued at 22:14Z
(entry `221400Z-message-queued-investigator-452.md`); same target,
expanded scope per the new kumavis guidance.

## Order matters

Rebase first (clears `mergeStateStatus: DIRTY`), then investigator
(produces report against current state). Doing them in reverse
risks the investigator referencing pre-rebase line numbers.
