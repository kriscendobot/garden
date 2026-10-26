## Completion report: endojs/endo-but-for-bots#1558, UNDRAFT stage (gauntlet iteration 4)

PR #1558 ("design: capability-scoped durable child-agent factory", base `llm-d5ac419`) is now out of draft and ready for review. It is still on the head the panel passed, `8e670033771d50d42aa23d0c6c1f362db2e7a275`.

**What I did**
1. **Pre-check:** right before changing anything, I fetched the PR state. It was open, still a draft, and on the exact panel-passed head.
2. **Un-draft:** I ran `gh pr ready`.
3. **Post-check:** a fresh fetch shows it is no longer a draft and the head is unchanged.

**Advisory review (light `claude -p` pass; recorded only, it did not affect the un-draft):**
- **Revoking bound facets:** the design says the root can reclaim state by revoking `bind` results. But `revokeDerived` exists only on `BoundChildAgentFactory`, and the root has no list of its `bind` results, so a lost bound facet could strand durable state. The `name` argument to `attenuate(name, policy)` is also never defined.
- **Inconsistent README status:**
  - `endo-claude-inference-backends` is marked "Draft" in one place and "In Progress" in another.
  - The `endo-guest-stdio-mcp` estimate still says "In progress (#1336)".
  - Both the design and the README list #1343 as Open; whether it has merged should be checked.
- **Approval and estimate wording:** the README says "ready to build", while the design says it waits for maintainer approval of the restored scope. The design has no `## Open questions` section. It also says it adds no milestone time while adding an L-sized estimate row.
- **Endowment rules:** the name check doesn't say it rejects reserved names like `@self` or `@main`. Values that can't be stored durably aren't addressed, and stored endowments keep what they reference alive.
- **No limits:**
  - There is no size limit or compaction on the journal.
  - There is no cap on endowment count or size, and no turn-rate or spending limit.
  - Re-running `infer` after a crash can bill twice.
- **Unstated assumptions:**
  - The design doesn't say that only the root host can supply makers.
  - It doesn't say where the turn ledger is stored or who can write to it.
  - The duplicate-collapsing in the reader views could hide replies that are legitimately repeated.
- **Unchecked references:** the deleted `endo-claude-agents-capability` row may leave dangling references elsewhere, and two maintainer quotes are cited without links.

**Follow-ups:** none required. The findings above are advisory, for the maintainer's review of the now-ready PR.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1558-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (175447 cached reads)
- Output: 1769 tokens
- Cost: $0.4206774
- Wall-clock: 60s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
