Fix round 4 for endojs/endo-but-for-bots#1425 is done: I applied the round-4 panel's must-fix and should-fix items, pushed head `cbc4bfcd2e`, and CI went green (15/15 checks, `ci-wait-merge` rc 0).

**Must-fix: the PR body was padded (pruner).** I rewrote the body from 481 words to about 300. The empty Scaling, Documentation and Upgrade sections are gone, and the per-file "The changes:" list is now two sentences describing the structural change.

**Should-fix items:**
- **`ci.yml` repin:** it stays as its own commit. The PR body now says why it is bundled (the zizmor workflow audit fails on the base's `# v3` pin) and that the new SHA is the `v3.0.4` tag commit.
- **Two constructors named `ShimStartCompartment`:** the lockdown-time local in `src-xs/lockdown-shim.js` is now `LockdownShimStartCompartment`. A comment explains that the prototype methods reach it through the module-level `privateFields` WeakMap in `src/compartment.js`.
- **Typing:**
  - In `src/lockdown.js`, the `onIntrinsics` marker parameter is now `(object: object) => void`, matching `makeCompartmentConstructor`.
  - The local is annotated with `ReturnType<typeof makeCompartmentConstructor> | undefined`.
  - The JSDoc says the callback runs synchronously, at most once, and not on a repeat call that returns early.
- **Summary comment (scribe):** posted at https://github.com/endojs/endo-but-for-bots/pull/1425#issuecomment-6061966246.

The code changes went in as one follow-up commit (`refactor(ses): name and type the XS lockdown-time shim constructor`), pushed with `safe-push-pr-head.sh` (`842abe7fcf..cbc4bfcd2e`). Before pushing I ran the package and repo-root `tsc`, `eslint` on the changed files, and the XS test (`node scripts/generate-test-xs.js && xst tmp/test-xs.js`); all passed.

**Follow-ups:** none from this stage. The driver re-posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1425-gauntlet-20261007-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (794940 cached reads)
- Output: 6702 tokens
- Cost: $0.7721560000000001
- Wall-clock: 594s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
