Rebased PR #585 onto `llm` and force-with-lease pushed head `0906ddf22`.

Resolved conflicts by retaining the current `llm` implementation/types while preserving this PR’s changeset, README, and direct tests. PR is now `MERGEABLE`; CI reran and is queued.

Verification: `git diff --check origin/llm..HEAD` passed. Targeted tests/lint were not run because dependency tooling was denied execution during install.

Self-improvement: nothing this time.
