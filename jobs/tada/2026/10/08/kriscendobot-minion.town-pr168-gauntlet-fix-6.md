# Gauntlet fix round 6 for kriscendobot/minion.town PR #168: done, CI green

I fixed all four must-fix items from the round-6 panel review, plus three of the skeptic's should-fix items. The changes are one commit, `bc7fe38` ("design(guest-oauth-bonds): address panel round 6"), on `design/guest-oauth-bonds`. I pushed it with `safe-push-pr-head.sh`, which moved the head from 171daf2 to bc7fe38. CI finished green: `ci-wait-merge` returned 0, with 3 of 3 checks passing and none failing.

**Must-fix items (all in `designs/guest-oauth-bonds.md`):**
- **decomplector #1:** Recovery no longer backfills old rows. The paragraph saying the first recovery through an old row fills in `provider`, `label` and `lastRecoveredAt` is gone, and the text now says nothing fills those fields later. The "Older sign-in" badge and the fixed `signInId` suffix are what tell old rows apart. The migration script is now named as the only thing that writes during migration. The § 9 ownership map shows that recovery writes only `lastRecoveredAt` on an already-migrated `RecoveryIdentity` and never touches an old row.
- **decomplector #2 (should-fix, done with #1):** I kept `lastRecoveredAt` and gave it a reason in § 3 and § 4. A recent "last used" date on a sign-in the owner never used is the one server-side sign that someone else used it.
- **novice #1:** "Migration and cutover" now opens with a short explanation before the procedure. It says what an old row is and why the list can't be built from it, so each row must be converted once.
- **novice #2:** The Terms box now defines **formula identifier / bearer** and **fingerprint**, in plain words plus the formula.
- **novice #3:** § 3 has a new before/after table comparing the old row, `GuestAccount` and `RecoveryIdentity` field by field. It marks which fields are this design's changes to #114.

**Skeptic should-fix items also addressed:**
- **#5:** The design now declares a unique index on `GuestAccount.guestFormulaFingerprint` as a change to #114.
- **#1:** The claim that the sign-out chain is "already proven in production" is downgraded. It now says the claim rests on reading the config and code, and that the manual browser check in § 8 is the first real run.
- **#4:** Test 13 now matches § 1 and open question 1: Ethereum's MCP column is never shown as a plain "Yes" or "No".

**Follow-ups for the next panel round:** these should-fix items are still open.
- **Skeptic #2:** who owns the migration if #114 lands without this design's changes.
- **Skeptic #3:** where `label` comes from.
- **Critic** (should-fix): a delay before removing other sign-ins, and a startup check that the fingerprint key is right.
- **Ergonomist** (should-fix): naming the legacy add route.
- **Decomplector #3:** `listComplete`, a temporary cutover state that sits in the permanent API.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr168-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1447311 cached reads)
- Output: 9305 tokens
- Cost: $1.0598582
- Wall-clock: 404s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
