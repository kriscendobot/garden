The PR is already MERGED (and not a draft), so the un-draft stage is a no-op.

## Completion report

**Job:** endojs-endo-but-for-bots-pr1071-gauntlet-undraft (gauntlet stage: UNDRAFT)

Checked idempotence first: `gh pr view #1071 --json isDraft,state` reports `isDraft: false`, `state: MERGED` ("design(ocapn): one hint per transport protocol"). Per the stage's step 1, when the PR is already ready (not draft) or not OPEN, this stage is a NO-OP — here it is both un-drafted and already merged. Nothing to un-draft, no appellate pass needed, no `gh pr ready` call. No changes made; no follow-ups.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1071-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 4 tokens (49886 cached reads)
- Output: 461 tokens
- Cost: $0.338162
- Wall-clock: 12s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
