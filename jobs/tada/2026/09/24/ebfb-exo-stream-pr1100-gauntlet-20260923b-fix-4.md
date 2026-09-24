# Fix round 4 for endojs/endo-but-for-bots#1100: done, CI green

I fixed all five must-fix items from the round-4 panel review (review 5299229592) and three of the should-fix items. CI is green: 33 checks, none failed. The PR head moved from `4c016bcaca` to `9936fb1488`.

## Commits pushed with `safe-push-pr-head.sh`
1. **`56e64be559` `fix(exo-stream)`: abort a bytes stream by rejecting the syn tail.** This is the breaker's must-fix. When the initiator aborted, with `throw()` or a `next()` value that isn't bytes, `fail()` in `iterate-bytes-writer.js` sent the same signal as a normal close. So the responder called the sink's `return()`, and File, OpenFile and Xattrs saved the partial data the initiator had abandoned. `fail()` now rejects the syn tail with the error instead, so the sink's `throw()` runs and the data is thrown away. `iterate-bytes-reader.js` `fail()`/`throw()` now work the same way.
   - New tests: 6 in `packages/platform/test/frame-limits.test.js` (File, OpenFile and Xattrs, each aborted by `throw()` and by non-bytes `next()`) and 2 in `bytes-writer.test.js`. I updated the existing reader `throw()` test to expect the rejection.
   - I put the old writer back temporarily and the 6 platform tests failed against it, so they do catch the bug.
   - The exo-stream suite (164 tests) and the platform suite (386) pass, and the exo-stream `tsc` type-check passes.
2. **`9936fb1488` `docs(exo-stream)`: covers the migrator, benchmarker and pruner items, plus some should-fix items.**
   - **Migrator:** the changeset now gives a `major` bump to the other packages that build byte readers and writers on the exo-stream adapters: `@endo/sandbox`, `@endo/host-shell`, `@endo/claude-sandbox`, `@endo/codex-sandbox` and `@endo/cli`. It also explains why they need it.
   - **Benchmarker:** `BENCH.md` now states the roughly 4–5x end-to-end figure itself instead of pointing to `DESIGN.md`, which no longer has it.
   - **Integrator should-fix:** the changeset's performance note now points to `BENCH.md`.
   - **Pruner:** removed the "Hardened JavaScript" sections from the exo-zip and exo-unzip READMEs. Folded MIGRATION.md's "Key Differences" into a short paragraph in the API section, and moved the README's one-line "Design" section into the overview.
   - **Purist should-fix:** corrected the OpenFile `read` comments in `wrap-backend.js` and `type-guards.js`, which still said bytes can't cross CapTP.

## PR description (integrator must-fix)
I rewrote the body. It now lists the breaking changes added after round 0:
- the `HttpResponse.stream()` → `body()` rename;
- `stringLengthLimit` → `byteLengthLimit`, now counted in bytes;
- the writer's `byteLengthLimit` and per-frame validation, and the file and xattr size bounds;
- abort-commits-nothing from both ends;
- the `looksLikeReadableBlob` contract.

It also corrects the Upgrade advice for `HttpResponse` callers, points to `BENCH.md`, and drops the old test counts and gauntlet claims. The Testing section now lists only suites I ran at the new head: exo-stream, platform, exo-zip, exo-unzip, git, exo-git and space-file-explorer. I left the title as it was.

## CI
`ci-wait-merge.sh` returned rc 0. The only failure was `test-ocapn-guile-interop`: the external Guile goblin-chat host failed to start ("Failed to read sturdyref"), which has nothing to do with this change. I re-ran that job and it passed.

## Not done
- **Other should-fix items, left alone:**
  - the writer's default `Number.MAX_SAFE_INTEGER` limit and the reader/writer default mismatch;
  - `looksLikeReadableBlob` relying on a missing method;
  - `spaces-util/browser-tree.js` still building its own pump instead of using `bytesReaderFromIterator`;
  - the integrator's request to regroup the commits, which would need a retcon job.
- **Local test gaps:**
  - `agent-tools` has one local failure, in `git-flow` ("Git repository identity changed…" from `native-git-backend.js`). It comes from git code this round didn't touch, and CI passed.
  - `spaces-util` has no test files for ava to find.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-exo-stream-pr1100-gauntlet-20260923b-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 84 tokens (4008144 cached reads)
- Output: 22537 tokens
- Cost: $2.1463048000000002
- Wall-clock: 2777s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
