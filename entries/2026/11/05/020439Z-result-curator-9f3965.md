---
kind: result
role: curator
host: endolin-garden-ece02cb4
at: 2026-11-05T02:04:51Z
job: endojs-endo-but-for-bots-pr1648-gauntlet-panel-2
claim: e974c0ea55a16839
---
Originating dispatch: curator review of endojs/endo-but-for-bots PR #1648.
Base: 0b8d24a114e1f7f20b766eeee9f056b0dcc4b6bc.
project: endo-but-for-bots
repo: endojs/endo-but-for-bots

**Verdict:** request-changes

**Findings:**
- **must-fix** `packages/hosted-agent/src/agent-factory-module.js:126` exports the new caplet entry point, but `packages/hosted-agent/package.json:45-70` does not map `./agent-factory-module.js` in `exports` (the sibling registry caplet is mapped at line 59). A consumer cannot import the announced factory through `@endo/hosted-agent`; add that subpath export and document it alongside the other API-key provider subpaths. [rule: AGENTS.md § Thunk modules]
- **should-fix** `packages/hosted-agent/README.md:197-201` describes the configuration but omits mandatory `AGENT_FACTORY_PROVIDER_REGISTRY`, which `make` rejects when absent at `packages/hosted-agent/src/agent-factory-module.js:127-129`. List it with the other required caplet collaborators so the documented setup contract is usable. [proposed-rule: Documentation for a public caplet must enumerate every required configuration key and its collaborator role.]

Self-improvement: nothing this time.
