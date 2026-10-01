# Fix round 6 for endojs/endo-but-for-bots PR #1390: all four must-fix items applied, CI green

I pushed four follow-up commits to `build/pet-name-path-only`, moving the head from `15f46bb218` to `784decdc7a`. CI finished green: 33 checks, 0 failed, and `ci-wait-merge.sh` returned 0.

**Must-fix items applied:**
1. **`adopt` key mismatch (surfacer), commit `f1157d6f5a`.** In `@endo/lal`, `adopt`'s `petName` is now `petNamePath` in the tool schema, the summary, the dispatcher's destructuring and its error text. It now matches the primer.
2. **Half-done `*Name` → `*NamePath` rename (stylist).**
   - **lal, commit `f1157d6f5a`:** I renamed every tool argument that holds a path:
     - `request`/`send`: `recipientName` → `recipientNamePath`, `responseName` → `responseNamePath`
     - `evaluate`: `workerName` → `workerNamePath`, `resultName` → `resultNamePath`

     The schemas, dispatcher, `primer/tools.md`, `primer/capabilities.md`, `LAL-ARCHITECTURE.md` and the tests all use the new keys. I also fixed examples that still passed bare strings, such as `send("@host", …)` and `evaluate('@main', …)`.
   - **Daemon help text, commit `f619b4f5e0`:** the signatures for request, send, form, adopt, invite, accept, evaluate, makeUnconfined, makeArchive and endow now use `*NamePath` parameter names. The `endow` bindings example now maps a slot to a path (`["my-counter"]`) instead of a string.
   - **Kept on purpose:** the `MakeCapletOptions` record keys `powersName`/`resultName` keep their names, so callers of that record don't break. The changeset now says so explicitly.
3. **`evaluate-dispatch.test.js` tested nothing this PR changed (prover), commit `98c6f12016`.** The test's stub now narrows its inputs with the daemon's real `namePathFrom`, so reverting that function makes the bare-string tests fail. It also checks the renamed keys, including that the old `resultName` key is rejected.
4. **Stale design doc (integrator), commit `784decdc7a`.** I updated the `EndoDirectory` row of the table in `designs/fs-interface-consolidation.md` and added a note: the guard still admits a string, but `namePathFrom` refuses it.

Also from the should-fix list: the typist's item is done. `ToolCallArgs`' path fields are now `NamePath | string`, and `petNames` is `(NamePath | string)[]`.

Locally, the lal tests (59 passed, 1 skipped), the daemon `help-text` test, lal lint (0 errors) and the repo-root `tsc` (no errors in the changed files) all pass.

**Should-fix items not addressed, for the next panel to judge:**
- The `scratch-` label in `makeUnconfinedFromTree` can exceed the 255-character pet-name limit.
- `spaces-util` turns tokens into paths with `split('/')`.
- The `@host` retry hint from `petNamePathFrom` suggests a path that is then refused.
- There are no tests for `Inspector.lookup`.
- Other roadmap design docs still mention `NameOrPathShape`.
- Two commits share a subject line; retitling one needs a history rewrite.
- No property test was added for evaluate dispatch: lal has no fast-check dependency.
- The `namePathLabel` docstring still says "Encodes".

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 98 tokens (4752392 cached reads)
- Output: 20836 tokens
- Cost: $2.2977503999999995
- Wall-clock: 3759s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
