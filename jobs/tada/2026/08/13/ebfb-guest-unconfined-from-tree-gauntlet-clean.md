This PR is test-only: a single commit adding one test (`host-only capabilities are not reachable through an EndoGuest`) to `packages/daemon/test/endo.test.js`. It pins the guest/host authority boundary — pure additive coverage, no production-code change, so nothing was orphaned and there is no dead code to remove. CI is fully GREEN at the current head (`dad2cf08`), including the `cover` jobs. The clean stage is an idempotent no-op.

## Completion report

**Stage:** CLEAN — endojs/endo-but-for-bots PR #977 (`test/guest-host-boundary-ebfb`, head `dad2cf08`)

**Assessment:**
- PR is a single test-only commit ("test(daemon): pin guest host-authority boundary") touching exactly one file: `packages/daemon/test/endo.test.js`. It adds a test asserting the full EndoHost-only method surface (`makeUnconfinedFromTree`, `makeUnconfined`, `endow`, `provideHost`, etc.) is absent from `EndoGuest` and unreachable via `@host` lookup at the CapTP boundary.
- Because the change adds no production code, it orphaned no code — there is nothing to prune.
- Coverage is inherently additive here; the `cover (22.x/24.x, ubuntu-latest)` checks are GREEN.
- Full `statusCheckRollup` shows every check COMPLETED/SUCCESS with no pending or failing checks.

**Actions taken:** None required — the PR is already in the correct shape (coverage present, CI green). No follow-up commits pushed, no project checkout needed.

**Follow-ups:** None.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-guest-unconfined-from-tree-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (185778 cached reads)
- Output: 2356 tokens
- Cost: $0.46227599999999996
- Wall-clock: 44s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
