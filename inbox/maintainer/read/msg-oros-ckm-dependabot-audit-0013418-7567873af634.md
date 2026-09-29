from_host: endolin-garden-ece02cb4
from: gardener:oros-ckm-dependabot-audit-0013418
reply_to: oros-ckm-dependabot-audit-0013418
msg_key: msg-oros-ckm-dependabot-audit-0013418-7567873af634
notice_count: 1
first_seen: 2026-09-29T17:30:33Z
last_seen: 2026-09-29T17:30:39Z
sent_at: 2026-09-29T17:30:39Z
---
Dependabot investigate-only pass — kriscendobot/oros-ckm-data-readiness (public, Apache-2.0), default branch ckm-poc-build. Investigate-only; nothing committed/merged.

ALERTS STATUS: Dependabot alerts ARE disabled for this repo (confirmed). The `gh api .../dependabot/alerts` 403 is genuine ("alerts are disabled"), compounded by the bot token also lacking admin:repo_hook — but "disabled" is the real state. To get GitHub's own 2-high count you'd enable Dependabot in Settings → Code security. Findings below are from `npm audit` against the default-branch package-lock.json.

HEADLINE: 10 high + 4 moderate + 2 low today. ALL 10 highs are in DEV/BUILD tooling (devDependencies + their transitives). NONE are in the production runtime (prod deps d3, dotenv, papaparse, pg, react, react-dom are all clean). Real-world exposure of the shipped app is effectively nil; these advisories bite only when the vulnerable dev tool runs against attacker-controlled input on a dev machine or CI. (npm's DB reports 10 vs Dependabot's snapshot "2 high" because npm's advisory DB is broader and several advisories are recent.)

FIX PICTURE:
- 9 of 10 highs close with a NON-BREAKING `npm audit fix` (lockfile-only bumps inside existing ^ ranges, no package.json change):
  brace-expansion, browserslist, glob, minimatch, nanoid, picomatch, postcss, rollup, undici(via jsdom).
- 1 high REMAINS after the safe fix: esbuild <=0.24.2 (GHSA-67mh-4wv8-2f99, dev-server can be made to serve arbitrary responses). It sits under vite@5, so it only closes by bumping vite 5→8 (BREAKING major). The 3 leftover moderates (vite, vitest, @vitest/mocker) are the same chain and need vite 5→8 + vitest 3→5 (BREAKING).

RECOMMENDATION (matches repo's milestone-merge / investigate-only convention):
1. Low-risk, do-now: run `npm audit fix` (lockfile-only, no dep-range change) at the next milestone merge — clears 9/10 highs with no API/behavior change; verify `npm run build` + tests after.
2. Deferred, breaking: schedule vite 5→8 and vitest 3→5 as a deliberate toolchain upgrade (config-migration risk) to clear the last high (dev-server esbuild) + 3 moderates. Not urgent given dev-only exposure.
3. Optional hygiene: enabling Dependabot alerts on the repo would give the authoritative GitHub count and ongoing notification (public repo, free).

Zero deps were added this arc, so this is fully pre-existing debt as the follow-up noted.
