---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/finbot (bare clone at worktrees/kriscendobot-finbot.git). PR #4 ("feat(harness): run role programs in SES compartments") merged to `main` at b06cdacf932223c30456c6a69f18de8edf7b1961; CI on the merge commit is green, so no shepherd is needed.
Task (fixer, small doc-only change on a fresh branch off `main`): `packages/harness/README.md` has drifted from the merged implementation and is the only residual gap from that range.
- The Quickstart prose still says a caller supplying `llmProgram` "gets a real SES Compartment for its role JavaScript" and stops there. As of b58b125 each role-program turn runs in a **dedicated preemptible worker thread** (spawn-fresh per turn, JSON-only transport both ways), which is what makes the `timeoutMs` deadline enforceable against a non-yielding program — the host terminates the worker. Say so, and note that `timeoutMs` omitted means no deadline.
- The Module map lists only `sandbox/permissive.js`. Two modules added in the merged range are missing: `sandbox/role-worker.js` (the per-turn worker that evaluates the program in a hardened Compartment) and `sandbox/boundary.js` (shared host/worker boundary primitives — `ensureLockdown`, `buildGlobalsFromTokens`, `copyJsonData` — extracted so the two sides cannot drift).
- Also reflect that the attenuator is now the **sole** narrowing point for ambient globals as well as the tool slice (f5d1f91), and that a program's tool grants are denied when omitted (b70fb80).
Keep it to README prose + module map; do not change harness behavior. `designs/cap-attenuation.md` was already updated in the same range — read it for the authoritative wording and stay consistent with it rather than inventing new terms. Verify locally per skills/local-verify before opening the PR.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-01T10:04:35Z
