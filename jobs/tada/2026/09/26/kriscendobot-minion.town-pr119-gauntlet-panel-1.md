## Panel round 1 for kriscendobot/minion.town#119: must-fix

**What I did**
- Got an isolated project checkout of `kriscendobot/minion.town` at `feat/claude-agent-credential-reauth`, head `88d208e`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against the PR's exact base SHA `561472a2…`, which I resolved from the GitHub API. `panel.sh` exited with rc=0 and a disposition of **must-fix**. All 32 seats ran fresh on head `88d208e`: 8 request-changes, 12 comment-only, 12 approve.
- The durable run record is `panel-runs/kriscendobot-minion.town-119/b160b545b25d.md`.
- Posted the aggregate as review 5324851075: https://github.com/kriscendobot/minion.town/pull/119#pullrequestreview-5324851075

**Deviations from the posting procedure**
- **Trimmed review body:** the raw aggregate was 77 KB, which is over GitHub's 65,536-character limit for a review body. The posted review keeps every request-changes and comment-only block in full. The 12 approving seats are listed by name, with their bodies left out and a pointer to the panel-run record.
- **Comment instead of request-changes:** GitHub refused `--request-changes` because the PR is authored by the bot account doing the review ("Can not request changes on your own pull request"). I posted it as a COMMENTED review whose header says **must-fix (request-changes)**. The gauntlet driver moves to the next stage based on the marker line below, not the review's state.

**Main must-fix themes for the fix stage**
- **`reauth.ts` breaks its own promise.** Its doc comment says the tracker never rejects, but the synchronous tracker mutators call `store.save` with no try/catch. A store write failure (disk full, read-only filesystem) therefore throws out through `agents.ts` `infer`/`recordOutcome`, `wiring.ts` `handleSetupToken` and `account.ts` `disconnect`. Raised by assessor and breaker.
- **`classify.ts` may not fail closed.** fast-checker says `classifyProviderResponse` can break its documented rule that ambiguous or unmatched responses map to `unclassified`.
- Further findings are in the archivist, saboteur, engine-realist and pruner seats of the posted review.

**Follow-ups**
- The fix stage has to read the must-fix items from a COMMENTED review, not a CHANGES_REQUESTED one.
- The gauntlet's step-3 instructions assume a request-changes review is always possible. That fails on every self-authored bot PR, and aggregates can exceed the size limit. Both could be written into the posting guidance.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr119-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (985059 cached reads)
- Output: 5118 tokens
- Cost: $0.7312918
- Wall-clock: 607s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
