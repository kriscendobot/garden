## Shepherd report: endojs/endo-but-for-bots#1349 (hardened TextEncoder/TextDecoder XS smoke)

**Outcome:** All 15 checks on PR #1349 now pass on head `d98467c6b5`, including zizmor. The PR is still a draft.

**Cause:** The failure came from the base branch, not from this PR's changes. The PR is based on `master-6ee3fda` and does not touch `.github/`. On that base, `.github/workflows/ci.yml:270` pins `dorny/paths-filter@d1c1ffe…`, which is v3.0.3, with the comment `# v3`. Upstream has since moved the `v3` tag to v3.0.4 (`0e4a8c6e`). zizmor v1.24.1 runs with `persona: pedantic`, so it reported "hash pin has mismatched or missing version comment" and exited with code 13. Other open PRs pass zizmor because they are based on `llm`, which doesn't have this line. This PR is the only one on a `master` snapshot.

**Fix:** I pushed one commit, `d98467c6b5` ("ci: pin dorny/paths-filter version comment to v3.0.3"), to `build/hardened-text-codecs-shim`. It changes only the version comment to `# v3.0.3`. The pinned hash is unchanged, so what CI runs is unchanged.

**Follow-up:**
- `master` itself still has the stale `# v3` comment. Any other PR based on a `master` snapshot, or a push to `master`, will hit the same zizmor failure until the one-line fix lands on `master`.
- When #1349 is ferried upstream, this commit can travel with it or be split out as its own change.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endo-but-for-bots-pull-request-1349.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (699411 cached reads)
- Output: 4003 tokens
- Cost: $0.6328382
- Wall-clock: 1719s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
