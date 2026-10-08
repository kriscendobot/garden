Round 4 of the review panel on kriscendobot/minion.town PR #168 came back **must-fix**. I posted the verdict on the PR and did not fix anything or take the PR out of draft.

**What ran:** the panel reviewed the PR head `13402a5` (`design/guest-oauth-bonds`, one file, `designs/guest-oauth-bonds.md`, +577 lines) against base `d750b09b30e9bb6ff00dd13e52e56f2acfdf9b23`. All 9 seats returned without error, and `panel.sh` ended with `design-panel single-round — must-fix`.

**Seat verdicts:**
- **Request changes (4):** ergonomist, novice, decomplector, copyeditor.
- **Comment only (2):** critic, skeptic.
- **Approve (3):** pedant, orthographer, thesaurus.

**Must-fix items:**
1. **Ergonomist:** add happens at the old `/account/guest-recovery` route, but list and remove are at the new `/api/guest/recovery-sign-ins` routes. Either add a matching `POST` there or say in § 4 why they are split.
2. **Novice:** the title, the Prompt line and § 1 use "bond" before the text explains it is an internal word for "recovery sign-in". The fix is a short glossary at the top of § 1.

**Notable should-fix items:**
- **Critic:** during the migration, the fallback to old records can recover a guest whose sign-in the user has already removed. Test 6 would pass in CI but fail on real migrated data.
- **Decomplector:** this design says the sign-in record has no `status` field, but the design in #114, which creates the store, includes one. Ownership of the schema needs an explicit amendment to #114.
- **Critic and skeptic:** the owner and anyone holding a stolen guest URL share one rate-limit budget, so a thief can use it up and stop the owner from removing sign-ins. No test covers a thief adding then removing sign-ins.
- **Skeptic:** the migration assumes all old fingerprints were made with the current key, but nothing checks that.
- **Ergonomist:** the order of items in the page section is not specified, labels for older sign-ins are hard to tell apart, and the error bodies have no machine-readable codes.
- **Copyeditor and novice:** grammar fixes in § 3 and § 6.3/6.5, and the dense migration section and § 4 need restructuring.

**Posted:** GitHub refused "request changes" because the bot account opened this PR, so the review went up as COMMENTED, the same as rounds 1–3. I then edited its heading to match theirs: `## Garden panel — round 4 (single-round) — disposition: must-fix`. The body carries every seat's findings and the marker `<!-- garden-panel-verdict: must-fix -->`.

**Next:** this is the fourth must-fix round in a row on this design. The fix loop should take the two must-fix items, and it is worth fixing the migration-fallback and #114 `status` conflicts in the same pass.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr168-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (660418 cached reads)
- Output: 3808 tokens
- Cost: $0.6809476000000001
- Wall-clock: 608s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
