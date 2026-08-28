Work complete. No garden-repo (`main2`) changes were needed — this "attention" directive resolved to an assessment plus routing, both delivered.

## Completion report

**Directive** (kriskowal, endojs/endo-but-for-bots#1070): *"Are we missing harness components to actually test all these cases where the tests are skipped?"*

**Preflight:** Exit 2 was a false-positive hint matching the bot's own "On it" acknowledgment comment, not a real resolution — proceeded.

**Investigation** (in `packages/hardened262` on branch `llm`): The two new Iterator/AsyncIterator cases pass in `module`/`lockdownModule` on all three agents and skip everywhere else. This is corpus-wide, not PR-specific: `agentRunsScenario` (`scripts/test.js`) wires only `module`/`lockdownModule` (~1595 skipped baseline lines). I traced the actual execution paths in `scripts/agents/{node,xs}.js`, `scripts/node-helper.js`, and `scripts/agents/scenario.js`.

**Answer (posted to the PR, [comment 5448028869](https://github.com/endojs/endo-but-for-bots/pull/1070#issuecomment-5448028869)):** Yes, in part — and it splits three ways:
- **Compartment axis (all agents): genuinely missing.** Nothing reads `test.compartment` to execute anything; no `new Compartment(...)` path exists in either agent.
- **sloppy/strict-script on `sesNode`: missing.** `node-helper.js` runs subjects only via `await import()` under a `type: module` package, so it has no faithful script path — a "sloppy" scenario would silently run as a module.
- **sloppy/strict-script on `xs`: component already exists**, gated off solely by the `agentRunsScenario` switch (xs passes `-m` only for module).

**Routing:** Posted a **designer** job `design-hardened262-skipped-scenario-harness` (explicit identity to escape the same-comment directive dedup) to spec the Compartment execution component (node + xs), the `sesNode` script-eval path, the per-agent widening of `agentRunsScenario`, and the baseline-ratchet/review plan — tied to the test262 coverage ratchet (kriscendobot/garden #51). Verified live on `origin/journal2` (already claimed into `jobs/doin/`).

**Follow-ups:** The design job owns the actual build-out; no further action on this directive.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1070-269933ea.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2408042 cached reads)
- Output: 21019 tokens
- Cost: $2.504506
- Wall-clock: 382s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
