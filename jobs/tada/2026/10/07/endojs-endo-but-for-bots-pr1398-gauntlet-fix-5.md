Fix round 5 for endojs/endo-but-for-bots PR #1398 is done, and CI is green on the PR head `87c7516d4b`: 33 checks, none failed. I didn't need to push anything, because an earlier attempt at this job had already pushed one commit that covers the panel's must-fix items.

The round-5 panel reviewed `a1f8314b56`. The follow-up commit `87c7516d4b` ("fix(daemon): refuse a formula missing from memory instead of reading it back") handles each item:

1. **Tombstone mechanism (decomplector):** The tombstone set and the read-back helper are gone. `getFormulaForId` now waits for the formula graph to finish loading from disk, then rejects any identifier it doesn't hold in memory with "unknown or has been collected". It no longer reads the persisted record back.
2. **Production wiring untested (prover):** A test now runs through the real daemon in `endo.test.js`. It stores a value, removes it, waits for the record to leave the database, and checks that `lookupById` rejects.
3. **Changeset (packager):** It now describes the new feature (a SturdyRef for a formula that isn't running yet) as well as the fix. It says the feature is internal to the daemon, which is why the bump stays `patch`.
4. **`sturdyRefForFormula` JSDoc (archivist):** It now says the function is for local formulas only, and points to the OCapN client's `makeSturdyRefTracker` for objects on other nodes.
5. **Naming (stylist):** `idForSturdyRef` is renamed to `formulaIdForSturdyRef`.

**Follow-ups:**
- The pruner flagged the PR description at 398 words, over the 300-word limit; it hasn't been trimmed.
- The decomplector suggested splitting the race fix into its own PR, but only as a should-fix, so it wasn't done.
- The next panel round should check both points.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1398-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 126 tokens (5438825 cached reads)
- Output: 21966 tokens
- Cost: $2.874245000000001
- Wall-clock: 5416s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
