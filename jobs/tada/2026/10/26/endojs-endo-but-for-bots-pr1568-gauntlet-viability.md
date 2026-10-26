**Viability report: endojs/endo-but-for-bots#1568** ("feat(exo-git): structured Git.show with a showText porcelain sibling")

The PR is open, still a draft, and not merged. I found nothing that replaces it, and the plan it implements is still current, so the gauntlet can start.

Deciding question: Does the live `llm` branch still have the text-only `Git.show(): Promise<string>`, and is there no other PR or landed change providing a structured `GitShow`, while the roadmap still calls for one?

Answer: yes, on all three counts.

Evidence:
- **PR state:** opened 2026-10-26T10:43Z. No reviews or comments yet.
- **Not yet on `llm`:** `packages/exo-git/src/types.ts` on `llm` still declares `show: (ref) => Promise<string>` and `stashShow: … => Promise<string>`. It has no `GitShow` or `showText`.
- **Still planned:** `designs/daemon-git-next-steps.md` on `llm` still lists Phase 6 ("Structured result shapes (`GitDiff`, `GitShow`, …), `*Text` porcelain siblings"). That is exactly what this PR delivers.
- **No competing PR:** a search for PRs about a structured `show` (any state) returns only #1568.
- **Its parent PR is intact:** #1568 sits on top of #1565 (the structured `diff` slice). #1565 is open and still a draft, and its head `3a61d1af…` is the commit #1568's frozen base `build-daemon-git-next-steps-structured-diff-3a61d1a` was cut from. The stack is consistent.
- **One thing to watch:** #1568 can't merge before #1565 does. When #1565 lands, this PR's base will need to be re-pinned and rebased (a weave).

No garden files changed. This gate spent no clean, panel, fix, or CI budget.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1568-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (180394 cached reads)
- Output: 1360 tokens
- Cost: $0.4311588
- Wall-clock: 25s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
