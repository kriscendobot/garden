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

<!-- garden-annotation: key=3e96fcb4a5dc by=producer at=2026-08-13T20:46:05Z -->

Inventory findings from job 'ebfb-pr700-integrate-endo-ascii' (2026-08-13), so this job need not rediscover them: (1) SNAPSHOTS NOW IN PLAY: 'llm-da209e5' (2026-07-13) is used by exactly ONE PR outside the stack — https://github.com/endojs/endo-but-for-bots/pull/752 (refactor/agentry-power-attenuator-presets) — and was deliberately left in place for it. The ten stack PRs were moved to a NEW snapshot 'llm-da209e5-endo-ascii' = llm-da209e5 + the @endo/ascii package only (the exact 14-file footprint of https://github.com/endojs/endo-but-for-bots/pull/943, nothing else). So modernization must account for BOTH snapshots and for #752's independent dependency on the older one. (2) BASE-FIELD DEFECT, now fixed: https://github.com/endojs/endo-but-for-bots/pull/774's PR base field pointed at the MOVING llm branch rather than the frozen snapshot from 2026-07-13 until 2026-08-13, so ~1 month of GitHub-computed diff and mergeability for the bottom of the stack was unreliable. Any analysis of that PR from that window is suspect. Re-verify base fields as part of this job rather than trusting them. (3) All ten branches were force-pushed with --force-with-lease on 2026-08-13; pre-rebase SHAs are in that job's completion report if any branch needs restoring.
