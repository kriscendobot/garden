---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/mentor-claude.sh
`scripts/jobs/handlers/mentor-claude.sh:136` rejects valid `.mjs` script paths, causing the 04:51:09 mentor output for `deploy/probe/ocapn-canary.mjs` to fail closed and lose a concrete fix. Accept `.mjs` in the lexical script-path allowlist and add a regression case covering that path.
