## Panel round 4: endojs/endo-but-for-bots#1419 — **must-fix**

I ran one single-round panel against head `24d7deb53b`, with base pinned to the PR's `baseRefOid` `0bdf8951cb`. `panel.sh` exited 0 with disposition **must-fix**, and all 33 seats returned ok.

**Seat votes:** 8 request-changes (prover, curator, saboteur, breaker, purist, engine-realist, integrator, scribe), 9 comment-only, 16 approve.

**Review posted:** https://github.com/endojs/endo-but-for-bots/pull/1419#pullrequestreview-5401313782
- It is a COMMENTED review. GitHub won't let the PR author request changes on their own PR, so it follows the same shape as rounds 1–3.
- The full aggregate was 87 KB, which is over GitHub's 65,536-character review limit. I added a summary header and kept every request-changes and comment-only seat report in full. The 16 approving seats appear by name only, with no report text. The posted body is about 59.8 KB.

**Must-fix items for the fixer:**
1. **engine-realist:** on the XS (Endor) manager, the new `node_modules` layouts probably fail. They include the `detect` default and every `node-modules-*` layout. The cause is that `@endo/compartment-mapper` is in the XS bundle's `EXCLUDED_PACKAGES`, and the new tests are not gated for that manager.
2. **saboteur:** a bare `catch {}` in `host.js` (around line 2385) silently drops errors from the `treeKind` lookup.
3. **curator:** `getTreeLayoutRunningAs` is missing from the `DaemonCore` interface in `types.d.ts`.
4. **prover:** fix commit `c09443ee33` has no regression test.
5. **integrator:** the PR body claims all of Phase 2 but defers the Phase 2 acceptance evidence the design names, including the Node/XS parity runs.
6. **scribe:** the round-2 and round-3 fix pushes still have no completion-summary comment.

**Should-fix items several seats agree on:**
- **Layout probe:** a failed marker lookup is treated as "absent", so detection can silently fall through to a different layout. Commit `24d7deb53b` undid the earlier fix for this.
- **Stale `runningAs`:** cancelling during `runTreeAs` leaves a stale `runningAs` entry.

I did no fixing and did not un-draft the PR. My temporary files are cleaned up and my inbox was empty.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-confined-application-makers-p2-makefromtree-20261003-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1134157 cached reads)
- Output: 6969 tokens
- Cost: $0.9308434000000003
- Wall-clock: 572s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
