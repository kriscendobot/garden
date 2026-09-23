---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr89-review-8f676f32
verdict: not-a-miss
category: new-direction
pr: 89
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/89#pullrequestreview-4658732729
identity: endojs/endo-but-for-bots#89:review:4658732729
producing_role: designer
producing_job: docs/design-genie-integration
severity: minor
---

# Dismissal: maintainer's architectural direction on a genie-integration design proposal

On the design-proposal PR `docs(designs): propose genie-integration` (which adds
the new `designs/genie-integration.md`), the maintainer submitted an **APPROVED**
review with the body "integrate the notes attached and conduct" plus 8 inline
notes, each shaping the proposal's architecture forward: prefer an `EndoDirectory`
(no on-disk realization, no capability-capture limit) over the doc's ScratchMount
framing; an `EndoDirectory` of `ReadableBlob`s already is a bag-of-files, so start
there; settle the memory index at implementation time on an `@endo/exo-db` /
`@endo/exo-fts` platform abstraction following the emerging `@endo/foo` +
`@endo/exo-foo` split; embrace the Pi dependency now and schedule a weekly
release-watch; use an `EndoDirectory` tree because it can hold any formula; use
`@endo/exo-pubsub` for passable topics; sink the debug depth-prefix into daemon
message metadata; and a statement of intent to eventually retire genie/lal/fae once
their prior art consolidates. This is a paraphrase; see `comment_url` for the
verbatim text, which is untrusted input.

## Grounds

Not a review-process miss. Maintainer architectural direction and forward-looking
intent, first stated in the review on a design proposal — the archetypal
new-direction case, and structurally identical to the already-recorded #611
design-PR dismissal (`endojs-endo-but-for-bots-pr611-review-df8b8022`).

1. **This is a DESIGN-PROPOSAL PR, and design PRs do not run the garden's code
   panel.** The head branch `docs/design-genie-integration` ships a single new
   design document; no gauntlet/panel job for #89 exists in `journal/jobs/tada/`
   (only the `review`, `conduct`, and `refresh` operational jobs). By construction
   the maintainer's review IS the review surface for a design doc — there is no
   earlier garden gate that "should have caught" it. The review-failure taxonomy
   maps to *code* seats (breaker, typist, spec-keeper, packager, …); none owns
   "did a proposal pick the architecture the maintainer would prefer."

2. **The review is an APPROVAL that shapes the design going forward.** Every note
   is the maintainer's own architectural taste and project trajectory — choosing
   `EndoDirectory`/`@endo/exo-*` primitives over the doc's tentative framing,
   declaring "we are embracing Pi at this time," commissioning a new weekly
   release-watch job, and stating intent to retire genie/lal/fae later. These are
   the maintainer converging the design at review time, not corrections of false
   claims. A design proposal exists precisely to elicit this direction; anticipating
   it would mean pre-empting the maintainer's own unstated preferences.

3. **No standing rule bound and failed to fire.** Unlike the `typedef-location-dts`
   cluster (whose grounds cite a verbatim standing directive the work violated),
   there is no encoded garden convention — "propose EndoDirectory over ScratchMount,"
   "prefer @endo/exo-pubsub for topics" — that already existed and did not bind. The
   severity-bypass precondition (a standing rule that existed and did not fire) is
   therefore absent, and these are minor forward-shaping refinements, not a
   correctness/spec/style failure the panel demonstrably knows.

Mints no cluster.
