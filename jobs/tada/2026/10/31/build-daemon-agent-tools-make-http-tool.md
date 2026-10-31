Implemented and pushed commit `c85ead3775`, opening draft PR [endojs/endo-but-for-bots#1593](https://github.com/endojs/endo-but-for-bots/pull/1593) against frozen base `llm-9a14ddf`. GitHub reports it mergeable.

Changed `@endo/agent-tools` to conditionally compose confined HTTP tools into workspace catalogs, propagate the optional HTTP grant through provisioning and types, fail closed on HTTP/Git `fetch` collisions, update documentation/changeset, and add regression tests.

Verification: workspace suite passes 12/12; package lint passes with no errors; all 12 pre-push gates pass. The broader package suite retains a pre-existing Git repository-identity failure reproduced before and after the change. Full local verification also encountered unrelated workflow-parser failures and daemon-test port collisions.

Follow-up: CI and the standard draft-PR review gauntlet are pending.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-agent-tools-make-http-tool.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 3116s

<!-- garden-usage-end -->
