I checked current master on both repos: the change is still missing, so I'm writing up a proceed verdict.

# Viability report for endojs/endo-but-for-bots PR #250

**Verdict: proceed.** The gauntlet can start: nothing has replaced this PR and the reason for it still applies.

**What the PR is:** "ci: disable npm lifecycle scripts in workflows", the master-based copy of #126, which already merged into `llm` on 2026-05-15. It is open and not a draft. Its base is the frozen `master-46d4edf` and its head is `ci/no-npm-lifecycle-master` @ `6029ba73`. The diff touches only 8 workflow files: it adds `env:` blocks setting `YARN_ENABLE_SCRIPTS=false` and `npm_config_ignore_scripts=true`, and changes plain `yarn install` to `yarn install --immutable`.

Deciding question: Does current `master` (on the fork, and upstream at endojs/endo) still lack the workflow-level lifecycle-script env settings and still run plain `yarn install`, with nothing else already doing this job?

Evidence:
- **Fork `master` @ `6ee3fda77`:** none of the workflows set `YARN_ENABLE_SCRIPTS` or `npm_config_ignore_scripts`. `browser-test.yml:47` and `typedoc-gh-pages.yml:32` still run plain `yarn install`.
- **Upstream `endojs/endo` `master` @ `356d6e70a` (6 days old):** same result. There are no env settings, and the same two plain `yarn install` lines are there.
- **The repo-level setting is still the only protection.** `.yarnrc.yml` has `enableScripts: false`, which is the single layer this PR is meant to back up.
- **The `llm` branch has the change** (through #126), so the design is settled. Master is the only target still missing it.
- **No objections on the PR.** The only review is the bot's 12-seat panel, which approved everything. There are no maintainer comments, no review asking for changes, and no newer competing PR.

**Caveats:**
- GitHub's REST API hit its rate limit partway through. I did the branch checks with shallow `git fetch` into a temporary repo instead, so I didn't call the compare API or re-run CI status.
- The PR's base is from May, so the gauntlet's clean or weave step will probably need to rebase onto current `master`.

No files or PRs were changed by this job.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr250-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (295924 cached reads)
- Output: 2732 tokens
- Cost: $0.5011208
- Wall-clock: 53s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
