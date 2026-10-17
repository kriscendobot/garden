# Gauntlet CLEAN stage — endojs/endo-but-for-bots#1485

CI is green at the new head `980ec0d4a62`: `ci-wait-merge.sh` returned rc 0 with 35 checks and 0 failures. I did not run a full coverage pass on the touched packages beyond the fixes below.

**Starting state:** the PR was a draft at `0fe2daa87b`, and CI failed on lint, all four test legs and both cover legs. The failures came from this PR's own changes:
- **Tests:** the goblin-chat tests `host-room` and `interop-self` still passed `captpVersion` directly to `makeOcapn`. This PR makes `makeOcapn` throw on that option, so both tests rejected.
- **Lint (type checks):** the same calls failed with TS2322. Separately, the `makeDaemon` JSDoc in `packages/thixotrope/test/daemon.test.js` failed with TS8032 (`root0.*` params with no matching `@param`).

**Fix (one commit, pushed with `safe-push-pr-head.sh`, advancing `0fe2daa87b` → `980ec0d4a62`):**
- `packages/goblin-chat/test/host-room.test.js` and `interop-self.test.js`: the three direct `makeOcapn` calls now pass `captpVersion` in the `makeStartSessionNetwork` options instead. The `hostRoom({ captpVersion })` calls stay as they are, because `hostRoom` already forwards it to the network.
- `packages/thixotrope/test/daemon.test.js`: fixed the `makeDaemon` JSDoc.

**Checked locally before pushing:** both goblin-chat test files pass (4 tests), `tsc` is clean for goblin-chat and thixotrope, and eslint is clean on the changed files.

**Coverage and dead code:** there are no new coverage tests. Both cover legs had failed only because of these two broken tests, and are green after the fix. I found no dead code orphaned by the change: `captpVersion` still has live consumers in `start-session.js`, `host-room.js` and `use-goblin-chat.js`.

**Follow-ups:** none. The PR stays draft for the panel stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1485-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1506253 cached reads)
- Output: 6516 tokens
- Cost: $0.9879066000000002
- Wall-clock: 2353s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
