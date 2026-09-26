Done.

## Completion report — `fu-scholar-ingest-erights-4-2`

**What the job asked:** Add the missing `### erights--elang-same-ref` nav block to `library/sections/README.md` (journal2). The two same-ref section files already exist and are linked from the `e-language` topic page, but had no block in the flat sections index — breaking the navigation backstop `library-link-check.sh` resolves.

**What I did:**
- Located the live state via read-only `git show origin/journal2:…` (never touched the WIP-laden `/home/kris/journal` worktree). Confirmed both child sections exist on disk (`erights--elang-same-ref--synchronous-sameness-and-reflexivity.md`, `erights--elang-same-ref--selfish-and-selfless-objects.md`), neither is a `kind: index` parent, and the `### erights--elang-same-ref` block was absent from the ~2.9 MB index.
- Built the new README from the **current** journal2 tip and inserted a two-item block at the correct alphabetical slot — between `### erights--elang-quick-ref` and `### erights--elib-capability-ode-ode-pki`. Listed in source-page order (synchronous-sameness, then selfish-and-selfless), matching the hand-authored convention of the neighboring erights blocks.
- Verified the diff was **exactly** the 5-line block (no other lines touched).
- Landed via `land-journal-edit.sh` (isolated producer-clone sync + CAS push), the sanctioned path for a library content edit.

**Verification:** Landed commit `dcddf1091` on `origin/journal2`. Re-fetched the tip and confirmed it is byte-identical to my intended body (no concurrent clobber / silent loss) and the block resolves. Inbox was empty at the checkpoint. Temp files cleaned up.

**Follow-ups / notes:**
- I deliberately left the `Total section files: 5840 …` header count untouched — it's hand-maintained narrative and adjusting it accurately needs a full corpus scan that's out of this job's scope.
- Larger context worth flagging: `scripts/jobs/regenerate-sections-index.sh` (+ its test) sits **untracked** at the root checkout — an in-flight effort to make this index a deterministic projection so it's never hand-edited again. It is not committed to `main2`/`origin/main2` or deployed. My fix is a stopgap consistent with current hand-maintenance; once that regenerator lands and runs, it will recompute the whole index (including the count) and supersede manual blocks like this one.
