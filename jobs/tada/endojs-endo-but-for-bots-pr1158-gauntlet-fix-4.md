CI is GREEN (rc 0). The fix stage is complete.

## Completion report

**Job:** gauntlet FIX round 4 — endojs/endo-but-for-bots PR #1158 (`design(exo-db): define portable passable databases`)

Applied the round-4 panel's must-fix and should-fix items to `designs/exo-db.md` (and one `designs/README.md` fix), pushed as a review-feedback follow-up commit (`bebe3240f..0fed284fd`) to the PR head `kriscendobot:design/exo-db`, and watched CI to terminal: **GREEN** (5/5 checks, 0 failed).

**What changed, by seat:**
- **critic** — (1) scoped the pending-mutation intent to `(database formula, row key)` so intents living in the shared `endo.sqlite` disambiguate which per-database sidecar to reconcile; propagated the three-part `(database formula, key, formula)` ledger tuple through steps 2/4/5, the impl plan, and decision 8. (2) Added a "Physical mapping and the multi-tenant table count" subsection: the DynamoDB single-table design is now a considered-and-scoped alternative against AWS's 2,500-table quota (keeps `Open questions: None` valid).
- **skeptic** — (1) widened predicate comparands from `JsonScalar` to a new `Comparand` type so `where` clauses can target full-range `int64`/`float64` narrow columns. (2) Added the inline synchronous (non-crash) write-failure compensation path, plus two verification-plan tests (non-crash failure release; two-formula same-key independent reconciliation).
- **decomplector** — exported a pure `keyOf(schema, row)` helper bridging the whole-row vs reified-`{partition,sort}` key shapes; demonstrated it in the worked example.
- **ergonomist** — renamed `between`'s `low`/`high` to `min`/`max` (removing the collision with the sort-key `Bound` `low`/`high`); split `ConflictError` into `RowExistsError`/`RowMissingError`; added `openTable` to `DatabaseAdminInterface`.
- **copyeditor / pedant** — band-name capitalization made consistent (`Narrow`/`JSON`/`Passable`); `broad-passable` → `Passable`; GSI glossed at first use; `p`/`s` forward pointer to the physical-schema section; "formula-and-pet-name graph" parse fix; README `3-4-week` compound-modifier hyphenation.
- **novice** — glossed the Smallcaps body-and-slots model at first use; added a concrete `float64` byte-transform worked pair (`-1.5` vs `2.5`); added a guard-reading on-ramp before the interface block.
- Also removed the redundant `materialize: { at: ['at'] }` from the worked example (skeptic note). Verified no em-dashes / smart quotes / other non-typist code points were introduced.

**Follow-ups:** none; per stage protocol I stopped after CI green without re-running the panel (the driver re-posts panel-5).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1158-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 120 tokens (5406834 cached reads)
- Output: 35706 tokens
- Cost: $4.6632
- Wall-clock: 896s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
