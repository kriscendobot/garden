## Panel round 2 for PR #250: must-fix

The single-round panel on endojs/endo-but-for-bots#250 ("ci: disable npm lifecycle scripts in workflows") came back **must-fix**. One seat asked for a one-sentence change to the PR description; none found anything wrong in the workflow code.

**How it ran:** I reviewed head `a31662b4` against the PR's pinned base `46d4edf3` (`master-46d4edf`), in an isolated checkout of `endojs/ci/no-npm-lifecycle-master`. `panel.sh` finished with exit code 0 and a must-fix disposition. All 33 seats completed: 20 approved, 12 left comments only, and 1 requested changes. The run is recorded at `panel-runs/endojs-endo-but-for-bots-250/b7b0c3ccf146.md`.

**What blocks:**
- **The one required change (pruner seat):** the PR description's *Documentation Considerations* section says "None for downstream users. The change affects CI only." It should say only "The change affects CI only."
- **Optional suggestions from other seats:**
  - Say in the PR description that the `release.yml` and `typedoc-gh-pages.yml` jobs only run on push, so a PR run can't test them before merge.
  - Mention the switch to `yarn install --immutable`.
  - Later, add a check that every workflow sets both the `YARN_ENABLE_SCRIPTS` and `npm_config_ignore_scripts` variables.

**Review posted:**
- The bot authored this PR, so GitHub refused a request-changes review. The review went up as **COMMENTED** at 2026-10-08T17:42:14Z.
- It starts with a must-fix summary.
- The full panel output was 67 KB, which is over GitHub's 65,536-character limit for a review. To fit, the posted review (25 KB) names the 20 approving seats and includes the full text from the 13 seats that didn't approve.

**Next:** The fix-loop stage should apply the one-line change to the PR description; no code changes are needed.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr250-gauntlet-20261007-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (703049 cached reads)
- Output: 4307 tokens
- Cost: $0.6673498000000002
- Wall-clock: 211s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
