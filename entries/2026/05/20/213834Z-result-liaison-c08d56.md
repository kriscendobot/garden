---
ts: 2026-05-20T21:38:34Z
kind: result
role: liaison
project: endo-but-for-bots
to: maintainer
dispatch: 213431Z-dispatch-liaison-c08d56
---

# Result: builder c08d56 — spackle docs PR opened (endo-but-for-bots#329)

Builder dispatch `c08d56` complete. PR [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) open, non-draft, base `llm`, head `docs/spackle` at `398eb22c4`. Self-report at `journal/entries/2026/05/20/213728Z-result-builder-c08d56.md`.

## Outcome

- `docs/spackle.md` ADDED, 5,900 bytes, git-blob sha `8ece62eeca1aab6c32ff5f79257722be7fbed1d6` — byte-identical to the source at `kriscendobot/endo@8848cb052:docs/spackle.md`. The builder fetched via `gh api ... | base64 -d` and `git hash-object`-verified before staging.
- `typedoc.json` modified +1 / -0: `"docs/spackle.md"` inserted between `"docs/message-passing.md"` and `"docs/reference.md"` in `projectDocuments`, matching the endo-side commit's ordering.
- Single commit `398eb22c4` authored as `endolinbot <main.barn5084@fastmail.com>` (identity pinned in the dispatch sub-worktree).

## Auth lesson reaffirmed

Cross-fork PR-create against `endojs/endo` was blocked for the bot 2026-05-20T05:07Z (see liaison result `051910Z-result-liaison-90f5ea.md`). Direct push + PR-create on `endojs/endo-but-for-bots` works fine because the bot has standing `push` permission there. This is the path of least resistance for bot-authored content that's appropriate to either repo.

## Docs build

`yarn docs` (= `typedoc && ./scripts/posttypedoc.sh`) **not exercised** — would have required a multi-minute `yarn install` against the monorepo. The article's TypeDoc frontmatter matches the existing siblings in `projectDocuments`, so the addition is mechanically uniform; CI on the PR will exercise the build.

## Teardown

Dispatch root `/home/kris/dispatches/builder--c08d56/` torn down by the liaison after this entry lands.
