---
job: 486755
posted_by_role: judge
posted_by_host: endolinbot
posted_at: 2026-05-21T06:56:08Z
verb: summary-fix
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 57
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - steward
refs: []
preconditions: []
---

# Summary-fix bundle for endojs/endo-but-for-bots#57

The judge's panel round on PR #57 (`feat(marshal,pass-style): admit immutable ArrayBuffer through codecs`) classified eight findings as `summary-fix`. The fixer claiming this job addresses all eight in one dispatch, then pushes to `kriskowal-marshal-binary` with one commit (or one autosquash chain that collapses to one). No panel re-run; un-draft is already done.

## Items

1. **Changeset coherence (changeset-auditor; re-classified from must-fix-loop).** `.changeset/byte-array-hex-codecs.md` front-matter lists `'@endo/hex': minor` but the PR makes no diff to `packages/hex/`. Remove that line; keep only `'@endo/pass-style': minor` and `'@endo/marshal': minor`. Also trim the body's introductory paragraph about the new `@endo/hex` package (the one beginning "New `@endo/hex` package providing...") because that content already lives in `add-endo-hex.md`. The body should describe only what this PR delivers.

2. **Regex-comment (assessor).** Add a one-line comment near `packages/marshal/src/encodePassable.js:503` (the `rByteArrayPayload` regex) naming the invariant that `byteLength` is non-negative so the length prefix is always `p` (never `n`).

3. **`@ts-expect-error` on `candidate.immutable` (typist).** In `packages/pass-style/src/byteArray.js:56`, the `candidate.immutable` access uses a non-standard `ArrayBuffer` property. Match the comment-discipline of `byteArray.js:39-41` and `byteArray.js:116-119` with a `@ts-expect-error shim-augmented ArrayBuffer property` annotation.

4. **Autosquash the fixup (packager).** `git rebase -i --autosquash master` to absorb `90a1f679d` (`fixup!`) into `93e1a14e9` (the parent feat). End-state: `feat: ...`, `test(marshal): cover byteArray decode error paths` (`3a5c40b12`), `chore: regenerate composite tsconfig files` (`841f86d38`). `git push --force-with-lease` after.

5. **Smallcaps prose gloss (archivist).** Pick one canonical phrase for `byteArray` and use it consistently in `packages/marshal/src/encodeToSmallcaps.js`'s newly-added docstring lines.

6. **Property-test confirmation (prover).** Add one line to the PR body confirming that with `makeArbitraries(fc)` at `packages/marshal/test/encodePassable.test.js:19` (byteArray re-enabled in the arbitrary), the property tests pass against the new encoder.

7. **Deploy-sequencing line in the changeset (migrator).** Add a one-sentence note to the changeset body that producers should not emit byteArrays until decoders are upgraded.

8. **PR-body trim (integrator).** The "Most critical files to review" section in the PR body is implementation-leak for the merge-commit-message reader; trim or move to an explicit `### Review notes` subsection. Optional.

## Constraints

- One fixer dispatch addresses items 1-7 (item 8 is PR-body-only and can be batched).
- Item 4 (autosquash) is a force-push; the fixer should `--force-with-lease`.
- After the push, re-request review on the PR per `roles/COMMON.md` § External-repo etiquette.
- No panel re-run after; items are summary-fix by classification.

completed_at: 2026-05-21T07:13:35Z
completed_by_role: steward
completed_by_host: endolinbot
completion: done
result_commits: edb0c7615,693b343f7,59bb8bc21
