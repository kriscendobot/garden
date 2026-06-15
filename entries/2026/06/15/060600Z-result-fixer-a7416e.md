---
ts: 2026-06-15T06:06:00Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/411
---

# Result: fixer dispatch a7416e on endojs/endo-but-for-bots#411

PR #411 (ci/cache-playwright-browsers) on `endojs/endo-but-for-bots`. Maintainer's 2026-06-07 directive requested a broader investigation since the prior cache + retry + version-pin attempts had not made browser-tests green and the failure recurred regardless of timeout.

## Diagnosis

Root cause is the upstream Playwright + Node 24.16 extract-zip regression tracked at [microsoft/playwright#41000](https://github.com/microsoft/playwright/issues/41000). `playwright install` hangs silently in the archive-extraction phase on Node 24.16.0 against Playwright 1.57.0 through 1.59.x. The fix landed in Playwright 1.60.0.

The bot fork's `.node-version` is `lts/*`, which resolves to Node 24.16 on the current `ubuntu-latest` runner. The PR's prior pin was `@playwright/test@1.58.2`, squarely in the broken range. Logs from run 26995491127 show download succeeding in 1.5 seconds, "extracting archive" log line, then 30 minutes of silence per attempt, killed by the retry framework, identical on retry. `DEBUG=pw:install` (carried in from commit 3fbe0af31) confirmed the hang is post-download.

## Version matrix evaluated

| Version | Result |
| --- | --- |
| 1.49.x | Pre-CFT, downstream of multi-CDN fix and CVE floor; not the right floor. |
| 1.55.1 | CVE floor (GHSA-7mvr-c777-76hp affects < 1.55.1). |
| 1.58.2 | Broken: extract-zip hang. |
| 1.59.x | Broken: extract-zip hang. |
| 1.60.0 | Fixed. Latest stable as of May 2026. Used. |

## Commits landed (force-with-lease push to ci/cache-playwright-browsers)

- `5090f3b14` — bump `@playwright/test` from 1.58.2 to 1.60.0 in `browser-test/package.json`.
- `9afeb867d` — regenerated `browser-test/package-lock.json`.
- `45810f0f1` — restored the `mv /opt/google/chrome /opt/google/chrome-unstable` step. Commit 3fbe0af31 had removed it on the (now-falsified) hypothesis that the rename was interacting with the Playwright install hang; with the real hang fixed, the rename's load-bearing role for the `chromium-next` (channel `chrome-dev`) test is back in scope. Added a multi-line comment above the step recording the rationale so a future reader does not remove it again.

## CI rollup

Run [27527097138](https://github.com/endojs/endo-but-for-bots/actions/runs/27527097138) on `45810f0f1`: **Browser Tests passed**, 4/4 tests green in 1.1m (chromium-next chrome 149.0.7827.53, chromium 148.0.7778.96, firefox 150.0.2, webkit 26.4). Browser-binary install completed in 19 seconds (cold cache). The 120-minute outer ceiling and 30-minute per-attempt budget are now well-oversized; an explicit comment in the workflow flags them as provisional pending right-sizing in a follow-up PR.

Posted top-level PR comment: https://github.com/endojs/endo-but-for-bots/pull/411#issuecomment-4705021110

## Discipline

Pre-push gate ran probes-only (no JS or markdown source touched): all probes pass. Force-with-lease push used; lease validated against the freshly-fetched head before each push. Lockfile shipped in its own commit per `skills/yarn-lock-separate-commit/SKILL.md`. Pull-request authorized by standing relaxation on `endojs/endo-but-for-bots`.

Self-improvement: when shepherd or fixer identifies a CI failure mode that "looks like" a known phenomenon (CDN flake, runner-image drift), still write down a one-line "alternative-hypotheses-considered" before pushing, because the first explanation that fits some of the evidence can occlude the one that fits all of it; #411's diagnosis lost ~3 days to that until the maintainer requested a broader search.
