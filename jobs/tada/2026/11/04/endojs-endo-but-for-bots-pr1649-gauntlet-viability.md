**Viability report: endojs/endo-but-for-bots PR #1649** (feat(hosted-agent,lal,fae): add the pinned responder for API-key guest agents)

The PR can enter the gauntlet. I spent nothing on clean, panel, fix, CI-wait or un-draft.

**Deciding question:** Is #1649 still the only live implementation of phase 5 (the pinned responder) of the API-key agents design, on a design the maintainer still wants built?

**Answer:** Yes.

**Evidence:**
- **The PR is current.** #1649 is OPEN, a draft and MERGEABLE. It was opened today (2026-11-04T11:50Z).
- **Nothing replaces it.** No other PR, open or closed, mentions the responder or covers phase 5.
- **The design is wanted.** The design PR #1543 is still open. kriskowal approved it on 2026-11-04T00:29Z with "Please conduct the design and build the implementation".
- **The stack beneath it is in place.** #1649's base is `feature/api-key-agent-factory-a46a836`, at `a46a836e92`. That is exactly the current head of the phase 4 factory PR #1648, which is open. The phase 1 and 2 PRs (#1573, #1575) are also still open.

Nothing in the newer base history displaces it. It is a stacked slice under `orchestrate-build-api-key-agents-20261104`, so it should stay a draft until the PRs below it land.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1649-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (186372 cached reads)
- Output: 1359 tokens
- Cost: $0.4551024
- Wall-clock: 29s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
