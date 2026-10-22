I fixed the hang in PR #1538's `provideGitClone` tests and pushed it to `build/daemon-git-clone` as `61abd3046`. CI now passes every daemon test that comes from the PR. CI is still red overall, but only because of the known ubuntu-26.04 sandbox breakage, which comes from the base and not this PR.

**Cause:** the bug was in the credential-rotation test itself; the process-group kill from `d1c0a317d` works. The test's fake https server accepted git's connection but never read from it. Once git had sent its TLS ClientHello, those unread bytes stayed in the socket buffer, so after the kill the socket never emitted `end` or `close`. The test then hung at `await disconnected.promise` until ava's 5-minute timeout, leaving the other 48 tests in the file pending.
- Both CI platforms logged the expected "changed during clone" error, so the abort itself had worked.
- It passed locally only when the rotation happened before git sent its first bytes.
- A standalone script with `/usr/bin/git` reproduced it: git exits on the group kill, but the server socket never closes unless the server reads.

**Fix:** one test-only commit in `packages/daemon/test/git-remote.test.js`, with no source changes.
- The fake server now reads and discards what git sends.
- The test now triggers the rotation when git's first bytes arrive rather than when it connects. That always reproduces the timing that hung in CI instead of leaving it to chance.
- Prettier is clean. ESLint shows only two warnings that were already there (lines 482 and 523).

**Verification:**
- **Locally:** the rotation test passed 3 runs out of 3. I couldn't get a fully clean local run of the whole file:
  - "GitRemote push round-trips to an independent fetcher over file://" times out every time on this host. It has a 2-second limit, and it fails the same way on the base `llm-54d3d2a`, so this host is too slow for it; it isn't the PR. It passed in CI in 554ms.
  - On the scratch mount, git also sometimes refuses the test's repositories with a "dubious ownership" error. Running with the temp directory on tmpfs avoided that.
- **CI run 39854262229:**
  - `test (22.x, macos-15)` and `test (24.x, macos-15)` passed.
  - On Ubuntu the daemon package passed 1614 tests with no failures, including all 51 git-remote tests. The rotation test took 2.7s, and all nine `provideGitClone` tests passed.
  - The remaining failures are `test (22.x/24.x, ubuntu-latest)`, `cover (22.x/24.x, ubuntu-latest)` and `sandbox-drivers`. Each job fails only the two sandbox tests the new runner breaks: "prlimit nproc cap is enforced inside the slice" (`ulimit: Illegal option -u`) and "bwrap parent death leaves no owned process group". These already fail on other PRs.
  - I read the results through the Actions runs API rather than `ci-wait-merge.sh`.

**Follow-ups:**
- The ubuntu-26.04 sandbox breakage needs its own fix on the base, either changing the tests or pinning the runner. Until then this PR's CI stays red.
- The gauntlet for #1538 is halted at its clean stage. It needs to be re-run, or resumed, against the new head `61abd3046`.
- The 2-second limit on the round-trip test is too tight for slow hosts like this one. Worth a separate small fix.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1538-fix-git-clone-test-hang.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 122 tokens (6026592 cached reads)
- Output: 26761 tokens
- Cost: $2.8164423999999997
- Wall-clock: 4052s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
