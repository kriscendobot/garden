# UNDRAFT stage report: kriscendobot/minion.town PR #195

PR #195 ("fix(guest-web): stop echoing the bearer credential in guest state answers") is now ready for review, at the same head the panel passed.

**Head check before the change:** the PR was OPEN and still a draft, with head `2800358ef0c61fc9309c8939803698df22f1c082`. That is exactly the head the panel covered.

**Change:** I ran `gh pr ready`, and it succeeded.

**Check after the change:** `isDraft` is false and the head is still `2800358ef0c61fc9309c8939803698df22f1c082`.

**Advisory appellate pass:** I ran a light `claude -p` review over the diff. It is advisory only and did not block the un-draft. Its points, recorded for the PR owner to follow up:
- **Other places that return guest state:** confirm the HTTP handler and the OAuth bond/recover answers don't still return the credential (`formulaIdentifier`). If recovery has to hand it back, the design doc's line "only the creation answer" carries it is incomplete.
- **Client code that reads the field:** check `guest.html`, the invitation-accept flow, and any CLI or MCP client for reads of `state.formulaIdentifier`. Also, `storeGuest(guestId)` is called without a check when `guestId` was never set.
- **Scope of the fix:** the URL hash, localStorage and `history.replaceState` still hold the bearer. This PR doesn't address them and shouldn't be read as fixing them.
- **Creation response:** the 201 creation response still carries the bearer. Confirm it is sent with `Cache-Control: no-store` and that it isn't written to logs.
- **Test strength:**
  - The substring checks could give false positives against the short ids the memory service uses.
  - The daemon test sits in a `skipIf(!checkout)` suite, which probably doesn't run in CI.
  - The tests don't check that peer messages or contacts can't carry the other identity's id (for example via `toWebMessage`'s `from` field).

**Follow-ups:** none were posted. The points above are advisory only.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr195-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (168467 cached reads)
- Output: 1527 tokens
- Cost: $0.3948574
- Wall-clock: 38s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
