Fix round 1 for endojs/endo-but-for-bots PR #1498 is pushed and CI is green: all 35 checks passed and none failed.

The latest panel verdict was review 5567692038. It had three must-fix items, and one commit (`1da3b2b187`) addresses them all. I pushed it to `build/daemon-locator-terminology` with `safe-push-pr-head.sh`.

1. **Archivist — README totals (`designs/README.md`):** I recounted the summary table rather than adjusting the old figures. The totals are now 78 Complete/Implemented and 82 In Progress, dated 2026-10-19, with 249 records. I added a sentence about the status change and undid an unrelated `…` → `...` edit (the integrator flagged it).
2. **Archivist — the "`from` contains only…" claim (`designs/daemon-locator-terminology.md`):** The design doc now describes the `fromNode` parameter, which the code adds when the handle's peer key differs from the hostname (`manager.js` ~7533). The invitation locator template now includes `[&fromNode={handlePeerKey}]`.
3. **Breaker — `help.md` out of sync with the generated `help-text-data.js`:** I undid the unrelated `→` → `->` edits in the `glob`/`grep`/`glorp` examples and kept the `locate`/`identify` wording changes. Running `node scripts/generate-help-text-data.mjs` now leaves `help-text-data.js` unchanged.
4. **Should-fix from packager and releaser — changeset:** I removed the line that pointed readers at the design doc and the "No function signature…" sentence. It now tells upgrading users that code matching the old error messages has to change.

These should-fix items are still open:
- Add `@deprecated` to `agentNodeNumber` in `externalizeId`, or add a test that pins its unused behaviour.
- Fix the `LOCAL_NODE` "for tests" wording: the exported constant has no importers.
- Make the prover's error-message regexes stricter.
- Apply the pruner's trims to the PR body, comments and design history.
- Drop `@endo/cli` from the changeset, which the releaser suggested.

I did not re-run the panel; the driver posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1498-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1479378 cached reads)
- Output: 6413 tokens
- Cost: $0.9970715999999998
- Wall-clock: 1935s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
