Fix round 3 for PR #1412 is pushed and CI is green: all 33 checks passed. The PR body and changeset are fixed. I didn't make the three suggested code refactors; the PR body now explains why for each.

**What I changed**
- **Commit `279a9b3c75`** (`docs(claude): address panel-3 changeset and README findings`), pushed to `build/endo-claude-backends-1357`, moving the head from `15a24d78b5`:
  - **Changeset:** rewritten as a release note. It names the two new import paths, the version-pin and `maxBudgetUsd` behavior, the shared `@endo/claude/*.js` subpaths in one clause, and the new runtime dependencies (`@endo/inference`, `@endo/bytes`, `@endo/utf8`). The implementation detail is gone. (releaser, packager)
  - **README:** removed the "This increment is honest…" sentence that introduced Known gaps. (pruner)
- **PR body:** refilled section by section against the template.
  - **Template headings (must-fix):** added the three missing sections, Scaling, Documentation and Upgrade Considerations.
  - **Dependency and phase ledger (integrator):** the body now says the PR depends on #1403, which is merged. It also states that the canary evidence for design gates 3 and 8 is not claimed, and that the empty response-shape table and the `maxBudgetUsd` trip are deferred.
  - **XS stub (coverage-auditor must-fix):** says why `test:xs` is a stub: the code imports `node:*` modules and cannot run on XS.
  - **Parallel modules (decomplector must-fix):** explains why `child-env.js` and `constructed-environment.js` stay separate. The old one's safety check forbids exactly the `ANTHROPIC_*` credential variables the new backends must pass. It also explains why `results.js` and `response-shapes.js`/`stream-reducer.js` are different result vocabularies.

**Suggested refactors I didn't make (reasons are in the PR body)**
- **Thin top-level re-export files and per-subpath `types` entries (packager, should-fix):** the subpaths point straight at `./src/*.js`, the same pattern as the sibling `@endo/inference` package. Types still resolve, because the pack step writes a `.d.ts` file beside each source file.
- **Error helper and turn timer in `turn-guard.js` (decomplector, should-fix):**
  - `errorCategory` reports only an error's `code` or `name` and never reads its message. The existing `@endo/errors` helpers don't guarantee to keep a message that quotes the credential out of a failure detail.
  - `makeTerminationRace` is needed because the limit's abort signal can't end a wait on a party that never answers.
- **Shared `runTurn(transport)` for the two backends (decomplector, should-fix):** reshaping both turn paths in a late review round seemed too risky. If the next panel insists on it, it's a separate follow-up.
- **Squashing the ~27 fix-up commits (integrator, should-fix):** I left the history alone. A retcon is available if the maintainer wants it tidied.

The panel isn't re-run here; the gauntlet driver posts panel round 4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1412-post-weave-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1633945 cached reads)
- Output: 9327 tokens
- Cost: $1.0970810000000002
- Wall-clock: 2439s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
