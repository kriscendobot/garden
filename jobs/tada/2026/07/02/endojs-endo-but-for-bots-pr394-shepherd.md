The new CI run for my pushed SHA is classified **"CI (docs-only)"** — since the push only touched SECURITY.md files, the path filter skips the heavy test matrix (the full matrix, with my lint fix, will run on the fixer's next code push). My work here is complete: deterministic fix landed, remainder diagnosed and escalated.

Completion report:

---

**Shepherd on endojs/endo-but-for-bots PR #394 — complete (fixed in-scope, escalated rest)**

**Live CI state (re-fetched):** RED across `lint`, `test (20/22/24 × ubuntu/macos)`, `cover (20/24)`. Diagnosed into three distinct root causes — one deterministic (fixed), two systemic (escalated).

**Fixed and pushed (commit `3952dd2fd` on `design/gateway-package-phase-6`):**
- **`lint`** failed on `scripts/check-security-md.sh`: packages `bytes`, `gateway`, `hex` carried the stale `"Github"` SECURITY.md variant while the branch's majority/canonical is `"GitHub"`. Synced all three to canonical (single-char capitalization only). `bash scripts/check-security-md.sh` now exits 0 locally. Pushed via rebase-CAS under bot identity.
- Note: because the push touched only SECURITY.md, CI classified it **docs-only** and skipped the test matrix; the full matrix (with lint now green) runs on the next code push.

**Escalated to fixer — `next: fixer`** (posted job `endojs-endo-but-for-bots-pr394-fixer`, identity-deduped). The remaining failures are real, in the branch's own diff (from ancestor design-stack phases, not phase-6's gateway work), and need reproduction on Node versions I lack locally (only Node 22 here) plus core-library context — a contextual/missing-context impasse, not a shepherd surgical fix. Master's "CI" workflow is green with the same ava@8.0.1/emittery@2.0.0, so these are branch-introduced:
  1. **Node 20** (`test`/`cover` 20.x): `@endo/panic` test crashes with `results.values(...).filter is not a function` — emittery@2.0.0's error-emit path uses `Iterator.prototype.filter` (Node 22+ only). Triggered by 4 panic tests this branch added (+49 lines); one errors on Node 20 (they pass on 22, which fails elsewhere), masked by the emittery crash.
  2. **Node 22/24** (`test` 22/24.x, `cover` 24.x): systemic `AssertionError: null == true` at **module load** across ses-ava test files (`zip`, compartment-mapper's `hardened-module-source`/`module-source`/`preserve-format`, `promise-kit`) — a shared top-level feature/ponyfill detection asserting false on newer Node. The zip package also got a 733-line deflate/inflate rewrite on this branch; its module-load failure may be its own detection code — triage both.

**Follow-ups for the fixer** (full inventory, hypotheses, and what I already tried are in the posted job body): reproduce on Node 20 and Node 22/24; fix the erroring panic test and the shared `null == true` detection without deleting/skipping tests.

Inbox drained (empty). Isolated project worktree left in place for the fixer/requeue continuity.
