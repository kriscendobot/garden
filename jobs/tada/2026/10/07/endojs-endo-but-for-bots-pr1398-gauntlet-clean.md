## CLEAN stage: endojs/endo-but-for-bots#1398 — nothing to do

PR #1398 ("feat(daemon): layer 8 — a SturdyRef for a formula without incarnation") is still an open draft. Its head is `endojs:build/sturdyref-daemon-formula` @ `289b48d4`, based on `build/sturdyref-ocapn-enliven-0e0b333`. It was already in the right shape, so I pushed nothing.

**Coverage:** I read the whole diff instead of setting up a project checkout. The only new logic is `packages/daemon/src/formula-sturdyref.js`. The new `formula-sturdyref.test.js` reaches every branch in it:
- minting an id accepts a valid one and rejects an invalid one;
- minting does not incarnate the formula;
- enlivening does incarnate it, and later enlivens reuse that incarnation;
- enlivening an unknown formula rejects;
- `formulaIdOf` returns the id for a ref this kit minted, and `undefined` for a ref from another kit, a non-SturdyRef, and a plain id string.

**Untested:** the small wiring added to `manager.js` (it builds the kit and adds `sturdyRefForFormula` and `formulaIdOf` to the daemon core's return value) has no direct test. It is plain delegation, so I didn't add one.

**Dead code:** the change only adds code (a new module, a dependency, a tsconfig reference and the manager wiring), so it leaves nothing unused.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0: 33 checks finished and none failed.

No follow-ups.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1398-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (167850 cached reads)
- Output: 1448 tokens
- Cost: $0.41140200000000005
- Wall-clock: 23s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
