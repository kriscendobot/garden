I didn't open a PR. Every remaining increment of the `endo-fs-from-git` design is already covered by an open draft PR, so a new one would only duplicate work.

**Where the design stands on `llm` (4ae452c59c):**
- **Shipped:** Phases 1–3 and the content-addressed QIDs. `Git.filesystemAt(ref)` now lives in `packages/exo-git/src/git-filesystem.js` (moved out of `daemon`). Its backend has a `qidFor` hook that uses git object OIDs as `pathId`.
- **Phase 4 (compose, `withCachedReads`, Mount as the writable layer, README docs):** draft #1510 (https://github.com/endojs/endo-but-for-bots/pull/1510). It is mergeable, CI is all green apart from skipped checks, it has been through a gauntlet, and it is waiting on review.
- **Phases 5 and 6 (sha256-format repositories, paged `streamLsTree` listing):** draft #1537 (https://github.com/endojs/endo-but-for-bots/pull/1537). It is mergeable and has had a gauntlet and a shepherd job (2026-10-23). It has 5 failing checks on head `fee2309e11f`, all in test and cover jobs:
  - The cover failure I traced is the bwrap sandbox tests (`ulimit -u` illegal option, parent-death check), which are already failing on other PRs and have a separate fix in #1566.
  - test (24.x) also logs CapTP oracle-lifecycle exceptions. I didn't trace those, or the sandbox-drivers and test (22.x) failures.
  - So it's not confirmed that none of these come from #1537. Re-run CI once #1566 lands and see what is still red.
- **Not in any PR:** the design's original `git-sha1` `BlobRef` hash. #1537 records it as obsolete because the `blobInfoFor` hook was retired upstream, so it isn't a pending increment.

No job with my base had opened a PR before, and I changed nothing in the garden or the project repo.

**What would move the arc forward:**
1. The maintainer reviews #1510 and #1537. They touch separate design-doc sections and say they merge in either order.
2. Rebase or re-run CI on #1537 once #1566 lands.

After both merge, the design's Status can be set to Complete. Nothing else is left to build.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-fs-from-git-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (646273 cached reads)
- Output: 3683 tokens
- Cost: $0.7625786000000001
- Wall-clock: 66s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
