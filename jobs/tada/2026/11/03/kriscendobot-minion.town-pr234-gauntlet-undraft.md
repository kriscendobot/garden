**Gauntlet undraft: kriscendobot/minion.town #234: done**

PR #234 is now ready for review. It is still OPEN at the head the panel passed, `bb6f1bee265fa0c7341291330adc70a5a1f422ac`. The metadata check before `gh pr ready` showed that head, and the check after it showed the same head with `isDraft: false`.

The Actions runs API shows `test (typecheck + vitest)` and `clip frame browser gate` both passed on this head. I read that API because this host's PAT can't read `statusCheckRollup`.

**Advisory appellate pass (does not block the un-draft)**

I did this review in the job session rather than starting a separate `claude -p`. I read the source, workflow and deploy diffs plus the panel's last review, but not the test diffs, and I ran nothing. I found no defects that need fixing before merge.

Two items the panel did not raise:
1. **Orphaned pending invitations:** a pass that fails after the mint leaves a pending record in the router's `invitations` map. Only accepted records are cleared when a contact is forgotten, and I saw no expiry in the router. These records last until restart and only build up on failed passes, but the PR's "Growth that stays" section lists only accepted records. A one-line addition there would cover it.
2. **Partial cleanup:** `reset("cleanup")` stops at its first failed call, so an error on the inviter's forget also skips the acceptor's cleanup. The next pass resets first, so this resolves itself. It does make the panel's point about silent cleanup failures slightly stronger.

Panel items worth keeping, neither promoted to a fix:
- **`attachCoupon: false` comment:** it overstates what happens today, because nothing on this base reads the field until #199 lands.
- **Missing JSDoc:** the new helpers in `prod-objectives.mjs` have no JSDoc. The typist seat rated this should-fix, but it doesn't change behavior.

**After merge:** the probe fails at `step reset` and opens the tracking issue until the deploy carrying these routes lands. `DEPLOYMENT.md` documents this, so expect it rather than treat it as a regression.

No files changed in the garden repo, and I posted no PR comments.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr234-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (432691 cached reads)
- Output: 5692 tokens
- Cost: $0.6924982
- Wall-clock: 157s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
