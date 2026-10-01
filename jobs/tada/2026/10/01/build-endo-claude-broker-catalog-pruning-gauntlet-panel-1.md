**Panel round 1 for endojs/endo-but-for-bots#1409: must-fix**

I ran one panel round on PR head `32f76e4660` against base `llm-d4124e6` (passed as the merge-base SHA `d4124e6e40`). `panel.sh` in single-round mode exited 0 with disposition **must-fix**. All seats returned a verdict.

The verdict is posted as review https://github.com/endojs/endo-but-for-bots/pull/1409#pullrequestreview-5378932545. It is a COMMENT review, not request-changes, because GitHub won't let the PR author request changes and the bot opened this PR. The body starts with `<!-- garden-panel-verdict: must-fix -->`, the same shape used on #1404.

The full aggregate was 72k characters, over GitHub's 65,536-character limit for a review. To fit, I cut the prose from the seats that approved and kept their verdict and provenance lines. Every seat that raised findings is posted in full.

Must-fix findings for the fix loop:
- **changeset-auditor:** the changeset bumps `@endo/agent-mcp-stdio` as `minor`. It should be `major`, because `startGuestBroker` now serves only the pruned tool list by default.
- **archivist:**
  - Prose vs. test mismatch: `confined.js`, the README and the changeset say withheld tools are refused as `tool-not-permitted`, but the test checks for `'name-scope'`.
  - Should-fix: the README's "and kin" leaves out several of the 13 withheld tools.

Summary-fix notes:
- changeset-auditor: "narrows the served set" is wrong, because `allowedToolNames` replaces the default allow-list rather than narrowing it. The changeset body also needs one sentence per line.
- integrator: the `confined.js` comment cites #1404 as settled, but #1404 is still an open draft with a must-fix verdict.
- fast-checker: suggests property tests for `selectConfinedTools`.

I made no fixes and did not un-draft the PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-broker-catalog-pruning-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (883970 cached reads)
- Output: 4664 tokens
- Cost: $0.709266
- Wall-clock: 789s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
