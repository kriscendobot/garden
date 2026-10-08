Fixed PR #122 by pushing commit `ba97495`, removing stale Endo daemon socket inodes before restart to prevent the `ECONNREFUSED` readiness race.

Verification:
- `npm run typecheck`: passed.
- `npm test -- --run`: 479 passed, 7 skipped.
- GitHub Actions run https://github.com/kriscendobot/minion.town/actions/runs/37707976713: all three jobs passed on exact head `ba97495`.
- PR is mergeable with `CLEAN` status.

Follow-ups: none. No PR comment was posted because the job did not authorize comments.
Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr122-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 363s

<!-- garden-usage-end -->
