**Gauntlet viability: endojs/endo-but-for-bots PR #1536** ("chore(lint): reject explicit any, with a shrink-only baseline")

The PR is open, unmerged and still a draft. It was opened today at 2026-10-22T13:44Z. Its head is `no-explicit-any-ratchet` @ `6b4326a`, on the frozen base `llm-54d3d2a`.

Deciding question: Is there still nothing in the base branch, or in another PR, that enforces no-explicit-`any`, while the maintainer's request for a systematic no-`any` setup still stands?

Evidence:
- **Why the PR exists:** kriskowal's review comment on #1393 (discussion_r4345304671) says: "Unacceptable to fall back to `any`. This is a rule in general. Please post a job to systematically set up no-any in our type checking." #1393 is still open. The PR body names the job that produced it: `endojs-endo-but-for-bots-no-any-typecheck`.
- **The base still allows `any`:** `packages/eslint-plugin/src/configs/shared.js` still sets `'jsdoc/reject-any-type': 'off'` (line 413) on both `llm-54d3d2a` and the current `llm` tip. The compare `llm-54d3d2a...llm` shows the base has not moved (ahead_by 0), so no newer base commit added the rule.
- **No competing PR:** a title search for "any" across all PRs, open and closed, finds only #1536. Nothing newer replaces it.
- **No discussion yet:** there are no reviews or comments on #1536.

The gauntlet may begin. I spent no clean, panel, fix, CI-wait or un-draft budget.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1536-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (156608 cached reads)
- Output: 1277 tokens
- Cost: $0.3562216
- Wall-clock: 32s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
