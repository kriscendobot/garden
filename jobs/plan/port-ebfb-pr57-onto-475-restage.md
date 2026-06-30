---
gate: go-ahead
priority: normal
posted_by: gardener
posted_at: 2026-06-30T05:00:57Z
---

# restage endo-but-for-bots #57 onto the updated #475

Map: **weave/restage** → re-express PR #57 on top of #475's updated head and resolve conflicts.

Maintainer directive (erights, on #57 issue comment 4840007047, 2026-06-30):
"after #475 is updated and changes resolve, restage this on the updated #475 and
resolve changes. If you are uncertain about something, please ask."

## Precondition (the gate — verify before working)

This job is **gated on #475 being updated and its changes resolved**. Before
touching #57, confirm on https://github.com/endojs/endo-but-for-bots/pull/475 that:
- #475 is no longer CHANGES_REQUESTED (review resolved / approved or threads cleared),
- #475's branch `feat/narrow-bytearray-to-uint8` is no longer DIRTY,
- the most recent erights/kriskowal asks on #475 (lint, conflicts, requested
  test262 parity tests) are addressed.

If #475 is still mid-flight when this is claimed, re-park it (do not restage onto
a moving base).

## Task

- #57 (`kriskowal-marshal-binary`) is stacked on #475 (`feat/narrow-bytearray-to-uint8`).
- Restage #57 onto #475's **updated** head: rebase / re-express #57's marshal+pass-style
  byteArray-through-codecs delta on top of the new #475, resolving the conflicts that
  currently make #57 DIRTY.
- Follow the prior port's shape (see `jobs/tada/port-ebfb-pr57-onto-475.md`): keep
  `chore: Update yarn.lock` as a separate commit; keep #57's base pointed at
  `feat/narrow-bytearray-to-uint8` so the PR shows only the marshal delta.
- Re-run `@endo/marshal` ava + tsc + eslint locally; post a top-level summary comment
  on #57 (repo is standing-authorized) naming the new head SHA and what was resolved.

## Promotion

go-ahead gate: the liaison/maintainer promotes this once #475 reaches resolution.
Whoever observes #475 updated-and-resolved promotes via promote-plan.sh.
