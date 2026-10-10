**Clean stage for endojs/endo-but-for-bots PR #311: nothing to do. Coverage was already in place, CI is green, and I pushed nothing.**

The PR is "fix(module-source): pass defineProperty through functor calling convention". It is open, not a draft, and its base is the frozen `master-455ce47`. The head is `712918f280cabfc08124d7c03f0cab4d816b1aac`.

- **Idempotence check:** the PR was already the right shape, so I skipped the coverage pass:
  - **Tests are already on the PR.** The `ses` path is covered by a new test in `module-source.test.js`, with the updated `format-preserved.txt` fixture pinning the new preamble. The `compartment-mapper` `bundle-mjs.js` path is covered by a new regression test in `bundle.test.js` for a module that shadows `Object`, with its own fixture.
  - **No orphaned code.** The only thing the change removes is the inline `Object.defineProperty(...)` emit in `transform-analyze.js`, which the new hidden `$h͏_defineProperty` binding replaces. Nothing is left without a caller.
- **CI:** `ci-wait-merge.sh endojs/endo-but-for-bots 311 --no-merge` returned rc 0: all 17 checks passed and none failed. That includes `cover`, lint, build, test and test262 across Node and OS versions, plus test-xs and test-hermes.

Follow-ups: none. The gauntlet can go on to the panel review stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr311-gauntlet-20261007-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (177509 cached reads)
- Output: 1514 tokens
- Cost: $0.4388058
- Wall-clock: 20s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
