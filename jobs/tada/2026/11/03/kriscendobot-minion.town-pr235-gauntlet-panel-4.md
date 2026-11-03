Panel round 4 for kriscendobot/minion.town PR #235 ended **must-fix**, and the review is posted. The PR is self-authored, so it went up as a comment review that keeps the `Must-fix before merge` heading: https://github.com/kriscendobot/minion.town/pull/235#pullrequestreview-5761109433

- **Pinned pair:** base `3f6c2b24a9855e98a339cb242f05efc7339b9e0d`, head `db1d918241554be304928536d93df5984f780be8`, on branch `garden/build-minion-town-mcp-resources-primer`. I checked out the head detached in an isolated project worktree, and `rev-parse HEAD` matched before and after the probes. The PR head had not moved when I confirmed the review.
- **Style pre-pass:** `pre-push-gates.sh --no-auto-fix --probes-only` exited 0. It raised one non-blocking advisory, from the pruner on comment concision: a 9-line prose comment at `src/resources.ts:1`.
- **Panel:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` exited 0 and printed `code-panel single-round — must-fix`. Three probes changed the seating:
  - The archivist was forced by the completed-design link-status pre-pass, which reported contradictory status lines.
  - The decomplector was seated by the new-mechanism probe.
  - The pruner was forced over the PR description by the body-concision probe.
- **Posted review:** I read only the first 1,500 characters of the aggregate, so this is not a full list of findings. That part covers the locksmith seat, which marks its `request-changes` as should-fix only and finds no new runtime authority. Its main finding is that the guide's inert `powers` claim is stronger than its proof:
  - `tools/guide-recipes/recipes.ts:316-330` checks only the guest-side method list, not a visitor's session.
  - The allowlist admits `streamBase64`, which appears to conflict with design § 3.3. The locksmith inferred this from the method name and did not run it.
  - Both daemon test runs pass `clips: false`.

As the job specifies, I made no fixes and did not un-draft; the PR is still a draft. The full aggregate is on the review, and the driver routes the next stage from the marker below.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr235-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (321110 cached reads)
- Output: 3486 tokens
- Cost: $0.47262999999999994
- Wall-clock: 1275s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
