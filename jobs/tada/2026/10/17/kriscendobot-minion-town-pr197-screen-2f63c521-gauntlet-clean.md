I did the coverage pass and pushed one new test to https://github.com/kriscendobot/minion.town/pull/197, but CI never started within the hour, so this stage is still pending.

**Coverage pass** on `deploy/aws/www/shell.js`, the only source file the PR changes (run with vitest + v8 coverage against `test/shell-clip.test.ts`):
- **New pure helpers:** all covered, except one branch. When an engine reports only `violatedDirective` on a CSP violation, `createLiveFrameWatch().violation` falls back to reading that field, and no test reached that path.
- **New test:** "reads the directive from violatedDirective when effectiveDirective is absent". It checks that an event with no directive and one with a non-frame directive are ignored, and that a `child-src` `violatedDirective` for the watched origin fails the frame over to the inert card. I removed the fallback in the source to confirm the test then fails, and restored it. The suite passes 94/94 and `npm run typecheck` is clean.
- **DOM wiring:** the other uncovered new lines are in `bootstrap` (`showLive`, `showDocument`, the caption, the load/violation listeners). Unit tests can't run that code; the PR's three-engine Playwright browser gate (`test/browser/clip-frame-gate.ts`) is what runs it.
- **Dead code:** none. The old `clipDocument` was kept and now takes a reason argument, and every export is still used.

**Push:** commit `8cd365a` ("test(shell): cover the violatedDirective fallback in the live-frame watch") went to `feat/clip-live-frame` via `safe-push-pr-head.sh`, moving the head from `2f63c52` to `8cd365a`.

**CI: still pending.** `ci-wait-merge.sh` ended with rc 4. Both runs for `8cd365a` ("Test (typecheck + vitest)" and "clip frame browser gate") have been queued since 17:07Z without starting. Across the repo, 11 runs are queued and none are in progress, so the self-hosted `ci-minion-town` runner looks stalled. It's not a billing block: the runs are queued, not refused. I messaged the maintainer, because re-posts of this stage will keep timing out until the runner is back.

Two host problems got in the way:
- The bot PAT can't read `statusCheckRollup`, so the CI wait relied on the script's Actions-runs-API fallback.
- The GitHub REST quota (5,000/hr) ran out from 17:04Z to about 17:17Z, which delayed the first CI reads.

**Follow-ups:**
- Restart the ci.minion.town runner, or move CI to hosted runners with `CI_RUNS_ON` (`skills/minion-town-ci-runner-switch`). This host has no AWS access, so I couldn't inspect the runner.
- Re-run this stage once CI starts.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr197-screen-2f63c521-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2310815 cached reads)
- Output: 13847 tokens
- Cost: $1.3181750000000005
- Wall-clock: 3810s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
