CI is terminal GREEN (rc 0, 5/5 checks passing). The round-5 fix stage is complete.

## Completion report

**Round-5 FIX stage for endojs/endo-but-for-bots PR #997** (design-only PR: `designs/worker-retention-and-revocation.md`). Applied the panel-5 must-fix items once, pushed as a follow-up commit, watched CI to terminal green, and posted the required summary comment.

**Pushed:** commit `8fa1f5c51` to `kriscendobot:design/worker-retention-and-revocation` (safe-push advance mode, `78863ae6f → 8fa1f5c51`).

**Must-fix items applied:**
- **CapTP `answers`-survival trace** (wire-watcher/prover/engine-realist/breaker/saboteur/warden/migrator/spec-keeper/assessor): corrected the attribution to the *unconditional* key-namespace mismatch (`answers` keyed `q-N`; `CTP_DROP` deletes `reverseSlot` → `q+N`) rather than the contingent `gcImports` default; recorded a **second, distinct `@endo/captp` prerequisite** (a bounded answer-retirement authority).
- **DD6 conjunct (iii)** (assessor): rebound to the final-release mutation, not resolution.
- **Conjunct (ii) signal** (saboteur/breaker/engine-realist/migrator): named the cross-peer retention-set `remove` (`manager.js:1602`), not `op:gc-exports`; stated the residual and scoped the row-3 tax claim.
- **`provideImport`** (curator/surfacer/migrator): corrected to `@endo/ocapn`; new seam is a `makeCapTP` option beside `makeDefaultCapTPImportExportTables`.
- **`WorkerDiscipline`** (curator/stylist/typist/purist): optional `discipline?` field (avoids `kind` collision), named module + default, `'orthogonal-persistence'` tag.
- **`Endowment` split** + guest `{id,release}` return + `LivePresence` admissibility (purist/locksmith/typist/surfacer/warden/curator), with amendments recorded to the chat-slot sibling design.
- **Q6** enumerated all ten guest-reachable methods (warden).
- **Session-unique** `question:<session>:<answer-pos>` edge (saboteur/corner-prober/purist/breaker).
- **Admission cap** over growing union-find groups + per-peer bound (saboteur/breaker/corner-prober).
- **Injected lease clock** power / XS timer (transplanter).
- **Worked example** fixed to real API (typist).
- **`## Test Plan`** section added (fast-checker).
- **README** glyph sweep reverted, ambiguous "Current totals" named by date, layering-note surfaces synced (packager/integrator/pruner/archivist).
- **Citation drifts** fixed; **tree-grounded-citations rule** landed in `designs/AGENTS.md` (scribe).

**Declined:** stylist's doc-title rename (broad should-fix); comment-only stylistic nits.

**Summary comment:** posted at PR #997 (`#issuecomment-5306959409`).

**CI:** terminal GREEN — browser-tests, build, lint, test, zizmor all pass (rc 0).

Per the stage brief I did not re-run the panel; the driver re-posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr997-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 161 tokens (16566165 cached reads)
- Output: 63994 tokens
- Cost: $13.803440250000005
- Wall-clock: 1077s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
