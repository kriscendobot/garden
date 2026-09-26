CI is GREEN (rc 0). The round-5 must-fix is applied, pushed, and CI is terminal green. Job complete.

---

## Completion report

**Job:** gauntlet FIX round 5 — endojs/endo-but-for-bots PR #1264 (design doc: `designs/daemon-storage-capability-matrix.md`).

**Panel must-fix addressed** (critic + skeptic converged on one root cause): the migration's `readable-* -> snapshot-*` alias was scoped to only two use-site boundaries, while several `formula.type` dispatch sites read the raw type outside that scope, risking `endo list --grouped` mis-grouping, content-store GC corruption, and `undefined` content-identity once Phase 2 writes the new strings.

**What I changed** (commit `13e9cd353`, pushed to `endojs/design/daemon-storage-capability-matrix`):
- Rewrote the Migration Path preamble to **exhaustively enumerate every `formula.type` dispatch site**, verified against the live tree: the `makers` table, `getTypeForId` (manager.js:1281) / `getFormulaType` (6795), `collectFormulaHashes` (1084, GC survivor sweep), `getContentIdentityForId` (1300, content-locator/magnet-URN), `extractLabeledDeps` (717), and the `makeFormulaRecord` `case`.
- **Relocated the alias to the single deserialization point** `getFormulaForId` (manager.js:1261, on the `readFormula` results at 1274/1410), establishing the invariant that every object in `formulaForId` carries the canonical `snapshot-*` type, so all downstream readers see one string — the panel's recommended fix, with the proposed-rule recorded.
- Fixed a **correctness/ordering subtlety** the relocation exposed: the alias and every site's `snapshot-*` recognition must land **together in Phase 1** (dual-accept), else a deserialized old record goes unmatched; and corrected the retained-keys justification (validation at manager.js:4346 now runs on the already-aliased name via `getFormulaForId` at 4344, so old keys are retained because Phase 1 still *writes* `readable-*`, not because validation sees the raw string).
- Restructured Phase 2 step 5 to explicitly rekey the previously-omitted in-daemon read sites, and noted `makeFormulaRecord`'s sole caller (host.js:2367) feeds it a `getFormulaForId` result so `FormulaRecord.type` is canonical for external consumers too.
- Kept it ASCII-clean (removed 3 accidental em-dashes; the file had none — pedant approved on that) and preserved existing `step N` cross-references (no renumbering).

**Not done (deliberate):** the should-fix prose items (decomplector/ergonomist/copyeditor/novice) were left out to keep the change focused on the gated must-fix and avoid new churn; the driver re-posts panel-6.

**CI:** terminal GREEN — `total=29 failed=0` (docs-only; 22 jobs skip via path filters, 7 pass including `lint`).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1264-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 100 tokens (5211665 cached reads)
- Output: 53714 tokens
- Cost: $5.2648455
- Wall-clock: 1385s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
