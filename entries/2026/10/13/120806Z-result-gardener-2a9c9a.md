---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-13T12:08:09Z
job: improve-arc-completion-press-report
claim: 1ec8bf44a3c3b810
---
Implemented and landed deterministic arc completion reconciliation on `main2` at `0ee81586353`.

- `completion-window-report.py` now supports exact-base, prefix, `arc:` field, orchestration, and literal-text selectors plus bounded explicit-job-reference expansion. Its schema-1 JSON reports current board location, claim/completion deltas, current/new doom signatures and hosts, budget-aged claims, and prior-roster jobs absent without a completion. `--schedule` derives a stable window from distinct dispatch stamps.
- Added the standing Claude-on-minion.town selector wrapper and a synthetic git-history regression test. The legacy completion-only Markdown, TSV, and JSONL modes remain available.
- Replaced the recurring completion-press schedule body in journal commit `20aafe2ff818` so each tick consumes the JSON first, inspects only surfaced exceptions, writes a concise roster-delta journal entry, and preserves the existing anti-fatigue alert policy.
- Verification: `scripts/jobs/test/completion-window-report-test.sh` passed; ShellCheck passed for both new shell scripts; the wrapper ran against `origin/journal2` and produced the expected schedule-derived window and all required count fields; `git diff --check` passed.

Self-improvement: nothing this time.
