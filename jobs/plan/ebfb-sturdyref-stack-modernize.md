---
gate: deferred
priority: 2
posted_by: producer
posted_at: 2026-08-13T20:34:44Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: weaver
repo: endojs/endo-but-for-bots

Parked. Plan and execute the modernization of the sturdyref bridge stack, which
has been frozen for a month and is drifting further with every additive fix.

## The situation

Ten stacked PRs — https://github.com/endojs/endo-but-for-bots/pull/774, /737,
/541, /698, /700, /701, /702, /703, /704, /871 — sit on the frozen snapshot
`llm-da209e5` from 2026-07-13. Live `llm` is roughly 350 commits ahead.

On 2026-08-13, integrating @endo/ascii into /700 required minting YET ANOTHER
snapshot (`llm-da209e5` + the ascii package alone) because rebasing onto live
`llm` was judged too conflict-risky for that task. That was the right local
call and the wrong long-run trajectory: each additive fix deepens the
divergence and makes the eventual rebase harder, not easier.

## Why this needs its own job

- **The drift compounds.** A month behind today; the cost of modernizing only
  grows, and it is paid all at once whenever it finally happens.
- **Frozen bases entangle.** A conductor was blocked on 2026-08-13 because
  frozen base `llm-bfc91f5` was shared between two PRs, where forwarding one
  would have forked the other. Multiple live snapshots multiply that hazard.
- **Base fields drift out of truth.** /774's PR base field pointed at the MOVING
  `llm` while the stack actually sat on the snapshot, so GitHub's diff and
  mergeability for the bottom of the stack were wrong for weeks before anyone
  noticed.

## The work

1. Inventory the current state: every PR in the stack, its true base, its PR base
   field, which frozen snapshots exist, and which PRs outside the stack share any
   of them. Establish who would be affected by retiring each snapshot.
2. Decide and record the target: rebase the whole stack onto live `llm`, or
   re-cut a single current snapshot the whole stack shares. Say why.
3. Sequence it bottom-up, one PR at a time, verifying each PR's diff contains
   only its own commits after each step. Capture pre-rebase head SHAs so any
   branch can be restored.
4. Retire the superseded snapshots ONLY after confirming nothing else uses them.
5. Leave every PR's base field pointing at what it actually sits on.

## Notes

- Expect real conflicts; a month of drift across ten PRs is not a mechanical
  rebase. Budget accordingly and split into claim-sized stages rather than
  attempting the whole stack in one handler.
- Do not merge anything as part of this. The deliverable is a modernized,
  truthfully-based stack ready for normal review.
- Coordinate with any in-flight job touching these PRs before force-pushing.
