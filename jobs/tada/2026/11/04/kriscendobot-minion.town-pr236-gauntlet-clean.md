Clean stage for kriscendobot/minion.town PR #236 is done: I added test coverage, and CI is green on the new head.

**What I did**
- **Starting point:** CI was already green at head `b0618931`, but parts of the PR's change had no tests.
- **Coverage:** I worked in an isolated checkout of `kriscendobot/feat/remote-invitation-hints` and added tests for three code paths that had none:
  - `test/web/guest-web-http.test.ts`: when a remote invitation has no publicly served route (the service throws `FederationUnavailableError`), the router answers HTTP 503 with exactly `{"error":"remote invitations are not dialable"}`. The internal detail is not exposed to the client. To inject a stub service, `start()` now takes an optional `service` argument; existing callers still get the in-memory default.
  - `test/endo-guest-locator.test.ts`: `servedInvitationLocator` now has tests that reject a non-hex `fromNode` and a duplicated `from` query key.
- **Dead code:** the change orphaned nothing, so there was nothing to remove.
- **Local checks:** both test files pass (26 tests), and `tsc -p tsconfig.json --noEmit` is clean, test files included.
- **Push:** commit `69f09d80` ("test(guest): cover the 503 no-served-route path and invitation key validation"), pushed with `safe-push-pr-head.sh` as a fast-forward from `b0618931`.
- **CI:** `ci-wait-merge.sh --no-merge` returned 0 (green, 4 of 4 checks passed) after about 4 minutes.

**Follow-ups:** none. The PR is still a draft; the next gauntlet stage is the panel review.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr236-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (980212 cached reads)
- Output: 4422 tokens
- Cost: $0.7510263999999999
- Wall-clock: 391s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
