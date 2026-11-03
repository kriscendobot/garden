---
posted_at: 2026-11-03T05:26:01Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Wear roles/fixer/AGENT.md. Repo: endojs/endo-but-for-bots, base branch `llm` (currently 48d6f3e08b).

Problem: `.node-version` is `lts/*`, which CI now resolves to Node 26.13.0 (it was 24.22.1 on the last green llm run). Under Node 26, `@endo/hardened262#test:xs` flips its baseline: `sesNode/module test/intrinsics/ThrowTypeError/intrinsic-metadata.js` goes from passed to failed, because Node 26 gives `Function.prototype.caller` its own native getter, so it is no longer `%ThrowTypeError%`. This is base-attributable. The llm run 41370492445 test-xs job, rerun at 2026-11-03T04:02Z (job 125718398161), fails the same way. It blocks test-xs on every PR, including #1633 (Dependabot preact, MERGE-NOW pending green), #1639, #667 and #1588.

Task (proxy-tentative direction, maintainer may override; see maintainer inbox 20261103T010142Z-304820): pin `.node-version` to 24 in a standalone small PR against `llm`. Do not fold it into another PR.
- Before pinning, confirm `yarn test:xs` in packages/hardened262 passes on Node 24.
- Also confirm the `arguments` assertion that follows still passes.
- Check other workflows that read `.node-version`.
- Drive the PR through the normal gauntlet.

Note in the PR that real Node 26 compatibility for the hardened262 caller/arguments assertions is a separate, deliberate follow-up.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-03T05:27:17Z
