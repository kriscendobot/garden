---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr475-review-90ef14d6
verdict: not-a-miss
category: new-direction
pr: 475
review_at: 2026-08-22T01:02:48Z
repo: endojs/endo-but-for-bots
surface: pr-review-comment
author: erights
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#discussion_r3834646848
identity: endojs/endo-but-for-bots#475:review:4998441893:retro
producing_role: builder
producing_job: n/a
missed_by: n/a
severity: minor
---

# Dismissal: request for a cross-package DataView-wrapper commutativity test

PR #475 ("feat(pass-style): narrow byteArray to plain frozen Uint8Array")
modifies `packages/immutable-arraybuffer/src/lib.js`, whose shim wraps the
original `DataView.prototype.setFloat*` methods. On that file the senior
contributor observed that the ses-shim independently wraps the same methods to
close the NaN side-channel vulnerability, reasoned that the two wrappings ought
to commute (identical observable behavior regardless of install order), and
asked that a joint test be written exercising both install orders, placed in the
`@endo/ses` package because of the layering, and made to run on XS. This
paraphrase omits the untrusted review text; the verbatim comment is at
`comment_url`.

## Grounds

This is new direction, not a review-process miss. The judgment rests on the PR's
review history and the diff, not on the comment text or the primary report:

1. **The requirement is first stated in the comment and rests on knowledge no
   review surface holds.** The demand is not "cover the new runtime path in the
   changed package" (which a coverage seat could raise) but "prove that this
   shim's DataView.setFloat* wrapping commutes with a *separate* package's
   NaN-side-channel repair of the same methods." That property requires knowing
   the ses NaN repair exists, wraps the identical methods, and must compose --
   domain knowledge held by the repair's author. No juror-seat brief
   (`fast-checker`, `coverage-auditor`, `prover`), skill, gate, or standing
   instruction encodes "when a diff touches a method another security shim also
   wraps, demand a cross-package commutativity test." A panel that ran perfectly
   on the #475 diff could not have conceived of it, and a general check that
   fired on this signal would either need the same cross-package knowledge or
   fire as noise across every wrapper edit.

2. **The gauntlet did run; this was not an avoidance/process gap.** The design
   PR was not routed around review -- `journal/jobs/tada/` holds
   `endojs-endo-but-for-bots-pr475-gauntlet-20260819.md`, so a gauntlet was
   supervised on this PR. The comment is not a symptom of a skipped evaluator; it
   is a maintainer adding coverage the evaluator was never taught to want.

3. **It is a scope/coverage addition, and the primary loop delivered it.**
   Confirmed against the world (not the primary's assertion): the primary
   `endojs-endo-but-for-bots-pr475-review-90ef14d6` pushed real commit
   `313e0ba42b` ("test(ses): cover DataView wrapper commutativity (#475)", 8
   files) adding both-order tests
   (`packages/ses/test/dataview-wrappers-immutable-first.test.js`,
   `dataview-wrappers-ses-first.test.js`, shared assertion helpers) in `@endo/ses`
   plus XS generation via `packages/ses-test/scripts/generate-test-xs.js`. The
   deliverable exists; there is no false-peer no-op here.

Choosing to prove a novel commutativity property between two independent
security shims is a taste/scope decision the maintainer surfaced, not a knowable
correctness, spec, or convention violation the review process failed to bind. A
dismissal mints no cluster and dispatches no improvement job.
