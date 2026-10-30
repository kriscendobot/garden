## Weave report: endojs/endo-but-for-bots#1559 (`daemon-worker-import-from-mount`)

I wove #1559 onto `llm-9a14ddf`, the current `llm` tip, and CI is green on the new head: every workflow run on `6d40c781e0` passed.

**What I did**
- **Rebase:** moved the PR from `llm-d5ac419` to `llm-9a14ddf` (31 commits behind) with `git rebase --onto origin/llm origin/llm-d5ac419`. There were no conflicts and neither of the PR's 2 commits was dropped or came out empty.
- **Diff check:** `git diff --stat llm-9a14ddf..HEAD` shows the same 16 files, +1335/−6, as before the weave. Only the PR's own files are in it.
- **Refs:** the frozen base `llm-9a14ddf` already existed on the remote at `9a14ddf660`. I force-pushed the head with a lease (`aade3d7bd7` → `6d40c781e0`) and changed the PR base to `llm-9a14ddf`, so both refs moved together.
- **Local tests:** `packages/daemon` `make-from-package.test.js` and `package-read-powers.test.js` all pass (15 tests). `yarn lint` for the daemon showed only `Cannot find module '@endo/sha256'` errors, in floot files. That package is new on `llm` and the local install hadn't linked it, so it's a local setup problem, not the PR's code. The CI lint job passed.

**CI**
- **Old reds:** the previous run's failures were two bwrap tests in `packages/sandbox` (`ulimit -u` and parent-death). The base commit `27705a4cdf` ("test(sandbox): fix Linux resource limit and cleanup assertions") fixes them, so the weave by itself got CI running cleanly again.
- **Re-runs:** CI run 41102862471 needed two re-runs of failed jobs:
  - `test (22.x, ubuntu-latest)` and `sandbox-drivers` both failed on `bwrap › bwrap timeout and repeated cancellation reap process groups` ("process group N survived bounded cleanup").
  - Re-run 1: `test (22.x)` passed; `sandbox-drivers` failed again on the same test.
  - Re-run 2: `sandbox-drivers` passed, and the run concluded **success**.
- **Not this PR's fault:** that test only exercises the sandbox bwrap driver and doesn't reach any daemon code this PR changes. It is a timing race on a 25ms timeout, and `llm` at 9a14ddf is green.
- **Remaining "fail" rows:** `gh pr checks` still lists some, but they all come from runs that were cancelled and superseded (41102861860 and similar). They started because the head push and the base edit each triggered CI. Every run that actually executed on the new head succeeded: CI, IronHorse oracle sanitizers, Floot Android, OCapN Guile interop, mutual-deps and the workflow audit.

**Follow-ups**
- **Flaky sandbox test:** the bwrap test above failed twice in a row on the ubuntu-26.04 runner image before passing. Someone should look at it before it starts tripping other PRs.
- **Warm-cache mismatch:** the project worktree probe reported `better-sqlite3` loading under node ABI 137, but the container's node is v22 (ABI 127), so the daemon wouldn't spawn until I rebuilt the module. The rebuild ran `prebuild-install` on a hardlinked file in `node_modules/.store`, so the shared warm-cache copy may now be the ABI-127 build. The cache key and the actual runtime disagree; that bug belongs in `ensure-project-worktree.sh`.
- **PR state:** it's still a draft. I didn't post a comment on the PR because the job didn't authorize one.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1559-weave-20261030.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 98 tokens (3835982 cached reads)
- Output: 14531 tokens
- Cost: $1.7165283999999996
- Wall-clock: 5718s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
