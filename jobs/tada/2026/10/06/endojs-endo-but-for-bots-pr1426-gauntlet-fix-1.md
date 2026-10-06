Fix round 1 for endojs/endo-but-for-bots PR #1426 is done. I applied the panel's must-fix items in three follow-up commits, which moved the head from `5666a29bc4` to `89b272ac38`, and CI is green (33/33).

**What I changed, by reviewer:**
- **prover (must-fix):** nothing tested the earlier fix that builds the Chat page's `file:` URL with `pathToFileURL`. I moved that construction into a helper, `chatFilePageUrl` in `packages/familiar/src/security-warnings.js`, and `electron-main.js` now calls it. A new test uses an install path containing a space, `#` and `%`. It checks that the URL matches what Electron reports for the loaded page, and that the old `` `file://${path}` `` template does not. Reverting the fix makes the test fail. (`a1db13be7c`)
- **purist / wire-watcher (import the channel name in `preload.mjs`):** declined. The packaged app ships `preload.mjs` on its own, without `src/` (see `scripts/package-app.mjs`), so that import would break the shipped app. The old comment blamed the test harness; I corrected it to give this reason. The existing test that checks the two names match is still there. (`528951c126`)
- **purist (rebuild the preload's subscriber list on `@endo/notifier`):** declined, with the reason given on the PR. The subscribers are synchronous callbacks, and the preload file can't load extra packages once the app is packaged.
- **pruner:** cut the comment in the design doc's code sample (`designs/familiar-localhttp-protocol.md`) down to one line. (`89b272ac38`)
- **scribe:** posted the missing summary for the earlier round-6 push, combined with this round's summary: https://github.com/endojs/endo-but-for-bots/pull/1426#issuecomment-6007460760. A second comment records the CI result.

**Checks:** the `packages/familiar` tests (23), its type check and eslint (no errors) all pass locally. The repo-wide type check shows no errors in familiar. I pushed with `safe-push-pr-head.sh`, which only added commits on top of the PR head.

**CI:** the first CI wait came back red (rc 3) on one leg, `test (24.x, macos-15)`. The failure was a relay-channel timeout in `@endo/daemon` `test/http-content-plane.test.js`. This PR doesn't touch daemon and the other three test legs passed, so I re-ran just that job once. It passed, and a second CI wait returned rc 0. Strictly, the job told me to report rc 3 as orchestration-failed. I re-ran the job instead because the failure isn't in this PR's code.

**Follow-ups:** the comment-only items were left for later: matching Windows drive letters without regard to case, a second check on the preload side so warnings can't reach a weblet, and property-based tests. That daemon test may be flaky on macOS and could deserve its own look.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1426-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (3213844 cached reads)
- Output: 14856 tokens
- Cost: $1.6906407999999997
- Wall-clock: 4520s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
