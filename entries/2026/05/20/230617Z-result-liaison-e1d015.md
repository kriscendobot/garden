---
ts: 2026-05-20T23:06:17Z
kind: result
role: liaison
project: endo
to: maintainer
dispatch: 225513Z-dispatch-liaison-e1d015
---

# Result: builder e1d015 — mirror of endojs/endo#3036 pushed to kriscendobot/endo (cross-fork PR-create blocked)

Builder dispatch `e1d015` complete. Branch `mirror/3036-exo-stream` pushed to `kriscendobot/endo` at head `6434d37b7`. Self-report at `journal/entries/2026/05/20/230459Z-result-builder-e1d015.md`. Sibling builder 96fa5a (llm-side mirror) still running.

Compare URL for maintainer ferry:

  [https://github.com/endojs/endo/compare/master...kriscendobot:endo:mirror/3036-exo-stream](https://github.com/endojs/endo/compare/master...kriscendobot:endo:mirror/3036-exo-stream?expand=1)

## What's in the rebase

- Original PR #3036: 28 commits (24 are fixup revisions) → squashed to single `feat(exo-stream): Introduce Exo streams` commit. Net +6612 / -245 across 63 files. New `@endo/exo-stream` package (4 exports — `streamIterator`, `iterateStream`, `streamBytesIterator`, `iterateBytesStream` — plus DESIGN/PROTOCOL/MIGRATION docs and 121 tests). `@endo/daemon` refactor deletes 4 reader-ref/ref-reader wrappers. `@endo/cli` commands rewired. `CONTRIBUTING.md` adds mermaid style.
- Rebase against `bf951df3` produced **only 2 conflicts** after ~9 months of drift:
  - `CONTRIBUTING.md`: kept both sides (Mermaid sub-section + new TypeScript declarations section landed since).
  - `packages/cli/src/commands/store.js`: kept both import sets and both code paths.
- master still has the original `reader-ref.js` / `ref-reader.js` modules → the PR's substance is **not** partially-satisfied; the rebased branch is the full net-new work.
- Head commit: `920923da7` (feat commit, kriskowal authorship preserved) + `6434d37b7` (`chore: Update yarn.lock` + regenerated composite tsconfigs).

## Method note worth flagging

Builder used **squash-then-rebase** (`git reset --soft <merge-base>` → single commit → `git rebase upstream-master`) rather than `git apply --3way <pr.patch>`. The patch-apply variant inflates conflict count by conflating intermediate-state conflicts (across the 24 fixup commits) with net-diff conflicts. For multi-commit PRs with long fixup chains, this is the better technique. Worth landing in `skills/conflict-resolution/SKILL.md`. Carried forward for the gardener.

## Local verification

- `@endo/exo-stream`: lint 0 errors, test 121/121 pass.
- `@endo/daemon`: lint clean (one pre-existing-style warning at `daemon-node-powers.js:380:45`, `safe-await-separator` on `JSON.parse(await text())`, from the PR itself); test 119/119 pass.
- `@endo/cli`: lint clean, test 10/10 pass.
- `yarn build:types:gen` regenerated 4 composite tsconfigs (folded into the feat commit).

## Next step

Maintainer ferry needed to open the upstream PR against `endojs/endo`. The branch is ready; the rebase came out clean. Once open, the liaison can dispatch the gamut's downstream stages (cleaner / judge / fixer / un-draft). erights's 30+ inline-comment thread on the original would also need to be triaged; that's a separate engagement.

## Teardown

Dispatch root `/home/kris/dispatches/builder--e1d015/` torn down by the liaison after this entry lands.
