## Viability report: endojs/endo-but-for-bots#1559

**Verdict: proceed.** The PR is open, not superseded, and the need behind it still holds.

**PR facts:** The PR is open, draft and unmerged: "feat(daemon): makeFromPackage runs package.json-rooted trees". It was opened 2026-10-26T01:11Z by job `build-daemon-worker-import-from-mount`. Head is `8a16f9e9ff`. Base is the frozen `llm-d5ac419`, which is 0 commits behind the current `llm` tip. It has no reviews or comments yet.

Deciding question: Does `llm` still lack a `makeFromPackage` entry point that runs a confined caplet from a `package.json`-rooted tree with no `node_modules`, and is the prerequisite it builds on, `@registry` (Phase 1), present on `llm`?

Evidence:
- **Nothing newer on `llm`.** The base `d5ac419` is the current `llm` tip (`ahead_by: 0`). Searching the repo's code for `makeFromPackage` finds it only in design docs and `exo-npm/snapshot-mapper.js`, not in daemon source. `llm`'s `designs/README.md` still lists `daemon-worker-import-from-mount` as **Not Started**, so no other implementation has landed.
- **The prerequisite is in place.** PR #403 (the `EndoRegistry` capability and the `@registry` special name) merged on 2026-08-17. `packages/daemon/src/host.js` on `llm` wires `'@registry'`, which this PR resolves through.
- **No competing PR.** The nearest open PR is #1419 (`makeFromTree` node_modules layouts). It implements a different design (`agent-confined-application-makers.md`) for trees that do have `node_modules`. #1559 targets trees without one, so the two complement each other rather than overlap. No other open or closed PR implements `makeFromPackage` or this design's Phase 2.
- **The motivation still holds.** The design's integration layer of the four-layer stack is still unbuilt on `llm`. That layer runs package.json-rooted mounts without `npm install` or a `node_modules` tree. The PR's departure from the design sketch (resolving in the daemon rather than the worker) follows the amendment in #1117 and is disclosed in the PR description for review. It is not a sign of a stale premise.

Nothing on the PR was changed, and no clean, panel, fix or CI budget was spent. No follow-ups beyond the normal gauntlet.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1559-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (242996 cached reads)
- Output: 2099 tokens
- Cost: $0.49667520000000004
- Wall-clock: 47s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
