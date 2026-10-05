## Panel round 2 on endojs/endo-but-for-bots #1391: must-fix

I ran one panel round on the PR head and posted the verdict. Nothing was fixed or un-drafted.

- **Run:** head `1730228a7b` (`endojs:build/sturdyref-ses-accommodation`), base `ef4662f04b`, the frozen branch `build/sturdyref-shim-first-wins-ef4662f`. I passed the base as a SHA. `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` exited 0 with disposition **must-fix**, and all 33 seats returned ok.
- **Review posted:** https://github.com/endojs/endo-but-for-bots/pull/1391#pullrequestreview-5414404138. GitHub refused a request-changes review because the bot owns the PR, so it went up as a COMMENTED review with the must-fix verdict in the heading, the same shape as earlier rounds. It ends with a `garden-panel-verdict: must-fix` marker.
- **Tally:**
  - Request-changes (2): breaker and integrator.
  - Comment-only (6): archivist, saboteur, purist, gateway, corner-prober and fast-checker.
  - Pruner returned summary-fix.
  - Approve (23).
  - Changeset-auditor returned no verdict text, so it wasn't counted.
- **Must-fix (integrator):** #695's open CHANGES_REQUESTED review has three threads. The PR body answers only the remotable-vs-passable one. It must also cover the confinement thread and the retention/GC thread, or say why they are out of scope.
- **Should-fix:**
  - **Breaker:** `sampleSturdyRef` checks `SturdyRef.prototype` by reading its property descriptor. `completePrototypes` later reads it with a plain property read (`[[Get]]`). A Proxy can answer those two reads differently, so the prototype that gets registered may not be the one that was checked.
  - **Integrator:** the branch carries four daemon commits (`e703fad05d`, `d6d07ab446`, `14381fc8f5`, `0ebeab85eb`) that cancel each other out. Rebase them off before merge.
- **Minor:** pruner wants a redundant line about the breaking change removed from `.changeset/ses-permit-sturdyref.md`. Breaker and integrator also left comment-only wording notes.

**Follow-up:** changeset-auditor printed leftover text from a background command instead of a verdict. If it keeps happening it's worth a look.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-20261005-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (869609 cached reads)
- Output: 5370 tokens
- Cost: $0.7950417999999999
- Wall-clock: 655s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
