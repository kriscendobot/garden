The panel round 2 is complete and the verdict is posted.

Panel round 2 for endojs/endo-but-for-bots PR #1084 ("docs: Design adaptive exo-stream pacing and buffer control", head `design/exo-stream-adaptive-pacing`, base `llm`) ran to a single-round disposition of **must-fix**.

What I did:
- Resolved the PR head (endojs/endo-but-for-bots @ `design/exo-stream-adaptive-pacing`, base `llm`) and got an isolated project worktree checked out at HEAD `ef55668e6`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh <wt> 1084 origin/llm`. The diff is docs-only (`designs/exo-stream-adaptive-pacing.md` +418, `designs/README.md` +9). The panel terminal line was `panel #1084: design-panel single-round — must-fix`.
- Assembled the round-1 aggregate (all seats — critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice — returned request-changes) into a verdict-headed body and posted it to the PR.

Verdict posting note: the bot (`kriscendobot`) authors this PR, so GitHub rejects a `--request-changes` review on one's own PR. I posted the aggregate as a **COMMENTED** review instead (confirmed submitted at 2026-08-29T05:12:35Z), with the `verdict: **must-fix**` header and full per-seat findings in the body so the disposition is unambiguous to the next stage and to the maintainer.

Recurring must-fix themes for the fixer: (1) the unconditional "hard memory bound" claim doesn't hold against producer-side `buffer`/pre-pull the consumer can't enforce (flagged by critic, skeptic, decomplector); (2) PR #832 / `ReadableBlob.lines()` framed as landed while still open/unmerged; (3) `fill` field required in the `CreditController` interface but never consumed by any transition rule; (4) `floor()` method name collides with "floor = min" prose; (5) `iterateBytesReader` sibling omitted from Compatibility; plus copyedit/pedant polish and a novice ask to explain CoDel basics.

No fix, un-draft, or loop performed — this stage stops here per the gauntlet contract.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1084-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 33 tokens (857390 cached reads)
- Output: 4950 tokens
- Cost: $1.0071029999999999
- Wall-clock: 423s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
