I recorded this as a **review miss** that the review process should have caught. The cluster it joins was already reopened, and I did **not** dispatch a second improvement job.

**What I checked**
- No earlier record existed for this review, so the retro was not a repeat.
- kriskowal's review (5610163704, CHANGES_REQUESTED, 2026-10-22) says Parcel recognition in `packages/pass-style/src/parcel.js` is a shape check. It should be a brand check: an object test plus a lookup in the WeakMap that holds each parcel's location and open hook.
- This is not a new requirement. The design on the PR's own base, `designs/parcel.md`, already says `Parcel.isParcel` consults that WeakMap and that "the brand check is the only recognition path". The shim already implements it.
- The gauntlet ran six panel rounds after the switch to Parcel (2026-10-15 to 10-16):
  - Rounds 3 and 4 raised must-fixes that added more shape validation (descriptor checks, lying or stateful `isParcel`, reentrancy) instead of questioning the approach.
  - In round 5, the decomplector check added by the earlier improvement (commit 7a88d0007c2) did fire and flagged the bespoke validator as must-fix.
  - The round-5 fixer removed only the cache and declined the rest as "a design change", without asking the maintainer.
  - Round 6 couldn't post its review (403 on the bot token), and the gauntlet halted with 20 must-fixes unaddressed. That left the maintainer to raise the point.
- The primary job's fix is really on the PR. Head `5f9bc1533d` includes `4a034b968a`: recognition is now an object check plus the captured `Parcel.isParcel`, the shape checks are deleted, and a test rejects a same-shape impostor. One question is still open to the maintainer on the PR: should the WeakMap live inside pass-style itself?

**What I recorded**
- Wrote `review-misses/misses/endojs-endo-but-for-bots-pr1392-review-8531f855.md`: category `process`, severity moderate, a paraphrase only (no quoted review text), with grounds.
- It joined the `design-bespoke-mechanism-over-existing-path` cluster. Writer output: count=5, prs=1226,1407,1433,1392, status=open, recurrence=0.
- The cluster had already been reopened today by the #1433 retro, which counted as a real recurrence after the 2026-10-07 improvement and has already alerted the maintainer. So no new alert went out, and I sent none.

**Threshold decision: held, with the reasoning recorded on the cluster**
The cluster passes the dispatch threshold, but the skill says a second improvement round after a recurrence waits for the maintainer. I recorded two additions for that round's scope:
1. A fixer should not be able to decline a decomplector "is it needed?" must-fix as out of scope. It either does the fix or asks the maintainer on the PR.
2. When the decomplector looks for an existing path, it should include the mechanism the PR's own governing design names. The well-known ocap idiom list proposed in the #1433 retro should also cover "brand check through a closely held WeakMap, not a shape check".

**Follow-ups**
- The maintainer needs to decide whether to start a second improvement round (`review-improve-design-bespoke-mechanism-over-existing-path` round 2) covering the #1433 and #1392 additions.
- The bot token's 403 when posting reviews on endojs repos from oros-studio is what halted the gauntlet at round 6. It was already known and still needs fixing.

Self-improvement: no garden edits; the skill worked as written. The local journal checkout was behind origin, so I read the live cluster file through the GitHub API to see the real state.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1392-review-8531f855-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1593878 cached reads)
- Output: 10600 tokens
- Cost: $1.2279676
- Wall-clock: 150s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
