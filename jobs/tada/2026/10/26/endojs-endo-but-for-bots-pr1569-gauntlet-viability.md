PR #1569 can start the gauntlet: it is still needed and nothing newer replaces it. I only read evidence for this stage — no clean, panel, fix, CI-wait or un-draft budget was spent, and nothing was changed or posted.

**PR facts:**
- **Status:** open and still a draft, created 2026-10-26T12:41Z.
- **Branches:** head `build-daemon-git-next-steps-structured-merge` @ `f866574b`. Base `build-daemon-git-next-steps-structured-show-49531a3` @ `49531a35`, the frozen branch of #1568.
- **Activity:** no comments or reviews yet.

**Deciding question:** On current `llm`, does `Git.merge()` still return porcelain text, with the accepted design still listing a structured merge plus a `mergeText` sibling as open Phase 7 work, and with no other PR or landed commit providing it?

**Answer: yes.**

**Evidence:**
- **Code on `llm`:** in `packages/exo-git/src/interfaces.js`, `merge` is still declared as `.returns(M.string())`. There is no `mergeText` or `GitMergeResult` on `llm`.
- **Design on `llm`:** `designs/daemon-git-capability.md` says the design is "In Progress … Phase 7 structured shapes open". Its section on structured result shapes lists `merge` among the methods that still return text and are due to gain structured-shape siblings, with the text output kept under `*Text()` methods.
- **No competing work:** searching the repo's PRs for "mergeText" / "structured merge" finds only this PR and its own stack (#1565 diff → #1568 show → #1569 merge). All of them are open drafts from the same Phase 7 build series and complement each other.
- **Linked issue:** the PR body refs #691, the git-integration tracker.
- **Base PR:** #1568 is open (a draft based on #1565's frozen branch). So the stack premise holds; this PR just has to land after #1568.

**Follow-ups for later stages:**
- The gauntlet should keep #1565 → #1568 → #1569 in that order.
- The PR intentionally breaks callers of `Git.merge()` (major bumps for `@endo/exo-git` and `@endo/git`). Reviewers should check that.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1569-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (177868 cached reads)
- Output: 1558 tokens
- Cost: $0.4531896
- Wall-clock: 23s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
