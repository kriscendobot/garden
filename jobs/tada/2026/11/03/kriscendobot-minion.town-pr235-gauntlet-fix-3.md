Fix round 3 on kriscendobot/minion.town#235 is finished: all must-fix items are applied and pushed, taking the head from `43ebebf9` to `db1d9182`. CI is green at that commit (`ci-wait-merge` rc 0), with `test`, `changes` and both Claude harness jobs passing: https://github.com/kriscendobot/minion.town/actions/runs/41738311769

**Must-fix items applied**
- **Missing changeset (packager, changeset-auditor, releaser):** `a3974df0` adds `.changeset/mcp-guide-resources.md`, a `minor` bump. The seats disagreed on whether to mention the `evaluate` fix for `undefined` results. I included it, because the PR's production run reproduced that error, so the releaser's "never reached users" is wrong.
- **Wrong env var name (archivist):** `62139997` changes the design's `MCP_RESOURCES_DIR` to `MCP_RESOURCES_DIRECTORY`, the name the code reads, in all six places.
- **Guide failure costing a session its tools (breaker):** `f8318c18` has two parts:
  - `loadGuide` now rejects a duplicate URI or name, so the session falls back to an empty guide with a warning.
  - `registerGuideResources` is now guarded: if registration throws, it warns and withdraws what it had registered.

**Should-fix items also applied**
- **Loader validation (breaker):** `f8318c18` also rejects a non-finite `order` and a URI that isn't `minion-town://<kind>/<page>`.
- **Comment cuts (pruner 10, 11, 12):** `db1d9182` removes the two narrating comments and keeps the recipe bounds only in `recipes.ts`.
- **PR description (packager):** it now says the design is carried over, and I replaced its stale line saying CI hadn't run.

**Testing**
- `tsc` is clean.
- `test/resources.test.ts` and `test/harness-gate.test.ts` pass locally, and the pre-push probes pass. The full suite ran only in CI.
- Before the fix was finished, 10 of the 31 tests in `test/resources.test.ts` failed against the old `src/resources.ts`, including one proving a session keeps its tools when two guide files collide.

**Pruner items I did not apply** (`summary-fix` or `acknowledge`, so they don't block the un-draft). The reasons are in the PR comment: https://github.com/kriscendobot/minion.town/pull/235#issuecomment-6618088210
- **1–4 (PR body):** the tool-surface audit and PASS/FAIL results were build deliverables, and the maintainer decides from them.
- **5, 7, 8 (primer repeating the guide):** the design says the primer states its own facts, and it has to work for clients that can't read resources.
- **6, 7 (repeats across guide pages):** left because an agent may read a single page; this is a maintainer call.
- **9 (the "Which guide next" index):** the finding itself leaves this to the maintainer.

**Follow-ups:** the driver posts panel-4. The maintainer decisions and the pre-merge cold-agent baseline listed in the PR description are still open.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr235-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (896060 cached reads)
- Output: 16040 tokens
- Cost: $1.2174119999999997
- Wall-clock: 747s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
