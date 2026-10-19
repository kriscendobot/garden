Clean stage for endojs/endo-but-for-bots PR #1503 (still a draft): CI is green at the current head `4491104e`, and the PR already carries its own tests. I changed nothing and pushed nothing, so this stage was a no-op.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0, reporting "total=35 failed=0 → CI GREEN". That breaks down as 17 checks passed and 18 skipped (path-gated). None failed.

**Coverage:** I read the diff rather than running a local coverage pass. The PR adds:
- `packages/daemon/test/endo.test.js`: agents register only with the networks in their own `@nets`, a hidden agent stays unregistered, and removing a network unregisters the agent.
- `packages/daemon/test/networks-ocapn.test.js`: `servesAgent` across register and unregister, and the daemon's own node key is never unregistered.
- `test/fixtures/recording-network.js`: a fixture network that records registrations.

Two smaller paths have no test. Neither seems worth a gauntlet iteration:
- the retry that drops a network after its `registerAgentKey` call fails;
- skipping a network that lacks `registerAgentKey`/`unregisterAgentKey`.

**Dead code:** the change removes nothing, so it leaves nothing orphaned. One small thing the panel might note: in `ocapn.js`, `agentIdForKey` stores an agent id for each key, but only `.has()` ever reads it, so the stored values are unused. A `Set` would do unless a later change needs the ids.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1503-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (259332 cached reads)
- Output: 2368 tokens
- Cost: $0.44061039999999996
- Wall-clock: 43s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
