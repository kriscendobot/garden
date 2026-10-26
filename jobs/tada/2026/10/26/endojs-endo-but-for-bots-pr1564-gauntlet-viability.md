Viability decided: proceed. No competing implementation was found on llm, and the design stack is still open.

PR #1564 (`feat(exo-agent-factory): collapse republished replies`) is open, unmerged and a draft. I opened it 4 minutes before this check (head `92b5a1fa`). It is the step-6 slice of the stack #1558 (design) → #1560 (core) → #1563 (turn ledger) → #1564. Its base is the frozen `build/exo-agent-factory-turn-ledger-6eac641`.

Deciding question: Has anything on `llm` already added reader-side collapse of republished same-sender, same-`replyTo` replies to Fae and Lal (or replaced the child-agent-factory design), and is the step-6 replay-duplicate problem still unsolved?

Evidence:
- **Nothing has replaced it.** `packages/exo-agent-factory/` does not exist on `llm`, so the whole package lives only in this stack. A code search for the PR's filter, `collapseReplies`, also found nothing.
- **The readers don't collapse replays yet.** On `llm`, `packages/fae/agent.js` and `packages/lal/inbox-loop.js` have no dedup or reply-collapse logic. The one "collapse" match in `agent.js` is about handling cancel and disconnect events, not duplicate replies.
- **Recent commits don't overlap.** I read the post-2026-10-20 `llm` commit subjects for fae and lal (floot, hosted-agent, overload-retry work). `designs/floot-daemon-owned-turns.md` never mentions `replyTo`, collapse or duplicates.
- **The design stack is live.** #1558, #1560 and #1563 are all open. #1558 has only bot critic reviews (request-changes and comment-only), and nobody has rejected or closed it.
- **The base isn't stale.** `llm` has 0 commits that the frozen base lacks, so nothing newer has landed underneath it.
- **One thing to watch:** #1564 can't land before #1563, #1560 and #1558 merge, because it builds on them.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1564-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (295354 cached reads)
- Output: 2665 tokens
- Cost: $0.4905948
- Wall-clock: 46s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
