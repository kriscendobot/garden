## Gauntlet fix round 2: endojs/endo-but-for-bots#1100

I applied the round-2 panel's must-fix items, pushed them to the PR head, and CI came back green on the new head `2500c24ed4`: 33 checks, 0 failed, `ci-wait-merge` returned 0.

**Pushed commits** (with `safe-push-pr-head.sh`, moving the head from `2618acd3c8` to `2500c24ed4`):
- **`d70035d69f` fix(exo-stream,platform), saboteur must-fix.** When a frame was rejected, file and xattr writes still saved the part already received. The writer pump ended the stream with the sink's `return()`, which is the step that saves the data.
  - The pump now calls the sink's `throw(err)` when it has one, and uses `return()` only otherwise.
  - `bytesWriterFromIterator` passes `throw()` on to the sink.
  - `OpenFile.write`, `File.write` and `Xattrs.set` now drop their buffered frames in `throw()`.
  - This commit also corrects the comment on `WRITE_FRAME_BYTE_LENGTH_LIMIT` (a saboteur should-fix).
  - New tests cover the exact limit and one byte over it, for both the 16 MiB write limit and the 64 KiB xattr limit. Other new tests check that a rejected frame (too large, or a leftover base64 string) leaves the old file or xattr unchanged. Five of the new platform tests fail on the previous head and pass now.
  - One behavior change: `host-shell` stdin is backed by a Node stream, and on abort it is now destroyed instead of ended.
- **`034b02eb36` refactor(daemon), typist must-fix.** Replaced the inline `import()` types in `mount.js` with top-of-file `@import` lines.
- **`fc4db4a75c` test(daemon), prover and fast-checker items.** Named the readable-blob limit `READABLE_BLOB_FRAME_BYTE_LENGTH_LIMIT` (7_500_000) and added tests at the exact limit and one byte over.
- **`2500c24ed4` docs(9p-server), integrator should-fix.** Added a dated note to `PERFORMANCE.md` saying its base64 material and `base64LimitFor` references describe a tree from before this change.

**Scribe must-fix:** I posted a summary comment on the PR (issuecomment-5805473824). It covers this push and also records the round-5 (`0ada7df897`) and round-6 (`ae192bfa86`) pushes, which never got summaries of their own.

**Local checks:**
- Tests pass: exo-stream 162, platform 378, and the daemon `mount.test.js` run plus the new limit test (85 together).
- `lint:types` is clean for all three packages; eslint gives warnings only.
- 9 `host-shell` `formula` tests fail locally, but they fail the same way without my change.

**Not done:**
- **Regroup the commits by subject** (integrator should-fix). That means rewriting the branch history, so it's better done as a retcon before merge.
- **Split large single-chunk producers into smaller chunks** (saboteur finding 3). It isn't a regression, so it's left as a follow-up.
- **Reading a 16 MiB chunk back runs out of memory.** Reading a single 16 MiB chunk back through `File.read` in one process exhausts the heap. That problem is outside this PR. The test at the exact 16 MiB limit checks the file size instead of reading the file back.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-exo-stream-pr1100-gauntlet-20260923b-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 104 tokens (4526171 cached reads)
- Output: 26393 tokens
- Cost: $2.2895502
- Wall-clock: 2569s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
