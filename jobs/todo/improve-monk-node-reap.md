---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/monk-claude.sh
Run the Claude invocation in a managed process group and add signal/exit cleanup that waits for its descendants to terminate. `garden-monk@2` repeatedly starts with left-over `node` processes, showing the current worker handler can exit before its Claude runtime tree is fully reaped.
