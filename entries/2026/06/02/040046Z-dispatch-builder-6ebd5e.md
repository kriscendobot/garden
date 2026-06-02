---
ts: 2026-06-02T04:00:46Z
kind: dispatch
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/builder--6ebd5e
short_id: 6ebd5e
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/382
  - https://github.com/endojs/endo-but-for-bots/pull/382#issuecomment-4598586622
---

# dispatch: builder — rename @endo/endo-git → @endo/git (follow-up to #382)

Maintainer comment on MERGED #382 (kumavis-authored):

> @kriscendobot Please create a follow up that just renames
> `@endo/endo-git` to `@endo/git`. This parallels the relationship
> between `@endo/stream` and `@endo/exo-stream`, and establishes a
> precedent that we should record for further design reviews.

Builder dispatches off current `llm` (HEAD 144096f0). Opens a
DRAFT PR against `llm` renaming the package and updating all
references.

Naming-precedent encoding is gardener-shaped (the
`@endo/<short>` / `@endo/<endo-short>` convention parallels
stream/exo-stream); flagged for a follow-on gardener dispatch.
