The dependabot watcher now waits only on the REST cooldown, so an unrelated GraphQL quota latch no longer stops it. The fix is pushed to `main2` as `f82e5083b70`.

**What I changed:**
- **`scripts/jobs/dependabot-watcher.sh:196`:** the top gate is now `api_cooldown_active rest` instead of the all-scope check, because its PR list comes from the REST API. The REST latch still blocks it, which covers the 2026-10-27T12:19:42 REST quota warning.
- **One addition beyond the job text:** the watcher does make GraphQL calls in one place, the base-CI check (`handlers/dep-base-ci-gh.sh`). Narrowing the top gate alone would have let those calls run under a GraphQL latch and fail. That check now runs `api_cooldown_active graphql` first. Under a latch it logs and skips, and the PR gets the ordinary full review, which is what already happens when that check fails.
- **`scripts/jobs/test/dependabot-watcher-test.sh`:** new section RG with three checks:
  - With only the GraphQL latch active, the job is still posted.
  - With only the GraphQL latch active, the base-CI check is never called and the job carries no base-CI annotation.
  - With the REST latch active, the tick is skipped.

**Tests:** the full suite passes, 76 passed and 0 failed. With the old all-scope gate, the new "still posted" check fails (75 passed, 1 failed). The only new shellcheck notes are SC2015 info notes, the same `&& ok || bad` pattern the file already uses throughout.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-rest-scope-dependabot-cooldown.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1840880 cached reads)
- Output: 9978 tokens
- Cost: $1.188656
- Wall-clock: 1479s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
