Opened PR: https://github.com/endojs/endo-but-for-bots/pull/976

Changed `ci.yml`, `ci-docs.yml`, `depcheck.yml`, and `zizmor.yml` to validate pushes to `llm` while retaining `master`. The PR body documents current branch divergence, workflow classification, cost tradeoffs, and why release, TypeDoc Pages, Familiar release, and repository-writing automation remain unchanged.

`rust.yml` is absent from current `llm` and exists only in draft PR #124, which was not modified. Its expensive XS validation needs a separate trigger decision if merged.

Verification: Prettier and `git diff --check` passed; the PR’s zizmor check passed. Remaining CI was pending at handoff.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-but-for-bots-workflow-triggers-llm.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 239s

<!-- garden-usage-end -->
