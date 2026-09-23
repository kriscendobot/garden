---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr442-review-61c65980
verdict: miss
category: style-convention
pr: 442
cluster: typedef-location-dts
cluster_pattern: Exported/shared type definitions authored as @typedef in a .js module instead of a hand-written .d.ts — a repeat of an explicit maintainer directive the garden already encoded as prose only.
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/442#discussion_r3522728825
identity: endojs/endo-but-for-bots#442:review:4629047816
producing_role: builder
producing_job: ebfb-pr-442-rebase-then-refactor-on-platform
missed_by: typist (always-on core) / pre-push gate (absent)
severity: major
---

# Review-miss: typedef-only `.js` module should be a `.d.ts` (repeat of an encoded directive)

On the `@endo/daemon-cas` extraction PR, the maintainer's CHANGES_REQUESTED review
carried three inline comments. Two are new-direction/taste and are NOT misses
(recorded in `grounds` below); the third is the miss recorded here.

**The miss (comment 1, `packages/platform/src/fs/types.js`):** the maintainer asked
for the type definitions to live in a `.d.ts` file rather than a typedef-only `.js`
module. This is a paraphrase — see `comment_url` for the verbatim text.

## Grounds

The `.d.ts`-for-type-definitions convention is a **standing garden rule that already
existed and did not bind on this PR**. It is written verbatim in two authoritative
places, both encoded from an *identical* maintainer directive two days earlier:

- `roles/builder/AGENT.md` (the builder directive line): "Type definitions belong in
  a `.d.ts` / `.ts` types module, not inline `@typedef` in a `.js` file."
- `roles/jurors/typist/AGENT.md` (the always-on typist seat brief): flags an
  exported/shared `@typedef` living in a `.js` file rather than the package's
  dedicated type-definition module.

Both carry the same provenance: kriskowal on `endojs/endo-but-for-bots#58` review
`4612637233` (2026-07-02), "Typedefs in .d.ts, please. **Adjust the garden to avoid
this in the future with builder directives and a reviewer.**" The garden did exactly
and only that — a builder directive plus a reviewer (typist) seat line — yet the same
convention was violated again on #442 and the maintainer had to repeat the feedback.
This is a pure sense-and-correct failure of an explicit maintainer prevention-request:
the pattern now spans two distinct PRs (#58 → #442).

Why it slipped: the #58 response omitted the strongest tier the review-retrospective
skill prefers — a **deterministic pre-push gate**. `scripts/.../pre-push-gates/probes/`
has no typedef-location probe, so nothing mechanical blocked the push. The typist seat
is always-on, but a whole-file `types.js` of exported typedefs is a slightly different
shape than the "inline `@typedef` in an implementation `.js`" the seat brief names, and
the gauntlet panel does not appear to have run on #442 at all (no panel/gauntlet job in
`journal/jobs/tada/` for the PR) — so the only remaining reviewer was the maintainer.
A gate cannot be skipped and cannot forget; it is the missing durable check.

**The two non-misses in the same review (recorded here, not clustered):**
- Comment 2 (`fs-node/content-store-powers.js`): "I suspect this module is
  superfluous / duplicates fs and crypto powers." An architecture judgment, lightly
  held ("I suspect"); the fixer investigated and kept it with reasoned pushback. New
  direction / design taste — nobody could have anticipated it.
- Comment 3 (`daemon-cas/src/content-store.js`): "leaning lightly toward" separating
  the storage path from the powers options, "Consider" flattening. Explicitly tentative
  API-ergonomics design preference first stated in the comment. New direction / taste.
