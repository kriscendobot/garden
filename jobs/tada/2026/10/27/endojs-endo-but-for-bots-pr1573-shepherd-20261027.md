## Shepherd report: endojs/endo-but-for-bots#1573 (draft, `feature/api-key-provider-registry` → `llm-844ce3d`)

CI is still red, but none of the failures come from this PR. I pushed nothing: the reds are all fleet-wide problems that other open PRs already fix. While I worked, the gauntlet's clean stage force-pushed a retcon, moving the head from `9d7ad83c` to `43bf47ff` and cancelling the run in progress. The two heads have identical trees (empty `git diff`).

**What this PR's code got (head `43bf47ff`, run 40461446943):**
- `test (22.x, macos-15)` **passed** on the full package set, including 18 `inference-provider-registry` tests. This is the only test leg that avoids both of the problems below.
- `lint`, `familiar-bundle` and both `viable-release` legs passed.
- Locally on `9d7ad83c`: `@endo/hosted-agent` passed 853/853, and the daemon `secret-manager`, `secret-backend` and `inference-provider-registry-restart` tests passed 28/28.

**What's still red, and who fixes it:**
1. **`build`** (depcheck workflow): `scripts/graph.sh: tred: command not found`. The runner image is now ubuntu-26.04, and the graphviz 14 package installed there doesn't provide `tred`. → Fixed by **endojs/endo-but-for-bots#1566**, whose own CI is green.
2. **`sandbox-drivers`, both `cover` legs, and `test` on ubuntu 22.x and 24.x**: two `packages/sandbox` bwrap tests fail on the new image (`ulimit: Illegal option -u`, and "parent death… without running any assertions"). The ubuntu test jobs stop at the sandbox package. → Also fixed by **#1566**. The same failures show up on #1560–#1572.
3. **`test (24.x, macos-15)`**: `packages/floot` `factory-system-prompt.test.js` dies with an unhandled `ClientDestroyedError` on Node 24. It fails the same way on every Node 24 leg of #1545, #1562, #1564 and even #1566. → Fixed by **endojs/endo-but-for-bots#1567** (test-only).

**Messages:** I sent this diagnosis to the active peer `endojs-endo-but-for-bots-pr1573-gauntlet-clean` so it doesn't chase these reds.

**Classification: `next: none`.** The PR needs no change. Once #1566 and #1567 land on `llm`, a weave of #1573 onto a fresh `llm` snapshot should turn it fully green. The order is: merge #1566 and #1567, then weave #1573. The Phase 2 adapters can continue on top of #1573 now.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1573-shepherd-20261027.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 106 tokens (4548531 cached reads)
- Output: 17706 tokens
- Cost: $2.0398582
- Wall-clock: 6745s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
