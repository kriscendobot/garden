Memory updated (the body edit landed; the timestamp metadata is cosmetic). Job complete.

## Completion report — `endo-npm-cas-registry-press-20260801-150502`

**Tick outcome: assess → demonstrate finish line → escalate the one blocking maintainer ruling.** No new code pressed this tick, by design — the next increments are either owned by live shepherds or gated on a maintainer decision.

**What I did:**
1. **Re-assessed, didn't assume.** Read the design doc at current llm HEAD (`3ec55851d`, #873 merged). The design now records **all 5 phases landed**, plus process-shim (#859), peer/optional deps (#857), and workspace-protocol resolution (#873). The arc has moved well past the phases named in the (older) job spec — it's now in real-world-package hardening.
2. **Demonstrated the finish line with real-execution evidence, fresh state (no cache).** Reused the sibling press worktree's prebuilt release binary. Ran `endor run entry.js` where the entry `require('is-odd')`:
   - Cold resolve built `registry.db` from scratch and fetched **is-odd@3.0.1 → is-number@6.0.0** from the npm registry, CAS-stored (hashes cited), MVS-selected.
   - Executed in XS → `is-odd(3) = true` / `is-odd(4) = false`.
   - `endor run --offline` replayed **identical output with zero network** (registry-table + CAS only).
   - App dir had **no `node_modules`, no lockfile** — only `entry.js` + `package.json`. `endor registry list` showed both `(name,version)→CAS-hash` rows. **This is the literal finish line.**
3. **Found the frontier is blocked on one ruling, and confirmed it live.** `endor run nanoid@5.1.16` (default build) reproduces `import webcrypto not found` on current HEAD — the exact precipitating case of **#879** (design-only, ~4 ticks awaiting a maintainer ruling on the archive's runtime identity: default `exports` condition set + whether to endow `Buffer`). The dependent code PRs (#876 `--conditions`+webcrypto, #877 dual-build, #878 URL globals) are draft under **live shepherds (pr876/pr878-shepherd)** — I deferred to them.
4. **Escalated #879 to the maintainer** (via the liaison) with the finish-line evidence, the reproduced nanoid failure, the three candidate policies, and an offer to run the corpus experiment #879's test plan describes.
5. Updated the `npm-cas-registry-arc-state` memory; cleaned scratch temp dirs; inbox drained empty.

**What changed:** nothing in the garden repo or the project repo (no push). This was a verify-and-unblock tick.

**Follow-ups:** (a) Maintainer ruling on #879 is the single gate for the remaining global-endowment code. (b) If the maintainer wants data, the corpus experiment (resolve N popular dual-build packages both ways, count "only default works" vs "only browser works") is the concrete next press. (c) Build gotcha still holds — reuse a sibling press worktree's release `endor` rather than rebuilding the `c/moddable` submodule.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-npm-cas-registry-press-20260801-150502.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2126870 cached reads)
- Output: 21979 tokens
- Cost: $2.3198229999999995
- Wall-clock: 396s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
