## FIX round 2: endojs/endo-but-for-bots#1403 (`@endo/inference` seam)

I applied the panel-2 must-fix items as two follow-up commits, pushed them to the PR head, and CI came back green: `ci-wait-merge` rc 0, 33 checks, 0 failed. The PR head moved from `ef660bd65e` to `297986fd50`, pushed with `safe-push-pr-head.sh` in advance mode.

**`9d56f2ad9b` fix(inference): refuse a non-positive pid in the process group killer** (assessor)
- `makeProcessGroupKiller` now throws on any pid that is not a positive integer. Before, a pid of 0 would have become `kill(-0)`, which signals the caller's own process group. A pid of `undefined` still returns false, as before.
- I added a test for pids 0, -1234, 1.5 and NaN.
- The `terminate` JSDoc now says a throw is uncaught from both the timer callback and the `cancelled` rejection handler, not just the timer.

**`297986fd50` refactor(inference): address panel review feedback**
- **stylist:** renamed `secretId` to `secretIdentifier` and `runId` to `runIdentifier` across the shapes, types, recorder, README and tests.
  - The design doc (`designs/endo-claude-inference-backends.md`) still says `secretId`, which I didn't change. Someone may want to bring it in line.
- **purist:** the three "retry later" tags are now listed once, in a new exported `RETRY_LATER_TYPES` in `guards.js`. `ClassifiedResultShape`, `AdmissionReasonShape` and the classifier's `retryAfterMs` check all read from that one list.
- **purist:** the UTF-8 byte count now uses `TextEncoder` instead of a hand-written loop. A lone surrogate still counts as 3 bytes.
- **assessor nit:** removed the duplicate `harden` calls on shape literals that were already hardened.
- **archivist:** the README now describes the grant and refusal shapes exactly: `{ type: 'granted', env, release }` and `{ type: 'refused', admission }`.
- **surfacer:** removed the top-level `"types"` field from `package.json`. It pointed to a bare `@endo/inference` import, and the `exports` map has no `"."` entry to serve one.

**pruner (summary-fix):** I rewrote the PR body down from about 1,100 words. I took out the per-export tour (the README covers it), shortened the prototype-differences, testing and compatibility sections, and fixed the stale `secretId`, test count and `0.0.0` version mentions.

**Checks:** all 49 package tests pass; `yarn lint` has 0 errors, with 7 warnings left in files this round didn't touch; `prettier --check` is clean; and the repo-root `tsc -p tsconfig.json` reported nothing for this package.

I left the comment-only notes for later: deriving `InferResultTypeShape` from the result union, adding an interface guard on `buildMcpServer`, and the mixed meaning of `UsageRecord.detail`. The panel wasn't re-run; the driver posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1403-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2211103 cached reads)
- Output: 11649 tokens
- Cost: $1.3616326
- Wall-clock: 2557s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
