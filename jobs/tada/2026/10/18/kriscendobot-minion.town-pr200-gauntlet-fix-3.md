I applied the panel-3 must-fix items on PR #200 and pushed them (`8f0de31..333d531`). CI is **still pending**: the run had not even started when the one-hour deadline passed. It has been queued since 01:36Z on the self-hosted `ci-minion-town` runner, which has picked up no jobs since about 00:10Z. `main`, #198's branch and `ci/harness-path-gate` are stuck in the same queue. Because of that, there is no CI verdict on the fix yet.

**Changes**, in two follow-up commits on `feat/beta-settings-simplify`:
- **Durable deletion:** the tombstone and audit writes are now flushed to disk (`fsync`) before the 204 is sent. The parent directory is also flushed when the file is first created. A new helper, `src/web/durable-append.ts`, does this.
- **Fail-closed tombstone load:** a malformed complete line in the tombstone file now stops startup with an error naming the file and line. Only a torn last line is tolerated, and it is cut off rather than terminated with a newline.
- **Bond authority split:** `hasGuestBond`, `unbondGuest` and a new `unbondIdentity` moved off `AccountStore` into a separate `GuestBondAdmin`. Only the guest web router receives it. The cached store the other routers get no longer carries any of these methods, and a test checks that.
- **Bond/deletion race:** after a recovery bond is written, the router checks the tombstone again and undoes the bond if a deletion got there first. Any bond the deletion sweep missed (the DynamoDB index can lag) is removed the next time that sign-in tries to recover it.
- **Deploy preflight:** in production on DynamoDB, the app checks the fingerprint index at startup and refuses to start without it. The existing readiness check in `deploy-app.sh` then restores the previous build. I didn't add a check in the CI workflow because the CI role has no DynamoDB permissions.
- **Invitation count removed:** `invitation-allowance.ts` and the count UI are gone (decomplector). That also covers the locksmith finding about the coupon-issuer adapter.
- **Settings page:** `settings.js` now gets only its three operations (settings, invite, delete) instead of a general bearer `api`. The delete confirmation must match exactly, with no trimming, and the typed text is what gets sent.
- **Tests:** a `createApp` integration test using `STATE_DIRECTORY`, flush checks, three fast-check properties, and race and missed-index cases.
- **Docs:** `designs/closed-beta-waitlist.md` has a new "Settings menu" section and no longer mentions the old panel or the "sibling job". `DEPLOYMENT.md` notes the startup check. I trimmed the PR body as well.
- **Smaller items:** fixed the "canceling"/"canceled" spellings, removed the comments the pruner flagged, and replaced `seq` with a bash loop.

**Not changed:**
- **"Delete account" label:** kept, because the maintainer chose it. The page copy now says the sign-in itself stays, for MCP, and the design doc says the waitlist isn't touched because nothing links a guest to an address.
- **Migrator's "legacy bonds" finding:** not reproducible. `bondGuest` has written the fingerprint attribute since it was added on 2026-09-17, so the index backfill already covers old rows. A code comment now says so.
- **Purist's `@endo/sha256` suggestion** (should-fix): not done.

**Local results:** typecheck is clean and 1254 tests pass. One test fails: `test/git-remote/capability.test.ts › propagates a git failure`. It is not in this PR's diff, and its expected git error didn't surface here.

**Follow-ups:**
- Someone needs to restart the `ci-minion-town` runner. This host has no AWS access to do it.
- The maintainer still needs to run `deploy-accounts-store.sh` before deploying.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr200-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 132 tokens (7875531 cached reads)
- Output: 47919 tokens
- Cost: $3.7429342000000005
- Wall-clock: 4288s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
