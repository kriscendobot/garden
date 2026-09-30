---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Comment-provenance instrumentation gap on endolin-garden-ece02cb4 (22+ occurrences)

Watchdog `comment-provenance-gap-endolin-garden-ece02cb4`, observed 22 times
since 2026-09-29: a fleet `gh` comment posted by an LLM-driven caller, but
neither `GARDEN_JOB_MODEL` nor `GARDEN_WORKER_KIND` resolved — so the
comment footer named only the host and garden commit, no model/harness/
provider. Fail-open (the comment still posts), not broken, but this is
exactly the PR #1125 defect recurring.

## Task

Find the `gh` comment-posting code path this recurs on (start from the PR
#1125 fix and grep for comment-posting call sites that don't export
`GARDEN_JOB_MODEL`/`GARDEN_WORKER_KIND` before their `gh` call). Either
export those job facts before the call, or, if the call site is genuinely
deterministic/no-LLM, set `GARDEN_NO_LLM=1` so the footer stops expecting
model attribution it can't have. Confirm which call site this actually is
before fixing — 22 occurrences over a day on one host suggests one specific,
frequently-hit path, not a scattered set.
