Implemented and pushed commit `edac084d9ed` to `main2`.

Added a bounded static pre-pass that audits local Markdown links from changed completed designs. Contradictory unfinished statuses now force the archivist with exact source, link, and target line evidence. Added fixtures covering contradictory and agreeing statuses.

Verification: new integration test passed 6/6; related panel tests passed 26/26; Bash syntax, ShellCheck, and `git diff --check` passed.

Follow-ups: none.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-completed-design-link-status-audit.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 271s

<!-- garden-usage-end -->
