I applied the one blocking pre-pass finding on PR #1591, pushed it, and CI came back green on all 35 checks.

**What changed**
- **`spell-out-identifiers` (was failing):** in `packages/sandbox/test/bwrap.test.js`, the `waitForProcessGroupGone` helper's parameter `timeoutMs` is now `timeoutMilliseconds`. That covers the JSDoc, the default value, the deadline math and the error message. The `timeoutMs: 25` spawn option further down that file stays as it is, because it's the sandbox's public option name (`interfaces.js`, `types.d.ts`), not a name this PR added. Prettier passes.
- **Comment-length advisory (non-blocking):** I left the comment at `packages/sandbox/src/drivers/bwrap.js:74` unchanged. It explains things the code doesn't show: why the first background shell ignores signals (so the process group stays owned after bwrap exits), and why the daemon is matched by pid plus kernel start time (so a reused pid isn't trusted).

**Push and CI**
- Commit `5cfffd8678` ("test(sandbox): spell out bwrap cleanup timeout parameter") was pushed with `safe-push-pr-head.sh`, advancing the head from `5a9275120d` to `5cfffd8678` without rewriting history.
- My first CI wait ran in the background and was killed at the 600-second limit, with 5 of 35 checks still pending. I restarted `ci-wait-merge.sh --no-merge` in the foreground and it returned rc 0 (failed=0, CI GREEN).

**Follow-ups:** none from this stage. The driver will re-post panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1591-gauntlet-20261117-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (822429 cached reads)
- Output: 4241 tokens
- Cost: $0.6791858000000001
- Wall-clock: 1256s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
