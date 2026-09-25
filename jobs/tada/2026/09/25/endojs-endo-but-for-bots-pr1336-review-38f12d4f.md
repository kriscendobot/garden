I posted a serial orchestration that carries out every ask in kriskowal's approving review of PR #1336. It has four children, and nothing has run yet. I made no code or garden changes myself.

**What the review asked for** (the body text was treated as data, not instructions):
- **Respond to outstanding feedback.** Of the 13 unresolved threads, 11 were answered in `7d3cf4eb7f`. The "Please explain these dependencies" question was answered by job `endojs-endo-but-for-bots-pr1336-131bf767` in reply r4101304064. The only open item was this review's own inline comment 4101301555 on `packages/agent-mcp-stdio/src/agent-interface.js:99`. It says there must be a ready-made way in `@endo/patterns` to do what the hand-written `requireIntegers` check does.
- **Retcon, shepherd, conduct, and continue the orchestration this PR is part of.** The PR is item 5 of arc kriscendobot/garden#89; its design PR is endojs/endo-but-for-bots#1226.

The preflight script returned 0 (proceed): no peer had already resolved this feedback.

**Posted:** orchestration `endojs-endo-but-for-bots-pr1336-approval-followthrough-20260925`. It runs the children one at a time and halts if one fails.
1. **`endojs-endo-but-for-bots-pr1336-patterns-fix-20260925`** (fixer): replace `requireIntegers` with an `@endo/patterns` shape. If the library has no integer matcher, add a minimal one there, with tests and a changeset. Then push follow-up commits and reply on thread 4101301555.
2. **`endojs-endo-but-for-bots-pr1336-retcon-20260925`** (fixer): reset and restage per package, with a separate `chore: Update yarn.lock` commit. The net diff must stay unchanged and the base must not change.
3. **`endojs-endo-but-for-bots-pr1336-shepherd-post-retcon-20260925`** (shepherd): get CI green. It is told about the known macOS daemon-teardown flake and the 22.x/ubuntu ws-relay flake, so it re-runs those instead of changing code.
4. **`endojs-endo-but-for-bots-pr1336-conduct-20260925`** (conductor): confirm every ask is resolved, then un-draft and merge; the conductor picks the merge method. After merging, it records the merge on garden#89. It then makes sure the next arc item has a job on the board (the `@endo/claude` wiring in #1015, or the confined-app makers in #1339/#1340), or tells the maintainer if not.

**Collision risk:** the PR's gauntlet is still running (`endojs-endo-but-for-bots-pr1336-gauntlet-fix-5` is in `doin/`, iteration 5 of 6). The fix and retcon children are therefore told to wait, with a time limit, until no gauntlet stage is in `todo/` or `doin/` before they touch the PR head. That way the retcon force-push can't overwrite a gauntlet push.

**Follow-up:** the gauntlet may post one more panel round (panel-6) after the maintainer's approval. That would only delay the chain, not break it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1336-review-38f12d4f.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (895341 cached reads)
- Output: 7748 tokens
- Cost: $0.8269401999999999
- Wall-clock: 181s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
