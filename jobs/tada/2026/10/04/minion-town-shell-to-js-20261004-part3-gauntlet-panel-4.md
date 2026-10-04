Panel round 4 on kriscendobot/minion.town#154 finished with a **must-fix** verdict, and I posted it to the PR.

- **Run:** `panel.sh` ran in single-round mode on an isolated checkout of `chore/javascript-only-scripts-part-3` at head `8b73552`. It compared against base `chore/javascript-only-scripts-part-2b-2ca6c15` (`2ca6c15`). It exited 0 with disposition `must-fix`.
- **Tally:** 33 reviewer seats: 2 request-changes (stylist, breaker), 11 comment-only and 20 approve.
- **Round 3 items:** the panel confirmed all five closed: the `deprovision` shell injection, duplicate MANIFEST keys, the reaper tests, the stale `ENDO_COMMIT` test text, and the fix-round summary comment.
- **Must-fix items:**
  1. In `deploy/aws/scripts/lib/remote-template.js`, a bare `$NAME` reference in `renderRemoteProgram` has no word boundary. `$URLs` with `URL` supplied renders as `http://evils` instead of throwing. It needs a boundary check and a test.
  2. In `deploy/aws/systemd/endo-daemon-reap-port-orphans.js`, the new exports `parseListenerPids` and `listenerPids` should become `parseListenerProcessIds` and `listenerProcessIds`, and the test file updated to match.
- **Should-fix items** (listed in the review): stale `ENDO_COMMIT` in a `die()` message and in `DEPLOYMENT.md`, an unused `ENDO_COMMIT` template variable, `null` being rendered as the text `null`, an unreachable throw in `deploy-app.js`, two different `quote` helpers, a re-implemented sleep helper, and the `bash -n` test not checking that `bash` exists. There are also optional property-test and boundary-test ideas.
- **Coverage not checked:** there was no c8 report, so coverage of new lines is unverified. The coverage seat flagged this but did not block on it.
- **How it was posted:** GitHub refuses a request-changes review from the PR's own author, so it went up as a COMMENTED review headed "Panel round 4 — must-fix". Round 3 was posted the same way. The body is about 42 KB, with approve seats shortened to their verdict line to stay under GitHub's size limit.

I made no fixes, did not un-draft the PR and committed nothing to the garden repo.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part3-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1235685 cached reads)
- Output: 7139 tokens
- Cost: $1.069765
- Wall-clock: 2035s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
