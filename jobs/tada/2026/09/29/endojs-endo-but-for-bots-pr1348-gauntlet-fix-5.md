## Gauntlet fix round 5: endojs/endo-but-for-bots PR #1348

Round 5 is pushed and CI is green: `ci-wait-merge` returned rc=0 with all 33 checks passing on head `cb763267fc`. Must-fix items 1 and 2 are still open because they need a maintainer decision on #731, so panel-6 will almost certainly flag them again.

I pushed three follow-up commits (`c193f194cd` → `cb763267fc`) with `safe-push-pr-head.sh`.

**Should-fix items fixed:**
- **purist (rename table keyed by group labels):** `d915bcc81b` removes the module-level `composedNames` table. Each composed group now carries its own `names` table where it is added to the catalog.
- **breaker and wire-watcher (collision failure path has no test):** there are now two tests. One uses two synthetic groups that both emit `inspect` and checks that the `agent-tool catalog name collision` error is thrown. The other shows that a group's `names` table resolves the same collision.
- **CI failure on my first push:** it exported the guard from `src/workspace.js`, and the test that pins that module's export surface failed. `cb763267fc` moves the guard into an internal `src/catalog.js` that the package does not export.

**Must-fix item 3 (design prose contradicts the parking callout):** `97c2ff6553` updates `designs/daemon-agent-tools.md` and both rows in `designs/README.md`:
- `@endo/agentry/workspace-agent` is now recorded as new JSON-tool surface that is not covered by the #731 grandfathering.
- Whether the Phase 4 lal/fae wiring goes through this harness or through code mode is recorded as depending on #731.
- Code mode stays the default consumer until that is decided.

**Must-fix items 1 and 2 (the #731 parking and the ledger's `Disposition`):** not fixed; both need the maintainer.
- Only the maintainer can lift the parking. The question is already in their inbox from round 3 (read, but no answer yet) and round 4 (unread), so I did not send it a third time.
- The PR stays draft.
- I did not change the ledger. The gate allows only `deliverable` or `non-deliverable-probe`, and switching to probe would take the PR out of the gauntlet, which is the choice the maintainer has been asked to make.

**Checks run locally:**
- The agent-tools `workspace` and `exports` tests pass (13 tests).
- Package `tsc`, root `tsc` (checkJs) and eslint report no errors, and prettier is applied.
- The full agent-tools suite has one failure, in `git-flow` ("Git repository identity changed"). It comes from this local environment and is unrelated to these changes; CI passed.

I posted the round-5 summary on the PR (issuecomment-5883490316) and an addendum about the CI fix, as the scribe asked.

**Follow-ups:**
- The maintainer's decision on #731 and on this PR's disposition. The gauntlet will keep looping until it arrives.
- The locksmith's `readOnly` rename or rejection, which the panel accepted as a follow-up.
- The integrator's request to regroup the commits needs a retcon before merge.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1348-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (2468497 cached reads)
- Output: 14424 tokens
- Cost: $1.4614754
- Wall-clock: 1779s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
