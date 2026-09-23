---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr819-review-f8bab00f
verdict: not-a-miss
category: new-direction
pr: 819
review_at: 2026-08-29T04:14:50Z
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/819#pullrequestreview-5056856498
identity: endojs/endo-but-for-bots#819:review:5056856498
producing_role: builder
producing_job: endojs-endo-but-for-bots-pr819-review-f8bab00f
missed_by: n/a
severity: minor
---

# Dismissal: refresh-and-extend directive for map/set CLI, bag coherence, and cross-type verb consistency

On PR #819 (durable collection stores), the maintainer's CHANGES_REQUESTED
review is a forward-looking work directive: refresh the branch and add endo CLI
commands for maps and sets; implement sets specifically so the team can reason
about the vestigial value columns a set carries; reason through the coherence of
bag semantics; and observe that some Agent-interface/CLI verbs may be reusable
across collection types, with the principle that a verb of a given name should
carry the same signature and usage everywhere. This paraphrase omits the
untrusted review text; the verbatim body is at `comment_url`.

## Grounds

This is new direction, not a review-process miss. The judgment rests on the PR's
own material and the board, not on the comment text:

1. **The review is the origin of the work, not a critique of it.** The review
   was submitted 2026-08-29T04:14:50Z and is phrased as an invitation — "let's
   refresh and take a swing at" maps/sets CLI, "do sets so we can better reason
   about" the value columns, "reason through the coherence of bags." The primary
   builder job then *did that work*: the PR head `67d0b75a0` and title
   "feat(daemon): durable map and set stores with CLI commands" match the
   primary's tada report exactly. A review that commissions the next phase of
   work cannot be a defect the panel failed to catch in delivered work — there
   was no delivered work for it to indict.

2. **No gauntlet/panel ran on #819 that this could have pre-empted.** The only
   `journal/jobs/tada/` entries for #819 are this review's primary and a
   shepherd job; no panel/gauntlet job exists for the PR. There is no review
   surface whose output the maintainer is overriding — this is scope and
   sequencing set by the maintainer directly.

3. **Every element is taste/scope/design direction reserved to the maintainer.**
   Choosing to extend the store family with map/set CLI verbs now, using sets as
   the lens to reason about vestigial value columns, deferring bags to a
   coherence-reasoning phase, and adopting the cross-type verb-signature
   consistency principle are all scope and design-taste calls first stated in
   the comment itself. No juror seat, skill, gate, or standing instruction
   encodes "the maintainer will next want sets before bags" or "verbs must share
   signatures across collection types"; a panel that ran perfectly could not
   have anticipated them.

## Note on the verb-consistency principle

The one line that reads like a general rule — a verb of a given name should have
the same signature and usage across types — is a design principle the maintainer
is *introducing* here, not a standing convention the work violated. It governs
future cross-type CLI/Agent surface design; there is no prior seat brief, skill,
or COMMON.md norm that already bound the producer to it, so its absence at review
time is not a sense-and-correct failure. Should this principle recur as a
maintainer correction on delivered inconsistent verb signatures in a later PR,
that would be a candidate `naming`/`ergonomist` miss on its own grounds — but
here it is stated prospectively, not as a caught defect.
