## Completion report: minion-town-guest-state-stop-echoing-formula-identifier-20261016

I opened the fix as draft PR **https://github.com/kriscendobot/minion.town/pull/195**. The new test fails on the old code and passes with the fix. The usual gauntlet follows; I did not merge.

**The report was accurate.** `GET /api/guest` returned the guest's `formulaIdentifier`, which is its bearer credential. `POST /api/guest/invitations/accept` leaked it the same way, because it answers with the same state.

**What changed:**
- The guest state answer now holds only `contacts` and `messages`. Only creation (`POST /api/guest`, 201) returns the identifier. Both the in-memory and daemon backends are updated.
- The guest page (`deploy/aws/www/guest.js`) keeps the credential it already holds and only takes a new one from the creation answer.
- `designs/invitation-only-guest-onboarding.md` § 11 now states that rule.
- **New test** in `test/web/guest-web-http.test.ts`: the state answer and both accept answers (first acceptance and repeat) must not contain the identifier, either half of it, or the key `formulaIdentifier`.
- **Daemon test:** the daemon-backed test now also checks that no state answer has `formulaIdentifier`. It skips locally because it needs a built Endo checkout; CI runs it.

**PR base:** the PR targets a frozen snapshot of `main` (`main-51ad067`), because the PR-opening script requires one.

**Consumers checked, all still working:**
- **Guest page:** create, accept (including create-then-accept), refresh, recover, resume.
- **Demo script:** `dev/guest-web-daemon-demo.ts` reads the identifier only from creation.
- **Tests:** both web test files read it only from creation.
- **Other code:** `claude-guest-bridge.ts` and `guest-self-endpoint.ts` don't use this answer, and the OCapN canary doesn't call `/api/guest`.

**Test results:** the full `npm test` run passes except for one test in `test/git-remote/capability.test.ts` ("propagates a git failure"). It fails the same way on unchanged `main`, so this change didn't cause it.

**Garden docs:** `context/operations/minion-town-mcp.md` now points to PR #195 and also names the accept route. Pushed to main2 as 591671f07ad.

**Other places the credential appears (left unchanged):**
- `GET /account/guest-recovery` returns the identifier. That is intended: it's the recovery handoff, and it requires OAuth identity headers.
- The guest page shows the credential, stores it in `localStorage`, and puts it in the URL fragment. These are existing design choices; the page tells the user to treat it like a password.
- The guest routes don't log the credential. That is the routes' own code only; I didn't look at Caddy's access-log settings.

**Follow-up:** after #195 merges and deploys, drop the "redact before logging" caveat from `context/operations/minion-town-mcp.md`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-guest-state-stop-echoing-formula-identifier-20261016.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1599313 cached reads)
- Output: 11629 tokens
- Cost: $1.1436266
- Wall-clock: 194s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
