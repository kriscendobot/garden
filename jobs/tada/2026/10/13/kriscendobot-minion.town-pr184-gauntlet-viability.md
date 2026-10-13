## Viability report: kriscendobot/minion.town PR #184, "fix(probe): add deterministic dispatch backstop"

**Viability: proceed.** I spent nothing on clean, panel, fix, CI-wait or un-draft.

**PR facts:**
- State OPEN, not merged, draft.
- Head is `fix/prod-probe-dispatch-backstop` @ `935b6d6d`.
- Base is `main-bc11010` @ `bc110102`.
- Opened 2026-10-13T00:13Z by the job `build-minion-town-prod-probe-dispatch-backstop`.
- No comments or reviews yet.

**Deciding question:** Is GitHub's schedule still the only thing that triggers the production probe on `main`, and is it still skipping cron slots, so that a backstop outside GitHub Actions is still needed and nothing else has supplied one?

**Answer: yes.**

**Evidence:**
- **Base is current.** `main` is 0 commits ahead of the PR's frozen base `bc110102`, so no newer base history could have displaced this PR.
- **No backstop on `main`.** `deploy/aws/ci-runner/host/` on `main` contains only `bootstrap.sh`, `ci-runner-controller.sh` and `ci-runner.service`, with no backstop service or timer. `.github/workflows/prod-probe.yml` on `main` is still triggered only by the `17 */3 * * *` cron, manual dispatch, and the post-deploy `workflow_run`. It has no strict dispatch input.
- **The motivating problem is still happening.** The most recent schedule-triggered probe runs on `main` were at 2026-10-12 15:25Z and then 2026-10-13 00:39Z. That is a gap of about 9h15m against a 3-hour cron, so roughly two slots were dropped. The 15:25 run is also about 68 minutes late for its :17 slot. This matches the PR's stated reason ("GitHub skipped multiple three-hour cron slots and delayed others").
- **No competing PR.** The other probe PRs are #182 (merged; runner opt-in and reporting), #166 (merged; the original probe) and #171 (open; validating the pinned Claude harness). None of them add a dispatch backstop or a clock outside GitHub, so #184 is not superseded.

Changes: none. I made no garden edits and pushed nothing.

Follow-ups: none from this stage. The gauntlet may move on to clean.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr184-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (152357 cached reads)
- Output: 1653 tokens
- Cost: $0.3589074
- Wall-clock: 138s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
