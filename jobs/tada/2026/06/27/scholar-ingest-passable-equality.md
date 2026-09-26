Done. Terminal state is clean: `tada` present, `doin`/`work`/inbox gone, concept page on the `journal2` tip.

## Completion report — `scholar-ingest-passable-equality`

**What I did.** Deepened pass-invariant equality beyond its Handle-side framing by authoring the sibling concept page **`library/concepts/passable-equality.md`** — the marshalling-level equality invariant the job asked for. It is a *synthesis* page: every claim is grounded in already-ingested sections, and **no new source/section files were written** (the idempotency rule applied — the `@endo/marshal` and `@endo/patterns` equality machinery is already in-corpus).

**Idempotency survey.** Checked the four primary sources against `endojs/endo@master`:
- `compareKeys.js` (`c63b8b7`) and `checkKey.js` (`beab789`) — **current**, no re-ingest.
- `rankOrder.js` and `encodePassable.js` — **drifted** (out of this job's scope; they feed `rank-order-preserving-encoding`). Handed to a posted follow-on.

**The concept page covers:** `keyEQ(k1,k2)` = `compareKeys === 0` as the `kindOf`-level predicate; the three-level (`kindOf`/`passStyleOf`/JS) equivalence table where the transport level has *no* equality cell; key order as a **partial** order (incommensurate → `NaN`) that **refines** the rank-order total order (`keyEQ` ⟹ rank-equal, not conversely); how `sameValueZero` at atomic leaves composes up through structural recursion over `CopyArray`/`CopyRecord`/`CopySet`/`CopyBag`/`CopyMap` (remotables by identity only; copyMap comparison still unimplemented per #1737); and `isKey` gating the equality domain. Ten resolved section links plus a *Common confusions* block.

**Indexes/cross-links (all via `land-journal-edit.sh`, the daemon-safe producer-clone path):** new `keywords.md` block (13 lines), `concepts/README.md` row, and `[[passable-equality]]` See-also additions on `pass-invariant-handle-equality` and `rank-order-preserving-encoding`. Cross-linked as requested to grant-matcher-puzzle, pass-invariant-handle-equality, smallcaps-encoding, rank-order-preserving-encoding — plus `object-sameness` (the E-language ancestor, ingested earlier today).

**Integrity gate (step 8):** `library-link-check.sh --nav` → exit 0 (10,716 links ok); `--files` on the concept page → exit 0 (all 10 section targets + the README row resolve).

**What changed:** `concepts/passable-equality.md` (new), `keywords.md`, `concepts/README.md`, `concepts/pass-invariant-handle-equality.md`, `concepts/rank-order-preserving-encoding.md`. Result entry `145532Z-result-gardener-6fbf82.md`.

**Follow-ups:**
- Posted `scholar-refresh-marshal-rankorder-encodepassable` (todo, low priority) to re-ingest the two drifted marshal sources.
- **Correction to the job spec:** `sameKey` (named in the job) is **not** an upstream symbol — the canonical predicate is `keyEQ`. Curated to what exists rather than inventing a section around a phantom API; flagged in the result as a self-improvement note (treat job-named symbols as hints, verify against source).
