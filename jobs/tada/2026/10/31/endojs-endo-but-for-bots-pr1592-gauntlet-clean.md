The clean stage for endojs/endo-but-for-bots#1592 is done: I added one missing test, and CI is green at head `f615fb2669a` (36 checks, 0 failed, `ci-wait-merge.sh` returned 0).

**Coverage pass:** The PR makes `makeFromPackage` snapshot a live mount before the worker imports it. Its tests cover the mount path but not the other branch, where the source is already a readable-tree. In that case the caplet should use the tree's own identifier rather than take a fresh snapshot. I added `makeFromPackage uses a readable-tree source without re-snapshotting` in `packages/daemon/test/make-from-package.test.js`. It stores a mount snapshot with `storeTree`, runs `makeFromPackage` on it, checks that the import works, and checks that the caplet formula's source identifier equals the tree's.

**Dead code:** none. The change only moves the existing code inside a `try`/`finally`; nothing was left unused.

**Local checks:** All 14 tests in `make-from-package.test.js` pass and eslint reports no errors. The tests had to run under `/usr/local/n/versions/node/24.21.0`: the worktree's better-sqlite3 is built for Node 24, while the `node` on PATH is 22, so the daemon won't start there.

**Push:** commit `f615fb2669a` went to `daemon-worker-import-from-mount-phase-four-snapshot` through `safe-push-pr-head.sh --mode advance` (from `efdbdc4cd9f`).

**CI:**
- **First run:** `test (22.x, ubuntu-latest)` failed on one sandbox test, `bwrap › bwrap timeout and repeated cancellation reap process groups` ("process group 37395 survived bounded cleanup"). This PR doesn't touch `packages/sandbox`. The same test passed twice in that same job log and passed on the Node 24 legs, so it is a timing flake.
- **Rerun:** I reran only the failed job with `gh run rerun --failed`, and it passed.

**Follow-ups:**
- My first CI wait got moved to the background and killed at its time limit. I replaced it with shorter foreground rounds; the CI result is unaffected.
- The bwrap flake hit a PR that doesn't touch sandbox, so it is worth tracking separately; the earlier bwrap fix is #1566.
- The PR is still a draft; the panel stage comes next.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1592-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (3042180 cached reads)
- Output: 12699 tokens
- Cost: $1.4831359999999998
- Wall-clock: 6523s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
