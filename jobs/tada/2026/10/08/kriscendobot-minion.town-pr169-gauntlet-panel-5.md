PR #169 (kriscendobot/minion.town, head `6a12eb1` against base `d750b09`) fails panel round 5 with **must-fix**. I posted the verdict on the PR, but as a COMMENTED review, because GitHub won't let the bot request changes on its own PR. Rounds 3 and 4 were posted the same way.

**What I ran**
- Made an isolated checkout of `kriscendobot/minion.town@fix/deploy-secret-preflight`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 GARDEN_YARN=npm panel.sh <wt> 169 d750b09b30e9…` detached and waited for it in the foreground. All 34 seats returned. It ended with `panel #169: code-panel single-round — must-fix`, which is printed just before `exit 0`, so this is a real verdict and not an infrastructure error.
- Seat verdicts: 2 request-changes, 12 comment-only, 20 approve.

**Round-4 items:** the round-4 must-fix items (retitle, trim the body) and its should-fix items (`guest_recovery_key_*` naming, inline the fetch seam, `→`) are all fixed at this head.

**Still blocking (must-fix)**
- **decomplector** (pointed at the shared helpers because the same mechanism drew must-fix findings in earlier rounds): remove `lib/guest-recovery-helpers.sh`, the `$GUEST_RECOVERY_HELPERS` loader and the `eval`. Replace them with one inline grep check in the `deploy-app.sh` heredoc, written like the existing `ACCOUNT_GATE_SHARED_SECRET` check near line 420. This also gets rid of the key pattern written out twice, which five seats flagged.
- **migrator**: the preflight now makes a valid `GUEST_RECOVERY_KEY` mandatory for every CD deploy, but the app only needs it when it uses the DynamoDB account store. Either run the preflight only in that case, or document it as an unconditional CD prerequisite with a one-time rollout step.

**Non-blocking (should-fix)**
- The test's `sudo` stub doesn't check which file path it serves (breaker).
- The comment in `minion-mcp.service` still calls `account.env` optional.
- Confirm the live key matches the new character class before tightening the writer.
- The writer-side check has no test.
- The commits that added and then removed the CD writer should be regrouped into one or two commits, since this repo lands merge commits.
- Inserting step `4a` relabeled six existing step comments; number the new step so the old labels stay.

**Posted review size:** the full aggregate was 84,743 characters, more than GitHub allows in a review. The posted version has a summary header, all 22 non-approve seat sections, and lists 12 approving seats as "omitted for length". It includes the `<!-- garden-panel: … round=5 disposition=must-fix -->` marker.

**Follow-up:** the gauntlet driver should post the fix-loop stage next. I made no garden changes and did no fixing or un-drafting.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr169-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (844188 cached reads)
- Output: 6255 tokens
- Cost: $0.8066256
- Wall-clock: 289s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
