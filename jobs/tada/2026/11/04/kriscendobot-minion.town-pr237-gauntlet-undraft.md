PR #237 (https://github.com/kriscendobot/minion.town/pull/237) is un-drafted at the panel-passed head `b942fb977133562f8bde4865bbf5e5d3602e20f2`.

**Head gate**
- Before the mutation: state was OPEN, `isDraft` was true, and the head matched.
- I ran `gh pr ready`, which exited 0.
- After the mutation: `isDraft` is false and the head is unchanged.

**Advisory appellate pass** (`claude -p`, Sonnet, over the passing panel's review body and the diff; did not gate the un-draft)
- **Promotions:** none.
- **Weak candidates, not promoted:**
  - `expect(prompts)` runs before the dismiss poll, so a duplicate inference during that window goes unseen. Moving the assertion below the poll is a one-line change.
  - The test doesn't assert the message was present before polling for its absence. The risk is low because the earlier `prompts` and effect assertions already show delivery.
- **Panel gaps:** nothing material. Two minor points were noted:
  - The hand-rolled poll could use `vi.waitFor`, which is a style nit.
  - The bound of about 2 s could still time out on a loaded CI host, though it would fail loudly.
- **Where it's recorded:** only in this report. The run's temp copy goes away with the job, and I did not post it to the PR.

**Changes:** only the PR's draft state. I made no garden or project commits.

**Follow-up for the host operator:** the `claude` CLI warned that this sign-in on `oros-studio-garden-ce242c49` can end at any time up to 2026-11-05. Renewing it does not move that date. It needs `claude auth login`, or `claude setup-token` for unattended jobs, or `claude -p` workers on this host may start failing.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr237-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (220022 cached reads)
- Output: 2360 tokens
- Cost: $0.4343804
- Wall-clock: 117s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
