---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-28T12:24:16Z
---
Removed the two queued chrome-native-function-caller-arguments-repro dead-upstream self-heal jobs after rechecking the live state: `gh api repos/kriscendobot/chrome-native-function-caller-arguments-repro` returns HTTP 404; `watch-optout/kriscendobot-chrome-native-function-caller-arguments-repro` remains present; both `repos/` and `comment-repos/` arming records are absent; and no matching watcher or failed units are registered on this host. The incident's CI-watcher completion had already landed the armed-fork reconciliation and local unit teardown, so the sibling comment-watcher and dependabot-watcher jobs had no remaining action.
