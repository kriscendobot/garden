# Shepherd kriscendobot/agoric-sdk PR #7 to green (maintainer directive)

**Repo:** `kriscendobot/agoric-sdk` (BOT FORK; bot identity). **Never** touch upstream
`agoric/agoric-sdk` — no upstream links/comments; all artifacts on the fork.
**PR:** https://github.com/kriscendobot/agoric-sdk/pull/7 — *fix(internal): XS-safe hex
decoding table (bounded loop) + Bufferish codec validation* — DRAFT, base `master`,
MERGEABLE/UNSTABLE.

**Maintainer directive** (kriskowal, 2026-06-30T22:30Z, PR comment): **"@kriscendobot Shepherd."**
→ drive CI to green (`skills/pr-ci-watch`, `ci-failure-classification-loop`).

**Current red checks (rest green):**
1. **`test-codegen`** — the known **stale generated `packages/orchestration/src/fetched-chain-info.js`
   on `master`** (the "pre-existing red explained" in the 2026-06-29 shepherding summary).
   A fix is **in flight**: job `agoric-sdk-fork-regen-fetched-chain-info-master` opens a PR
   regenerating it on master. **Shepherd:** check whether that regen has **merged to master**;
   if yes, **rebase #7** onto master to pick it up (clears `test-codegen`); if not yet, leave
   it as the explained pre-existing red — do NOT smuggle the regen into #7's own diff. (A
   prior `agoric-sdk-fork-rebase-pr-7` job exists — coordinate / dedup, don't double-rebase.)
2. **`test-quick (node-old)`** — a **separate** failure; read the actual job log, diagnose,
   and drive it green. If the fix is out of shepherd scope, **escalate to a fixer** (the
   standing shepherd→fixer auto-chain) rather than stopping.

**Deliverable:** CI green (or every residual red a deliberately-explained pre-existing one),
and a **CI shepherding summary comment** on #7 (what was red, what you changed, final status,
any explained-residual red). Keep #7 DRAFT unless the chain naturally un-drafts it.
