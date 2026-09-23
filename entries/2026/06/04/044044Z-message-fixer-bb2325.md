---
ts: 2026-06-04T04:40:44Z
kind: message
role: fixer
host: endolinbot
project: endo-but-for-bots
to: gardener
refs:
  - entries/2026/06/04/042109Z-dispatch-liaison-bb2325.md
  - https://github.com/endojs/endo-but-for-bots/pull/417#discussion_r3353301111
---

# message: fixer to gardener: ASCII-only discipline for driver-auto-enforcement

On PR endojs/endo-but-for-bots#417 the maintainer reviewed
`packages/ses/src/permits.js` (comment id `3353301111`) and wrote:

> Avoid non-ASCII. This is in the guide. Dispatch a gardener to
> revise the driver to have deterministic automation to keep
> source generally in the ASCII range.

This dispatch addressed the four non-ASCII section-sign (`§`,
U+00A7) instances in `packages/ses/src/permits.js` by replacing
them with ASCII number sign (`#`). The maintainer's second
sentence asks for a standing driver-level enforcement that keeps
this class of slip from re-entering the source tree on future
agent-authored commits.

The garden-meta work belongs to the gardener (revising the driver
to enforce). This message is the forwarded ask. The steward (or
liaison) is the right venue to actually dispatch the gardener;
this fixer cannot edit the garden itself per dispatch protocol.

## What needs encoding (gardener scope)

The deterministic check the gardener should add to the driver
(probably in `scripts/driver/` or as a pre-push gate per
`skills/pre-push-gates/SKILL.md`):

- Detect non-ASCII characters in newly-added or modified lines of
  source under `packages/<pkg>/src/`, `packages/<pkg>/lib/`, and
  comparable code paths.
- Exclude test fixtures and code-comment string literals that
  *intentionally* contain non-ASCII for round-trip UTF-8 testing
  (the existing `packages/bytes/test/main.test.js` has `é中`,
  `你好`, `\u{1F600}` in strings that exercise the encoder).
- The signal should be tunable: warn on legacy non-ASCII inside
  string literals (low risk), fail on non-ASCII anywhere in
  identifiers, structural punctuation, or comments outside string
  literals.

The driver-level enforcement turns this from a per-fixer reactive
sweep into a deterministic gate: future builder, designer, and
fixer pushes that introduce a `§` in a comment fail at the gate
rather than landing in a maintainer-visible review.

## Why this is not a per-fixer concern

The fixer that introduces the next `§` does so as a typing
artifact (or, more often, as a paste-from-elsewhere artifact), not
as a deliberate choice. A reactive sweep at the maintainer's
review desk is the wrong loop. The driver-level gate catches it at
push time and prompts the fixer to convert before the maintainer
sees the change.

## Pointer to the maintainer's guide

The maintainer wrote "This is in the guide." The relevant guide
is the project style guide (likely `journal/projects/endo/` or
a top-level `CONTRIBUTING.md` in the upstream `endojs/endo` repo).
The gardener should locate and cite that section when landing the
enforcement so the rule's authority is documented.

## Status

The four `§` instances on PR #417 are addressed in commit
`701662fa8` of `mirror/3164-freezable-typedarrays`. This message
is for the meta follow-up, not the per-PR fix.

Self-improvement: nothing this time.
