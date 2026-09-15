Resolved PR #1125 review feedback.

- Pushed `02d5610a2a`: invitation result names now exclusively retain accepted connections; redundant synthetic guests and implicit pins are removed.
- Preserved explicit `guestPins`, `hostPins`, and wake-on-message machinery.
- Pushed regression fix `bf272ccf54` for nested result-name paths.
- Updated the PR description, replied to the review thread, and posted the final verification summary.
- Local targeted tests, TypeScript, ESLint, and six policy probes passed.
- Full CI passed across Node 22/24 on Ubuntu/macOS, plus lint, coverage, browser, sandbox, release, and security checks.
- Follow-up: maintainer review remains.

Self-improvement: after changing a retention model, search the complete suite for assertions encoding the superseded model before the first push.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1125-3193517b.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 5878s

<!-- garden-usage-end -->
