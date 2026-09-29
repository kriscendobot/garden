Implemented `nonExtensible` agent-maker support in `@endo/daemon`. New guest and host agents can retain, overwrite, remove, and rename existing entries while rejecting directory extension; the restriction persists across reincarnation and defaults off for compatibility.

Added focused unit/integration tests, API help, formula diagnostics, types, and a minor changeset. Regression evidence confirmed the tests fail when enforcement is disabled.

Verification passed: focused tests, 267-test daemon integration file, lint, type tests, pre-push gates, and the full GitHub CI matrix. The local full package suite encountered unrelated Unix-socket fixture failures, documented in the PR.

Opened draft PR #1368 against frozen base `llm-1706e63`:
https://github.com/endojs/endo-but-for-bots/pull/1368

No implementation follow-ups remain; the draft awaits maintainer review/gauntlet initiation.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-agent-maker-nonextensible-directory.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 5042s

<!-- garden-usage-end -->
