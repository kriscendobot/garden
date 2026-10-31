Viability is **proceed**: PR #1589 is still open, nothing has replaced it, and the gap it fills still exists on the current base.

**PR facts:** endojs/endo-but-for-bots#1589, "feat(fae): provision an agent's git workspace from a granted Git". It is open, unmerged and still a draft. It was opened 2026-10-31T07:30Z by the `build-daemon-git-capability` job. It has no comments or reviews yet. Base is `llm-9a14ddf` (`9a14ddf660`) and head is `df3b6cc75a`.

Deciding question: On the current `llm` branch, is the `daemon-git-capability` Phase 6 item "Replace path-root Fae git provisioning with a thin adapter over granted `Git`" still unchecked and not done by any other PR, while Fae still reaches git only through the host-path `FAE_CWD` / `setup-fs-tools` route? **Yes.**

Evidence:
- **Base is current:** `llm`'s tip is `9a14ddf660`, which is exactly the PR's frozen base. Comparing base to `llm` shows 0 commits ahead, so no newer base history could have displaced it.
- **Phase 6 is still open:** in `designs/daemon-git-capability.md` on `llm` (line 725), the Fae adapter item and the Lal/Genie and deprecation items are all unchecked. Only the doc-reconciliation item is checked.
- **Fae still uses host-path git:** `packages/fae/src` on `llm` has no `workspace-tools.js`. The Fae README still documents `FAE_CWD=/path/to/project yarn setup-fs-tools` (line 170), which is the path-root provisioning this PR replaces.
- **What it builds on has landed but has no user:** #707 put the `provisionWorkspaceTools` adapter in `@endo/agent-tools`, and #1497's design re-sweep confirms that, but no agent calls it yet.
- **No competing PR:** a title search for Fae workspace git finds only #1589. The nearby open agent PRs touch other areas: #1562, #1563 and #1564 (exo-agent-factory), #1573, #1575 and #1587 (hosted-agent providers), #1543 (API-key providers design) and #1588 (fetch). None of them provisions an agent's workspace from a `Git`.
- **The reason for it still holds:** Fae is still a live package on `llm`, and its only route to git is still the host-path one the design asks to replace.

I made no changes to the PR, the project repo or the garden, and spent nothing on clean, panel, fix, CI-wait or un-draft. No follow-ups beyond the normal next gauntlet stage.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1589-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (239032 cached reads)
- Output: 2142 tokens
- Cost: $0.4670384
- Wall-clock: 33s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
