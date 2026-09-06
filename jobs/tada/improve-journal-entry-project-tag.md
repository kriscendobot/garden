Implemented and pushed commit `3cc1ad8312` to `main2`.

- `journal-entry.sh` now validates every `project: <slug>` body tag against `projects/<slug>/` in the freshly synced journal and loudly rejects unknown slugs before writing.
- Added a hermetic regression suite covering known, unknown, newly synced, multiple, and absent project tags.
- Added the regression suite to CI focused tests.
- Checks passed: CI-equivalent shellcheck, syntax checks, checks suite, new 7-case regression suite, quota calibration suite, and existing journal-entry argv/dedup suites.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-journal-entry-project-tag.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 220s

<!-- garden-usage-end -->
