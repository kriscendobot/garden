---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr96-review-b474e0ee
verdict: not-a-miss
category: new-direction
pr: 96
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/96#pullrequestreview-4633381823
identity: endojs/endo-but-for-bots#96:review:4633381823:retro
producing_role: gardener-reconciliation-build-no-panel-ran
severity: minor
grounds: >
  This retro judges whether the garden REVIEW PROCESS should have anticipated
  kriskowal's review 4633381823 on PR #96 (compartment-mapper auxiliary
  package.json overrides), and concludes it could not reasonably have — this is
  a taste-level naming refinement, not a demonstrable seat miss. The review body
  was empty; the single inline comment (on
  packages/compartment-mapper/src/package-descriptor-cache.js) observed that a
  closure-local helper named walkUpwards and the pre-existing exported search
  read as undifferentiated (both connote searching/walking upward) and asked for
  a more specific, coherent, differentiated pair. The primary job resolved it by
  renaming the local const walkUpwards -> walkToCompartmentRoot (3 references,
  non-exported) and left the widely-used exported search untouched. Three
  dispositive facts from the PR's actual history. First, the target is a
  NON-EXPORTED, closure-local helper introduced during the #96 reconciliation
  build — the finest grain of naming, below the surface any seat prioritizes:
  the ergonomist reads the EXPORTED user-facing surface for mental-model
  coherence, and the stylist reads code identifiers for names that are ambiguous
  or that LIE about what they do. walkUpwards is neither ambiguous nor a lie —
  it accurately walks upward. Second, NO ENCODED CONVENTION was violated. No
  seat brief, skill, or standing instruction says a local helper name must be
  maximally differentiated from a sibling function's name in the same file; the
  ask is for GREATER specificity/coherence as a pair (state the distinguishing
  target — climbing to the compartment root), a refinement toward a better name,
  not a correction of a wrong one. Contrast the stylist's actually-encoded
  naming checks (gratuitous renames of public identifiers; redundant-word
  concatenations like ATM-Machine / ContentAddressStoreStore) — none of which
  this comment invokes. Third, NO CODE PANEL RAN on #96: the PR reached its head
  through implementation/reconciliation jobs (finish-ebfb-pr96*,
  reconcile-pr96-general-case, the ts/design-doc and review-followup jobs),
  never a design->gauntlet->code-panel flow, so there was no prior garden review
  that failed to catch this; but even had the stylist fired, "these two names
  read too similarly" on a 3-reference local const is exactly the close-read
  maintainer-taste polish the discriminator classifies as new direction. The
  maintainer's own framing — "a more specific, coherent, differentiated pair" —
  is a preference statement, not a convention citation. Recorded as a durable
  dismissal so the same comment is never re-litigated. No cluster minted; no
  improvement dispatched.
---

# Dismissal: endo-but-for-bots #96 review 4633381823 (retro)

kriskowal's review 4633381823 on PR #96 has an empty body and one inline comment
observing that a closure-local helper `walkUpwards` and the pre-existing exported
`search` in `package-descriptor-cache.js` read as undifferentiated, asking for a
more specific, coherent, differentiated pair. The primary job resolved it by
renaming the local `walkUpwards` -> `walkToCompartmentRoot` (3 references,
non-exported), leaving the exported `search` untouched.

Not a garden review-process miss. The target is a non-exported, closure-local
helper — the finest grain of naming, below the surface any seat prioritizes (the
ergonomist reads the exported surface for the user's mental model; the stylist
reads identifiers for names that are ambiguous or that lie, and `walkUpwards`
accurately walks upward). No encoded convention was violated: no seat brief,
skill, or standing instruction requires a local helper to be maximally
differentiated from a sibling name — the ask is for a *more* specific/coherent
pair, a refinement toward a better name rather than a correction of a wrong one.
And no code panel ever ran on #96 (it reached head via implementation/
reconciliation jobs, not a design->gauntlet->code-panel flow), so there was no
prior garden review that missed anything; even had the stylist fired, "these two
names read too similarly" on a 3-reference local const is close-read maintainer
taste, classified new-direction. See comment_url for the verbatim review.
