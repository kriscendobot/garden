Implemented and opened draft PR: https://github.com/endojs/endo-but-for-bots/pull/1291

- Added pi-ai-backed chat/streaming, model detection, and tool-call recovery to `@endo/agentry`.
- Migrated Fae, Jaine, and Floot from Lal providers to agentry.
- Removed `packages/lal/providers`, Fae’s duplicate parser, Floot’s Anthropic adapter, and obsolete SDK dependencies.
- Updated tests, fixtures, documentation, and lockfile.
- Commit: `0805332d65c0bc0277c5cca111c7c704bd729e63`.
- Verified affected package tests, lint, TypeScript, and immutable install; Floot passed 195 tests, Lal passed 43 with one environment-dependent skip.
- Follow-up: PR remains draft pending CI and review.
- Self-improvement: reported non-executable warm-cache Yarn shims to the liaison.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-migrate-agents-to-agentry-scuttle-lal.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1159s

<!-- garden-usage-end -->
