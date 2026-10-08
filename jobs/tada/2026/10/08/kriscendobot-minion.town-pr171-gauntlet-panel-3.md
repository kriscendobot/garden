Round 3 of the panel on kriscendobot/minion.town PR #171 finished with verdict **must-fix**, and the review is posted on the PR.

**What ran**
- Got an isolated checkout of `kriscendobot/minion.town` `feat/claude-arc-prod-validation` at head `4aec293`.
- Ran `panel.sh` in single-round mode against the PR's base commit `55299f0`. It exited 0 with disposition `must-fix`, and all 34 seats returned: 6 request changes, 18 comment only, 10 approve.
- Posted the result as a review on PR #171 (07:31:53Z). It went up as a plain comment: GitHub does not let the bot request changes on its own PR, which is also how rounds 1 and 2 were posted. The heading reads "Garden panel — round 3 (single-round) — disposition: must-fix".
- The review has a hand-written summary and the full write-ups for the request-changes seats and the first comment-only seats. To stay under GitHub's size limit, 15 seat write-ups were cut; the review lists them by name.
- The gh wrapper blocked the first post because of bare `#167`/`#166` references. Both are minion.town PRs, so I posted with `GARDEN_ALLOW_BARE_ISSUE_REF=1`.

**Round 2's items are fixed:** the strict-run test now runs `runCheck`/`runProbe` end to end, the PR body's evidence and verification sections are current, and a completion-summary comment follows the latest push. No seat found a correctness bug in the control flow.

**Still blocking**
1. **Title:** it claims more than the PR checks. Only the pinned-harness check runs in production; the confinement check stays deferred until #167 lands (integrator).
2. **Workflow churn:** the decomplector asks to stop hardening `prod-probe.yml`. The probe is read-only only because of the program it sends, not because of what its AWS role allows. The fix is either a probe-only role limited to a fixed SSM document, or recording that as accepted risk with a tracking issue.
3. **`deferred` never expires and counts as an overall pass:** once #167 merges, the confinement check can stay green forever, and the "close the tracking issue on a green run" step fires anyway (seven seats). The options are to drop the check until #167 is decided, or to give `deferred` an expiry.
4. **Concision:** three cuts to the PR body and `DEPLOYMENT.md` (pruner).

**Main non-blocking items**
- `DISABLE_UPDATES` is read from the Node service, not from the `claude` child, whose environment drops it.
- A different `ENDO_CLAUDE_BINARY` could run in place of the hashed one.
- The third-party actions that receive the AWS credentials are on movable tags and should be pinned to commit SHAs.
- The release-manifest validator duplicates the existing one.
- The SSM wait gives up before the on-box program can finish.
- Some test gaps remain.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr171-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1206551 cached reads)
- Output: 8126 tokens
- Cost: $1.0020062
- Wall-clock: 308s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
