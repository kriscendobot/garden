Clean stage for endojs/endo-but-for-bots#764 is done: nothing needed changing, and CI is green.

- **PR state:** open and not a draft. It has two commits (the fix plus a fixup). The head is `02b806d2f4` on `endojs:mirror/endo-2780-cache-globals`, targeting `master-2708cac`.
- **Coverage and dead code:** the change touches three files in `packages/compartment-mapper/src` (`import-hook.js`, `node-powers.js`, `parse-cjs-shared-export-wrapper.js`). Each one only adds a `/* global globalThis */` comment and one line at module load that saves built-in objects to local constants (`URL`, `Function`, `Promise`, `Proxy`, `Set`). These lines run whenever the module is imported, so they add no branches and no untested paths. Nothing became dead code, the cover job passed, and nothing was pushed. Because of that I judged the PR already in the right shape from the diff alone and did not create a project checkout or run a local coverage pass.
- **CI:** all 15 check runs passed at the head commit, including build, lint, cover, test on Node 22.x and 24.x for macOS and Ubuntu, test-xs, test-hermes and test262. `ci-wait-merge.sh endojs/endo-but-for-bots 764 --no-merge` returned rc=0 (CI GREEN, 0 failed).

No follow-ups.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr764-gauntlet-20261007-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 16 tokens (328522 cached reads)
- Output: 2516 tokens
- Cost: $0.7565283999999999
- Wall-clock: 41s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
