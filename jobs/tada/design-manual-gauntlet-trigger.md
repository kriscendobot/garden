Completed the manual-gauntlet-trigger design.

- Added `designs/manual-gauntlet-trigger.md` and indexed it in `designs/README.md`.
- Proposed explicit `run the gauntlet #N` triggering, draft-state enforcement, and a non-mutating readiness audit.
- Documented the historical safety trade-off, cost census, migration plan, affected files, tests, and garden-only alternative.
- Landed commit `2256256578` on `main2`.
- Opened draft review PR: https://github.com/kriscendobot/garden/pull/85
- Follow-up: maintainer decision is needed on the explicit-merge bypass and alert-versus-redraft policy before implementation.

Verification: `git diff --check` passed; PR #85 is open, draft, based on frozen `main2-6eb30e6`, contains exactly the design and index files, and carries both required job/open-question markers.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-manual-gauntlet-trigger.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 309s

<!-- garden-usage-end -->
