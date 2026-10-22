---
arc: minion-town-git-remote
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Fix endojs/endo-but-for-bots PR #1538 on `build/daemon-git-clone`: diagnose and repair the credential-rotation/process-group cancellation hang in the new `provideGitClone` tests, then push and verify the PR-attributable daemon tests.
