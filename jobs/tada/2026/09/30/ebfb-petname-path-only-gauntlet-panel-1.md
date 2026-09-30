The panel round for endojs/endo-but-for-bots#1390 is done and the verdict is **must-fix**; I re-checked that the review is on the PR. The last session ended with the completion signal above the stage-result marker, so it wasn't recorded as done. Nothing else was outstanding.

- **Panel run:** `panel.sh` ran in single-round mode against head `09350117e6` and base `8e53cc0f89` (the PR's base commit), and exited 0 with `must-fix`. It reused a saved panel record (`6c9c5b61f8d0`) for this exact head and base. That record is the earlier round-2 run at 17:51Z, so the 20 findings are that run's and no reviewers were run again.
- **Review posted:** The verdict went up at 2026-09-30T17:57:06Z as a COMMENTED review. GitHub won't let the bot request changes on its own PR. The review is headed `**must-fix** (request-changes)` and ends with a `garden-panel-verdict: must-fix` marker.
- **Findings:**
  - **Stale docs and types:** outdated JSDoc and type annotations in `daemon/host.js`, `chat/add-space-modal.js` and `claude-sandbox-factory.js`.
  - **Bare pet-name strings still passed:** in `fae/src/tool-makers.js`, `jaine/agent.js` and `space-whylip/src/hooks/useConversation.js`.
  - **Changeset:** the `@endo/sandbox` and `@endo/agentry` bumps are marked minor, but the change is breaking.
  - **Should-fix:** the 35 commits record the sweep instead of logical changes, and the mount/platform-fs exclusion needs a stated reason and a follow-up.

Nothing was fixed or un-drafted; that is for the next gauntlet stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (471137 cached reads)
- Output: 4123 tokens
- Cost: $1.068184
- Wall-clock: 92s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
