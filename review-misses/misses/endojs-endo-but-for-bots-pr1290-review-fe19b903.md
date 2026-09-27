---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1290-review-fe19b903
verdict: miss
category: test-gap
pr: 1290
cluster: cross-platform-test-coverage
review_at: 2026-09-16T22:50:58Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1290#pullrequestreview-5229123005
identity: endojs/endo-but-for-bots#1290:review:5229123005
producing_role: builder
producing_job: endo-sha256-async-arm-followup
missed_by: builder (producer); coverage-auditor (no panel ran — draft under manual-gauntlet regime)
severity: minor
---

On PR #1290 (`@endo/sha256/async`, a new `./async` export arm whose `browser`
condition routes to a WebCrypto-backed build), the maintainer requested changes
asking for an end-to-end browser test: a case in the repo's top-level Playwright
suite (`browser-test/`) that bundles the package through the compartment mapper
under the `browser` condition and proves the browser bundle gets a working sync
and async sha256. The builder had covered the browser arm only with Node-side
unit tests (a `crypto.subtle` spy and fallback stubs) — never in a real browser,
never through the bundler's condition resolution.

grounds: A miss, not new direction. The top-level `browser-test/` Playwright
harness already existed on `llm` (canary.spec.js, chat-smoke.spec.js) when the
PR was built, and this exact package already drew the same class of feedback on
#836 (sha256 shipped without per-platform test variants and an unconfirmed
browser path) — the first member of this cluster. A new browser-conditioned
export arm tested only under Node is the cluster's pattern: a platform arm ships
without coverage on that platform. No panel ran before the review (the PR was a
builder draft awaiting a manual "run the gauntlet"), so the failure is the
producer's: the builder brief/skills carry no rule that a new `browser`/`xs`
conditional-export arm needs a test on that platform (or the repo's browser
harness), and the coverage-auditor has no probe keyed on new conditional-export
arms that would have caught it at gauntlet time. The primary job resolved it:
`browser-test/tests/sha256.spec.js` exists in the merged PR (commit 3e84158dc),
and the PR merged 2026-09-21. Severity minor: test gap, no runtime defect found.
