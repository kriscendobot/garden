---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-11-05T08:12:39Z
---
# Dependabotany - endojs/endo-but-for-bots PR #1629 re-deferred (blockers #1613 and #1646 still open)

project: endo-but-for-bots
repo: endojs/endo-but-for-bots

- PR #1629 - EMBARGO-2026-11-06 - actions/setup-python v7.0.0 -> v7.1.0 (github-actions). Recheck 2026-11-05T08:11Z: the maturity floor 2026-10-29T02:56:04Z has passed. Re-verified: v7.0.0 resolves to `5fda3b95a4ea91299a34e894583c3862153e4b97`, v7.1.0 resolves to `6d4fd22b20465ccc0f7354476588e8df7c9ca0e0`, both match the pins; v7.1.0 remains the newest release; GHSA and OSV list no advisories for either version; no sibling Dependabot PR exists; live `llm` still pins v7.0.0 at both call sites. The prior benign source read stands and was not repeated.
- Blocker #1613 is unchanged: OPEN and unmerged, with 38 completed exact-head checks and no failures. #1629 exact head `38ebe454893ccbc84a866c73f3bd84abfbcebfc7` remains 38-success / 2-failure, only `ironhorse-oracle-sanitizers` and `test-ironhorse-oracle`.
- Second blocker #1646 is unchanged: OPEN, draft, and red on `test (24.x, ubuntu-latest)`. Live `llm` still has `.node-version` = `lts/*`, so the conductor's required rebase would encounter the Node 26 rollover failure until the Node 24 pin lands.
- No rebase or merge was attempted. Re-deferred one day. Next recheck: the daily heartbeat `dependabotany-recheck-endo-but-for-bots`; no new one-shot because the maturity floor has passed. Once #1613 and #1646 both land on `llm`, conduct through `ci-wait-merge.sh --dependabot-auto-merge`.
- Verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1629#issuecomment-6653080920
