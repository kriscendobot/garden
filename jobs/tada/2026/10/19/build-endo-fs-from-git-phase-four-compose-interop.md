---
handed-off: build-endo-fs-from-git-phase-four-compose-interop-open-pr
deliverable-complete: false
---
Phase 4 is built and pushed, but there is no PR yet. This host's bot token gets a 403 when it tries to open PRs on endojs, so I posted a successor job, pinned to the endolin host, that only opens the PR.

**Overlap check:** No files collide, so nothing needed to wait.
- `build-daemon-mount-next-phase` is still queued and unclaimed.
- `fs-interface-consolidation` is a design that changes interface guards.
- This change is tests and docs only, with no `src/` edits.
- Related design PR #807 has no outstanding changes-requested review.

**What changed** (endojs/endo-but-for-bots: branch `endo-fs-from-git-phase-4-compose-interop` on frozen base `llm-92b91a7`, one commit):
- **Tests:** five new tests in `packages/daemon/test/git.test.js` covering Phase 4:
  - `compose(scratchFs, gitFs)`: reads come from the git tree, while new files and copied-up writes go to the scratch layer. The historical tree stays unchanged, including through a fresh `filesystemAt('HEAD')`.
  - `compose(gitFs, gitFs)` is refused.
  - **Daemon Mount integration:** with `compose(mountAsFilesystem(scratchMount), gitFs)`, new files land in the Mount's directory on disk, and reading a historical file doesn't copy it there.
  - `withCachedReads(gitFs, cas)` answers the second read of a file from the cache. The test proves this by swapping in fake bytes of the same length under that file's cache key: the next read returns the fake bytes.
  - **Cross-filesystem rename:** moving a file into the git tree fails with `EXDEV`. Moving one out fails with `EACCES`, because the read-only check runs before the `EXDEV` check. The design expected `EXDEV` in both directions; the doc now records what actually happens.
- **README:** `packages/exo-git/README.md` has a new "Composing `filesystemAt(ref)`" section showing these patterns. Its outdated `@endo/endo-fs` references now point to `@endo/platform/fs/extended`.
- **Design status** (`designs/endo-fs-from-git.md`):
  - Phases 1–4 are now listed as landed and the Phase 4 checklist is ticked.
  - The `compose` examples use the real `(layer, backing)` signature instead of an array.
  - The Status section now notes that commit `0668baf85` removed the `blobInfoFor`/`'git-sha1'` snapshot hook. Snapshots now report the SHA-256 of the raw bytes. Only the file identity (QID) still uses the git object ID.

**Verification:**
- All 23 `filesystemAt` tests pass, five of them new.
- The pre-push probes pass and eslint shows no errors.
- The full gate run's `yarn lint:fix` stage failed. The errors in my test file are fixed and the probes-only rerun passes, but I didn't rerun the full gate.
- I reverted the gate's auto-fix of the design doc because it rewrote `→` characters on lines this change didn't touch.

**Handoff:** successor job `build-endo-fs-from-git-phase-four-compose-interop-open-pr` is on `jobs/todo`, pinned with `requires: host=endolin-garden-ece02cb4`. Its only task is running `ensure-pr.sh` for this head and base, with the PR body (in the repo's template) embedded. That job's completion report will name the draft PR and start the review gauntlet.

**Follow-ups:** Phase 5's SHA-256-repo detection and Phase 6's paged directory listing are still deferred, as the design says. The lasting fix for the handoff is giving the bot token pull-request write access on endojs.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-fs-from-git-phase-four-compose-interop.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 118 tokens (5549205 cached reads)
- Output: 31712 tokens
- Cost: $2.720681000000001
- Wall-clock: 1152s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
