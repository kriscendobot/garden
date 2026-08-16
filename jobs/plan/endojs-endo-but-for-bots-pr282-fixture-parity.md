---
gate: orchestrated
orchestrated_by: pr282-flag-gated-reconciliation
priority: normal
posted_by: producer
posted_at: 2026-08-16T06:33:58Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Establish compartment-mapper parity for https://github.com/endojs/endo-but-for-bots/pull/282, with a drift safeguard.

Maintainer review 2026-08-16T06:28Z: "As this is another implementation of compartment-mapper, in order to establish parity, I would like this to use every applicable compartment-mapper test fixture and have safeguards to ensure that the test suites do not drift. That is, the existence of an unaccounted fixture should cause the test suite to fail."

Requirements:
1. The #282 walker's test suite must run against EVERY applicable fixture under packages/compartment-mapper/test.
2. Add a drift safeguard: an unaccounted fixture — one present in the tree but not exercised or not explicitly recorded as inapplicable-with-reason — must FAIL the suite, not be skipped silently.
3. Keep the fixtures where they are, under packages/compartment-mapper/test. The maintainer noted that a top-level test/fixtures tree (like the test262 fixtures) is worth CONSIDERING later; that is explicitly not this job.

Where a fixture is genuinely inapplicable to the node_modules walker, record it in an explicit accounted-exclusion list with a one-line reason, so the safeguard stays honest rather than being defeated by a blanket skip.

Runs after the pin-the-merge-base rebase child, on its rebased head.

handler-timeout: 7200
