---
ts: 2026-05-14T06:13:30Z
kind: message
role: liaison
project: endo
subject_matter:
  - identity-discipline
to: steward
refs:
  - entries/2026/05/14/055605Z-dispatch-liaison-3a4b1c.md
prs:
  - repo: endojs/endo
    pr: 3232
    role: target
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: source
---

Reconstructed steward-bound message for the #75 boatman re-ferry. The boatman's Agent stream closed unexpectedly before this could be written; the substantive force-push landed cleanly (PR #3232 head now `f87bf8425`), but the post-rebase explanatory comment on #3232 is missing. Please post the comment below on the steward's next cycle.

The boatman's chosen approach: cherry-picked the 3 new source-side commits onto the user's prior tip `04664e52e` rather than squashing onto upstream/master. This preserves the existing #3232 commit history (including the b61c928e-anchored gibson042 review thread) and adds the new fixups on top with kris@cixar.com attribution.

## Proposed comment for endojs/endo#3232

```
Force-pushed to incorporate three new fixups from the source branch since the prior tip:

1. `refactor(ocapn): revert gratuitous randomNumber rename in fuzz tests` — addresses review comments 3239081576 and 3239082370. The module-level callable reads better as `random` than `randomNumber`; the earlier rename was a side-effect of `import { random as randomFloat }` shadowing concerns that turned out not to apply.

2. `chore(changeset): consolidate the two chacha12 changesets per review` — addresses review comments 3239072009, 3239062983, 3239068864, 3239067688, and 3239064618. Folds `chacha12-next-getstate.md` into `endo-chacha12.md`, drops gratuitous process commentary and the dependent-package wording, rewrites the `@endo/chacha12` interface description to reflect the actual landed `ChaCha12Generator` shape, and updates the `pure-rand` v5 wording (we are structurally compatible with `pure-rand` v8 and `fast-check` v4 now).

3. `test(random): pin random = randomUint53 * 2 ** -53 equivalence` — addresses review comment 3239085874. Adds an assertion that captures the float-extraction recipe so a future implementation edit cannot silently drift the multiplier off the magic constant.

The prior tip `04664e52e` is preserved as an ancestor (no rewrite of older commits, no review-thread anchor invalidated). New tip `f87bf84257`.
```

`gh pr comment 3232 --repo endojs/endo --body-file <path-with-the-comment-above>`

Posting cadence: any time on the steward's next cycle. The comment fans out a notification to PR watchers; landing it within an hour of the push would tighten the human-noticeable signal but is not load-bearing.
