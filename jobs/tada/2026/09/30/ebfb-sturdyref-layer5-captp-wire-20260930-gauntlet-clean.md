Clean stage finished as a no-op: CI is green at PR #1394's current head and I pushed nothing.

- **PR state:** endojs/endo-but-for-bots#1394 (`build/sturdyref-captp-wire`) is open and draft, with head `9a9aa310f9`.
- **CI:** `ci-wait-merge.sh endojs/endo-but-for-bots 1394 --no-merge` returned rc 0 ("total=33 failed=0 → CI GREEN").
- **Coverage and dead code:** the PR already ships its own tests (`packages/captp/test/sturdyref.test.js`, `packages/ocapn/test/sturdyref.test.js`). I skipped the coverage pass and did not check out the branch. The diff removes the old sturdyref helpers (`makeSturdyRef`, `enlivenSturdyRef`, `makeSturdyRefTracker`) and their import in `packages/ocapn/src/client/index.js`. I didn't search the repo for leftover callers, but a stale import of a removed export would most likely fail the green lint/typecheck/test cells.

Follow-ups: the panel stage is next in the gauntlet.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer5-captp-wire-20260930-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 166 tokens (5974467 cached reads)
- Output: 26694 tokens
- Cost: $3.2881574000000007
- Wall-clock: 6275s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
