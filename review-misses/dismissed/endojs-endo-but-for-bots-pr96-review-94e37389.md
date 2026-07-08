---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr96-review-94e37389
verdict: not-a-miss
category: new-direction
pr: 96
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/96#discussion_r3532573034
identity: endojs/endo-but-for-bots#96:review:4640383589:retro
producing_role: gardener-reconciliation-build-no-panel-ran
severity: minor
grounds: >
  This retro judges whether the garden REVIEW PROCESS should have anticipated
  kriskowal's review 4640383589 on PR #96 (compartment-mapper auxiliary
  package.json overrides), and concludes it could not — this is the maintainer
  offering his OWN specific naming preference in an interactive design
  conversation, the textbook new-direction case. The review body was empty; its
  single inline comment is a threaded REPLY (in_reply_to 3526843847) reading, in
  paraphrase, "for consistency I would name this searchCompartmentDescriptor;
  thank you for the more specific name suggestion." Three dispositive facts from
  the PR's actual history. First, this is a CONTINUATION of a naming thread the
  prosecutor ALREADY DISMISSED as new-direction one retro earlier
  (misses/dismissed record endojs-endo-but-for-bots-pr96-review-b474e0ee.md,
  review 4633381823, same thread root 3526843847): round one asked for "a more
  specific, coherent, differentiated pair" for the local walkUpwards and the
  exported search; the primary renamed walkUpwards -> walkToCompartmentRoot and
  left search untouched; THIS comment is kriskowal's round-two reply choosing the
  specific replacement name for the exported search (search ->
  searchCompartmentDescriptor). The round-one dismissal grounds carry over
  verbatim. Second, the comment is a FIRST-STATED MAINTAINER PREFERENCE — "I
  would name this searchCompartmentDescriptor" — a specific name the maintainer
  supplies himself, the definition of new direction the discriminator classifies
  as not-a-miss. No seat brief, skill, or standing instruction names this
  function, requires a particular public identifier, or mandates that sibling
  public functions be maximally differentiated by name; the existing exported
  name search is neither ambiguous nor a lie (it accurately searches), it is
  merely LESS SPECIFIC than the maintainer's preferred searchCompartmentDescriptor.
  The stylist's actually-encoded naming checks (gratuitous public renames,
  redundant-word concatenations) are not invoked, and the ergonomist reads the
  exported surface for mental-model coherence but cannot pre-guess a maintainer's
  bespoke preferred spelling. Third, NO CODE PANEL RAN on #96: the PR reached its
  head through implementation/reconciliation jobs (finish-ebfb-pr96*,
  reconcile-pr96-general-case, ts/design-doc and review-followup jobs), never a
  design->gauntlet->code-panel flow, so there was no prior garden review that
  failed to catch it. Recorded as a durable dismissal so this comment is never
  re-litigated. No cluster minted; no improvement dispatched. The bot's handling
  was exemplary (it even flagged the breaking-export semver implication and added
  a major changeset), reinforcing that this is collaborative naming refinement,
  not a review miss.
---

# Dismissal: endo-but-for-bots #96 review 4640383589 (retro)

kriskowal's review 4640383589 on PR #96 has an empty body and one inline
comment, a threaded reply on `packages/compartment-mapper/src/package-descriptor-cache.js`
in which the maintainer offers his own specific preferred name — rename the
exported `search` to `searchCompartmentDescriptor` for consistency — and thanks
the bot for its earlier, more-specific name suggestion. The primary job resolved
it by renaming `search` -> `searchCompartmentDescriptor` across its definition,
re-export, tests, JSDoc, and references, and added a `major` changeset for the
breaking public rename.

Not a garden review-process miss. This is the round-two reply in a naming thread
whose round one was already recorded as a durable dismissal
(`dismissed/endojs-endo-but-for-bots-pr96-review-b474e0ee.md`, review
4633381823, same thread root 3526843847); those grounds carry over. The comment
is a first-stated maintainer preference — a specific public identifier the
maintainer supplies himself ("I would name this searchCompartmentDescriptor") —
not a violation of any encoded convention. No seat brief, skill, or standing
instruction names this function or requires a particular public name; the
existing `search` is neither ambiguous nor a lie, just less specific than the
maintainer's preferred spelling. And no code panel ever ran on #96 (it reached
head via implementation/reconciliation jobs, not a design->gauntlet->code-panel
flow), so there was no prior garden review that missed anything. Interactive,
collaborative naming taste — classified new-direction. See comment_url for the
verbatim text.
