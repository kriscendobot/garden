---
ts: 2026-06-04T03:28:40Z
kind: result
role: liaison
host: endolinbot
to: "*"
refs:
  - entries/2026/06/04/031814Z-dispatch-liaison-ed2960.md
  - entries/2026/06/04/032215Z-result-shepherd-ed2960.md
  - entries/2026/06/04/032356Z-dispatch-liaison-770ee3.md
  - entries/2026/06/04/032721Z-result-fixer-770ee3.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 411
    role: target
---

# result: #411 shepherd diagnosed CFT hang; fixer landed h1+h2 (DEBUG + drop vestigial mv)

Maintainer: "Please take a look at the CI failure at endojs/endo#3296".
Shepherd → fixer chain closed cleanly.

## Shepherd outcome

- Diagnosis: **silent post-download hang in Playwright 1.58.2's
  Chrome-for-Testing install path** at v1208.
- CFT 145 zip downloads 100% in 1.5s, then ~14m41s of silence
  before retry kills at 15min ceiling. Three retries identical.
- Contrast: last green upstream run (2026-05-27, ^1.49.1,
  build v1148) printed "downloaded to ..." within 2s.
- 1.58.2 pin's "multi-mirror CDN" framing was wrong — log
  shows a single CDN host; download finishes quickly; the
  hang is post-download.
- Classification comment: `4618654468`.
- Escalation: `next: fixer`.

## Fixer outcome

- **New head**: `3fbe0af31` on `ci/cache-playwright-browsers`
  (regular append on `37440d0e2`).
- **Changes** in `.github/workflows/browser-test.yml` (+6/-2):
  - Dropped vestigial `mv /opt/google/chrome
    /opt/google/chrome-unstable` step (Selenium-container
    vestige; may interact with CFT install probing for system
    Chrome).
  - Added `env: { DEBUG: pw:install }` to the install step
    (next run surfaces what's actually hanging).
- **Reply comment**: `4618674467`.

## Three outcomes the next CI run discriminates

1. CI passes → `mv` step was load-bearing for the failure.
2. `pw:install` debug surfaces a fixable step → land h3 or
   another surgical fix.
3. Still hangs with informative debug → downgrade Playwright
   pin to 1.49.x family (deferred h3).

## Teardown

`dispatches/shepherd--ed2960`, `dispatches/fixer--770ee3`
torn down.

## Steward queue post-engagement

- **#411** at `3fbe0af31`; CI re-queued. Awaits result + (if
  still failing) hypothesis-3 fixer.
- **#417, #418** unchanged.
- All other queue items unchanged.
