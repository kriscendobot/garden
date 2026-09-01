Completed and pushed `f449ba29da`.

| Journal snapshot (2026-07-28, 3,659 reports) | Result |
|---|---:|
| Completed jobs with numeric requeue history | 603 (16.5%) |
| Requeue events ending in those reports | 1,316 |
| Reclaimed on a different host | 325 / 603 (53.9%) |
| Certain total-loss lower bound | 325 / 3,659 (8.9%) |
| Actual resume vs fallback logs | Not recoverable: handler logs are host-local, not journaled |

The quoted 26/3,659 figure was a false measurement: completed reports contain worker prose, not the reaper’s machine marker. The “empty marker” values were prose/code-example extraction artifacts; the reaper always writes a numeric count.

The honest fallback framing and resume/fallback test were already landed in `3af218d5`. I made the focused test hermetic by pinning its intended legacy `gardener` worker kind, preventing an ambient cleric-kind environment from changing its provider/model assertions. `gardener-worktree-test.sh` passes 44/44.

Recommendation: add a host-affine requeue preference as the next cheap capability improvement; do not build transcript portability without maintainer sign-off.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/measure-requeue-exit-knowledge-loss.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 13 on 2 host(s) (4 unmetered)
- Input: 96 tokens (4732167 cached reads)
- Output: 42713 tokens
- Cost: $4.6140485 (4 engagement(s) unpriced)
- Wall-clock: 1628s
- Model(s): claude-opus-4-8 ×9

<!-- garden-usage-end -->
