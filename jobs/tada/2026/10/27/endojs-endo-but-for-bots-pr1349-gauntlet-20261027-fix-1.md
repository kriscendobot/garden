**Fix round 1 for endojs/endo-but-for-bots#1349: pushed, and CI is green (16 of 16 checks) on the new head `2d325f6ff1`.**

There was no deterministic pre-pass block, so I worked from the latest panel verdict, review 5666203766 ("Must-fix before merge"). I made four commits on `build/hardened-text-codecs-shim` and pushed them with `safe-push-pr-head.sh` (8382a1f48a → 2d325f6ff1).

**Fixed:**
- **locksmith** (`39d901ae68`): the internal callback in `repairIntrinsics` was renamed to `onShimStartCompartment`. It now gets only a frozen shim `Compartment` constructor, which `lockdown.js` builds itself. The intrinsics record and `markVirtualizedNativeFunction` stay inside `lockdown.js`. `src-xs/lockdown-shim.js` is simpler as a result.
- **prover:**
  - `39d901ae68` deletes `repair-intrinsics-hook-not-forwarded.test.js`, because it also passes on the base branch.
  - `2d325f6ff1` extends `text-codec-primitive-prototype.test.js` to check that the normal `TextEncoder` next to the bad `TextDecoder` still gets replaced. I confirmed locally that the test now fails both when the codec replacement is removed and when the primitive-prototype check is removed.
- **transplanter** (`6e2c11a27d`): the new browser spec now calls `page.goto('/')`, and `browser-test/playwright.config.js` sets `baseURL`. The existing `canary.spec.js` still hard-codes the full URL; I left it alone.
- **integrator, changeset** (`7751a45fb9`): `.changeset/tender-lions-tickle.md` now describes the SES-owned constructors, so it no longer contradicts the newer changeset.

**Declined, with reasons given in a PR comment** (https://github.com/endojs/endo-but-for-bots/pull/1349#issuecomment-6440688180):
- **decomplector**, a must-fix asking to remove the whole constructor-replacement approach: I didn't do this. It would reverse the PR's design, which kriskowal's last review accepted ("minor findings only"). The reported Chromium behaviour in endojs/endo#3369 also says lockdown can't safely permit those properties. If the maintainer wants that alternative, it needs a separate design decision.
- **benchmarker**, which wanted measurements for commit `32be2c61d3`: I posted a "not pursuing" reason instead. The skipped work runs once per `lockdown()` at start-up.
- **integrator, history**, asking to squash the `fixup!` commits and tidy the 37-commit history: left for the merge step. This was a should-fix, not a must-fix.

**Checks:** locally, 35 targeted codec tests pass, and `yarn lint:types`, `yarn test:xs` and eslint on the changed SES files all pass. Eslint does report five `globalThis` errors in `browser-test/tests/text-codecs.spec.js`, on lines I didn't change. CI checks the same file and passed, so I didn't fix them. `ci-wait-merge` returned 0 (GREEN, 0 failed).

**Follow-ups:** the panel-2 run will review the new head. The maintainer may want to rule on the decomplector's proposal.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20261027-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1822920 cached reads)
- Output: 12924 tokens
- Cost: $1.211312
- Wall-clock: 717s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
