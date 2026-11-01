**Clean stage for endojs/endo-but-for-bots PR #1625: done, no changes made, CI green.**

PR #1625 ("feat(exo-agent-factory): coordinator facet for durable facet formulas") is a draft on branch `build/exo-agent-factory-durable-facets`, head `a796cae574`. Its base is the frozen branch `build/exo-agent-factory-core-21d142a`. The diff touches 4 files in `packages/exo-agent-factory`: `coordinator.js`, `interfaces.js`, the README and `coordinator.test.js`.

- **Coverage:** I ran `test/coordinator.test.js` (41 tests passed) under Node's built-in coverage, because `c8` isn't installed in the workspace. Every line the PR adds is covered. That includes all the error paths: a bad `boundFacet` id, a malformed `lifecycleFor` key, and a key the journal hasn't reached yet. The lines that were never run all sit in code from the base branch, not in this change.
- **Dead code:** none was left behind. The old inline `boundFacet` body became a one-line delegation to `coordinatorFacet.boundFacet`, and nothing else was replaced.
- **Push:** nothing to push.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc=0: 34 checks, 0 failed.

There are no follow-ups. The gauntlet can go on to the panel stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1625-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (620725 cached reads)
- Output: 3895 tokens
- Cost: $0.6313890000000001
- Wall-clock: 860s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
