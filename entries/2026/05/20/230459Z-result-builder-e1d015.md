---
ts: 2026-05-20T23:04:59Z
kind: result
role: builder
project: endo
repo: endojs/endo
to: liaison
refs:
  - entries/2026/05/20/225513Z-dispatch-liaison-e1d015.md
---

# Result: builder e1d015 — mirror endojs/endo#3036 onto kriscendobot/endo@master (compare URL fallback)

## 1. Original-PR scope

`feat(exo-stream): Introduce Exo streams` (kriskowal, OPEN ~9 mo, base `master`, head `ce7293d6`). 28 commits squashed (24 are `fixup` responses to erights / jcorbin / grypez / gibson042 review). 63 unique files, +6612 / -245.

- Net-new package `@endo/exo-stream` (4 exports: `streamIterator`, `iterateStream`, `streamBytesIterator`, `iterateBytesStream`) — 11 source modules, 11 test files (121 tests), `DESIGN.md`, `PROTOCOL.md`, `MIGRATION.md`, scaffolding.
- Refactors `@endo/daemon` to use `exo-stream`; **removes** `packages/daemon/{reader-ref,ref-reader}.js` and `packages/daemon/src/{reader-ref,ref-reader}.js` (4 deletions).
- Refactors `@endo/cli` commands (`bundle`, `cat`, `follow`, `inbox`, `install`, `list`, `make`, `store`) plus `demo/cat.js` to call `exo-stream` directly.
- `CONTRIBUTING.md` adds Mermaid-diagram style sub-section.

## 2. Conflict count and triage outcome

**Minor** (only 2 conflicts after 9 mo of drift, both content-level not structural):

- `CONTRIBUTING.md` — both sides added a new section. Resolved by keeping both: PR's *Mermaid Diagrams* nested under *Markdown Style Guide*, master's *TypeScript declarations* as its own top-level section preceding *Rebuilding ses*.
- `packages/cli/src/commands/store.js` — PR replaced `makeReaderRef` import with `bytesReaderFromIterator`; master added `concatBytes` / `bytesToText` and new text-streaming code paths. Both imports kept; both new code paths preserved.

Used PR-head rebase (squash 28 commits → 1, rebase onto `bf951df3`) rather than `git apply --3way /tmp/3036-master.patch`. The patch-apply variant produced ~20 “Falling back to direct application” messages because the 28-commit fixup chain creates intermediate states the unified diff cannot represent. The squash-then-rebase variant yielded the 2 clean conflicts above.

## 3. Master-side substance already partially-satisfied

No. `packages/daemon/{reader-ref,ref-reader}.js` still exist on master and are still the daemon's stream-marshaling surface; nothing has been migrated away. The PR's wire-in remains net-new work. (`daemon-node-powers.js`'s `EndoReadable` ↔ `makeFileReader` refactor is the PR's own; reverting that file to master breaks typecheck.)

## 4. Branch + head SHA pushed

`kriscendobot/endo:mirror/3036-exo-stream` — head `6434d37b79b33ab24fb92351caca93ec77ca1509` (`chore: Update yarn.lock`), parent `920923da7a11857387a854fed0fd9944409271e6` (`feat(exo-stream): Introduce Exo streams`, author `Kris Kowal <kris@agoric.com>`, committer `endolinbot`).

## 5. PR URL / compare URL

`gh pr create` failed as documented: *“kriscendobot does not have the correct permissions to execute `CreatePullRequest`”*.

Compare URL: https://github.com/endojs/endo/compare/master...kriscendobot:endo:mirror/3036-exo-stream?expand=1

## 6. `yarn lint` and `yarn test` results

- `@endo/exo-stream`: lint clean (0 / 0); test 121 / 121 pass.
- `@endo/daemon`: lint 0 errors / 1 warning (`safe-await-separator` at `daemon-node-powers.js:380:45` — from the PR's own `JSON.parse(await text())` refactor, non-blocking); test 119 / 119 pass.
- `@endo/cli`: lint clean (0 / 0); test 10 / 10 pass.
- `yarn build:types:gen` regenerated composite tsconfigs (new `packages/exo-stream/tsconfig.composite.json` + updates to `packages/{cli,daemon}/tsconfig.composite.json` and root `tsconfig.composite.json`), all included in the feat commit.

## 7. Self-improvement

Self-improvement: for multi-commit PRs with long fixup chains (`endojs/endo#3036` had 24 of 28 commits as `fixup`), prefer squash-then-rebase (`git reset --soft <merge-base>`, single commit, `git rebase <new-base>`) over `git apply --3way <pr.patch>`. The latter falls back to direct application per-intermediate-state and conflates intermediate-state conflicts with net-diff conflicts, inflating apparent conflict count. The skill that should mention this is `skills/conflict-resolution/SKILL.md` (or a sibling “squash-rebase-for-fixup-chain” skill if the maintainer wants it carved). The fact didn't fit naturally inside the existing skill bodies so I'm flagging here rather than drafting a SKILL edit from a dispatch root.
