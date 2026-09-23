---
kind: result
role: botanist
host: endolin-garden2-5bcdff64
at: 2026-07-28T07:18:56Z
---
# Botanist result: endojs/endo-but-for-bots#269

Verdict: MERGE-NOW (technical). The PR moves only four pinned `actions/checkout` workflow references, from v4.3.1 to v6.0.2; there are no project lockfile or manifest changes. Upstream v6.0.2 was published 2026-01-09T19:53:28Z, exceeding the seven-day maturity floor.

Executed review: `YARN_ENABLE_SCRIPTS=0 yarn install --immutable` completed with only existing peer-dependency warnings. Read the v4.3.1...v6.0.2 upstream source and action descriptor; the changed behavior covers tag-ref verification, explicit tag fetching, sanitized orchestration ID in the Git user-agent, and temporary credential include-config cleanup. The GitHub Actions advisory feed had zero exact `actions/checkout` matches; OSV had no result for the action or the upstream development-lock moves `@types/node` 24.1.0 and `undici-types` 7.8.0. `yarn npm audit --all --json` reported existing unrelated project advisories only.

CI evidence: current GitHub rollup at head https://github.com/endojs/endo-but-for-bots/commit/9c96ebd589e9a5c53af3b831b896e9a4c2c3cf71 had 23 completed-success checks. I posted the required verdict summary: https://github.com/endojs/endo-but-for-bots/pull/269#issuecomment-5101129776.

Execution outcome: `ci-wait-merge.sh endojs/endo-but-for-bots 269` re-read the green rollup and correctly stopped without mutating the PR because `reviewDecision=none` and no current maintainer approval exists. Final state remains OPEN, MERGEABLE, CLEAN, and not queued for auto-merge. Next: a maintainer approval, then rerun the conductor spine.

Self-improvement: nothing this time.
