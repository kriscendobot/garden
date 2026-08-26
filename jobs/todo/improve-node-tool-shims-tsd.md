---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardening/install-node-tool-shims.sh
Add a runtime-relative `tsd` shim and test it. The prescribed SES verification failed in a warm-cache worktree because `tsd` was omitted from the shared shim installer.
