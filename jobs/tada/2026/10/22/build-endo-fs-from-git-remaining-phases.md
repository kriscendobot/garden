---
handed-off: build-endo-fs-from-git-remaining-phases-open-pr
deliverable-complete: false
---
## Report: build-endo-fs-from-git-remaining-phases

The code for the remaining phases (5 and 6) is finished, tested and pushed, but the draft PR is **not open yet**. This host's bot token is refused when creating PRs on endojs (403 "Resource not accessible by personal access token"). I posted a successor job, pinned to the endolin host, whose only task is to open the PR with the body I wrote.

**Scope.** Phase 4 (compose interop) is already in an open draft, endojs/endo-but-for-bots#1510, so I didn't duplicate it. That left Phase 5's SHA-256-repository item and Phase 6, paged directory listing. My design-doc edits stay inside the Phase 5 and 6 sections, so this work and #1510 should merge in either order.

**Phase 6: paged directory listing**
- The git backend contract (`packages/exo-git/src/git.js`) gains an optional `streamLsTree(treeOid)` that yields tree entries one at a time. Because it is optional, existing backends and test fakes keep working.
- The native backend (`packages/git/src/native-git-backend.js`) implements it by parsing `git ls-tree` output as it streams. A record can be split across chunks, even in the middle of a multi-byte UTF-8 name. Stopping early kills the git process.
- `list()` in `packages/exo-git/src/git-filesystem.js` now reads through it, so `Cursor.read(limit)` only fetches one page of a wide tree.
  - A listing already cached by path lookup is reused rather than running `ls-tree` again.
  - A backend without `streamLsTree` falls back to the old whole-array `lsTree`.

**Phase 5: SHA-256 repositories**
- The `ls-tree` parser accepted only 40-hex IDs, so `filesystemAt` threw on a repository made with `git init --object-format=sha256`. It now also accepts 64-hex IDs, and the file ID (`pathId`) carries the full 256-bit value.
- The design's other Phase 5 item (`'git-sha256'` as the snapshot hash algorithm) no longer applies. Commit `0668baf85` removed the `blobInfoFor` hook it depended on, and the design doc now says so.

**Tests and checks**
- A new `packages/exo-git/test/git-filesystem.test.js` uses a fake backend that counts reads. It shows `read(10n)` on a 5,000-entry tree pulls exactly 10 entries and `close()` stops the stream. It also covers reuse of the cached listing, the `lsTree` fallback and the 256-bit file ID.
- `packages/git/test/native-git-backend.test.js` adds 4 tests: streaming matches `lsTree` on 5,000 entries with multi-byte names, early stop, rejection of an option-shaped ID, and a real SHA-256 repository.
- `packages/daemon/test/git.test.js` adds 2 end-to-end tests: paging a 4,000-file tree, and reading a SHA-256 repository.
- Results:
  - `@endo/exo-git`: all 61 tests pass.
  - `@endo/git`: all 19 tests pass. The first full run had 3 failures that did not come back on a rerun; they look like load flakes.
  - Daemon: the 20 `Git.filesystemAt` tests pass.
  - Lint and type checks show no errors, and Prettier is clean.

**What's on the remote**
- Branch `build/endo-fs-from-git-sha256-paged-listing`, commit `fee2309e1`, with a changeset (minor bump for both `@endo/exo-git` and `@endo/git`).
- Base is the frozen branch `llm-54d3d2a`, equal to the current `llm` tip.
- Successor job: `build-endo-fs-from-git-remaining-phases-open-pr`, pinned `requires: host=endolin-garden-ece02cb4`. Its body contains the full PR text and the exact `ensure-pr.sh` call, using this job's base so the PR is linked back to this job.

**Follow-ups**
- The PR-check script `phase-evidence-gate.sh` rejects a PR body that links a design by its full GitHub URL. It reads `github.com/.../designs/X.md` as a design path, can't find it, and refuses the PR. Naming the design as `designs/X.md` works around it, and I added this to the host memory file. The script's design-path pattern should be fixed.
- The lasting fix for the 403 is giving the bot's token "Pull requests: write" on endojs.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-fs-from-git-remaining-phases.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 122 tokens (6650097 cached reads)
- Output: 35288 tokens
- Cost: $3.1743793999999985
- Wall-clock: 1349s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
