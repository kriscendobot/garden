The clean stage for PR #239 (kriscendobot/minion.town, `garden/web-accept-evaluate-locator`) is done: I added unit tests and CI is green at the new head `65233d6d`.

CI was already green at the starting head `bdfef8c4`. I still ran the coverage pass because the new locator branch of `POST /api/guest/invitations/accept` and the new `isInvitationLocator` check were only tested by `test/web/guest-web-daemon.test.ts`. That test is skipped whenever there is no daemon checkout.

**What changed:** one test-only commit to `test/web/guest-web-http.test.ts`, pushed with `safe-push-pr-head.sh` (`bdfef8c4` → `65233d6d`). It covers:
- **Locator route, using the in-memory service:**
  - A non-string, a non-`endo://`, or a locator with no `type` gets a 404 with the code `invitation-unavailable`.
  - A well-formed locator gets a 200 and the contact is added.
  - Reusing a pet name gets a 409, so guest-state errors pass through instead of being turned into "unavailable".
- **A daemon refusing the locator:** a stubbed `acceptLocal` failure becomes a 404, and the locator text is not echoed back.
- **`isInvitationLocator`:** a table of accepted and rejected inputs, including a locator over the length limit.
- **Test helper:** `start()` now takes an optional `service` so a test can supply a stub.

**Checks:**
- The file's 18 tests pass and `tsc --noEmit` is clean.
- The change orphaned no dead code.
- No changeset was needed for a test-only change.
- `ci-wait-merge.sh --no-merge` exited 0 with 7 of 7 checks green.

**Follow-ups:** none.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr239-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (874723 cached reads)
- Output: 4642 tokens
- Cost: $0.7523926000000001
- Wall-clock: 381s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
