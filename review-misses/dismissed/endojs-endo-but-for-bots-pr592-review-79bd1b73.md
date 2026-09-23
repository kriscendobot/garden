---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr592-review-79bd1b73
verdict: not-a-miss
category: new-direction
pr: 592
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/592#pullrequestreview-4668730401
identity: endojs/endo-but-for-bots#592:review:4668730401:retro
producing_role: builder
producing_job: factor-watchdirectory-to-endo-platform
severity: minor
grounds: >
  kriskowal's FIFTH CHANGES_REQUESTED review on PR #592 (garden-authored: the
  builder factored the watchDirectory primitive out of @endo/daemon into
  @endo/platform and, in the same PR, reworked packages/daemon/src/mount.js). The
  review body is empty; the substance is eight inline comments, paraphrased: (1)
  the 50ms debounce default should be a configurable watchDirectory option
  threaded up to followNameChanges as a general, advisory setting an
  implementation may ignore; (2) a bare "not sufficiently specific" on
  mount.js:413; (3) the mount code should thread a cancellation context that
  propagates to cancelling watchDirectory, because a mount formula can be
  cancelled; (4) avoid the `Arg` abbreviation — the parameter is likely a
  `pathComponent` or `segment`; (5) a non-blocking "I do not mind a drive-by
  commit to improve these names"; (6) are `args` segments, and is spreading them
  here consistent with the EndoDirectory interface; (7) "Likewise"; (8) "I
  believe I've provided feedback in the past that this should be named `mount`,
  since it produces a mount from a mount ... I do not mind a drive-by ... I could
  equally be convinced that this should be more entangled with the agent-in-charge
  so it can produce a durable formula for the resulting mount point, by name."
  This retro judges whether the garden REVIEW PROCESS should have anticipated
  these and concludes it could not have, on five grounds drawn from the PR's
  actual history. (a) NO panel/gauntlet ran on #592 — the PR is still DRAFT
  (draft=true at review time), the builder correctly left it draft to flag the
  gamut, and the maintainer is reviewing and steering the draft first; the panel,
  the juror seats, and the pre-push gates are the review process, and none of them
  has run yet, so there is nothing for them to have "missed." This is the same
  established basis on which all four prior #592 reviews were dismissed
  (da7fef5e/4629031768, 9e382ba1/4631951294, 1050d7e9/4631937541,
  2e32890c/4631936168). (b) The naming asks (4,5,8) are the maintainer refining an
  in-progress cleanup the garden builder was ALREADY doing: the PR diff shows the
  builder renaming pathArg→path, segmentsFromPathArg→segmentsFromPath,
  resolvePathArg→resolvePath, segmentsFromHasArgs→segmentsFromHasInput in this
  very change; the maintainer is co-refining the remaining vocabulary (Arg →
  pathComponent/segment, makeMountExo → mount) and explicitly frames it as
  optional ("I do not mind a drive-by," "I could equally be convinced"), i.e.
  non-blocking taste on the maintainer's own long-standing codebase vocabulary
  ("I've provided feedback in the past"), not a garden-introduced naming defect.
  (c) NO encoded review element demonstrably knows an identifier-abbreviation-
  avoidance convention and failed to bind at authoring: a grep of roles/ and
  skills/ for abbreviation/shorthand/full-word surfaces only the no-latin-shorthand
  skill (Latin i.e./e.g./etc. in prose, not identifier abbreviations like `Arg`)
  and the ergonomist/stylist juror-seat naming lenses — which are PANEL seats
  (didn't run) whose lens is surface coherence and the caller's mental model, not
  a mechanical "never abbreviate"; the specific call that `Arg` should be
  `pathComponent`/`segment` and that a mount-from-a-mount should be named `mount`
  is the maintainer's domain vocabulary for the daemon mount / EndoDirectory
  surface, which no seat, skill, or standing instruction encodes. (d) The
  substantive design asks (1 configurable advisory debounce interval threaded to
  followNameChanges; 3 cancellation-context propagation to watchDirectory; 6
  EndoDirectory args/segments consistency) are interface-design refinements first
  stated in this review, rooted in the maintainer's knowledge of the daemon's
  mount/cancellation model — scope/direction on a draft, not a violated standing
  bar or a lost invariant. (e) The vague "not sufficiently specific" (2) carries
  no encoded convention a check could sense. All eight comments are pre-panel
  maintainer steering of a draft. New direction, not a garden review-process miss.
  Recorded as a durable dismissal so the same review is never re-litigated. No
  cluster minted; no threshold evaluation; no improvement dispatched. Calibration
  note: this is the FIFTH kriskowal review on #592 to resolve to a dismissal —
  the PR is a still-draft, heavily-steered refactor, and every review has been
  pre-panel direction; the floor is >= 2 distinct PRs, so no cluster forms from
  this single PR (the one-PR-masquerading-as-systemic pitfall). Were a SECOND
  garden-authored PR later to draw the same identifier-abbreviation naming ask
  AFTER its panel had run (so the ergonomist/stylist demonstrably had a turn and
  missed it), that would be the moment to record a naming miss and consider a
  cluster.
---

# Dismissal: endo-but-for-bots #592 review 4668730401 (retro)

kriskowal's fifth CHANGES_REQUESTED review on the watchDirectory-into-@endo/platform
refactor (which also reworks packages/daemon/src/mount.js) has an empty body and
eight inline comments: make the 50ms debounce a configurable advisory option
threaded to followNameChanges; thread a cancellation context that propagates to
watchDirectory cancellation; avoid the `Arg` abbreviation (prefer
`pathComponent`/`segment`); improve several names via optional drive-by;
questions about whether spreading `args` is consistent with the EndoDirectory
interface; and a note that a mount-from-a-mount producer should be named `mount`
(long-standing maintainer feedback), possibly reworked to mint a durable formula.

Not a garden review-process miss. The PR is still DRAFT and no panel/gauntlet has
run — the builder correctly left it draft for the gamut and the maintainer is
steering the draft first, the same basis on which all four prior #592 reviews were
dismissed. The naming asks refine a cleanup the builder was already doing (the diff
renames pathArg→path, segmentsFromPathArg→segmentsFromPath, resolvePathArg→resolvePath),
are explicitly non-blocking drive-bys on the maintainer's own codebase vocabulary,
and no garden seat/skill/standing instruction encodes identifier-abbreviation
avoidance (grep surfaces only the Latin-prose no-latin-shorthand skill; the
ergonomist/stylist naming lenses are panel seats that never ran). The design asks
(configurable debounce, cancellation-context propagation, EndoDirectory
consistency) are interface-refinement direction first stated in the review, rooted
in the maintainer's mount/cancellation domain knowledge. Pre-panel steering of a
draft — new direction, not a miss. Fifth #592 review to dismiss; one PR, so no
cluster forms. See comment_url for the verbatim review.
