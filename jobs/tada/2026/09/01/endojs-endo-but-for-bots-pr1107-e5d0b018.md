Addressed the specifier feedback in commit `aa8eb640c` and pushed it to PR #1107.

- Replaced release-path/symlink rewriting with stable `@endo/daemon/iroh.js` package resolution.
- Removed the deployment-specific helper and added focused setup/idempotency tests.
- Focused AVA tests, TypeScript, ESLint, Prettier, and `git diff --check` passed.
- Posted completion summary comment `5493626000`.
- CI is running; one check passed and the remainder were pending at handoff.

Self-improvement: use package exports before introducing deployment-path rewriting.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1107-e5d0b018.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 346s

<!-- garden-usage-end -->
