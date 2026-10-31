Opened draft PR endojs/endo-but-for-bots#1595: https://github.com/endojs/endo-but-for-bots/pull/1595

Implemented interactive bounded Git remote provisioning and inspection for `@endo/cli` and `@endo/daemon`, including fetch-only and agent profiles, approval previews, credential-safe inspection, documentation, changeset, and real-daemon integration coverage.

Verification: all 13 pre-push stages passed; targeted Node 24 CLI tests passed 8/8 and daemon tests passed 11/11. Regression mutations confirmed the new boundary, approval, and inspection tests are load-bearing.

Follow-up: the full local verifier encountered workflow parsing errors in zizmor and timeouts in the daemon-wide channel/code-mode suites; PR CI is pending.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-git-remotes-interactive-provisioning.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 4886s

<!-- garden-usage-end -->
