# investigator on endojs/endo-but-for-bots PR #394 (Node-20 panic test failure; NOT lint)

Repo: endojs/endo-but-for-bots (bot-pushable; bot-repo only, no upstream endojs/endo touch). Standing comment auth applies.

PR #394 (head branch design/gateway-package-phase-6) had its fixer poisoned 5x — because the failure needs Node-20 reproduction the sandbox lacks (only Node 22 available), so a plain fixer re-poisons. Do NOT blindly re-post a fixer.

## The failure (from the shepherd->fixer escalation)
- The shepherd already landed the lint fix (SECURITY.md Github->GitHub sync, commit 3952dd2fd); lint should be green.
- Remaining: 'test (20.x, *)' and 'cover (20.x, *)' crash in @endo/panic. emittery@2.0.0 index.js:780 calls results.values(...).filter(...) — an Iterator.prototype.filter helper ABSENT on Node 20. emittery only hits this path when a listener rejects, i.e. when a test ERRORS. This branch ADDED 4 tests to packages/panic/test/index.test.js (+49 lines vs master): 'panic using globalThis.panic (XS fallback)', 'panic without console.error' (sets globalThis.console = undefined), and edits to 'panic last resort'. One errors on Node 20 (they pass on Node 22). Panic passes on master (which lacks these tests).

## Your task
Diagnose WHICH added test throws on Node 20 and WHY, reasoning from the diff and the panic source (index.js logic is version-agnostic; the throw is likely one added test's setup, e.g. globalThis.console = undefined interacting with the Node-20 path). Propose the minimal fix (guard the added test for the Node-20 environment, or fix the underlying panic path). If you can obtain Node 20, verify; if not, land a best-effort fix clearly marked 'NOT verified on Node 20 — needs CI confirmation' per COMMON.md Reporting, and post a summary on #394. If the cause is genuinely undiagnosable without Node 20, report that precisely to the maintainer inbox rather than guessing.

Provenance: liaison residual sweep of the reaper POISON backlog (pr394-fixer).
