---
ts: 2026-06-15T06:10:00Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: a7416e
prs:
  - { repo: endojs/endo-but-for-bots, pr: 411, role: target }
refs:
  - entries/2026/06/15/055055Z-dispatch-fixer-a7416e.md
  - https://github.com/microsoft/playwright/issues/41000
  - https://github.com/endojs/endo-but-for-bots/pull/411
---

# result: fixer — PR #411 browser-test BROKEN→GREEN via Playwright 1.60.0 (microsoft/playwright#41000)

## Failure-mode diagnosis

Root cause was upstream microsoft/playwright#41000:
`playwright install chromium` hangs silently in
archive-extraction on Node.js 24.16.0 against Playwright
1.57.0–1.59.x. CFT zip downloads in 1.5s, `pw:install
extracting archive` logged, then no further output until
per-attempt timeout. Bot fork's `.node-version` is `lts/*`
→ Node 24.16 on ubuntu-latest. Prior pin `@playwright/test
@1.58.2` was squarely in the broken matrix.

Prior hypotheses (CDN flake, `mv /opt/google/chrome`
interaction, timeout sizing) each addressed plausible
adjacent failure modes but NOT the actual fault.

## Version matrix

| Version | Result | Notes |
|---|---|---|
| 1.49.x | Pre-CFT, downstream of CVE floor | not the right floor |
| 1.55.1 | CVE floor | GHSA-7mvr-c777-76hp (CVSS 8.7) affects < 1.55.1 |
| 1.58.2 | Broken | extract-zip hang (matches #41000) |
| 1.59.x | Broken | same root cause |
| **1.60.0** | **Used** | upstream fix for #41000; Chromium 148.0.7778.96 |

## Final landing

`@playwright/test@1.60.0` (latest stable, May 2026,
single-major bump above the CVE floor).

Three commits:
- `5090f3b14` Playwright pin bump.
- `9afeb867d` chore: Update yarn.lock (separate per
  discipline).
- `45810f0f1` Restored `mv /opt/google/chrome
  /opt/google/chrome-unstable` step caught as secondary
  regression on first 1.60.0 run; added explanatory comment
  so it does not get removed again under the "Selenium
  vestige" misreading.

## CI result

Browser Tests PASSED on `45810f0f1`
(run 27527097138): 4/4 tests green
(chromium-next 149.0.7827.53, chromium 148.0.7778.96,
firefox 150.0.2, webkit 26.4) in 1.1m total; browser
install in 19s.

PR-wide rollup at report time: 8 SUCCESS (incl. Browser
Tests), 2 IN_PROGRESS, 6 QUEUED, 0 FAILURE.

## Citation

PR top-level summary on mirror:
pull/411#issuecomment-4705021110.

## Self-improvement signal

When shepherd or fixer identifies a CI failure mode that
"looks like" a known phenomenon (CDN flake, runner-image
drift), still write a one-line *alternative-hypotheses-
considered* note before pushing. The first explanation that
fits SOME evidence can occlude the one that fits ALL of it
— #411 lost roughly three days to that occlusion before
the maintainer requested a broader search. Gardener-shaped:
add to `skills/shepherd`/`roles/fixer` as a
*pre-push alternatives note* norm.

Dispatch root torn down.
