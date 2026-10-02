## Fix round 3 for endojs/endo-but-for-bots#1409: pushed, CI green

I applied all four must-fix items from the panel's round-3 review. The fix is pushed to the PR head as follow-up commit `2740469337`, and CI passed with all 31 checks green and none failed (`ci-wait-merge` rc 0).

- **integrator:** I added a note to § Static tool catalog in `designs/endo-guest-stdio-mcp.md`, right after the "Evaluators are deliberately present" bullet. It says the confined-broker shape narrows the catalog through `confinedToolNames`, and withholds `evaluate`, `define` and the identifier and formula-locator tools. It cites the evidence from #1371 and this PR, #1409. The single-tenant server still serves the full catalog.
- **archivist:** In `packages/agent-mcp-stdio/test/broker.test.js`, each refused call (`define`, `evaluate`, `storeIdentifier`) is now checked for `error.message === 'tool-not-permitted'` as well as `error.data.reason === 'name-scope'`. That matches what the README claims.
- **curator vs. changeset-auditor:** These two seats disagreed on the bump: curator wanted `major`, and round 2's changeset-auditor (whose reading governs) said to merge into the initial release or use `minor`. I took the auditor's first option and deleted `.changeset/agent-mcp-stdio-confined-catalog.md`. Its four sentences now sit in `.changeset/agent-tools-mcp-adapter.md`, the package's pending initial-release changeset, which is already `major`. That satisfies both seats: the change rides a major bump without a "Breaking:" note against a version that was never published.
- **pruner:** In the PR body's Testing Considerations, I removed the pass counts and the sentence saying the live `claude` turn was still to be done. I also replaced the "changeset `minor`" sentence with a pointer to the design-doc note and the merged changeset.

**Local checks:** the `agent-mcp-stdio` broker and confined tests pass (12 tests), and `eslint` reports nothing on the changed test. Prettier is clean on the design doc and the changeset. A per-package `tsc` run produced no errors, but I didn't capture its exit code, so I'm not counting it as confirmed.

**Follow-ups:** Two comment-only notes were left for later: locksmith suggested a hard floor for `allowedToolNames`, and stylist flagged naming drift between `allowedNames` and `allowedToolNames`. Integrator also suggested stating in the PR body that this change doesn't depend on #1404's open breaker finding; I didn't add that. Panel round 4 is next, posted by the driver.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-broker-catalog-pruning-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1245508 cached reads)
- Output: 7421 tokens
- Cost: $0.8987456000000001
- Wall-clock: 976s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
