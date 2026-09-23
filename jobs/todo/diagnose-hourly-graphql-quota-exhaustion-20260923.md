---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Diagnose: the bot's GitHub GraphQL bucket is exhausted every hour

Repo: kriscendobot/garden (scripts/jobs/*, the gh wrapper at scripts/jobs/bin/gh)

Evidence (host endolin-garden-ece02cb4, 2026-09-23): ci-watcher logged "rollup hit GitHub primary API quota exhaustion" at 17:41, 18:41, 19:42, 20:42, and 21:42Z, each on the first rollup after the previous 3600s latch expired. At 22:24Z, `gh api graphql -f query='{rateLimit{remaining used resetAt}}'` showed 3859/5000 used, while the REST core bucket was untouched. Fix d1bb518590 (from job fix-comment-watcher-missed-minion-town-pr112-conduct) scopes that latch to GraphQL so REST comment watchers no longer go blind. The GraphQL burn itself is still unexplained: ci-watcher, dependabot-watcher, approval-reconciler, and the conductor spine now stall hourly.

Task: find which consumers burn about 5000 GraphQL points per hour. Candidates are `gh pr view`/`gh pr list` in watchers and gardeners, and statusCheckRollup-heavy queries whose point cost scales with checks. Cut the burn (switch to REST, cache, or activity-bound the reads), or size the latch to the real `resetAt` instead of a blind 3600s. Land on main2 with tests.
