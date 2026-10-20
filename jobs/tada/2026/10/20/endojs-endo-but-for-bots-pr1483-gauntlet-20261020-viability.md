**PR #1483 viability report**

PR: https://github.com/endojs/endo-but-for-bots/pull/1483, "feat(ocapn-noise,daemon): negotiate heartbeats by capability bit and default them on". It is open, still a draft, and not merged. The head is `362dd9e`. The base is the frozen #1482 head, `build/ocapn-noise-session-reconnect-crossed-hellos-acbaf00`; it was restacked there on 2026-10-20.

Deciding question: Does the #1476 → #1478 → #1481 → #1482 → #1483 stack, which this PR finishes with Upgrade Considerations, still have no newer implementation replacing it, while `llm` still lacks heartbeat capability negotiation and default-on heartbeats in `@endo/ocapn-noise` and the daemon?

Evidence:
- **Newest design still builds on this stack.** Design PR #1512 (opened 2026-10-20T01:32Z) "firms up the Proposed design against the open stack: #1476 → #1478 → #1481 → #1482 → #1483". It says the wire format is the one "#1481 and #1483 already define". Its slice B4 (turn reconnect on in the daemon) builds on this PR. So the latest design work depends on #1483 and does not replace it.
- **The other heartbeat PRs don't cover this work.**
  - #1502, #1508 and #1511 are Phase 1/2 builds in the `@endo/ocapn` client layer. #1508's heartbeat is off by default.
  - None of them adds capability-bit negotiation in `op:session-hello`, default-on heartbeats in ocapn-noise, or daemon wiring.
  - Whether those parallel Phase 1/2 builds are redundant with #1476/#1478 is a question for those PRs. It doesn't decide this one.
- **The need is still there.** `packages/ocapn-noise/src/network.js` on `llm` has no `heartbeat` or `FEATURE` references, and the whole stack is unmerged. The goal (spot a dead daemon peer within `SESSION_TIMEOUT` instead of waiting for TCP to give up) comes from design #252 and is still open.
- **No maintainer comment points the other way.** Every comment and review is from the bot. The round-1 panel passed with no must-fix items, and the previous gauntlet ended held-draft. No one has asked to close or redirect it.
- **Caveat:** the PR can't land until its unmerged ancestors (#1476–#1482) do, and Phase 4 (Resume) is still deferred on C1. Neither changes whether this PR is still needed.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1483-gauntlet-20261020-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (217979 cached reads)
- Output: 2640 tokens
- Cost: $0.4681238
- Wall-clock: 54s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
