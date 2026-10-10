Viability is **proceed**. PR #1403 is open and unmerged. Nothing newer has replaced it, and the design that asked for it still asks for it.

**Deciding question:** Does the current `llm` branch still lack a provider-neutral `@endo/inference` package, while its merged design still makes that package phase 1?

**Answer: yes.** The PR has not been superseded, and the reason it was opened still holds.

**Evidence:**
- **PR facts:** #1403 is open, a draft and unmerged. Its title is "feat(inference): add the provider-neutral @endo/inference seam". It is based on the pinned branch `llm-80054c3`, and its head is `7cc7cc3fe7`.
  - CI is green.
  - The earlier gauntlet ran six panel rounds and stopped with the status `review-budget-reached`. It was not stopped because something replaced the PR.
  - Every comment and review on it is from the bot. No maintainer has asked for it to be closed or redirected.
- **No newer implementation on `llm`:** `packages/inference` does not exist on `llm` (the lookup returns 404).
  - Since the PR's base, `llm` has moved 200 commits ahead. In that range, only `packages/claude` changed: the MCP adapter, the confined stdio MCP server, and a subscription-token fix. Nothing there is a seam package, and `@endo/claude` on `llm` does not depend on `@endo/inference`.
- **The design still calls for it:** `designs/endo-claude-inference-backends.md` on `llm` (merged as #1357, revised through panel round 6 on 2026-10-01) still says "The seam is a provider-neutral `@endo/inference`". It lists that seam as implementation step 1, and Decision 1 says "`@endo/inference` owns the seam".
- **Other open PRs depend on it rather than replacing it:**
  - #1369 is the gap-revealing prototype. #1403 deliberately follows the merged design instead of the prototype.
  - #1412 (phase 2, the `@endo/claude` CLI and Agent SDK backends) is stacked on #1403 and refers to it.
  - #1102 was narrowed and closed. The PR body records that this phase does not depend on it.

I spent nothing on clean, panel, fix, CI-wait or un-draft work, and made no garden or project changes.

**Follow-up:** #1369 now overlaps #1403 and #1412. Once #1403 lands, it is a candidate to close.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1403-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (181935 cached reads)
- Output: 2239 tokens
- Cost: $0.48055899999999996
- Wall-clock: 42s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
