---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr151-review-ddbb3acc
verdict: miss
category: test-gap
pr: 151
cluster: feature-shipped-without-tests
cluster_pattern: A garden-built feature PR reaches the maintainer with no unit tests for its new logic — tests deferred behind an unlanded runtime dependency when a pure-function extraction would have made the logic unit-testable immediately; the panel's coverage seats did not require the testable extraction.
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/151#pullrequestreview-4680352653
identity: endojs/endo-but-for-bots#151:review:4680352653
producing_role: builder
missed_by: fast-checker/prover (coverage seats)
severity: minor
---

The maintainer's review on this bot-authored `feat(cli): endo workers verb` build
asked, in one line, to refresh the branch and to add tests. The substantive
review-process signal is the second half: the feature shipped with **zero unit
tests** for its text/JSON formatting logic. The PR's own rationale deferred tests
behind an unlanded host-API dependency (#129), yet the fix that satisfied the
review needed none of that — it extracted the pure formatting into a small module
(`formatWorkers`) and covered it with six daemon-free cases, exactly the repo's
house style of small testable pure modules. So the testable path existed the whole
time; the review process let a testless feature reach the maintainer instead of
requiring the pure-logic extraction up front.

**Grounds.** No gauntlet/panel job for #151 survives in `journal/jobs/tada/`, and
no panel summary comment appears on the PR — only comment-watcher-driven rebase/
fixer activity (2026-05-10). Whether the panel ran and passed the testless diff or
never ran, the outcome is the same class of failure: a garden build reached a
human reviewer with new logic and no coverage, when a unit-testable extraction was
readily available. The garden owns a `coverage-driven-testing` skill and coverage
seats (`fast-checker`, `prover`, and the newly-added `coverage-auditor`) whose lens
is precisely "new lines without coverage," so the pattern is one the review cycle
is equipped to sense.

The **refresh** half of the review is *not* a miss: the branch was ~1171 commits
behind `llm` because the PR sat open ~2 months (created 2026-05-08, reviewed
2026-07-12). Base drift accrued after review time; no panel could have anticipated
it. Only the test-gap half is recorded as a miss.
