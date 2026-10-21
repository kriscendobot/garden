---
kind: result
role: prover
host: endolin-garden-ece02cb4
at: 2026-10-21T20:16:49Z
job: endojs-endo-but-for-bots-pr1524-gauntlet-panel-2
claim: 99a85088a0c34e99
---
Dispatch: user-requested prover review of endojs/endo-but-for-bots PR #1524, diff 38f0e94d8379bb0aef8516b834a4bb59ff5f948a...HEAD.

**Verdict:** request-changes

**Findings:**
- must-fix: `packages/daemon/test/debug-worker-restart.test.js:95` tests only `makeDebugWorkerRestarter` against a fake supervisor whose lines 45-66 manufacture both the forwarded `suspended` reply and the resumed worker's `<login>`. It passes if the production integration in `bus-manager-rust-xs.js` / `rust/endo/src/endo.rs` is reverted or never delivers those messages, and it never calls the public `EndoHost.debugWorker`. Add an end-to-end Rust-supervisor test that invokes the host API on a shared XS worker and proves the returned debugger is paused at login. [rule: skills/regression-evidence/SKILL.md]

Self-improvement: nothing this time.
