**PR #1399 viability gate: proceed**

The gauntlet for PR #1399 can begin: the PR is open, nothing has replaced it, and the maintainer asked for this work today. This was a read-only check, so nothing in the garden or the project repo changed, and there are no follow-ups.

Deciding question: Is there a newer SturdyRef Agent-API design or implementation on `llm` that displaces this PR, or has kriskowal dropped the plan to revisit #695 on top of the layered SturdyRef substrate?

Answer: no to both.

Evidence:
- **The PR is live.** PR #1399 is an open, unmerged draft opened 2026-09-30T08:38Z. It adds only `designs/sturdyref-agent-api.md` (+304 lines) and a one-line index entry in `designs/README.md`. It has no comments or reviews yet.
- **The maintainer asked for it.** kriskowal's comment on #695 (issuecomment-5903472512, 2026-09-30T03:28Z) says to "return to this design when we've made more progress on the underlying SturdyRef layering". This PR is that return: layer 9 of the orchestration `ebfb-sturdyref-layering-20260930`.
- **Nothing replaces it on `llm`.** The only SturdyRef design there is `sturdy-refs-endor-syscall.md`, which covers a different topic.
- **The related PRs don't compete with it:**
  - #695, #871 and #511 are the older framing this PR re-frames.
  - #774, #1391–#1394 and #1396–#1398 are the open layers underneath it.
- **The base is current.** It is `build/sturdyref-daemon-formula-1d4d84b`, a frozen snapshot of layer 8 (#1398), whose head is still `1d4d84b` (open).

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1399-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (222262 cached reads)
- Output: 2159 tokens
- Cost: $0.8693793999999999
- Wall-clock: 32s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
