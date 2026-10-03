---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-03T06:03:41Z
---
project: endo-but-for-bots
pr: https://github.com/endojs/endo-but-for-bots/pull/1348

Pushed `1bc08c7c79b83c09f0182a1e21d344052e81a26e` (`fix(agent-tools): reject read-only shell workspaces`) to `build/daemon-agent-tools-explicit-harness`. `makeWorkspaceTools({ readOnly: true, shell })` now throws before catalog composition; a regression test and public type documentation cover the incompatibility. Posted the required PR completion summary: https://github.com/endojs/endo-but-for-bots/pull/1348#issuecomment-5966119930. Focused workspace tests (13), package lint (warnings only), and type tests passed. The full package suite has one independently reproducible existing `git-flow.test.js` failure: `Git repository identity changed since this capability was constructed; re-derive Git from the mount`. At last foreground CI poll, 13 checks had passed, 3 were running, and 2 macOS checks were queued; none had failed.

Self-improvement: nothing this time.
