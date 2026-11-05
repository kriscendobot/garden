PANEL round 5 on [PR #249](https://github.com/kriscendobot/minion.town/pull/249) finished with a **must-fix** verdict, and the review is posted. I stopped there as the stage requires: no fixes, and the PR is still a draft.

- **Pinned commits:** base `7a0bcc903026382582afd97fcc3c2a18a0e85e05`, head `e90919d27e34ede8ea106a0b171adb3c0414a4c2` (branch `kriscendobot:fix/api-key-agent-panel3`). `git rev-parse HEAD` matched the head in the isolated checkout, and the PR head hadn't moved after the panel.
- **Style pre-pass:** exit 0, so the jurors ran. The only output was a non-blocking advisory from pruner on a 3-line comment at `deploy/aws/www/provider-ui.js:37`.
- **Panel:** `panel.sh` ran in single-round mode and exited 0. It also flagged a repeated must-fix on one mechanism and put the decomplector's "is it needed?" question to it.
- **Review:** [posted against the pinned head](https://github.com/kriscendobot/minion.town/pull/249#pullrequestreview-5780936703) as a comment review, because the PR is self-authored. It keeps the `Must-fix before merge` heading.

**Main finding in the review (locksmith, request-changes):** the key-replacement move gate fails open, while the read projection fails closed.
- **Defect:** `replacementMoves` in `src/auth/inference-provider-endpoint.ts` refuses only `creating` agents. A selected grant on a `deleting` or unknown-lifecycle agent can therefore be rebound to the new provider.
- **Fix it asks for:** refuse any selected grant or `attachment.agentId` claimed by a non-active record, matched by `agentId` or a reported `grantId`, and add replace tests for `deleting` and an unknown lifecycle.
- **Caveat:** locksmith couldn't confirm whether the factory revokes the grant during deletion, because `agent-factory.js` isn't in this checkout. If it does, this narrows to a stranded-grant defect.

I only read the first part of the posted review, so it may contain more findings; the fix stage should work from the full text.

**Follow-up:** the gauntlet driver routes this verdict to the next fix stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr249-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (392317 cached reads)
- Output: 3803 tokens
- Cost: $0.5326834
- Wall-clock: 1113s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
