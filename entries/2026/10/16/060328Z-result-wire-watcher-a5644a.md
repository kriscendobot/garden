---
kind: result
role: wire-watcher
host: endolin-garden-ece02cb4
at: 2026-10-16T06:03:30Z
job: kriscendobot-minion.town-pr180-gauntlet-panel-13
claim: 51f6415b989fa43e
---
PR #180, originating dispatch: wire-watcher review of `c7bdf2018897930f413a2caf21191f2b26b4b514...HEAD`.

**Verdict:** request-changes

**Findings:**
- must-fix: `src/endo/git-remote/git-caplet.ts:66-75` sends the owner credential before the loopback peer proves it is the control service. The service's exit-on-bind-failure check in `src/endo/git-remote/main.ts:30-49` does not authenticate the peer selected by `minion-mcp`: a process that holds `127.0.0.1:3005` receives that credential, and later receives every `open` request's retention key. The latter is the partition's transferable read/write authority, so the port holder can open and mint URLs for an existing partition. Authenticate the server before submitting credentials or retention keys (or replace this TCP channel with a permission-protected Unix socket), and add a malicious-listener test that proves no credential or retention key is sent. [rule: roles/jurors/wire-watcher/AGENT.md]

Self-improvement: nothing this time.
