I broke the build cycle on PR #1393, and all four `test (…)` legs plus `lint` now pass.

**Cause:** `@endo/pass-style` depends on `@endo/sturdyref`, and `@endo/sturdyref` listed `@endo/pass-style` as a dev dependency. Turbo counts dev dependencies when it orders builds, so it saw a loop and stopped every test run before any test started.

**Fix (pushed to `build/sturdyref-marshal-representation`, head now `36c4f40bcd`):**
- `b9b3777f1b` fix(sturdyref): removes `@endo/pass-style` from sturdyref's dev dependencies. The only use was one assertion in `packages/sturdyref/test/sturdyref-shim.test.js` checking that `passStyleOf` rejects a SturdyRef made without the shim. I removed that assertion and its import. Pass-style's own `test/sturdyref-absent.test.js` already covers the same case ("without the shim, a ponyfill ref is not passable").
- `36c4f40bcd` chore: Update yarn.lock, in its own commit as asked.

**Checks:**
- Locally, a turbo dry run on the old `package.json` reproduces "Cyclic dependency detected"; with the fix it reports no cycle.
- Locally, sturdyref's tests pass (22), pass-style's sturdyref tests pass (11), and sturdyref's lint shows 0 errors.
- On GitHub, test (22.x/24.x × ubuntu/macos-15), `lint`, `cover (24.x)`, `build`, `test-xs` and `viable-release` all pass.

**Follow-up jobs posted:**
- `fix-ebfb-1392-sturdyref-passstyle-build-cycle`: the cycle actually started one PR down the stack, in #1392 (layer 3), which has the same red `test (24.x)` leg. This job applies the same fix there.
- `weave-ebfb-1394-sturdyref-stack-20260930`: #1394 is still based on the old #1393 head (`-f404dbc`), so it keeps the red legs. This job rebases #1394 onto the new #1393 head, works up the stack (#1396 → #1397 → #1398 → #1399), and re-runs their gauntlets.
- Once #1392 has the fix, rebasing #1393 onto it should see these two commits either drop out as duplicates or hit small conflicts in the same lines.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-ebfb-1393-sturdyref-passstyle-build-cycle.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1475024 cached reads)
- Output: 8143 tokens
- Cost: $0.9492808000000001
- Wall-clock: 2468s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
