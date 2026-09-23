---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr475-review-f1438d1b
verdict: miss
category: naming
pr: 475
cluster: semantic-name-matches-value-kind
cluster_pattern: A parameter or local is named for a related but different representation (such as calling a Uint8Array `buffer`), producing expressions where the same word denotes both the wrapper and its backing value; review checks behavior and types but does not compare each identifier's name with its declared and accessed value kind.
review_at: 2026-08-22T00:28:17Z
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: erights
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#pullrequestreview-4998361023
identity: endojs/endo-but-for-bots#475:review:4998361023:retro
producing_role: builder/fixer campaign
producing_job: endojs-endo-but-for-bots-pr475 campaign
missed_by: stylist naming seat and the gauntlet's types/style/docs lens
severity: minor
grounds: |
  This is the third review in erights' 2026-08-22 review burst on #475 pressing
  the same defect: a `Uint8Array`-valued binding named `buffer`, producing the
  `buffer.buffer` expression where one word denotes both the `Uint8Array` and its
  backing `ArrayBuffer`. The referenced (edited) inline comment broadens the ask
  to "all other places where two occurrences of the same identifier in one
  expression refer to completely different kinds of things." The two immediately
  prior reviews in the same burst were already recorded as misses:
  4998347995 (name-contradicts-value-type) and 4998356708
  (semantic-name-matches-value-kind, from the pre-edit version of this same
  comment). This review is the edited-comment re-surfacing of that identical
  naming pattern.

  It is a review-process miss, not new direction. The signal was visible from the
  diff alone: the flagged line's JSDoc/inferred type is `Uint8Array` while the
  identifier reads `buffer`, and the package deliberately distinguishes
  `ArrayBuffer` from `Uint8Array`/bytes. The stylist seat's standing brief already
  forbids "a name that lies about what the value is," and the 2026-08-19 gauntlet
  ran a types/style/docs lens over exactly `packages/immutable-arraybuffer/src/bytes.js`
  where the `buffer.buffer` construction already existed, yet its verdict did not
  flag the mismatch. The standing lens existed and did not bind — an ordinary
  naming completeness gap, not evaluator gaming (no measurement was moved and no
  gate was routed around).

  The first-loop deliverable exists in the world and was verified, not merely
  asserted: commit 1364f685c ("refactor(bytes): name Uint8Array values bytes")
  renames the bindings to `bytes` (so `bytes.buffer` now distinguishes value from
  backing) and is an ancestor of the current PR head affe74453; the analogous
  OCapN Syrup codec parameter was renamed in the same sweep. The primary job
  (f1438d1b) itself was a reply/summary confirming that landed fix.

  Severity is minor: the defect impairs reader comprehension but not runtime
  behavior or types. It does not qualify for the single-major standing-rule
  severity bypass.
---

# Miss: `buffer.buffer` — one identifier denotes two value kinds on #475 (edited re-surfacing)

erights' COMMENTED review 4998361023 on #475 (empty body; a meta-note pointing at
an edited inline comment — verbatim untrusted text at `comment_url`) re-raises the
naming defect: on the flagged line the identifier `buffer` appears twice denoting
two different kinds of value (a `Uint8Array` and its backing `ArrayBuffer`), and
the edited comment asks for every analogous site where the same identifier occurs
twice in one expression referring to different kinds of things.

## Grounds (miss — naming)

Same pattern as `semantic-name-matches-value-kind`: a name chosen for a related but
different representation, producing an expression where one word denotes both the
wrapper and its backing value. Visible from the declared type and the member access
in the diff, with no maintainer-only knowledge. The stylist naming lens and the
gauntlet's style/docs lens both ran over this file and did not flag it. This is the
third instance of the same defect in one review burst on a single PR (#475), the
prior two already recorded (4998347995, 4998356708).

## Disposition

Recorded as a miss joining the existing `semantic-name-matches-value-kind` cluster.
Held below dispatch: even after joining, every member of this cluster — and of the
sibling `name-contradicts-value-type` cluster — comes from the single PR #475, so
the floor's ≥ 2-distinct-PR guard is not met. This is precisely the "one messy PR
masquerading as a systemic pattern" case the guard exists to hold: one maintainer
pressing one naming point across a burst of edits, not cross-PR recurrence. Minor
severity, so no major-severity bypass. The first-loop fix (1364f685c) is confirmed
present in PR head affe74453.
