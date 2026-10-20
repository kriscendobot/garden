Updated `dev/new-clip-browser-demo.mjs` to launch the TypeScript helper through `process.execPath --import=tsx`, removing the Windows `npx.cmd` dependency.

Pushed commit `e3de8484` to PR #201’s `feat/new-clip-inventory` branch.

Verification:
- `npm run typecheck` passed.
- Cross-platform loader/spawn path executed successfully.
- Full suite: 1,427 passed; 26 unrelated environment-dependent failures.
- Real-browser acceptance not run locally because no built pinned Endo checkout was available; current PR-head CI remains pending.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-browser-demo-windows-spawn.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 661s

<!-- garden-usage-end -->
