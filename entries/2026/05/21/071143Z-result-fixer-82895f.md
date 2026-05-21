---
ts: 2026-05-21T07:11:43Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - jobs/open/20260521T065608Z--486755--endo-but-for-bots-57.md
---

# Summary-fix bundle for PR #57: applied

Addressed all eight items from judge 911c4b's panel summary-fix bundle on
PR #57 (`feat(marshal,pass-style): admit immutable ArrayBuffer through
codecs`) in one fixer dispatch.

## Items and dispositions

1. **Changeset coherence**: removed `'@endo/hex': minor` from
   `.changeset/byte-array-hex-codecs.md` front-matter; trimmed the
   `@endo/hex` introductory paragraph from the body (already covered in
   `add-endo-hex.md`).
2. **Regex-comment**: added a one-line comment above `rByteArrayPayload`
   in `packages/marshal/src/encodePassable.js` naming the invariant
   that `byteLength` is non-negative so the prefix is always `p`.
3. **`@ts-expect-error` on `candidate.immutable`**: the shim type
   augmentation in scope means TS does not flag the property access,
   so a `@ts-expect-error` directive would be "unused" and break
   typecheck. Resolved by adding a plain `// .immutable is a
   shim-augmented ArrayBuffer property.` comment in
   `packages/pass-style/src/byteArray.js` to satisfy the typist's
   comment-discipline intent without breaking typecheck.
4. **Autosquash**: `git rebase --autosquash origin/master` absorbed the
   `fixup!` (90a1f679d-equivalent) plus my own fixups into the feat
   parent. End-state: 3 commits (feat, test, chore). Force-pushed with
   lease.
5. **Smallcaps prose gloss**: simplified the docstring line in
   `encodeToSmallcaps.js` from "byteArray (hardened Immutable
   ArrayBuffer), hex-encoded" to "byteArray, hex-encoded" to match the
   concise sibling lines (`+` non-negative bigint, `$` remotable,
   etc.) and use the canonical `byteArray` term consistently.
6. **Property-test confirmation**: ran
   `yarn test test/encodePassable.test.js` in `packages/marshal/`; all
   13 property tests pass with the byteArray arbitrary re-enabled.
   Added a confirmation line to the PR body's Testing Considerations.
7. **Deploy-sequencing line**: added a paragraph to the changeset body
   noting that consumers must ship the new decoder before producers
   begin emitting byteArray values.
8. **PR-body trim**: moved "Most critical files to review" into a
   `### Review notes` subsection at the bottom of the PR body so the
   merge-commit reader sees the headline content first.

## Commits (after autosquash on origin/master)

- `edb0c7615` feat(marshal,pass-style): admit immutable ArrayBuffer through codecs
- `693b343f7` test(marshal): cover byteArray decode error paths
- `59bb8bc21` chore: regenerate composite tsconfig files

## Push

`git push --force-with-lease=kriskowal-marshal-binary:841f86d38 origin
HEAD:kriskowal-marshal-binary` succeeded: `841f86d38...59bb8bc21`.

## Pre-push gates

`probes-only` summary on the final tree shows three remaining failures,
all pre-existing in master and outside this PR's scope:

- `filename-no-stutter`: three `packages/marshal/{src,test,tools}/marshal-*.js`
  files exist on master; not introduced by this PR. Renaming is out of scope.
- `no-inline-import-jsdoc`: `marshal-test-data.js:21,30` are pre-existing.
  One inline-import in `encodePassable.js:512` introduced by this PR was
  fixed (replaced with the bare `ByteArray` type, since it is already in
  scope via `@import` on line 18).
- `security-md-hash-uniform`: divergent SECURITY.md files in
  `packages/{immutable-arraybuffer,bytes,hex,panic}/`; unchanged by this PR.

The `yarn lint --fix` auto-fix stage staged stylistic changes to
`packages/evasive-transform/src/index.js` and `packages/ses/src/compartment.js`
that are unrelated to this PR's diff; I reverted those rather than
silently shipping unrelated tree mutations.

`yarn lint:types` in `packages/marshal/` and `packages/pass-style/` both
pass after my changes.

## PR body and review re-request

- `gh pr edit 57 --body-file ...` applied the body trim (items 6, 8) and
  the testing-considerations confirmation (item 6).
- `gh api -X DELETE / -X POST .../requested_reviewers reviewers[]=erights`
  re-requested erights's review (the brief authorized this; erights was
  already on the request list).

## Job-board lifecycle

The dispatch prompt named the claimed-path
`endolinbot--20260521T065608Z--486755--endo-but-for-bots-57.md` but the
job is still in `jobs/open/` (not `jobs/claimed/`). I did not claim
via the job-board script (the orchestrator's responsibility per
`skills/job-board/SKILL.md` § Consumer-side wiring), so the orchestrator
should run `claim-job.sh` and `complete-job.sh done` against the open
path on return, or post a fresh job if the state has drifted.

Self-improvement: nothing this time.
