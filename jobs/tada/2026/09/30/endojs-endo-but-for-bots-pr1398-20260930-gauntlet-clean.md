---
orchestration-failed: true
---
orchestration-failed: true

# Clean stage for endojs/endo-but-for-bots#1398: CI is red because of a lint error inherited from #1396

The clean stage failed. `ci-wait-merge.sh` returned rc=3: 32 of the 33 checks passed and the only failure is `lint`. That error was not introduced by this PR. It comes from a lower layer of the stack.

**Coverage pass.** No changes were needed, and nothing was pushed. The PR only adds code (`formula-sturdyref.js`, the wiring in `manager.js`, a dependency, the tsconfig reference and a changeset). `test/formula-sturdyref.test.js` covers every branch of the new module:
- minting a ref without incarnating the formula;
- enlivening it and reusing the existing incarnation;
- a ref to an unknown formula rejecting;
- an invalid formula id rejecting;
- `formulaIdOf` returning `undefined` for foreign refs, non-refs and plain strings.

The change leaves no dead code behind.

**CI had never run on the current head.** Head 8b57a39 was force-pushed when the stack was restacked, and that push started no workflow runs. The last CI run was on the old head 1d4d84b. I closed and reopened the draft PR to start CI, and it ran as run 36701856416.

**Why it's red.** `lint` fails in three steps: "Check the root TypeScript program", "Check workspace TypeScript programs" and "build API docs". All three fail on one error:

```
packages/captp/test/sturdyref.test.js:264:40 - error TS2339: Property 'locate' does not exist on type 'EMethods<Required<unknown>>'.
```

That line was added by commit 7a341141ca ("test(captp,ocapn): cover SturdyRef-from-data validation branches"). It is on #1396 (`build/sturdyref-captp-construct`), two layers below this PR. #1396 has no CI runs on that head and no gauntlet job on the board, so nothing else was going to catch it.

**Follow-up posted.** I posted a fixer job, `fix-endojs-endo-but-for-bots-pr1396-captp-locate-ts2339`. It will:
1. Fix the type error on #1396's head and check it locally with the repo-root and captp type checks.
2. Restack #1397 and #1398 onto the fix, moving their frozen bases as needed.
3. Confirm #1398's `lint` job goes green.

After that, this clean stage should be re-run.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1398-20260930-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (2133643 cached reads)
- Output: 10644 tokens
- Cost: $1.1803686
- Wall-clock: 2502s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
