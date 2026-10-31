---
kind: result
role: prover
host: endolin-garden-ece02cb4
at: 2026-10-31T11:55:08Z
job: endojs-endo-but-for-bots-pr1589-gauntlet-panel-1
claim: b7ba84225bbd13a0
---
**Verdict:** request-changes

**Findings:**
- must-fix: `packages/fae/test/subagent-loop.test.js:1901` reaches the workspace behavior only by calling `spawnWorkerLoop` with an already-resolved `Git`, while `packages/fae/test/subagent-host.test.js:571` calls `provisionFaeAgent` with already-created locators. Neither test invokes the public `createAgent(name, { workspace: { git, remote? } })` path added at `packages/fae/agent.js:1318`. Consequently, a regression in petname lookup or the factory-to-driver handoff passes every new test. Add an end-to-end factory test that stores a `Git` (and preferably a recording remote) under the named petnames, creates the agent through that public API, and proves the loop receives and can use those capabilities. [rule: skills/regression-evidence/SKILL.md]
- must-fix: `packages/fae/test/workspace-tools.test.js:76` only asserts that an empty `GitRemote` makes `fetch`, `pull`, and `push` names appear. It never invokes a remote tool or demonstrates that it closes over the granted remote, so it also passes if the adapter hands `makeGitRemoteTool` the `Git` or another arbitrary remotable. Use a recording `GitRemote`, invoke at least one emitted tool through the Fae wrapper, and assert the expected remote method and arguments. [rule: skills/regression-evidence/SKILL.md]

**Notes (out of scope but worth flagging):**
- The targeted suite passed: `yarn --cwd packages/fae test test/workspace-tools.test.js test/subagent-host.test.js test/subagent-loop.test.js` (42 tests).

Self-improvement: nothing this time.
