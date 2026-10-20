# Gauntlet FIX round 1: endojs/endo-but-for-bots PR #1511

I fixed both failing style probes, pushed the fix to the PR head and CI came back green (35/35 checks, 0 failed).

**What I fixed** (on PR head `llm-ocapn-session-send-queue`, pushed with `safe-push-pr-head.sh` as a fast-forward from `45814763f` to `889864a5c`):

- **`no-inline-import-jsdoc`:**
  - `packages/ocapn/src/client/ocapn.js` now has a top-of-file `@import { SendQueue } from './send-queue.js'`, and the `OcapnDebug.sendQueue` property uses the bare `SendQueue` type.
  - `packages/ocapn/test/send-queue.test.js` now has `/** @import { ExecutionContext } from 'ava' */`, and `makeStalledPair` uses the bare `ExecutionContext` type.
- **`prefer-endo-primitives`** (in `send-queue.test.js`):
  - The two drain-failure tests used hand-rolled promise kits. They now use `makePromiseKit` from `@endo/promise-kit`.
  - The bare `Far('Greeter', …)` is now `makeExo` with a guard: `M.interface('Greeter', { greet: M.call(M.string()).returns(M.string()) })`.
  - The ocapn package didn't depend on `@endo/exo` or `@endo/patterns`, so I added both as `devDependencies` (`workspace:^`). The `yarn.lock` change is in its own `chore: Update yarn.lock` commit.
- **Advisory pruner note** (non-blocking): I left the 21-line header comment in `send-queue.js` alone. It explains why the queue is built the way it is (the stall and drain behaviour, epoch replay being at-least-once, which design phase it belongs to) and doesn't just narrate the code.

**Checks:**
- Both probes pass when re-run locally against the base branch `llm-ocapn-session-heartbeat`.
- `yarn test` on `send-queue.test.js` and `heartbeat.test.js`: 20 passed.
- `tsc --noEmit` is clean; eslint shows no errors, only warnings.
- `ci-wait-merge.sh --no-merge` returned rc 0.

**Commits:**
1. `refactor(ocapn): use Endo primitives and @import tags in the send-queue change`
2. `chore: Update yarn.lock`

**Follow-ups:** none. The driver re-posts the panel-2 stage.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1511-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1509296 cached reads)
- Output: 8829 tokens
- Cost: $0.9319112000000003
- Wall-clock: 2693s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
