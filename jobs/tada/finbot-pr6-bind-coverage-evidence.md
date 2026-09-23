All done. The panel job is confirmed on the remote board (`origin/journal2`), and PR #6 remains draft at the new head. Let me write the completion report.

---

## Completion report — `finbot-pr6-bind-coverage-evidence`

**Task:** Fix the merge-governance must-fix findings on finbot PR #6 (forecast data-sufficiency gate), leave the PR draft, and post a fresh panel on the new head.

### What I did

Worked in an isolated project worktree off the PR head `b663b4f`, pushed two commits, new head **`bdc96c1`**.

**Primary must-fix — provenance binding (the core security fix).** The armed `forecast-data-sufficiency` gate accepted an internally-consistent `dataSufficiency` descriptor from the caller with no tie to the cited forecast, so a forged descriptor could make a thin forecast look covered (reaching both `audit_proposal` and the executor's fire-time re-audit). The descriptor is already a hashed component of the projection artifact (`projectionArtifact` folds it into the JSON that `projectionId` hashes), so:
- `auditor.js` now recomputes `projectionId(forecast)` in the armed gate and requires `proposal.cited_forecasts` to name it — a descriptor swapped onto a thinner/foreign forecast changes the id and fails **closed**. Guarded (returns a verdict, never throws) and read as untrusted input.
- `ooda-cycle.js` cites the forecast's `projectionId` whenever a descriptor is present, so the real pipeline still approves. Gate off → no descriptor → citation unchanged → **byte-identical**.
- This is the sibling of invariant 4's `proposal_hash` recompute and shares its one residual (a wholly self-consistent, *self-cited* artifact is measured, not disproven) — documented honestly.

**Secondary findings:** fixed the `audit_proposal` config-shape doc (`reportDataSufficiency` is `project()`'s *second/config* argument) and the tool/skill/design prose that still said "bounds forgery, not provenance"; added a `--help` options block naming that `--data-sufficiency-min` arms a reject gate.

**Regressions added:** an auditor case proving a fat descriptor swapped onto an uncited forecast fails closed (and pinning the self-cited residual), and an **executor integration regression** proving no steps complete under a forged descriptor at fire time.

### Verification (executed, observed)
- `npm test` — **680 tests / 70 files, 0 failures** (after `npm install`; repo ships no lockfile).
- CLI end-to-end: gate off → APPROVED (byte-identical); `--horizon=20 --data-sufficiency-min=1` → REJECTED on `forecast-data-sufficiency` (coverage 0.450, SCARCE); `--warmup=40 --fit-window=40 --data-sufficiency-min=1` → APPROVED, `[PASS] forecast-data-sufficiency` (binding + coverage both clear).
- GitHub Actions `test` **green** on `bdc96c1`; PR `MERGEABLE`/`CLEAN`, still **draft**.

### Governance handoff
- PR left **draft** (no un-draft, no merge).
- Posted fresh full-panel job **`finbot-pr6-panel-20260801`** on `origin/journal2` (confirmed on board), targeting the current head `bdc96c1`, base `origin/main`. It directs: verify the primary must-fix is genuinely closed, confirm default-off byte-identity, re-examine the other 12 must-fix items from run `4fb530557978`, keep draft, and on a clean pass post `finbot-pr6-signoff` with `role: orchestrator, tier: mentor, no model pin` (per the 2026-08-01 governance annotation that removed the earlier `claude-fable-5` Fable pin — noted because my job body predated that amendment).

### Follow-ups
- The replacement sign-off is intentionally **not** posted by me; it is gated on the new panel passing with no unresolved must-fix.
- If the new panel surfaces the remaining prose/coverage must-fix items (stylist/pruner/purist/engine-realist), they fall to its fixer loop — I scoped this round to the binding + config-shape + CLI findings the job named.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/finbot-pr6-bind-coverage-evidence.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 155 tokens (15180290 cached reads)
- Output: 86113 tokens
- Cost: $12.179222999999999 (1 engagement(s) unpriced)
- Wall-clock: 1464s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
