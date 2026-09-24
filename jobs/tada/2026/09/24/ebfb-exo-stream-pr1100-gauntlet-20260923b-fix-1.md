Fix round 1 for endojs/endo-but-for-bots PR #1100 is done. The fixes are pushed and CI is green on the new head `2618acd3c8`: all 33 checks finished with none failing. I left the panel for the driver to re-post.

I applied the panel's six must-fix items as four follow-up commits on top of `aeba1a3f81`:

1. **`59c51b42c6` fix(daemon):** in `manager.js`, `formulateReadableBlob` now allows 7,500,000 bytes per frame instead of 10,000,000. The old limit was 10,000,000 base64 characters, which is about 7.5 MB of binary, and the rename to a byte limit had kept the old number.
2. **`a2f957770a` fix(platform):** the three file and xattr write paths no longer fall back to the unlimited default frame size:
   - `OpenFile.write` and `File.write` (in `wrap-backend.js`) now cap each frame at 16 MiB. The code that writes to them sends 1 MiB chunks or less.
   - `Xattrs.set` caps each frame at 64 KiB, the largest value a Linux extended attribute can hold.
   - Total size across frames is still limited only by what the caller is allowed to write. The comment on the new constant says so.
3. **`1855cdbbee` test(exo-stream):** new writer tests cover a frame of exactly the limit, a frame one byte over it, a zero-length frame, and a property-based round-trip test (fast-check, 200 runs).
4. **`2618acd3c8` docs:**
   - I reran the `BENCH.md` benchmark on Node 22.23.2. It took 20.3–22.8 µs per 64 KiB chunk over four runs, so the table now says about 20 µs instead of about 30 µs.
   - I replaced the non-ASCII symbols `≠` in `BENCH.md` and `≈2×` in `from-mount-backend.js`.
   - I reflowed `.changeset/exo-stream-single-stream-method.md` to one sentence per line and added a note that writers exposed to untrusted peers should set their own limit.
5. **Summary comment:** posted as [issuecomment-5804845389](https://github.com/endojs/endo-but-for-bots/pull/1100#issuecomment-5804845389). It covers `aeba1a3f81` (the snapshot and prettier fixes) and this round's commits.

**Local checks:** the exo-stream writer tests passed (22/22), all 371 platform tests passed, `tsc` passed in both packages, and eslint showed no errors in the changed files.

**Not done:**
- **`DESIGN.md` symbols:** the typist seat flagged symbols on line 41, but I found none there.
- **Commit split:** the packager seat noted that `aeba1a3f81` combines the git prettier fix with the snapshot repair. I left that pushed commit as it is rather than rewriting history.
- **Other suggestions:** the comment-only seats' other ideas are unchanged: a design note on how byte streams are recognized, a tracked issue for measuring XS, and more property-based tests in platform.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-exo-stream-pr1100-gauntlet-20260923b-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 84 tokens (3091219 cached reads)
- Output: 18575 tokens
- Cost: $1.6818318
- Wall-clock: 2590s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
