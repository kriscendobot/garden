PR endojs/endo-but-for-bots#1645 ("fix(agentry): keep system messages in makePiAgent requests") is now ready for review; it was a draft before this stage.

**Gate check:** Just before un-drafting, the PR was open, still a draft, and its head was `031d4eb51cfc5af643df583238f17610c5ba4c1d`, the exact commit the panel passed. I then ran `gh pr ready`. A second fetch afterwards shows `isDraft: false` and the same head commit.

**Advisory appellate pass:** I ran a light Sonnet review of the diff. It was advisory only and did not gate the un-draft. Points the panel may not have covered, for the maintainer to consider:
- **`convertToLlm` default:** When the caller doesn't supply `convertToLlm`, it is now passed as an explicit `undefined`. That could override pi-agent-core's built-in default. Adding it only when present, the way `getApiKey` already is, would rule this out.
- **Other filters:** It's worth searching the repo for other `convertToLlm` overrides or role-based message filters that would still drop system messages.
- **pi version:** The fix relies on pi ≥0.86 behaviour, but `package.json` and the lockfile weren't touched, so the dependency range isn't confirmed.
- **Saved transcripts:** No test covers loading a saved transcript back in. That could duplicate the system message or keep an outdated one.
- **Tests:** They read pi's internal `system.toolsAdded` field, which a pi upgrade could break. The fake-provider HTTP test has some fragility: a third request would throw inside the server handler, and teardown doesn't wait for open sockets to close.
- **Lint and types:** Unused JSDoc typedef imports and the many `any` casts should get lint and `tsc` runs.

No follow-up jobs were posted.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1645-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (177170 cached reads)
- Output: 1359 tokens
- Cost: $0.434174
- Wall-clock: 45s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
