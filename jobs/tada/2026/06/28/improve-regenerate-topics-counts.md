Inbox empty. Work complete.

---

## Completion report

**Job:** `improve-regenerate-topics-counts` — make the per-topic Sections-count column in `library/topics/README.md`'s Index a deterministic projection of the committed corpus.

**What I did** (in an isolated worktree off `origin/main2`, per the garden-infra-jobs norm; committed and pushed to `main2` at `86157f371`):

1. **Added `scripts/jobs/regenerate-topics-counts.sh`** — a sibling of `regenerate-sections-index.sh` sharing its contract exactly:
   - `--check` (regenerate in-memory, diff against committed README; exit 0 current / 1 stale or missing-page / 2 anchor-setup error — CI/gate form), `--print` (stdout, no network/write), `--land` (default; `ensure_clone`/`sync_clone` via `common.sh`, regenerate, land via `land-journal-edit.sh library/topics/README.md`, idempotent no-op when current, exit 75 on transient sync outage).
   - For each Index row, the authoritative count is the number of `| [...` section data rows under the topic page's `## Sections` heading. Rows whose count is the literal `(meta)` (e.g. `spec-to-implementation`, `references`) pass through verbatim and are never recounted.
   - Robust to abstracts containing escaped pipes (`\|`): the count cell is isolated via the ` | ` cell separator (which an escaped pipe never produces), so link + abstract columns are preserved byte-for-byte. The `## Index` header is the splice anchor (refuses with exit 2 if absent); the table ends at the next `## ` heading. A non-`(meta)` row naming a missing topic page is the blocking completeness failure (exit 1), mirroring the sections regenerator's DANGLING check.
   - Verified against the live corpus: it correctly flags the real drift (52 changed lines — e.g. `testing` 20→22, `errors` 33→44, `capability-theory` 40→60), preserves the huge `capability-theory`/`references` abstracts, and passes `(meta)` rows through.

2. **Added the paired test** `scripts/jobs/test/regenerate-topics-counts-test.sh` (hermetic throwaway library; 10 assertions, all passing): reconciliation, `(meta)` passthrough-when-page-absent, escaped-pipe abstract preservation, preamble/tail preservation, idempotence, missing-page failure, and missing-anchor refusal.

3. **Wired the scholar gate** (`roles/scholar/AGENT.md`): `--land` as a final landing step in step 9 alongside the sections-index regen; `--check` into the integrity gate (step 8); and clarifying notes in step 6 ("add Index rows by hand but don't hand-count the Sections column") and the Done section.

**Why:** Two independent 2026-06-28 cycles (results 173121Z, 174820Z) each hand-corrected multi-dozen-row count drift and both flagged the need for exactly this deterministic reconciliation — the same "impractical and risky" hand-edit that `regenerate-sections-index.sh` eliminated for the flat index.

**Follow-ups (optional, not in scope here):**
- `regenerate-sections-index.sh` has a periodic safety-net timer (`garden-regenerate-sections-index.{service,timer}`, from job `improve-periodic-sections-index-regen-timer`). A parallel `garden-regenerate-topics-counts` timer would give the same belt-and-suspenders coverage independent of the scholar gate; I left it out since this job only asked for the gate wiring.
- shellcheck flags `SC2034 GARDEN_TAG appears unused` — a false positive (it's read by `common.sh`'s `log()`/`die()` via `${GARDEN_TAG:-jobs}`), identical to the sibling script; no action needed.
