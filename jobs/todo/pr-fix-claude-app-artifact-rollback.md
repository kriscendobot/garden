---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo kriscendobot/minion.town: branch `fix/claude-app-artifact-rollback` (commit 54ac1e9, "fix: ship vendored Claude package in app artifact") has a fix ready but not yet opened as a PR. Changes touch deploy/aws/scripts/create-app-artifact.sh, deploy/aws/scripts/deploy-app.sh, and add test/deploy-app-artifact.test.ts, addressing a prior rollback caused by the vendored Claude package missing from the app artifact. Open a PR from this branch against main, then run the gauntlet (clean → panel review → fix-loop → un-draft).
