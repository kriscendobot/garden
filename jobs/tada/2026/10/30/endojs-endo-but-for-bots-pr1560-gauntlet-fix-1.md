# PR #1560 gauntlet fix round 1: CI still pending at the deadline

I fixed all six failing prepass probes and pushed the fix to the PR head, but CI did not finish within the 3600s deadline (`ci-wait-merge` rc=4). Two jobs are red, both from a bwrap test failure that also hits other PRs: `sandbox-drivers` and `test (24.x, ubuntu-latest)`. Two jobs were still pending when the deadline hit.

## What changed on the PR head (`build/exo-agent-factory-core`, now `d8fb029efd`)
Pushed with `safe-push-pr-head.sh` as follow-up commits on top of `b647776d73`:
- **`af6e3eb41c` fix(exo-agent-factory): address style prepass findings**
  - **prefer-endo-primitives:**
    - `src/policy.js` now counts instruction bytes with `encodeUtf8` from `@endo/utf8` instead of a direct `TextEncoder`. `@endo/bytes` has no text encoder, so it couldn't be used.
    - The test doubles in both test files use `makeExo` with an interface guard instead of `Far`:
      - a new `makeToken` helper for method-less stand-ins;
      - `AgentDriverMakerInterface` for the makers;
      - a passable default-guard interface for the fake `PrivateHost`.
  - **build-vs-buy:** `isRemotable` is now imported from `@endo/pass-style` instead of being redefined locally.
  - **spell-out-identifiers:** `dirFor`/`dir` are renamed to `directoryFor`/`directory`.
  - **no-inline-import-jsdoc:** `coordinator.test.js` now has a top-of-file `@import { ExecutionContext } from 'ava'`.
  - **no-plain-reexport:** `index.js` carries a `reexport-policy-exempt` marker as the package's own entry point, the same way `npm-registry-server` and `agent-mcp-stdio` do it.
  - **Dependencies:** added `@endo/utf8`, dropped the now-unused `@endo/far` dev dependency, and regenerated `tsconfig.composite.json`.
- **`bfbff9fe9a` chore: Update yarn.lock** (separate commit).
- **`d8fb029efd` fix(exo-agent-factory): restore canonical SECURITY.md.** The typist finding couldn't be applied. Endo's lint job (`scripts/check-security-md.sh`) requires every package's `SECURITY.md` to be byte-identical to `packages/skel/SECURITY.md`. Replacing the curly apostrophes turned lint red, so I put the file back.

**Local checks:** all 23 package tests pass, eslint and tsc are clean, and all six failing probes pass when re-run against the PR's merge-base. The pruner advisory on `coordinator.js:26` was non-blocking; I left that comment because it explains what the `PrivateHost` port is in a deployment.

## Garden-side fix (main2 `eff6ebf05c2`)
`typist-friendly-code-points.sh` now skips any `packages/*/SECURITY.md` that is byte-identical to `packages/skel/SECURITY.md`. Without this, the probe flags every new package with an unfixable file. I checked it in the project worktree: the canonical copy now passes, and a curly apostrophe in another markdown file is still caught.

## CI on `d8fb029efd`
Both red jobs fail the same test, `bwrap › bwrap timeout and repeated cancellation reap process groups`, in `@endo/sandbox`. This PR doesn't touch that package, and the failure has been on other PRs too. Its fix is endojs/endo-but-for-bots#1566, which is still open and unmerged. Lint is green now that `SECURITY.md` is back.

## Follow-ups
- Unless #1566 lands first, the bwrap test will keep these two jobs red on the re-run.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1560-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (3675430 cached reads)
- Output: 16535 tokens
- Cost: $1.7803540000000002
- Wall-clock: 5597s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
