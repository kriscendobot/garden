**Viability report: endojs/endo-but-for-bots PR #1561**

PR #1561 is open, still a draft, and was created on 2026-10-26 at 02:33Z, two minutes before this check. It is titled "feat(exo-agent-factory): wire the child-agent coordinator to the daemon". Head is `build/exo-agent-factory-daemon-wiring` @ `a6d6066c`, and its base is the pinned branch `build/exo-agent-factory-core-8c4a87e`.

Deciding question: Is the daemon side of the child-agent factory (step 3 of `designs/endo-child-agent-factory.md`) still unbuilt on `llm`, with its parent stack (design #1558 → core #1560) still alive, so that this PR is still the work that design needs?

Evidence:
- **Nothing has replaced it.** `packages/exo-agent-factory` is not on `llm`. The packages on `llm` with "agent" in the name (`agent-mcp-stdio`, `agent-tools`, `agentry`, `hosted-agent`) do not implement this coordinator. A search of all PRs for "exo-agent-factory" returns only this stack (#1558, #1560, #1561) as owning this work.
- **Its parent stack is alive and open.** The design PR #1558 is open, and core slice #1560 is open as a draft; both are from today. #1561 builds on #1560 and does not re-implement the coordinator.
- **The reason for it still holds.** The design's implementation plan names daemon wiring as step 3, and the maker adapters in step 4 are to be written against the descriptor shape this PR introduces. There are no maintainer reviews or comments rejecting the design. The only reviews on #1558 are the bot's own panel findings ("request-changes" / "comment-only"), and they ask for revisions rather than dropping the direction.
- #1561 has no comments or reviews yet.

One caveat: #1561 sits on top of an unmerged design (#1558) whose panel has open must-fix findings. Revisions to #1558 or #1560 may force a rework or re-pin of this PR. That is something to sequence, not grounds to stop the gauntlet.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1561-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (181345 cached reads)
- Output: 1409 tokens
- Cost: $0.44224100000000005
- Wall-clock: 27s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
