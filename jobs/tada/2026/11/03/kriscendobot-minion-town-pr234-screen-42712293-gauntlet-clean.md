Clean stage for kriscendobot/minion.town PR #234: nothing to change, and CI is green.

- **PR state:** open and not a draft. Head is `427122930f77` on branch `kriscendobot:probe/invitation-roundtrip`.
- **Coverage:** every new source path has a test, so I didn't push anything:
  - The `DELETE /api/guest/contacts/:petName` and `POST /api/guest/mail/dismiss-all` routes, including the 401 case without a credential and the 400 for a malformed percent-escape (`URIError`).
  - The memory and socket versions of `forgetContact` and `dismissAllMail`: a deletion overtaking them mid-flight, two overlapping forgets of one name, a forget that leaves the name in place, and a dismissal that fails only over mail already gone.
  - `LocalInvitationRegistry.accept`'s new `stillHolds` check and the new `retire`, including a replay after the contact was forgotten or the name rebound, and an accept still in flight when its name is retired.
- **Dead code:** none. `removeName` was generalized but is still used by both guest deletion and `forgetContact`.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0: 7 checks at the current head, 0 failed.

No follow-ups.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr234-screen-42712293-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (250688 cached reads)
- Output: 1410 tokens
- Cost: $0.4906176
- Wall-clock: 31s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
