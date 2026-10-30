---
handed-off: endojs-endo-but-for-bots-pr667-weave-20261030
deliverable-complete: false
---
I didn't open a new draft PR: the `endopi-stdio-rpc-bridge` design is already built in endojs/endo-but-for-bots#667, and a second PR would have been a duplicate. I posted a weave job to get #667 mergeable again instead.

**State of #667** (https://github.com/endojs/endo-but-for-bots/pull/667)
- It opened 2026-07-10 from the earlier job `build-endopi-stdio-jsonl-rpc-bridge`, which went through the gauntlet and got a passing panel verdict. It is **not a draft**.
- On 2026-07-13 kriskowal requested changes: "move these facilities into agentry or agent-tools". The code is now in `packages/agentry/src/rpc/` (`framing`, `protocol`, `bridge`, `session`, `serve`) with tests, plus a spawnable `packages/genie/rpc.js`. That review has not been re-approved, so it still shows CHANGES_REQUESTED.
- On 2026-07-29 kriskowal asked us to "rebase on current llm, resolve conflicts, and conduct". The rebase was done (head `4f9d899d`), but the merge step stalled: the 2026-07-30 approved-PR reconcile skipped #667 because it has no valid trusted approval.
- It conflicts with `llm` again (GitHub reports it as DIRTY).

**What I did**
- Posted job `endojs-endo-but-for-bots-pr667-weave-20261030`. It pins the merge base to the current `llm` tip, rebases and resolves conflicts, force-pushes, and moves the PR's base. It then posts a comment asking kriskowal to re-review. It must not merge without a fresh trusted approval.
- I made no changes to garden code or to the endo repo.

**Needs the maintainer:** kriskowal has to re-review and approve #667 before it can merge. The job asked for a new draft PR, but that would have duplicated #667.


## Manual gauntlet handoff

The completion guard found https://github.com/endojs/endo-but-for-bots/pull/667 ready without gauntlet coverage. A deduplicated review-docket decision was recorded; the PR was not re-drafted and no gauntlet was staged.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endopi-stdio-rpc-bridge.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (571864 cached reads)
- Output: 3812 tokens
- Cost: $0.6313248
- Wall-clock: 91s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
