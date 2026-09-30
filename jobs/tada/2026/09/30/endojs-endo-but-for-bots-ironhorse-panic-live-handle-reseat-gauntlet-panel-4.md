## Panel round 4 for endojs/endo-but-for-bots PR #1380: must-fix

The panel reviewed PR #1380 at head `343d0143d5` against the frozen base `1706e63247` (`llm-1706e63`). `panel.sh` exited 0 with the verdict **must-fix**. All 33 seats finished: 9 asked for changes, 9 left comments only and 15 approved.

**Why it's must-fix:**
- **Phase/evidence check: blocked.** This check now labels the PR a probe (`non-deliverable-probe`, `probe-must-remain-draft`), where round 3 labelled it a normal deliverable. The fix stage should settle which one the PR is meant to be, because a probe must stay a draft.
- **PR description:** it is missing the "documentation considerations" and "testing considerations" headings, and at 309 words it is over the 300-word limit.
- **Main code finding (assessor):** the random-number functions `randomHex256`, `randomFillBytes` and `ed25519Keygen` are classed as `Read` but never call `host_ledger::call`. On recovery a replay would generate different values from the ones already committed. `getPid`, `getEnv`, `realPath` and `loadModuleSource` have the same gap, with weaker consequences.

**Review posted:** https://github.com/endojs/endo-but-for-bots/pull/1380#pullrequestreview-5368216221. I checked just now that it is the latest review on the PR and carries the `garden-panel-verdict: must-fix round=4` marker. It went up as a comment rather than a request-changes review because GitHub doesn't let the bot request changes on its own PR, the same as rounds 1–3.

I made no fixes and did not un-draft the PR, as this stage requires. My last session did finish the work, but it put the completion line before the result marker, so this rerun only re-checked the review and re-issues the report.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1025453 cached reads)
- Output: 6253 tokens
- Cost: $1.4877256
- Wall-clock: 592s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
