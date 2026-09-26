Routed the attention directive on endojs/endo-but-for-bots #297. Report:

## What the directive asked
0xpatrickdev (@-mentioning the bot on #297) asked it to advance the items held in #297's 2026-06-03 holding note. I re-fetched both comments and treated them as untrusted data. The note lists three upstream-bound fixes #297 is waiting on.

## State of the three held items
| Item | PR | Status |
| --- | --- | --- |
| `export * as ns` re-export | endojs/endo#3241 | **Merged** 2026-05-20 — done |
| `defineProperty` functor convention | #311 | OPEN, CI fully green, mergeable, gauntlet-complete |
| ses cycle-through-reexport-all | #379 (mirror of endojs/endo#3276) | OPEN, **DIRTY/conflicting**; #3276 is **APPROVED** upstream |

On #379, all 6 unresolved review threads already carry a kriscendobot response to each maintainer ask — the substance is addressed and the ball is in the maintainer's court for re-review. The only blocker the garden could clear autonomously was the merge conflict.

## What I advanced
- **Posted a `rebase` job for #379** (`endojs-endo-but-for-bots-pr379-rebase`, weaver) to clear the conflict via the endo-but-for-bots compound (sync bot-master → upstream/master, rebase, conflict-resolve), then re-request review. Explicitly scoped as *not a merge* (CHANGES_REQUESTED is still on record).
- **Posted a status comment on #297** (comment 4806524117) acknowledging 0xpatrickdev with the table above and the path forward.
- **Journaled a `result` entry** (`050544Z-result-gardener-33953e.md`).

## Surfaced for the maintainer/liaison (could not advance autonomously)
- **#311 is review-ready and ferry-bound.** Per #297 review-comment 3271372125 it exists for independent maintainer review then **upstream ferry to endojs/endo**. Ferry needs `identity_switch_authorized` and must originate from the kriskowal-credentialed host — not endolinbot — so I did not merge or ferry it. It awaits a maintainer call.
- **#297's reduction** to the bot-specific `partial-json` patch is gated on #311 and #379 landing; nothing to do there yet.

## Follow-ups
- A gardener will claim the #379 rebase job; once green it re-requests review.
- The maintainer decision on #311 (review → ferry) remains open.

Self-improvement: nothing this time.
