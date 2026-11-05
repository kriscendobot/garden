**Clean stage, PR #1649: the coverage pass is pushed, but CI is not terminal.** `ci-wait-merge.sh` returned rc 4 at its 3600s deadline, so this reports still-pending rather than `clean=done`.

**CI at head `6a613403d4`**
- **Tally:** 23 passed, 10 skipped, 1 failed, 2 still running. The running jobs are `test (22.x, macos-15)` and `test (24.x, macos-15)`.
- **`test-xs` is already red, so the re-posted stage should expect rc 3 unless that changes.** It is the known Node 26 flip, with the same log signature as before: `.node-version` `lts/*` downloads 26, and `sesNode/module` fails `ThrowTypeError/intrinsic-metadata.js`. The PR's diff doesn't touch that area, and it needs the maintainer's decision on the Node pin or baseline.
- **Previous head `2dd07fe5af`:** `test (24.x, macos-15)` failed in `packages/daemon/test/http-content-plane.test.js` with 2 unhandled `ClientDestroyedError` rejections, a pattern already seen on other PRs. It could recur on this head; its cause is still unproven.

**Pushed (one commit, via `safe-push-pr-head.sh`; remote head confirmed)**
- **New tests in `hosted-agent/test/agent-responder.test.js`:**
  - a turn with no text
  - a turn that finishes after stop
  - mail arriving after stop
  - a failed pass resuming after backoff
  - locator parsing
  - the `describe` cursor
- **New test in `hosted-agent/test/agent-factory.test.js`:** Retry now and the summary's responder queue, including a malformed number and an unreachable responder. The fake responder gained `describe` and `retry`.
- **Dead code removed from `agent-responder.js`:**
  - `?? []` on `message.strings`, because inbound mail is always `package` type and carries `strings`
  - `if (stopped) return` in `pump`, because `step` already guards it and removing it broke no test

**Verification**
- **Tests:** `agent-responder`, `agent-factory` and `inference-provider-registry` pass (96 tests). `daemon/test/agent-responder-restart.test.js` passed 4/4 before the commit, and I did not rerun it afterwards. The full `hosted-agent` and `daemon` suites were not run locally.
- **Mutation checks:** six deliberate mutations were caught; the seventh removed the `pump` guard and survived, which is why it was deleted.
- **Lint and gates:** prettier ran on the changed files and eslint found 0 errors. Pre-push gates passed `--probes-only`, without repo-wide lint auto-fix.

**Coverage gaps that remain**
- c8 reports nothing for the caplet modules or the Lal and Fae harnesses in the real-daemon test, so `agent-*-module.js` has no coverage figures. I only read the diff and traced references there.
- The `invalid-agent-limits` catch in `setLimits` stays uncovered at that call site. It is phase 4 code that this PR only reformatted.
- `describe` still uses `...(state.cursor === undefined ? {} : { cursor })`, which kriskowal is known to dislike. I left that for the panel, as it's outside this stage.

**Host note:** the daemon test first failed to spawn on this host. Replacing the checkout's `better-sqlite3` with the Node 22 prebuilt fixed it, as the host's existing note describes.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1649-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 226 tokens (9825077 cached reads)
- Output: 51912 tokens
- Cost: $4.6781434
- Wall-clock: 14323s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
