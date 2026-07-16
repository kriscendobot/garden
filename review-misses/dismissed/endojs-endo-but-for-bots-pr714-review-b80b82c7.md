---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr714-review-b80b82c7
verdict: not-a-miss
category: new-direction
pr: 714
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/714#pullrequestreview-4701301334
identity: endojs/endo-but-for-bots#714:review:4701301334:retro
producing_role: none-no-garden-build-or-panel-on-record
severity: minor
grounds: >
  kriskowal (the repo owner and maintainer) submitted review 4701301334
  (CHANGES_REQUESTED, empty body) on PR #714 with three inline comments, all on
  packages/platform/src/fs-node/local-tree.js, all API-shape / design-taste calls
  on his own evolving library surface: (1) a naming-taste objection that a change
  was unnecessary because "Tree implies recursion"; (2) a forward-design request
  that the listTree ignore list be augmentable via an options bag; (3) a request
  to replace the variadic `...path` rest argument with a typed PetNamePath "to
  make room for options," bundled with a design concern that a default ignore
  list is "magic" and "should not be arbitrary." This retro judges whether the
  garden REVIEW PROCESS should have anticipated this feedback and concludes it
  could not have, for two independent reasons. First, the CONTENT is new
  direction, not a violated convention: the shipped surface `listTree(...path)`
  was deliberately modeled on the established sibling `list(...path)` (the PR body
  calls it "the recursive counterpart to `list`"), so the rest-argument shape was
  the LOCAL convention an ergonomist reading sibling surfaces would have endorsed
  for coherence — the maintainer is now OVERRIDING his own convention ("that will
  make room for options"), and the options-bag, augmentable-ignore-list, and
  PetNamePath asks are all first stated in this review. No standing rule the panel
  demonstrably knows (seat brief, skill, or COMMON.md norm) was broken; these are
  the maintainer's design-taste and scope calls on how his API should grow.
  Second, there is NO panel to indict: the journal holds no build, gauntlet,
  panel, or design job for #714 — only a shepherd (drive-CI-green) job and the
  review-feedback primary (pr714-review-b80b82c7). The garden has no record of
  building or panelling this PR (kriscendobot authored it 2026-07-12 as a #135
  follow-up, around the codex/cleric experimental-dispatch activity of that week),
  so the auto-gauntlet invariant — which attaches to garden BUILDS — has no build
  to attach to here, and there is no panel-seat failure to charge. Even a fully
  panelled #714 would most likely have shipped this same surface (sibling-coherent
  with `list`) and drawn the identical maintainer redirection. Same class as prior
  maintainer design-direction dismissals: unanticipatable API-taste on the owner's
  own library. Recorded as a durable dismissal so this review is never
  re-litigated. No cluster minted; no improvement dispatched.
---

# Dismissal: endo-but-for-bots #714 review 4701301334 (retro)

kriskowal (the repo owner) requested changes on the bot-authored feature PR #714
(add `listTree`/`rangeRead`) with three inline comments on `local-tree.js`, all
API-shape / design-taste: drop a redundant name ("Tree implies recursion"), make
the ignore list augmentable via an options bag, and use a `PetNamePath` rather
than a `...path` rest argument "to make room for options" (with a concern that a
default ignore list is "magic" / arbitrary).

Not a garden review-process miss, on two independent grounds. (1) The content is
new direction: the shipped `listTree(...path)` deliberately mirrored the
established sibling `list(...path)` — the local convention a coherence-reading
ergonomist would have endorsed — and the maintainer is now overriding his own
convention; the options-bag, augmentable-ignore, and PetNamePath asks are first
stated in the review, not violations of a standing rule the panel knows. (2)
There is no panel to indict: the journal has no build/gauntlet/panel/design job
for #714, only a shepherd (CI-green) job and the review-feedback primary, so the
auto-gauntlet invariant (which attaches to garden builds) has no build to attach
to and there is no seat failure to charge. Even a panelled #714 would likely have
shipped the same sibling-coherent surface and drawn the identical redirection.
New direction — unanticipatable API-taste on the owner's own library. See
comment_url for the verbatim review.
