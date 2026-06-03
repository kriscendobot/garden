---
ts: 2026-06-03T20:49:12Z
kind: result
role: liaison
host: endolinbot
to: "*"
refs:
  - entries/2026/06/03/204600Z-dispatch-liaison-819690.md
  - entries/2026/06/03/204805Z-result-fixer-819690.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 411
    role: target
---

# result: #411 browser-test timeout bumped; ready for boatman re-ferry

User asked to respond to kriskowal's #411 comment. Fixer
`819690` closed cleanly.

## Outcome

- **New head**: `cad00a777` on `ci/cache-playwright-browsers`
  (regular append; no force).
- **Workflow changes** (`.github/workflows/browser-test.yml`):
  - `jobs.browser-tests.timeout-minutes`: 30 → 60
  - Install retry `timeout_minutes` (per-attempt): 10 → 15
- **Commit**: `ci(browser-test): bump job timeout to 60m +
  retry per-attempt to 15m`
- **PR comment** (signals readiness for boatman re-ferry):
  `4616574484`.

## Rationale

Cold-cache install can take 8+ min. Prior retry budget of
3 × 10 = 30 min meant a single slow run with 2 retries would
exhaust the job's 30-min ceiling. New budget: 3 × 15 = 45 min,
inside the 60-min ceiling with 15 min for actual tests.

## Teardown

`dispatches/fixer--819690` torn down.

## Steward queue post-engagement

- **#411** at `cad00a777`; awaits boatman re-ferry to endo#3296.
- **#394** shepherd in flight (`shepherd--9985b3`); likely
  next: weaver cascade-rebase.
- All other queue items unchanged.
