---
orchestration-failed: true
---
orchestration-failed: true

**CLEAN stage: endojs/endo-but-for-bots PR #1396 (SturdyRef layer 6, "construct a SturdyRef from its data"). CI is RED, so this stage fails.**

**Coverage pass:**
- I got an isolated checkout of the PR head `build/sturdyref-captp-construct` and read the diff against its base, `build/sturdyref-captp-wire-dc0027b`.
- The existing tests did not reach these validation branches, so I added tests for them:
  - **`@endo/captp`:** the type checks on `peerId`, `designator` and `hints` (including `hints: null`), and how omitted fields are recorded when no `peerId` option is set (no `designator`, empty `hints`). Also the locator rejecting a non-string object id, tested through `makeRemoteKit('l-0')`.
  - **`@endo/ocapn`:** the `peerId` and `hints` type checks, and `hints` surviving a round trip through `makeSturdyRefFromData` and back out of `getSturdyRefData`.
- The change left no dead code behind.
- Both packages' sturdyref test files pass locally (captp 9 tests, ocapn 15). eslint reports no errors; its one warning is on an existing ocapn test line, not the new tests.
- I found the gaps by reading the branches, not with a coverage report: running c8 through ses-ava produced no output here.
- I pushed commit `608307976` (tests only) with `safe-push-pr-head.sh`, moving the head from `ef45f1dc0` to `608307976`.

**CI result:** `ci-wait-merge.sh` returned rc=3 (RED). The failing checks are lint, test on 22.x and 24.x for both ubuntu-latest and macos-15, and cover on 22.x and 24.x for ubuntu-latest. The new commit changes only tests and does not cause these:
- **lint:** `yarn build:types:check` fails with "Drift detected: packages/ocapn/tsconfig.composite.json" (needs `yarn build:types:gen`).
- **test and cover:** turbo stops on "Cyclic dependency detected: @endo/pass-style#build ↔ @endo/sturdyref#build", so no tests run.
- The parent layer PR #1394 (`build/sturdyref-captp-wire`) fails the same checks, plus `test-xs`. Both faults come from a lower layer of the SturdyRef stack, so they need fixing there, or on #1394, and then carrying up into #1396.

**Follow-up:** someone needs to fix the stack: remove the `pass-style` ↔ `sturdyref` build dependency cycle and regenerate the ocapn composite tsconfig. After that, re-run this stage.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2344842 cached reads)
- Output: 11392 tokens
- Cost: $1.2847203999999997
- Wall-clock: 5772s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
