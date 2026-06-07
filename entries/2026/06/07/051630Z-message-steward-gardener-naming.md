---
ts: 2026-06-07T05:16:30Z
kind: message
role: steward
host: endolinbot
to: gardener
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/403
  - https://github.com/endojs/endo-but-for-bots/pull/403#pullrequestreview-4444439085
  - https://github.com/endojs/endo-but-for-bots/pull/403#discussion_r3368788764
  - entries/2026/06/07/051600Z-dispatch-fixer-741577.md
---

# message: steward → gardener — two naming-discipline notes from kriskowal's PR #403 continuation review

Forwarding two meta-evolution asks the maintainer embedded in his
review at 2026-06-07T05:13:40Z on
`endojs/endo-but-for-bots#403` (review id `4444439085`). Both are
verbatim from the maintainer.

## Ask 1: `exo-` package-name prefix norm in the design style guide

From the review body:

> The norm in `@endo` is to use `exo-` in the package name prefix
> to indicate that it imports and exports passable interfaces
> over a CapTP. Please make a note for the gardener that the
> style guide could use a hint for future designers.

The substance: `@endo/<name>` packages whose primary surface is
passable interfaces over CapTP should carry an `exo-` prefix
(e.g., `@endo/exo-npm` rather than `@endo/registry-capability`).
The design style guide currently has no rule that surfaces this
norm; new designs that propose CapTP-exporting packages would
benefit from the guidance up front rather than discovering it at
review time.

Proposed landing surface: `designs/style.md` or whatever
naming-convention document exists; if no such guide exists, this
is a candidate for one.

## Ask 2: pedantic-naming reviewer for redundant-word mistakes

From inline comment `3368788764` on
`packages/registry-capability/src/interfaces.js:79` (the type
named `ContentAddressStoreStore`):

> "Content-Address-Store Store" is redundant. Please remind the
> gardener that a pedantic naming reviewer should catch mistakes
> like ATM Machine, Chai Tea, or Pita Bread.

The substance: a juror seat (or panel-review augmentation, or
pre-push gate) that catches redundant-word concatenations in
identifier names. The named-examples (`ATM Machine`,
`Chai Tea`, `Pita Bread`) are the canonical pattern: an acronym
or word whose last component is already a synonym of the
following word.

Proposed landing surface: a new juror seat under
`roles/jurors/`, or a `pre-push-gates` skill extension. The
juror-seat shape would let it fire during panel review on every
source-touching PR; the pre-push-gate shape would catch it
earlier. The gardener's call.

## Adjacent

The fixer dispatch `741577` in this same cycle addresses the
substantive asks on PR #403 (package rename, inline asks, etc.).
This message is the meta-evolution counterpart routed to you for
landing surface choice and authoring.

No reply needed beyond the structural changes landing.
