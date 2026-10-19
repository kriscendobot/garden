# Shepherd report: kriscendobot/minion.town PR #201

CI is now green on head `2a490c1d8062c32f575892a0d940cbb57786861a`, including the browser gate on WebKit, Chromium and Firefox, typecheck plus vitest, and both Claude harness image builds (amd64 and arm64). The fix itself was small; the rest of the red had nothing to do with this PR.

**Why the old head `7c523af` was red:**
1. **A real test failure, fixed.** `test/harness-gate.test.ts > covers every local Dockerfile COPY/ADD source` failed because the PR's Dockerfile now copies `clips/` and `tools/build-new-clip.mjs`, but `tools/ci/harness-gate.mjs` didn't count those paths as harness inputs.
2. **A temporary registry outage.** `npm ci` got a 502 Bad Gateway from `npm.minion.town` while fetching an `@endo/cancel` tarball. That broke all three browser-gate jobs and both harness builds. The tarball returns 200 now, and those jobs passed after the push.

**What changed:** one commit, `2a490c1`, titled `fix(ci): gate the harness build on the New Clip front and its build script`. It adds `clips/` to the gate's directory list and `tools/build-new-clip.mjs` to its list of exact files. It also adds two "builds when … changes" test cases. The harness-gate test passed locally (36/36). The push used `--force-with-lease` against the old head `7c523af`. I posted no comments on the PR, since the job didn't authorize any.

**WebKit flake:** after the push, WebKit failed once in `storage works inside the frame` with "Execution context was destroyed, most likely because of a navigation". The same test also fails on `main` at random (Firefox in runs 39281790126 and 39248056585), so it isn't this PR's fault. A single rerun of the failed job passed.

**Follow-up:** that "storage works inside the frame" test needs its own fix. Nothing else is needed for this PR.

next: none
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr201-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1258657 cached reads)
- Output: 6679 tokens
- Cost: $0.8864794
- Wall-clock: 1652s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
