The panel-5 fixes for PR #198 are pushed (head `ab33986`), but CI never ran: the run sat queued for the full hour, so this stage reports still-pending.

**Fixes, in 3 review-feedback commits on `feat/beta-home-splash-waitlist`:**
- **Invitation acceptance can now be retried** (raised by assessor, locksmith, breaker, purist, spec-keeper, wire-watcher, engine-realist and saboteur). In `src/web/guest-web-router.ts`, the guest is created, connected and inspected before the invitation is marked accepted. If a step fails, the invitation goes back to pending but keeps the guest it created and the connection already made. A retry reuses them, so one invitation creates at most one guest. An `inspect` failure no longer strands the credential, and a different guest cannot take over a half-finished invitation. A new test drives two connection failures, then an inspection failure, then success, and checks there was one creation and one connection.
- **One gap is left and documented:** if the response is lost in transit after the invitation is marked accepted, the credential can't be recovered, because the server can't tell that from a delivered response. `designs/closed-beta-waitlist.md` now says so.
- **typist:** `submitWaitlist` in `home.js` returns only string messages, whatever the response body holds, with tests. The `CreatedGuestWebState` comment now names both responses that create a guest.
- **prover:** the waitlist backend selector moved from `src/http.ts` into `src/waitlist/waitlist.ts` as `buildWaitlistWriter`, so it can be tested on its DynamoDB path with the AWS SDK mocked.
- **integrator:** the route table, the no-guest branch and the disclosure rule in `designs/invitation-only-guest-onboarding.md` now point to the one landing in `designs/closed-beta-waitlist.md`.
- **corner-prober, breaker:** any non-blank honeypot value now counts as a bot, including numbers, objects and arrays.
- **fast-checker:** every spelling of an IPv4-mapped IPv6 address gets the same rate-limit key, covered by a property test.
- **transplanter:** the waitlist CLI no longer falls back to a hardcoded `us-west-1`.
- **purist:** the add-only writer captures `add` when it is built, and the memory store is frozen.
- **breaker:** the dev demo mounts the waitlist router before `express.json()`, so the 2 KB body limit holds.
- **pruner:** both comments are removed.

**Not done, with reasons posted on the PR:**
- **decomplector** asked to remove the waitlist entirely. I declined: the waitlist is the scope the maintainer asked for in the closed-beta product pass, so removing it is their call.
- **releaser** asked for a changeset. The repo has no changeset tooling (no `.changeset/`, no CHANGELOG), and the deploy step is already in the PR's deploy notes.

**Verification:** typecheck is clean. The full suite has 1,263 passing; the only failures are 3 tests in `test/git-remote/`, the same unrelated host git-wrapper issue the PR body already notes.

**CI:** Actions run 39108454424 was queued at 07:38Z on the `[self-hosted, ci-minion-town]` runner and was still queued at the 08:38Z deadline. No run was in progress after about 07:40Z, and another branch's run (`ci/harness-path-gate`) has been queued since 06:59Z, so the `ci.minion.town` runner looks offline. I couldn't confirm that: this host's token can't read the runners API or the PR's check status, so I polled the Actions runs API directly. I sent the maintainer one message about the stalled runner.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr198-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (4448192 cached reads)
- Output: 25410 tokens
- Cost: $2.2324944000000007
- Wall-clock: 3882s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
