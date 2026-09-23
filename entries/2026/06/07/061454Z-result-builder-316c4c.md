---
ts: 2026-06-07T06:14:54Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: steward
dispatch_root: /home/kris/dispatches/builder--316c4c
refs:
  - entries/2026/06/07/060900Z-dispatch-builder-316c4c.md
  - entries/2026/06/07/060236Z-result-researcher-df145e.md
  - https://github.com/endojs/endo-but-for-bots/pull/429
  - https://github.com/endojs/endo-but-for-bots/pull/57
  - https://github.com/endojs/endo/pull/3226
---

# result: builder: duplicate endo#3226 onto llm (PR #429)

## Deliverables

- **Frozen-base branch**: `llm-2bd9e0c` at `2bd9e0cbb46324866b8c0d781e261648945b18fd` (origin/llm tip at dispatch time). Pushed to `origin`.
- **Duplicate head branch**: `kriskowal-marshal-binary-llm` at `7e2c6348e`. Pushed to `origin`.
- **DRAFT PR opened**: [endojs/endo-but-for-bots#429](https://github.com/endojs/endo-but-for-bots/pull/429). Title: `feat(marshal,pass-style): admit immutable ArrayBuffer through codecs (llm-base mirror of #57)`. Base `llm-2bd9e0c`, head `kriskowal-marshal-binary-llm`, isDraft=true.

## Commit list (origin/llm..HEAD, oldest first)

```
08c814316 feat(marshal,pass-style): admit immutable ArrayBuffer through codecs
43b9261c5 chore: Update yarn.lock
fdbf4c618 fixup! feat(marshal,pass-style): admit immutable ArrayBuffer through codecs
dc4d7df4b docs(marshal): prefer b0b5cafe in smallcaps-cheatsheet example
7e2c6348e chore: regenerate composite tsconfig files
```

Authorship preserved on the upstream-cherry-picked commits (`Kris Kowal <kriskowal@kriskowal.com>` as author, bot as committer). Bot identity authors the b0b5cafe doc-fix, the yarn.lock split, and the composite-tsconfig regenerate.

Note: the cherry-pick of `0b55322f8` was split into the feat commit + a separate `chore: Update yarn.lock` (1-line workspace dep addition for `@endo/pass-style` now listing `@endo/hex`) per the project's lockfile-separation convention. The upstream `fixup!` commit was preserved with its `fixup!` prefix verbatim per cherry-pick semantics.

## File-by-file conflict-resolution notes

One conflict on the cherry-pick of the feat commit:

- **`packages/pass-style/test/byte-array.test.js`**: `add/add` conflict. The pre-existing llm version held two `passStyleOf` tests for immutable `ArrayBuffer` (added on llm directly, not via the source PR). The upstream feat commit's version was a strict superset: same two tests verbatim plus added imports (`byteArrayToUint8Array`, `uint8ArrayToByteArray`, `byteArrayToHex`, `hexToByteArray` from `../src/byteArray.js`) and additional round-trip and reject-odd-length-input tests for the new hex helpers. **Resolution**: take the upstream superset (`git show 0b55322f8:packages/pass-style/test/byte-array.test.js > packages/pass-style/test/byte-array.test.js`). Both intents honored: llm-side tests preserved verbatim within the superset; upstream's new helper tests added.

No other conflicts. Cherry-pick of the `fixup!` commit `abc1010a` applied cleanly.

## Composite-tsconfig chase

Required. `node scripts/generate-composite-tsconfigs.mjs --check` detected drift on `packages/pass-style/tsconfig.composite.json` (pass-style now depends on `@endo/hex` at the workspace boundary, so the composite must list `../hex/tsconfig.composite.json`). Standalone `chore: regenerate composite tsconfig files` commit (`7e2c6348e`).

## Pre-push gates: inherited findings (surface, do not chase)

Running `garden/skills/pre-push-gates/pre-push-gates.sh --summary` against the head:

```
yarn format            fail (environmental; dispatch root not yarn-installed)
yarn lint              fail (environmental; same)
probes:
  filename-no-stutter            fail: marshal-justin.js / marshal-justin.test.js / marshal-test-data.js
  no-ascii-banners               pass
  no-inline-import-jsdoc         fail: encodePassable.js:509; marshal-test-data.js:21,30
  no-non-ascii-in-source         fail: encodePassable.js:489-490 contain em-dash U+2014
  no-pull-citations              pass
  security-md-hash-uniform       fail: packages/endo/SECURITY.md missing
  sentence-per-line-md           pass
  test-package-no-main           pass
yarn typecheck         skip (no typecheck script in this position)
```

All findings are inherited:

- **`filename-no-stutter`**: marshal-justin.js / marshal-justin.test.js / marshal-test-data.js predate this duplicate; the cherry-pick only modified them.
- **`no-inline-import-jsdoc`**:
  - `encodePassable.js:509` (`@returns {import('@endo/pass-style').ByteArray}`) introduced by the upstream feat commit's `decodeByteArray` JSDoc. Pre-existing on the bot fork's #57 too.
  - `marshal-test-data.js:21,30` (`import('../src/types.js').RankComparison` inline) pre-dates this duplicate on `llm`; the cherry-pick only added to the file, did not touch those lines.
- **`no-non-ascii-in-source`**: `encodePassable.js:489-490` carry two em-dash characters (`U+2014`) in a comment introduced by the upstream feat commit (lines starting `* Every character used here — \`a\`, \`p\`/\`n\`/\`~\`/\`#\`, ... — is outside ...`). Inherited from upstream; the no-non-ASCII probe (added 2026-06-04) post-dates the source PR.
- **`security-md-hash-uniform`**: `packages/endo/SECURITY.md` missing is a pre-existing state on `llm` unrelated to this cherry-pick.

`yarn format` / `yarn lint` failures are environmental (the dispatch root project worktree has no `node_modules`); the underlying drift cannot be evaluated from within this dispatch. Surface to the maintainer; the master-base sibling #57 has been through the gauntlet and would carry the same set.

## Prior-withdrawn context surfaced

The PR body explicitly notes that the prior llm-side sibling `#56` was withdrawn 2026-05-06 and asks the maintainer to speak to whether to keep this duplicate or withdraw again. The journal does not record the original withdraw reason, so the body offers the question rather than presupposing the answer.

## Out of scope (per the dispatch brief)

- No CI shepherding attempted. The DRAFT stays draft for the maintainer to engage on the keep-or-withdraw question.
- No pre-existing findings chased under this PR's banner.
- The bot fork's #57 carries a `test(marshal): cover byteArray decode error paths` follow-up commit beyond the upstream substance plus the b0b5cafe doc fix. The dispatch's step-5 procedure explicitly enumerated only `0b55322 + abc1010 + b0b5cafe`, so the test follow-up did **not** travel. The PR body surfaces this as out-of-scope for maintainer decision; a separate dispatch can cherry-pick `693b343f7` if wanted.

## Self-improvement

The dispatch brief's step-5 procedure (cherry-pick `0b55322 abc1010`) was a clean enumeration but the researcher's "judge-recommended substance fixes that are not PR-shell" framing left ambiguity on whether the bot-side test follow-up (`693b343f7`) should travel. I followed the brief verbatim and surfaced the gap in the PR body and this result for the maintainer to decide. A future researcher-precedence dispatch that surfaces "carry test-followup commits, yes/no" up front would close this gap; absent that, the brief's explicit enumeration takes precedence.

Self-improvement: when a researcher's framing about what travels overlaps with a dispatch brief's explicit cherry-pick enumeration, follow the brief and surface the gap in the result rather than expanding scope to honor the framing. The brief is the authoritative scope; the researcher's framing is context.
