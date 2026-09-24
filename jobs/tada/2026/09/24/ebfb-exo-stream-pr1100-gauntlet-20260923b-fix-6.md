# Gauntlet fix round 6 for endojs/endo-but-for-bots#1100: fix pushed, CI green

I fixed the must-fix from the round-6 panel verdict (review 5300297840) and two of its should-fix items, and updated the PR description for the third. I did not do the commit regrouping (retcon) the panel asked for. CI passed: `ci-wait-merge.sh` returned rc 0, with 33 checks and none failed.

The PR head moved from `860574a2bd` to `b946ac4986`. `safe-push-pr-head.sh` added two commits without rewriting history.

**Changes:**
- **Item 1 (must-fix) and item 2: `f4d95c0448` `fix(platform): give each buffered write stream its own buffer`.**
  - **Code:** In `buffered-bytes-writer.js`, each `stream()` call now gets its own buffer and running total. The writer is a small exo that builds a new sink on every call. Each sink latches after its first `return()` or `throw()`, so it never commits twice.
  - **Bugs this removes:** A second write can no longer commit a zero-padded buffer. Two holders streaming at once no longer mix their frames, and one holder's abort no longer throws away the other's frames. Reusing a writer for a later write still works, as the older inline sinks did.
  - **Tests:** I added four regression tests to `frame-limits.test.js`: one reuse test each for `File.write`, `OpenFile.write` and `Xattrs.set`, and one test with two holders streaming at once. All four fail against the old helper and pass now.
- **Item 3: `b946ac4986` `fix(platform,daemon): stream attenuated blob ranges in reader-sized frames`.**
  - **Code:** I exported the existing 48 KiB chunker from `platform/src/blob.js` as `byteChunks`. The partial-range `stream()` paths in `local-blob.js` and in `mount.js`'s `makeReadableBlobView` now send their bytes through it.
  - **Extra fix:** The regression test showed a second cause of the same bug, already present in the base branch. `mount.js`'s `bytesFromRange`, which backs `bytes()`, also sent the whole file as one frame, so I routed it through the chunker too.
  - **Tests:** I added `byteRange(0n, 200_000n)` tests for both the local blob and the mount. Each reads a 200,000-byte range, twice the reader's default 100,000-byte frame limit.
- **Item 4, partly: I edited the PR body.** The `bytesWriterFromIterator` bullet and the Upgrade Considerations section now describe `wrapBackend({ writeByteLengthLimit })`: 256 MiB by default, with `E2BIG` when a write goes over. The bullet also says each stream buffers its own frames.

**Checks run locally:**
- Full `@endo/platform` suite: 395 passed.
- `daemon/test/mount.test.js`: 83 passed.
- `lint` and `lint:types` for platform and daemon: 0 errors.
- Root `tsc` found nothing in the touched files, and prettier passes.

**Follow-ups:**
- **Retcon before merge (item 4):** the panel wants the commits regrouped into logical commits with a single `chore: Update yarn.lock`. That rewrites history, so it is out of scope for a fix round.
- **Comment-only notes, not addressed:**
  - `bytesWriterFromIterator` still defaults its frame limit to `Number.MAX_SAFE_INTEGER`.
  - The error text at `host.js:1716` no longer matches the `looksLikeReadableBlob` check.
  - Several `designs/*.md` files still describe `streamBase64()` as the live interface.
  - The inline `import()` casts in `mount.test.js` should use the file's existing `@import`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-exo-stream-pr1100-gauntlet-20260923b-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (3497619 cached reads)
- Output: 18016 tokens
- Cost: $1.7798918000000004
- Wall-clock: 2319s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
