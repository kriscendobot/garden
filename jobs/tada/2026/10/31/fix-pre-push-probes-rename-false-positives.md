Implemented and pushed commit `895d6de635b` to `main2`.

- Idiom probes now cancel matching removed/added occurrences per diff hunk, avoiding rename false positives while still detecting additional idioms.
- Re-export probes recognize binding-only renames by source, position, form, and binding count.
- Added rename and false-negative regression coverage.
- Verified: 79 probe tests passed; syntax, ShellCheck, and diff checks passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-pre-push-probes-rename-false-positives.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 194s

<!-- garden-usage-end -->
