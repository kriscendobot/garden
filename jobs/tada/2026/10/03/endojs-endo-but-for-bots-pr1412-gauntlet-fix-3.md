# Fix round 3 for endojs/endo-but-for-bots#1412: done, CI green

I applied the panel-3 must-fix items in two follow-up commits on top of `ee861f9bea` and pushed them with `safe-push-pr-head.sh`. The head is now `0bf0292c05`. CI finished green: 33 checks, 0 failed (`ci-wait-merge.sh` rc 0).

**Commit `8b02a3af31`, `fix(claude): check the pinned version, admission, budget, and wall clock`:**
- **Version pin (wire-watcher):** both backends now take a `getVersion` power. Each turn compares the binary's actual version with the pinned `version` before calling `acquire()`. On a mismatch, or if the version read fails, the turn returns `unavailable` without acquiring the credential or spawning anything. The shared helper is `checkPinnedVersion` in `confinement-options.js`. New tests cover an upgraded version, a near-miss version and a failed read for the CLI backend, and a version mismatch for the SDK backend.
- **Budget ceiling (assessor):** `buildSdkOptions` now validates `maxBudgetUsd` the same way `buildCliArguments` does, through one shared `assertBudgetCeiling`. There is a test for the SDK path.
- **Wall-clock limit (breaker, corner-prober):** `maxWallClockMs` is capped at `2**31 - 1`. Node shortens any larger delay, and `Infinity`, to 1 ms, so such a limit would end every turn at once. Guard and enforcer tests now cover `2**31` and `Infinity`.
- **Field name (stylist):** the credential grant field `env` is now `environment` in the type, the guard, the README, both backends and the tests.
- **Two should-fix items from the same round (breaker, wire-watcher):**
  - A grant must now carry `ANTHROPIC_AUTH_TOKEN` or `ANTHROPIC_API_KEY`; `ANTHROPIC_BASE_URL` alone is refused.
  - A malformed `acquire()` result now returns `unavailable` instead of making `infer` reject. The check uses `matches`, so no credential value can appear in the error detail.

**Commit `0bf0292c05`, `docs(claude): export the spec types and bring the changeset up to date`:**
- **Type exports (curator, surfacer):** `CliArgumentsSpec`, `SdkOptionsSpec`, `ConstructedEnvironmentSpec`, `TurnOutcomeSpec` and `SpawnOptions` are re-exported from `claude.types.d.ts`.
- **Changeset (packager):** it now names the version check, `maxBudgetUsd` and the scratch-directory module.
- **JSDoc (archivist):** the stale `buildArgv` comment no longer claims flags that `buildConfinementFlags` now emits.
- **README:** notes the version check and that the scratch directory is removed when the turn ends.

**PR body (binding template must-fix):** I rewrote it with all seven template headings in order and removed the invented "Platform scope" section. It is down from 842 to about 330 words, and `pr-body-template-check.sh` reports it conforms. The `garden-job` and related-design markers are kept.

**Local checks before pushing:**
- Tests: `@endo/claude` 141 passed, `@endo/inference` 50 passed.
- Package `tsc`: clean for both.
- ESLint: no errors, only the existing `safe-await-separator` warnings.
- Root `tsc -p tsconfig.json`: no errors in either package.

**Not done (left for panel-4 to judge):**
- The orthographer's "acknowledgement" spelling in `packages/inference/SECURITY.md` is unchanged. The lint gate requires that file to match `packages/skel/SECURITY.md` exactly, which is why commit `ee861f9bea` restored it.
- These should-fix items are deferred:
  - Integer-only `maxTurns` in the guard.
  - Renaming the purist's `retryAfterMs` reader field.
  - Calling the wrapped backend through `E(backend)` in the usage recorder and prompt-origin gate.
  - Moving `backends.types.d.ts` to a checked `.ts` file.
  - Making cancellation and the wall clock cover the setup awaits.
  - The README lifecycle sentence for the other generated files.
- The PR stays a draft until #1403 lands and a weave removes the stack merge commits.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1412-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 108 tokens (5867280 cached reads)
- Output: 24792 tokens
- Cost: $2.730864
- Wall-clock: 3111s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
