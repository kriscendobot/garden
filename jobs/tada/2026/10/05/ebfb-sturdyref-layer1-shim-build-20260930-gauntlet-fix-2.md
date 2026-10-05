Fix round 2 for PR #774 is done: I pushed a fix and CI is green on the new head `63e488be40` (33 checks, none failed, `ci-wait-merge` exit 0).

**Most of the panel's items were already fixed.** The previous run of this stage pushed commits `97a0393fba`, `c316cb982c`, `84bc1de42a` and `40ebb44dd3`, then CI's lint job went red and the gauntlet halted. Those commits:
- always freeze the constructor;
- check for a callable `harden`;
- save `WeakMap` and `Promise` at module load;
- keep enumerability when adopting an existing global;
- rename `desc`;
- trim the public exports;
- set the changeset to `major`;
- refresh the PR description.

**What broke CI:** three new test files tampered with globals by direct assignment (`globalThis.harden = o => o`, `Promise.prototype.then = …`, `WeakMap.prototype.get = …`). In a JS file, TypeScript treats those assignments as declarations, even under `@ts-nocheck`. The repo-wide type check (`tsc -p tsconfig.json`) includes these tests, so the global types changed for every package. For example, `harden` became `Harden | ((o: any) => any)`, which produced type and lint errors in about ten unrelated packages. Rerunning the old CI run gave the same errors, so it was not a flake.

**What changed:**
- **The fix (commit `63e488be40`):** the three test files now tamper through `any`-typed aliases. A small standalone TypeScript case reproduced the error and showed the fix clears it. The full repo-wide check didn't reproduce the failure locally because this checkout's install is incomplete, so CI going green is the real confirmation. The package's 28 tests pass, and eslint and prettier are clean.
- **Title:** changed to `feat(sturdyref): add first-wins SturdyRef shim with handler/enliven construction`, dropping "layer 1" and the em dash as the panel suggested.
- **Summary comment:** posted the summary the panel said was missing, mapping each must-fix to its commit (https://github.com/endojs/endo-but-for-bots/pull/774#issuecomment-5991393717).

**CI:** after the push, one leg failed: `@endo/daemon` daemon-teardown on macOS (Node 22). That package doesn't depend on `@endo/sturdyref`, so I treated it as a timing flake and reran only that leg, which then passed.

**Not done:**
- **Squashing the history into one commit** is left for a retcon before merge.
- **The British spelling "acknowledgement" in `SECURITY.md`** stays, because CI requires that file to match the canonical copy exactly.
- **The panel's should-fix suggestions** were not applied: a branded `SturdyRef` type, an XS test, and a frozenness check before adopting an existing global. They are still open.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer1-shim-build-20260930-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 114 tokens (5751184 cached reads)
- Output: 19600 tokens
- Cost: $2.5331407999999995
- Wall-clock: 5628s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
