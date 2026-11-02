---
orchestration-failed: true
---
orchestration-failed: true

# Clean stage FAILED: endojs/endo-but-for-bots PR #1476 (CI red at `aaa0c6c96`)

The coverage pass is finished and pushed, but CI ended red: `ci-wait-merge` returned rc 3 with 1 of 36 checks failed. No `clean=done` marker is emitted, so the driver should halt the gauntlet here.

## Failing check
- **Check:** `cover (22.x, ubuntu-latest)`, [run 41438794281](https://github.com/endojs/endo-but-for-bots/actions/runs/41438794281/job/125255320797), step `yarn test:c8 (affected set)`.
- **Failure:** `@endo/sandbox` test `bwrap › bwrap timeout and repeated cancellation reap process groups` failed with `process group 9612 survived bounded cleanup` (`packages/sandbox/test/bwrap.test.js:266`, called from `:1099`).
- **Likely unrelated to this PR:**
    - The PR doesn't touch `packages/sandbox`.
    - The same signature hit PR #1586 earlier today, and open fix #1591 targets it.
    - The CI run on the previous head, `ef689c10e`, passed, and my only change since then is a test in `ocapn-noise`.

I did not rerun the job, because no garden skill authorizes rerunning a flake and the job spec treats red as a stage failure.

## Decision for the maintainer
Either rerun the failed job or land #1591, then resume the gauntlet. A rerun is the quicker route, but this flake can recur until #1591 lands.

## Coverage work
- **Earlier pass:** the branch already had one, in `bcb60447d` and `09425cabc`.
- **New gap found:** no test reached the session's own `throw err` when the transport's `writer.throw` resolves, because the mock always rejected.
- **Fix:** commit `aaa0c6c96`, `test(ocapn-noise): cover a session throw the transport accepts`, adds a test for each of `reader.throw` and `writer.throw`. It was pushed with `safe-push-pr-head.sh`.
- **Test check:** both new tests fail when I temporarily change the code to skip `throw err`, and pass on the real code. ESLint, Prettier and `tsc` are clean.

| File | Lines | Branches | Notes |
| --- | --- | --- | --- |
| `ocapn-noise/src/network.js` | 96.85% | 89.62% → 90.25% | Lines 1189 and 1226 now covered |
| `ocapn/src/codecs/operations.js` | 100% | 100% | |
| `ocapn/src/client/ocapn.js` | 88.77% | 74.59% | The new `op:ping` and `op:pong` handlers are covered |

- **Remaining gap:** the only uncovered changed line in `network.js` is the swallowed `onClose` catch at line 1099. That catch predates this PR, which only reworded its comment, so the change didn't orphan it and I left it.
- **Dead code:** I found none orphaned by the change, so nothing was deleted.
- **Platform arms:** the PR adds none, and its body already explains the stubbed `test:xs`.

## Caveats
- **Local test runs:** whole-package runs in both packages reported one uncaught exception, an ENOENT on ava's `node_modules/.cache/ava/import-from-project.mjs`. That stopped `crossed-hellos.test.js` and `client.test.js` from finishing, so the coverage figures may be slightly low. Both files pass when run alone (2 and 35 tests), so this looks like a local race rather than a PR defect.
- **Inbox:** my last read timed out (rc 124), so a late message may be unread. An earlier read mid-job showed no messages.
- **Memory:** I added the #1591 recurrence and the noexec `TMPDIR` lesson to the existing notes.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1476-gauntlet-20261102-e530cc47c626-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 182 tokens (8383112 cached reads)
- Output: 68402 tokens
- Cost: $5.0944837
- Wall-clock: 19279s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
