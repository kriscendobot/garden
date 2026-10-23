Viability check for endojs/endo-but-for-bots PR #1543 (draft "design(agents): replace bare subscriptions with API-key providers"): the gauntlet may begin. I spent no clean, panel, fix, CI-wait or un-draft budget.

**PR facts:** The PR is open, unmerged and a draft. It was opened 2026-10-23 at 03:29Z, about 17 minutes before this check, by design job `design-claude-bare-retreat-api-key-agents-20261023`. Its head is `3749575e53`. Its base is the frozen branch `llm-d5ac419` at `d5ac41980a`. It changes only design docs: two new design documents plus a README index update, with no runtime code. There are no reviews yet. The bot's two comments say Prettier and the docs-only pre-push gates passed, and that the open questions are left for the maintainer.

Deciding question: Has anything landed on the base branch or been opened since this PR that either already plans the move off `--bare` subscription OAuth to API-key providers, or removes the premise that `--bare` cannot use subscription OAuth credentials?

Answer: No, so neither the "superseded" nor the "premise gone" claim holds.

Evidence:
- **Base is current.** The default branch `llm` is 0 commits ahead of the PR's base `d5ac41980a`, so no newer base history exists to supersede the PR.
- **No competing PR.** Searching all PRs for bare / api-key / inference provider turns up only earlier work the PR builds on: #1357 and #1403 (merged inference designs and interface), and #1369 and #1406 (open older inference/CLI items). None of them is an API-key replacement for `--bare`.
- **Referenced work still stands.** #1336, #1371 and #1412 are all merged. These are the Claude CLI wrapper, guest MCP server and CLI/SDK backends that the PR plans to retire, and nothing has removed them yet.
- **Premise holds.** The PR records a reproduction on Claude Code 2.1.296: `--bare` authenticates only through `ANTHROPIC_API_KEY` or `apiKeyHelper`, and an OAuth subscription token alone gives `Not logged in`. Nothing since has changed that.

Next step: the gauntlet can move on to the clean stage. The PR's two `Open questions` sections are still for the maintainer to decide during review.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1543-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (209230 cached reads)
- Output: 2028 tokens
- Cost: $0.39343000000000006
- Wall-clock: 65s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
