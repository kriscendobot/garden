Viability report: endojs/endo-but-for-bots PR #1673, "feat(lal): configure iterative context compaction"

**Result: proceed.** The PR is open, unmerged and a draft. No landed change has superseded it, and the need behind it is still open on `llm`. I spent nothing on the clean, panel, fix, CI-wait or un-draft stages and changed nothing.

Deciding question: Has current `llm` already delivered configurable iterative compaction for Lal and its Fae/Floot agents, or replaced the `providers/context-compaction.js` code that #1673 extends? **No.**

Evidence:
- **PR state:** the PR was opened 2026-11-17T14:35Z by job `build-endopi-iterative-compaction`, with head `59a8b6a8`. It is based on the frozen branch `llm-0368767`. Live `llm` is still at that same commit (`0368767778a2`), so nothing has landed on the base since.
- **The code it extends is still live:** `packages/lal/providers/context-compaction.js` exists on `llm`. Its last changes were Fae/Floot compaction fixes between 2026-10-01 and 10-27 (latest `5f88cd7f3b`, 10-27). None of them add the reserve-token or recent-tail budgets, enable/disable switch, custom instructions or richer summaries that #1673 adds.
- **The motivating design is unmet:** the Status section of `designs/endopi-iterative-compaction.md` (milestone M9) on `llm` still describes only the old genie substrate. `packages/lal/compaction.js` does not exist on `llm`.
- **One competing PR, not landed:** #1644 ("compact the conversation with an iterative structured summary") is an earlier, separate implementation of the same design. It adds a new `packages/lal/compaction.js` and a `/compact` inbox path. It is still a draft, its gauntlet halted after one round with CI red, and its panel review requested changes, so it does not displace #1673. The two overlap, though: the maintainer will eventually need to choose one and close the other. #1673 is the one that builds on the compaction code already shipping on `llm`.
- **No discussion yet:** #1673 has no comments or reviews.

Follow-up: no job posted. The #1644 versus #1673 duplication is something the maintainer should settle.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1673-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (249421 cached reads)
- Output: 2257 tokens
- Cost: $0.4905361999999999
- Wall-clock: 47s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
