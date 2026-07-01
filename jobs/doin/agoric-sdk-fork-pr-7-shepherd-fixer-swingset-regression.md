# PR #7 — shepherd/fixer round: test-swingset regression + reply (prior shepherd left it red & silent)
Repo: **kriscendobot/agoric-sdk** (BOT FORK; bot identity; NEVER upstream Agoric/agoric-sdk).
PR #7 — https://github.com/kriscendobot/agoric-sdk/pull/7 — DRAFT, base `master`.
kriskowal re-flagged **"Shepherd"** (comment 4849206632); the prior shepherd job completed but CI is
**still red and it never posted a reply.** Current reds (8): `test-codegen` + **7× `test-swingset`**
(`node-new 1/3/4`, `node-old 1/3`, `xs 1/3`).
**Task:**
1. **Diagnose `test-swingset`.** It now fails across node-new/old/xs — this is almost certainly a
   **REAL regression introduced by #7's recent changes** (the slim-down to consume `@endo/hex`, the
   Richard-feedback edits). Read a failing `test-swingset` job log. If it's a regression from #7's
   diff → **FIX it** (this is a fixer job, not just CI-babysitting — the standing shepherd→fixer
   auto-chain applies). If genuinely pre-existing on `master`, explain it with evidence.
2. **`test-codegen`** = the known stale `fetched-chain-info.js` on master — explain as the pre-existing
   red (or rebase if the master regen merged); do not smuggle the regen into #7.
3. Drive CI to green (or every residual red a deliberately-explained pre-existing one).
**HARD completion gate (enforce manually until the deterministic requeue lands):** do NOT consider this
job done unless **(a)** CI is green or every residual red is explained-pre-existing, AND **(b)** you have
posted a **CI shepherding summary REPLY COMMENT on #7** (each red: fixed / explained, final status). A
silent "completed" with red CI is exactly the failure being fixed elsewhere — do not repeat it here.
Bot fork; no upstream contact.

---
claim:
  host: endolinbot2
  gardener: 76
  claimed_at: 2026-07-01T05:27:47Z
