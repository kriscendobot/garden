**Viability report for endojs/endo-but-for-bots PR #1478**

The gauntlet may begin. This PR has not been overtaken.

**PR facts:** The PR is OPEN, a draft, and not merged. It was opened on 2026-10-16 at 18:56Z, a few minutes before this check. Its title is "feat(ocapn-noise): session outbound queue and stall fault injector (session-reconnect Phase 2)". It is stacked on the Phase 1 heartbeat PR #1476: its base branch `build/ocapn-noise-session-reconnect-heartbeat-9175a5b` is a frozen snapshot of #1476's head, and #1476 is itself OPEN and a draft against `llm-61cd656`. Its head is `2a16357e`.

Deciding question: Is `designs/ocapn-noise-session-reconnect.md` (design PR #252) still the plan in force on `llm`, with nothing else on the base or in another PR already providing its Phase 2 session outbound queue and stall injector?

Evidence:
- **The design is still current.** Design PR #252 is MERGED, and `designs/ocapn-noise-session-reconnect.md` is still on `llm`.
- **The base doesn't already do this.** `packages/ocapn-noise/src/network.js` on `llm` has no session-level outbound queue, no stall or loss handling, and no heartbeat. Its only queues are the inbound session queue and the dial-waiter queues. The last changes to `packages/ocapn-noise` on `llm` are dependency bumps (Oct 4 and 11) and fixes to settlement and shutdown (Oct 1). None of them overlaps this PR.
- **Nothing else does it either.** A search of all PRs, open and closed, for "ocapn-noise reconnect" and "session queue ocapn" found only this series: #1476 (Phase 1), #1478 (Phase 2) and #1475 (crypto review). There is no rival implementation, and the PR has no comments or reviews yet.
- **The reason for it still holds.** Phase 3 (reconnect with Rekey) needs a session queue that is not tied to one transport's cipher state, and this PR builds it. The successor job `endo-but-for-bots-ocapn-noise-session-reconnect-phases-3-5` owns Phases 3–5.

**Caveat:** This PR depends on #1476, which is still a draft. That ordering is how a stacked series works, so it doesn't make the PR non-viable. Merging should follow #1476.

I spent no clean, panel, fix, CI-wait or un-draft budget, and changed nothing in the garden or the project repo.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1478-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (155898 cached reads)
- Output: 1672 tokens
- Cost: $0.3829316
- Wall-clock: 40s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
