## Gauntlet fix round 6: kriscendobot/minion.town PR #93

I fixed both seats that requested changes in the round-6 panel review (review 5481756555 on head `4c650312`). Three follow-up commits are on `feat/clip-content-store-gc` (head `4c65031` → `186007f`), pushed with `safe-push-pr-head.sh`. CI is **green**: `ci-wait-merge.sh` returned rc 0, with all 3 checks passing.

**Commits**
1. `e30a09b` docs(gc): this addresses the archivist's request. Commit `2bef1cb` had swapped `→`/`…` for `->`/`...` on existing lines of `deploy/aws/README.md` and `designs/clip-formula-id-origin-and-content-gc.md`, and this puts the base branch's Unicode back. The README diff is now only the new GC row.
2. `e61c3ca` fix(gateway): this addresses engine-realist findings 1 and 3.
   - **Directory permissions:** `internBlob` now sets mode 2775 on the `blobs/` and shard directories it creates at runtime. Before, a shard created after the last deploy came out 0755, and the `endo-gateway-gc` user could not rename or unlink blobs in it.
   - **Cross-user rewrites:** I added a comment saying that when a duplicate blob belongs to another user, `internBlob` always rewrites it via rename (setting explicit file times requires owning the file), and that this is accepted.
   - **Test:** new shard directories must be group-writable.
3. `186007f` fix(gateway): this addresses engine-realist finding 2. `inventoryBlobs` no longer reads blobs already known to be live. For the rest, it reads one byte and only reads the whole blob if that byte is `{`, so ordinary content is never fully read.
   - **New test:** a non-JSON orphan blob is never fully read.
   - **Updated test:** the existing "vanishes during the read" test now uses a blob starting with `{`, so it still reaches the full read.
   - **From the assessor's comment-only items:** a missing file during the final quarantine unlink no longer aborts the run, and the `runGc` doc comment is back on the right function.

**Verification:** the gateway tests (188) and `tsc --noEmit` pass. The full `npm test` has one failure, in `test/git-remote/capability.test.ts` ("propagates a git failure…"). It fails the same way on the old head `4c65031`, the PR doesn't touch that area, and it passes in CI.

**Not addressed, left for panel-7:** these were should-fix items from comment-only seats.
- A missing git partitions directory is treated as "no git roots" when running in `--delete` mode.
- A bad `GATEWAY_GC_GRACE_MS` can crash the gateway at startup.
- The guest-directory cleanup in `unpublish` cannot be retried.
- Engine-realist's note that a guest pointing `front` back at an old manifest during the mark phase is not covered.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr93-gauntlet-20261010-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2308213 cached reads)
- Output: 13477 tokens
- Cost: $1.4260066000000005
- Wall-clock: 948s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
