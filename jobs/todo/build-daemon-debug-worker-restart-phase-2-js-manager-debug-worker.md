---
arc: moonshots
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Builder job on endojs/endo-but-for-bots (base `llm`): implement Phase 2 of `daemon-debug-worker-restart`, the JS manager `debugWorker`. Add it to the `HostInterface` guard and host object assembly, add the `debugFlag` control power in `daemon_bootstrap.js`, add help text, and test that the returned debugger is connected with the worker paused. Stack it on the Phase 1 Rust supervisor debug-flag PR, or its branch if that PR is not yet merged.
