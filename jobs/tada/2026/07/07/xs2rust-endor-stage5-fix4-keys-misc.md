Curated gate passes (1711/1711); all 92 byte-identity fixtures pass. The job was already complete before the reaper requeue.

## Completion report — `xs2rust-endor-stage5-fix4-keys-misc` (fix4 3/4), resumed

This was a reaper requeue of a session that had **already finished and pushed all work**. On resume I verified the landed state rather than redoing it: all four of my commits are present on `origin/xs2rust-endor` (tip `d93d2a4ee8`), the working tree is clean (only the never-committed `c/moddable` oracle pin shows modified), and every bar re-measures green.

**Landed commits (all on `origin/xs2rust-endor`):**
- `4008e834de` — slices 1+4: `fxPropertyName` numeric-key `fxNumberToIndex` classification (non-index number → canonical `fxNumberToString` symbol / `NEW_PROPERTY`) + the index-boundary wrap fix (in-range index above `i32::MAX` → `NUMBER` node via `push_property_index`).
- `c4a8eabb19` — slice 2: `arguments-callee` root-caused as NamedEvaluation of an anonymous class *with a heritage*; the inferred name is now held across heritage evaluation so it binds the constructor, not the heritage `function(){}`.
- `2430f0c806` — slice 3: captured named-function self-name coded as a closure (`NEW_CLOSURE` + `CONST_CLOSURE_1`), closing the `tco-call-args` "captured function name deferred" fold.
- `d93d2a4ee8` — README fix4 3/4 record.

**Bars re-verified on the tip:**
- `statements/class`: divergent=0, endor-rejected=0 ✓ (was 5 divergent)
- `expressions/class`: divergent=0, endor-rejected=0 ✓ (was 4 divergent)
- `expressions/call`: divergent=0, endor-rejected=0 ✓ (fold closed; also cleared `expressions/function`'s 3 `scope-name-var-*` rejects)
- Curated corpora: 1711/1711 divergent=0 (gate passes) ✓
- Byte-identity fixtures: 92 pass, including the 4 new fix4 fixtures ✓
- `#![forbid(unsafe_code)]` intact ✓

**Honest remainder (out of scope, unchanged):** `expressions/arrow-function` carries 6 pre-existing `scope-param-*-var-*` / `scope-body-lex-distinct` divergences — a separate scoper fold, confirmed pre-existing (stash-and-measure) and documented in the README fix4 3/4 note. No new/unattributed divergence anywhere.

Nothing further to do — the job is complete.
