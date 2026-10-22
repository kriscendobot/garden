---
orchestration-failed: true
---
orchestration-failed: true

# Gauntlet CLEAN stage for endojs/endo-but-for-bots PR #1537: CI is red, and the cause is the CI runner, not this PR

The coverage pass found nothing to change, so I pushed nothing. CI still finished red: `ci-wait-merge.sh` returned rc=3 at head `fee2309e1`. Every failure comes from the known `ubuntu-latest` = ubuntu-26.04 runner image breakage (see the memory note on the 2026-10-22 ubuntu-26.04 breakage). This PR's diff does not cause it.

**Coverage pass** (isolated checkout at `/Users/dom/garden/scratch/project-wt-endojs--765eefd9ee4d-57228221`):
- **What changed:** the PR adds `streamTreeEntries` and `parseLsTreeRecord` (which also accepts 64-hex sha256 IDs) in `packages/git/src/native-git-backend.js`. It also adds an optional `streamLsTree` to the backend typedef and the not-implemented stub in `packages/exo-git/src/git.js`, and paged `Directory.list()` in `packages/exo-git/src/git-filesystem.js`.
- **Tests:** the new tests cover these paths:
  - a 5,000-entry stream, where records cross chunk boundaries (the `pending` path);
  - stopping early;
  - rejecting an ID that looks like a command-line option;
  - parsing sha256 IDs;
  - falling back when a backend has no `streamLsTree`;
  - replaying a cached listing instead of re-listing;
  - `Cursor.read(limit)` reading one page at a time.
- **Gaps:** the only untested lines are a defensive branch for a final record with no trailing NUL byte, and the throwing `streamLsTree` in the not-implemented stub. The stub's other stream methods aren't tested directly either. I judged these too small to justify a push that would restart CI on runners that are failing anyway.
- **Dead code:** none. The old listing parser `parseLsTreeEntries` now calls `parseLsTreeRecord`, and `listTreeEntries` still uses it.
- **Coverage tool:** `c8` isn't installed in the checkout, so I reviewed coverage by reading the tests rather than running it.

**CI:** 5 of 35 checks failed: `test (22.x, ubuntu-latest)`, `test (24.x, ubuntu-latest)`, `cover (22.x)`, `cover (24.x)` and `sandbox-drivers`. Each failure is in the `packages/sandbox` bwrap tests:
- `prlimit nproc cap is enforced inside the slice`, which fails with `/bin/sh: 1: ulimit: Illegal option -u`
- `bwrap parent death leaves no owned process group`
- once, `bwrap timeout and repeated cancellation reap process groups`

No failure is in exo-git, git or daemon. The macOS test jobs, lint and viable-release all passed.

**Follow-ups:**
- The fix belongs on the base or the runner setup: change the sandbox tests, or pin the runner to ubuntu-24.04. It does not belong in this PR.
- The PR's base, `llm-54d3d2a`, is frozen, so a fix landed on the base branch won't reach this PR until it is woven (rebased onto a new base). Re-run this stage after that.
- I didn't find a fix job for the runner problem on the board.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1537-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1173951 cached reads)
- Output: 7273 tokens
- Cost: $0.8362182
- Wall-clock: 1844s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
