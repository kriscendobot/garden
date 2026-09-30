---
orchestration-failed: true
---
orchestration-failed: true

# Clean stage for endojs/endo-but-for-bots#1394 (SturdyRef layer 5, CapTP wire): CI is red, caused by the base PR #1393

The clean stage failed, but not because of anything in #1394's own diff. The build-graph cycle comes from the PR it is stacked on (#1393, layer 4).

**Coverage and dead code:** nothing needed changing, so I pushed nothing.
- The head `6450485a67` already has the coverage commit from an earlier attempt: `d649091283 test(captp,ocapn): cover SturdyRef wire refusal paths`.
- The change orphaned no code. `enlivenSturdyRef` is still exported and still used through `enlivenSturdyRefDetails`, `client.enlivenSturdyRef`, and the tests. The new `enlivenUnbound` default is reachable.
- I could not re-run the tests locally: the project checkout's `node_modules` is broken, and every test file in captp, ocapn and thixotrope exits with code 1 whether or not it relates to this change.

**CI at `6450485a67`:** the `test (22.x, ubuntu-latest)` leg failed before any test ran. `turbo run test` stopped with:
`Cyclic dependency detected: @endo/sturdyref#build, @endo/pass-style#build`
- `packages/pass-style/package.json` depends on `@endo/sturdyref`.
- `packages/sturdyref/package.json` lists `@endo/pass-style` in `devDependencies`, and turbo counts those for builds.
- The cycle is already present on the base branch `build/sturdyref-marshal-representation-f404dbc` (#1393). All four `test (…)` legs on #1393's head `f404dbc` fail the same way.
- #1394 does not touch `pass-style` or `sturdyref`, so every PR stacked on top of #1393 will be red until #1393 is fixed.

The other test legs were still queued. I stopped waiting because this failure blocks the whole test matrix, not a flake that would clear.

**Follow-up posted:** job `fix-ebfb-1393-sturdyref-passstyle-build-cycle` (fixer, #1393). It asks the fixer to break the cycle, for example by removing `@endo/pass-style` from sturdyref's devDependencies, with the yarn.lock update in its own commit. Once that lands and #1394 is rebased onto the fixed base, this gauntlet stage needs to be re-posted.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer5-captp-wire-20260930-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 158 tokens (5815420 cached reads)
- Output: 25455 tokens
- Cost: $2.9208240000000005
- Wall-clock: 6254s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
