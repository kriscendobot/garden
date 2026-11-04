## PR #1648 clean stage: CI still pending at my deadline

I fixed the lint failure and pushed it, and every other check is now green. One check, `test (24.x, macos-15)`, was still running when I had to stop, so this stage reports **still-pending** rather than done.

**What was red before:** three checks at head `a46a836e92`.
- **`lint`** was caused by this PR, in two ways:
  - Prettier flagged formatting in 5 changed files.
  - The repo-root type check (`tsc -p tsconfig.json`, checkJs) found 13 errors in `packages/hosted-agent/test/agent-factory.test.js`, mostly "possibly undefined" on the test doubles' `Map` lookups and the `catalog` stub.
- **`cover (24.x, ubuntu-latest)`** failed on the `bwrap timeout and repeated cancellation reap process groups` test in `packages/sandbox`. This PR doesn't touch that package, and it's a known pre-existing failure.
- **`test (24.x, macos-15)`** failed in `http-content-plane.test.js`, a daemon test this PR doesn't touch.

**What I changed:** one commit, `cb2db099fc` ("chore(hosted-agent): fix lint for the agent factory"), pushed to `feature/api-key-agent-factory` with `safe-push-pr-head.sh`.
- Ran prettier on the 5 flagged files.
- Added `Map<string, any>` type annotations to the `guestRecords`, `inventories` and `responderRecords` test doubles, and casts on the `catalog.value` stub and on one `createWithUse` result.
- No changes to the package's source code beyond formatting.

**Local checks after the fix:**
- The root `tsc` run gives 0 errors. It needs `--max-old-space-size=8192`, or it runs out of memory.
- eslint on `hosted-agent` gives 0 errors.
- The `hosted-agent` tests pass (922).

I skipped a deeper coverage pass: the test file is already about 1,250 lines, and my budget was tight.

**CI at `cb2db099fc` (run 41858065746):**
- `lint` is now green, along with every other check except one (18 success, 17 skipped).
- `sandbox-drivers` hit the same `bwrap` failure and passed when I re-ran it.
- Both macOS legs were cancelled repeatedly with "The job was not acquired by Runner of type hosted", meaning GitHub ran out of macOS runner capacity.
  - `test (22.x, macos-15)` passed on a re-run.
  - `test (24.x, macos-15)` was cancelled three times. Its fourth try started at 18:00:20Z and was still running at 18:08Z.
  - That leg took about 30 minutes last time, which would end after this job's 3-hour limit (around 18:24Z).

**Follow-up:** whoever runs the next attempt of this stage only needs to wait for that one macOS leg on run 41858065746. If GitHub cancels it again for capacity, re-run it with `gh run rerun --failed`.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1648-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 110 tokens (4222608 cached reads)
- Output: 16965 tokens
- Cost: $1.8337816000000002
- Wall-clock: 10658s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
