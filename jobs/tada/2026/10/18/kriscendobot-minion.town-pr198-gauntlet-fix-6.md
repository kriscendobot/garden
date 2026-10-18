Fix round 6 for PR #198 is already on the PR head, and CI is green. I made no new commits this round.

The must-fix in the panel-6 verdict was the invitation takeover guard. An unauthenticated retry could take over an invitation another guest had already connected or half-finished. The fix is in `2be159e7`, `db6a776f` and `c2484cc1`, pushed before this attempt started. Head `c2484cc1` is the current PR head, and the 11:06Z PR comment describes those commits.

- **Guard:** both entry paths of `POST /api/guest/invitations/accept` now refuse an invitation whose provisional guest or connected invitee belongs to someone else. A new test, `refuses a creating retry after another invitee connected`, fails without the fix.
- **Should-fix items folded in:**
  - A retry must reuse the pet name the connection gave the inviter. A different name gets 400.
  - `home.js` now catches a failed recovery bond and keeps the stored guest.
  - The design docs are trimmed.
- **Deferred:** procurer's point that `makeRateLimiter` duplicates `@endo/http-confine`. That package isn't published, so the local limiter stays. The decomplector's question about a single global signup budget is left for the maintainer.
- **Already documented:** the lost-201 case, where the credential response never reaches the client, is covered in § The one landing of `designs/closed-beta-waitlist.md`.

CI: `ci-wait-merge.sh` returned rc 0 (3 checks, 0 failed).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr198-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 80 tokens (3166069 cached reads)
- Output: 17390 tokens
- Cost: $1.8861359999999996
- Wall-clock: 3840s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
