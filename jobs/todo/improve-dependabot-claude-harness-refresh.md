---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/dependabot-watcher.sh
scripts/jobs/dependabot-watcher.sh:587 dispatches a full botanist review despite `2026-10-05T09:42:13Z` recording that every minion.town `@anthropic-ai/claude-code` bump predictably needs `npm run claude-harness:refresh` before tests pass. Add a narrow, validated migration hook for that parsed package/repo which directs the botanist spine to run and commit the signed-manifest refresh before CI, with a fail-closed file-scope check.
