---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-27T23:35:30Z
---
Routed kriskowal's endojs/endo-but-for-bots#1046 directive to durable job `build-continuous-ironhorse-fuzz-service` on the journal board. The builder job is claimed and in progress. Its acceptance contract covers removing `fuzz-ironhorse` from pull-request CI, a bounded leader-only continuous garden fuzz service with restart-safe persistent state and deduplication, and one marked standing bot-fork PR amended with every reproduced regression case and causal solution, including post-merge rollover.

Posted the routing confirmation on endojs/endo-but-for-bots#1046 at https://github.com/endojs/endo-but-for-bots/pull/1046#issuecomment-5446475773.

No garden source files changed. Follow-up ownership is entirely with `build-continuous-ironhorse-fuzz-service`, which must report its garden commit, project PR, tests, resource limits, state location, and any unresolved finding backlog.

Self-improvement: nothing this time.
