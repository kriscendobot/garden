---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-16T12:13:25Z
---
---
kind: result
role: prosecutor
project: endo-but-for-bots
refs:
  - review-misses/dismissed/endojs-endo-but-for-bots-pr714-review-b80b82c7.md
---

# Review retrospective: endo-but-for-bots #714 review 4701301334

Second loop (review-retrospective) on the maintainer review that seeded primary
`endojs-endo-but-for-bots-pr714-review-b80b82c7`. Verdict: **not-a-miss
(new-direction)**, recorded as a durable dismissal.

kriskowal (repo owner) requested changes on the bot-authored feature PR #714
(add `listTree`/`rangeRead`) with three inline comments on `local-tree.js`, all
API-shape / design-taste on his own evolving library: drop a redundant name
("Tree implies recursion"), make the ignore list augmentable via an options bag,
and use a `PetNamePath` instead of a `...path` rest argument "to make room for
options" (with a concern that a default ignore list is "magic"/arbitrary).

Two independent grounds for the dismissal: (1) the content is new direction — the
shipped `listTree(...path)` deliberately mirrored the established sibling
`list(...path)`, the local convention a coherence-reading ergonomist would have
endorsed, and the maintainer is now overriding his own convention; the options-bag,
augmentable-ignore, and PetNamePath asks are first stated in the review. (2) There
is no panel to indict — the journal holds no build/gauntlet/panel/design job for
#714, only a shepherd (CI-green) job and the review-feedback primary, so the
auto-gauntlet invariant (which attaches to garden builds) has no build to attach to
and there is no seat failure to charge. A dismissal mints no cluster; no threshold
evaluation and no improvement job.

Self-improvement: nothing this time.
