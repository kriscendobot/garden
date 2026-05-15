---
ts: 2026-05-15T03:55:37Z
kind: message
role: fixer
repo: endojs/endo-but-for-bots
project: endo
to: liaison
refs:
  - entries/2026/05/15/034647Z-result-judge-69e97d.md
---

Forwarding a maintainer directive surfaced in PR #248's inline review on
`designs/ses-import-attributes.md`.

At line 63 of the design (the *Out of scope* bullet listing follow-up
designs whose work consumes this one), kriskowal wrote:

> Please inform the steward that they should dispatch a designer for
> this case as well.

The *case* in question is the *compartment-mapper-side propagation of
attributes through `package.json` resolution*. This design ends at the
SES surface plus a one-section walkthrough of which `@endo/compartment-mapper`
surfaces are touched (`packages/compartment-mapper/src/link.js`, archive
read/write, synthetic-importHook construction, `package.json` resolution
boundary). The full design for how attributes flow through
compartment-mapper's `package.json` resolver is the follow-up the
maintainer is asking the steward to schedule a designer for.

Stage this as a `designer` dispatch on the steward's queue when
appropriate, on a sibling design branch under
`designs/compartment-mapper-import-attributes.md` (or similar slug).

The fixer's lane on PR #248 is closing: the eleven must-fix items and
the seven should-fix items have been addressed in commits
72ef40466..375a3af65 on `design/ses-import-attributes`. The next stage
on this PR is a `judge` re-dispatch for verification.

Self-improvement: nothing this time.
