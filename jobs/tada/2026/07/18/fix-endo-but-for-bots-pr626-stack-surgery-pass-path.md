# Completion report: fix-endo-but-for-bots-pr626-stack-surgery-pass-path

**Outcome:** PR endojs/endo-but-for-bots#626 now carries the scripted faux-model pass-path for the stack-surgery eval at head `73356f8ff5a`, with CI fully green (22/22 checks, run 29623812665). The PR remains DRAFT as directed.

**What I did** (two commits pushed to `feat/agentry-eval-scenario-multifile`):

1. `73356f8ff5a feat(agentry): script the stack-surgery eval pass-path`
   - New `src/eval/scenarios/stack-surgery/reference.js`: the reference `evaluate` source. It splits the mixed alpha/beta commit with the sanctioned no-reset recipe (`createBranch` at the mixed commit's parent with `switchAfterCreate`, read old content through `filesystemAt(ref)`, write/`add`/`commit`), re-targets the original fixup commits at the split commits (`cherryPick` with `noCommit`, re-commit as `fixup!` of the split summary), squashes them with `rebase({ autosquash: true })`, replays `side/gamma-tooling` then `side/docs-note` via `cherryPick` in order, and rewords the beta test commit to `test(beta): cover stack surgery`. The evaluate compartment has only `E`/`git`/`workspace` (no TextDecoder/atob), so the source carries its own `PassableBytesReader` drain and base64 decode for the `filesystemAt` read.
   - `stack-surgery.test.js`: pass-path test in the landed conflict-rebase idiom (`fauxModel` + `fauxToolCall('evaluate', {source})` through `runGitScenario`), asserting all 16 outcome checks pass, plus a do-nothing-model negative; stale "no pass-path yet" header replaced.
   - `_stack-surgery-repo.js`: powers flipped to `allowHistoryRewrite: true` (the exo gates `reword`/`cherryPick`/`rebase` on it).
   - `scenario.js`: `referenceSourcePath`/`referenceSourceExport` wired; `eval-live.test.js`: `skipReason` lifted (row stays credential-gated).
2. `2c14875336d test(agentry): pin rerere off in eval fixture repositories` — the bot host's global `rerere.enabled=true` replayed provisioning-time conflict resolutions into the pre-existing conflict-rebase mid-rebase test, a false local failure; pinned off per fixture repo for determinism.

Also refreshed the PR title (dropped "(pending git verbs)") and description, and posted the required top-level summary comment (issuecomment-5008997685).

**Verification (all observed, commands run locally in the per-job worktree):** `yarn ava` in packages/agentry: **117 tests passed** (including "outcome assertion passes when the scripted run performs the stack surgery"); `yarn tsc`: clean; `yarn eslint` on changed files: 0 errors (8 pre-existing-category warnings); `yarn prettier --check`: clean; all three pre-push-gate probes: pass. CI on `73356f8ff5a`: 22/22 pass.

**Follow-ups surfaced (not acted on):** the scenario prompt never states the exact `feat(alpha)`/`feat(beta)` split summaries the scorer requires, so a live model can fail `final-stack-summaries` on wording alone; suggested (in the PR comment) naming them in the prompt as a follow-up. No live worker was racing the branch; journal progress and result entries posted.

Self-improvement: the code-mode evaluate compartment has no TextDecoder/atob, so scripted eval sources that read bytes through `filesystemAt` need a hand-rolled reader drain; `reference.js` is now the reusable precedent (recorded in the journal result entry).
