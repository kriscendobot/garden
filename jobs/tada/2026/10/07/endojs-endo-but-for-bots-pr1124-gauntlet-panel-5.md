Panel round 5 on endojs/endo-but-for-bots#1124 came back **must-fix**. `panel.sh` exited 0 in single-round mode, and I posted the verdict as a review on the PR.

**Run details**
- The panel checked head `990695c9b` (kriscendobot `build/ocapn-nonce-locator-mechanism`) against base `f1e306582cb1` (the PR's `baseRefOid`, `llm-f1e3065`).
- I checked out the head with `ensure-project-worktree.sh`, at `scratch/project-wt-endojs--f589eeabfcdd-01168a89`.
- All 34 seats returned ok; the run is recorded at `panel-runs/kriscendobot-endo-but-for-bots-1124/90edaaebd627.md`.
- My first launch didn't record the exit code, so I stopped it and ran the panel again. That first launch left a second panel-run record, `e1e0d58e91ce`, which can be ignored. The rerun finished in about 2 minutes, so it probably reused seat outputs the first launch had already written to the same run folder. The head hadn't changed, so the verdict still stands.

**Review posted:** review 5447172696, at head `990695c9b`. GitHub refuses a request-changes review on the bot's own PR, so it went in as a comment review headed "Panel verdict: REQUEST CHANGES (must-fix)", the same as rounds 1–4. The full aggregate is about 94KB, too big for one review. I kept the request-changes seats whole, filled the rest of the space, and listed the 15 seats that didn't fit.

**Must-fix items:**
- **decomplector:** this is the third round in a row with must-fix on this locator.
  - `makeFormulaNonceLocator` is a public export that nothing uses, and it duplicates `localGateway.provide`.
  - It recommends removing the export, the thunk module, the types and the changeset, and adding a private adapter only when the wiring lands.
  - It says the maintainer must confirm whether the gateway path should be retired before any more hardening rounds.
- **integrator:** the title scope `(daemon,ocapn)` names a package the net diff no longer touches.
- **integrator:** commit history describes work that a later commit reverts. Commits `3bd1eb4a1`, `16ac97b46` and `5a3cfb1d5` are undone by `990695c9b`, whose message is a panel-round narrative. The commits need to be reset and regrouped.
- **reexport-auditor:** `packages/daemon/formula-nonce-locator.js:7` is a plain re-export with no `@deprecated` JSDoc.

**Follow-up:** the decomplector's main finding is a scope question for the maintainer, not something a fix round can settle. If the gauntlet keeps looping, it will likely hit the same finding again; asking the maintainer is the way out.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1124-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1379396 cached reads)
- Output: 8145 tokens
- Cost: $1.0231792
- Wall-clock: 356s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
