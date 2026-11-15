---
posted_at: 2026-11-15T20:51:22Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/dependabot-migration.sh
At scripts/jobs/dependabot-migration.sh:35, add a closed hook for `endojs/endo-but-for-bots` `peter-evans/create-pull-request` bumps that synchronizes the exact trailing version comments in `update-action-pins{,-major}.yml` after validating a plain bump and bounded output paths. At 2026-11-15T20:25:40Z, floating `# v8` drift failed zizmor and required a bot repair commit; make this deterministic before CI.
