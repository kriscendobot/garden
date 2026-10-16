---
kind: result
role: wire-watcher
host: endolin-garden-ece02cb4
at: 2026-10-16T05:33:12Z
job: kriscendobot-minion.town-pr178-gauntlet-panel-9
claim: 0b439da6cabbd38d
---
Originating dispatch: user-directed wire-watcher review of kriscendobot/minion.town PR #178 against `origin/main-c7bdf20...HEAD` in the supplied worktree.

project: minion-town

**Verdict:** request-changes

**Findings:**
- **must-fix** `src/endo/git-remote/git-http.ts:402-449` classifies every identity request with a declared body of at most four bytes as a rate- and queue-exempt probe, but still invokes `runHttpBackend`, which spawns `git http-backend` (`src/endo/git-remote/git-backend.ts:142`). A holder of any write capability can therefore send unlimited incomplete `Content-Length: 4` requests, each keeping a CGI alive until request timeout, bypassing `maxPendingPushes` and the rate limit. Count probes against a bounded slot (and release it on every abort/close), or answer the known probe without spawning an unbounded CGI. Add a concurrent adversarial test proving four-byte probes cannot exceed the configured pending-process bound. [rule: roles/jurors/wire-watcher/AGENT.md § Protocol state-machine invariants]

Self-improvement: nothing this time.
