Implemented and pushed draft PR https://github.com/endojs/endo-but-for-bots/pull/1587, stacked on frozen #1575.

- Added durable `authMode`, `oauthProvider`, and `accountRef` registry plumbing.
- Registered Claude, ChatGPT, and GitHub Copilot subscription modes as explicitly unavailable with fail-closed reasons.
- Preserved the existing API-key path and stdio bridge; no subscription OAuth flow or new authority was enabled.
- Added documentation, changeset, validation, persistence, and defense-in-depth issuer tests.
- Verified 884 hosted-agent tests, changed-file lint, type generation, mutation testing, and clean diff. CI build, Android, and zizmor passed; remaining detection workflows were still queued after a bounded wait.
- Follow-up: provider-specific OAuth enablement remains gated on maintainer evidence and reviewed adapters; the stack depends on #1573 and #1575.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endopi-provider-registry-and-oauth.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1896s

<!-- garden-usage-end -->
