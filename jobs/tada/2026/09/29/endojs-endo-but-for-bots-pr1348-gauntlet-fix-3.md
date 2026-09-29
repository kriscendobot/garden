## Gauntlet fix round 3: endojs/endo-but-for-bots PR #1348

I pushed two follow-up commits to the PR head (`5e1166a38b` → `b8a9e727d9`) and CI came back green on all 33 checks (`ci-wait-merge` rc=0). One of the two must-fix items needs a maintainer decision, so the PR will not clear review until that decision is made.

**Must-fix items from the panel-3 verdict:**
1. **New JSON-tool work despite the #731 parking (integrator): unresolved, maintainer decision needed.** The panel says a fixer cannot settle this, so I sent it to the maintainer inbox (`msg-…-489d813f734b`) with three options:
   - lift the parking for this slice and record that decision on #731 and in `designs/daemon-agent-tools.md`;
   - route Phase 4 provisioning through code mode (`code-mode-provisioning`, #965's `grants`) and close #1348 as superseded;
   - keep the PR draft until a Phase 4 lal/fae consumer exists.

   The PR is still draft.
2. **Ledger claims `deliverable` while phases are deferred (integrator): addressed in the PR body.**
   - I added a `Draft-hold:` line: the PR stays draft until the parking and slice-versus-Phase-4 question is decided.
   - I reworded the Phase 2 row so it says the whole phase stays open because 2c is unbuilt, while its 2a/2b sub-items landed in #615.
   - I also noted that `designs/README.md` has no phases.
   - The `Design:` line already names only `designs/daemon-agent-tools.md`. The gate script flags `designs/README.md` from the diff itself, not from the ledger, so removing it from the ledger would only cause a `missing-design` finding. That flag is a quirk of the garden gate, and I didn't change the gate.

**Should-fix items (commit `be32f1dde2` fix, `b8a9e727d9` docs):**
- **locksmith:** the `endow` hook is now called without the provisioned tools, so it never holds the granted `push`, `fetch` or `exec` closures. A hook that returns a non-object now fails with the module's own error message instead of a bare TypeError. Both behaviors have new tests (this also covers corner-prober's `endow` comment).
- **typist:** `defineWorkspaceAgent` now has a `@returns` tag, and the README describes it as returning an async maker.
- **curator:** `workspace-agent.types.d.ts` now includes `export type * from './src/types.js'`, like its sibling subpaths.
- **archivist:** the agent-tools README now documents `provisionHistoryTools`, and I clarified the "derives only the Filesystem view" JSDoc.
- **integrator:** the agentry README now explains how `workspaceGrants` differs from the code-mode `grants`. I documented the difference rather than renaming either one.
- **Not done:** folding the four fix-up commits into `31270da466`. That needs a force-push that rewrites history, which conflicts with this stage's follow-up-commit rule. It can be done as a retcon before the PR merges.

**Checks run locally:** the agentry `workspace-agent` and `exports` tests (6 passing), the agent-tools `workspace` tests (9 passing), agentry `tsc` (no errors), and eslint with no errors (a few warnings, none in the files I touched). Prettier reports the touched files clean.

**Follow-ups:**
- The maintainer's answer on the #731 parking.
- The optional retcon to fold the fix-up commits.
- panel-4 will probably flag the parking again until the maintainer decides.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1348-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1741440 cached reads)
- Output: 12158 tokens
- Cost: $1.144536
- Wall-clock: 1346s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
