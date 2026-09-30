## Completion report: ebfb-sturdyref-layer1-prelockdown-install

Importing `@endo/sturdyref/shim.js` before `lockdown()` now works. With layer 2's SES, a child compartment sees the same `SturdyRef` constructor. I've pushed #774, restacked #1391 onto it, and updated design #1389. Both PRs are still draft. I haven't watched CI on the new heads.

**#774 (layer 1), head `ef4662f04b` on `build/sturdyref-shim-first-wins`:**
- **The fix (`src/sturdyref-shim.js`):** the shim now calls `@endo/harden` only if a harden is already installed (`Object[Symbol.for('harden')]` or `globalThis.harden`). Otherwise it just freezes the constructor, its prototype and its two statics, and `lockdown` hardens them later. This follows the HandledPromise shim. First-wins and the non-configurable, non-writable global are unchanged, and refs are still frozen when made.
- **New test (`test/sturdyref-prelockdown.test.js`):** imports the shim, then `ses`, then runs `lockdown()`. It checks that:
  - no harden was installed early and `lockdown` succeeds;
  - the global is still the shim's constructor and stays locked;
  - the constructor, prototype and statics are frozen, and their shape matches what SES's `SturdyRef` permit allows (standing in for the permit check on this branch);
  - refs work.

  Against the old shim, the test fails with the "Cannot lockdown (repairIntrinsics) …" error. On this branch SES doesn't have the permit yet, so the child-compartment check accepts either no `SturdyRef` or the same one.
- **Package and docs:** `ses` is now a devDependency, with the lockfile change in its own `chore: Update yarn.lock` commit. The shim.js header, the README's lockdown and child-compartment sections, the ponyfill comment and the changeset no longer say to install after lockdown.
- **Checks:** all 22 package tests pass. Lint has 0 errors, only the same warnings the other test files already have. Prettier is clean.

**#1391 (layer 2):**
- I created the frozen branch `build/sturdyref-shim-first-wins-ef4662f`, rebased the layer-2 commit onto it (no conflicts), and moved the PR's base there.
- I added commit `a0ef0c4320`, which makes the child-compartment check strict. The test now requires `new Compartment().globalThis.SturdyRef` (and `evaluate('SturdyRef')`) to be the same constructor, using the real shim imported before `lockdown()`. It passes, and the SES `sturdyref-*` tests still pass (7/7).

**#1389 (design):** I pushed `55b47f7c5e` to `design/sturdyref-shim-contract`. It describes the before-or-after-lockdown install, the rule for when to harden, why installing before lockdown matters for layer 2, and a new row in the test table.

I left a comment on #774 and on #1391 summarizing these changes.

**Follow-ups:**
- #1391's stand-in shim (`packages/ses/test/_sturdyref-shim-first.js`) could just import the real shim, but that would make `ses` and `@endo/sturdyref` depend on each other. I left it alone.
- The rest of the stack continues under orchestration `ebfb-sturdyref-layering-20260930`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer1-prelockdown-install.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1608908 cached reads)
- Output: 15467 tokens
- Cost: $1.2053456000000002
- Wall-clock: 206s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
