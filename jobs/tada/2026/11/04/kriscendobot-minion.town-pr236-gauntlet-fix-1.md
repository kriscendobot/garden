# Gauntlet fix round 1: kriscendobot/minion.town#236

I fixed the panel's one must-fix and nearly all of its should-fix and summary items, then pushed two commits to `feat/remote-invitation-hints` (6cc65039 → 732918b7). CI is green: `ci-wait-merge` returned rc 0, with all 4 checks passing and none failed.

## The must-fix
The saboteur and breaker found that a refused remote invitation could delete an existing contact. `inviteRemote` (`src/web/guest-web-socket-service.ts`) now checks `E(guest).has(petName)` before minting and answers 409 (`GuestNameConflictError`) if the name is taken. While a mint is in flight, the name is also reserved for that guest, so two overlapping requests can't both get past the check.

## Should-fix and summary items
- **Cancel failures:** a failed `cancel()` after a refusal is now logged instead of silently dropped.
- **Hint filter:** `hintIsServed` now refuses a location that carries any transport hint other than `*:host` or `*:port` (for example a `ws:url`). Before, such hints were passed through unchanged.
- **Bad percent-escapes:** `parseLocator` now reports a malformed escape like `%ZZ` as `FederationUnavailableError` instead of a `URIError`, so the caller gets the 503 the docs promise.
- **Doc comments:** the `servedInvitationLocator` comment now says its node check only confirms the locator agrees with itself. I removed the duplicate text from the module header.
- **New tests in `test/web/guest-web-socket-faults.test.ts`:**
  - a refused invitation with federation on returns 503 and is cancelled exactly once;
  - only the served hint is handed out;
  - with federation off, the daemon's locator passes through unchanged;
  - an already-used name is refused before anything is minted, and the contact survives;
  - an overlapping request for the same name is refused.
- **New tests in `test/endo-guest-locator.test.ts`:** a repeated `type`, a missing `from`, a `%ZZ` escape, a location mixing TCP and `ws:url` hints, and served hints keeping their order.
- **`DEPLOYMENT.md`:**
  - § What is in the tree now describes invitation filtering, including the weaker node check.
  - § Rollback notes that `disable` turns invitation filtering off again.
  - The plan for serving WebSocket is cut down to one paragraph that keeps the "start the listener before repointing Caddy" ordering.
  - The stale "draft" label on endo-but-for-bots#1647 is gone.
- **Other docs:** I rewrote the changeset for API clients, as the releaser suggested, and added the new 409. I updated the out-of-date scope note in `designs/invitation-only-guest-onboarding.md`.
- **PR description:** I rewrote it to read as a merge commit. The wrong tracker link (#227) is replaced by `designs/remote-guest-endo-cli.md` § 5. I cut the locator dumps, the scratch diff, the evidence table and the duplicated WebSocket text. The three open questions and the garden-job markers are kept.

## Checks
- The typecheck passed.
- The three test files I touched pass (82 tests).
- The full suite passed except for 1 of 1696 tests: `test/git-remote/capability.test.ts > propagates a git failure…`. That code is untouched by this PR and the failure most likely comes from this worker's local git environment. CI was green.

## Not done
- **Commit grouping:** the integrator asked to move a test out of `6cc65039` into `69f09d80`. That needs a history rewrite, which a fix stage that only adds commits shouldn't do.
- **Code formatting:** I didn't reformat whole files with prettier, because these files already failed prettier before this PR and the repo doesn't enforce it.
- **Remaining test corners:** I skipped the corner-prober's minor router-mapping-order and uppercase-hex cases.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr236-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2675627 cached reads)
- Output: 16203 tokens
- Cost: $1.6454494000000002
- Wall-clock: 554s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
