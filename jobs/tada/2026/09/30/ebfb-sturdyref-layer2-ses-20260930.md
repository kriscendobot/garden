Layer 2 is up as draft PR https://github.com/endojs/endo-but-for-bots/pull/1391. SES now permits `SturdyRef` and gives child compartments the identical constructor when it is present at `repairIntrinsics` time. But layer 1's real shim can't yet be loaded before lockdown, so the complete path (real shim → lockdown → child compartments) doesn't work until layer 1 is fixed. I've posted a job to fix that.

**What changed** (branch `build/sturdyref-ses-accommodation`, commit caa792be80, `packages/ses` only):
- **`src/permits.js`**:
  - `SturdyRef` is now a universal global, next to `HandledPromise`.
  - New permits for the constructor (statics `enliven` and `isSturdyRef`) and its prototype, matching layer 1's constructor shape.
  - When no shim ran, nothing is added and no global appears.
- **`src/global-object.js`**:
  - Layer 1 installs `globalThis.SturdyRef` as non-writable and non-configurable. Lockdown tried to redefine it and threw `Cannot redefine property: SturdyRef`.
  - Lockdown now leaves such a binding alone when it already holds exactly the value it would install. Child compartments still get the shared constructor.
- **Tests**:
  - `test/sturdyref-shimmed.test.js` uses a pre-lockdown stand-in with layer 1's shape and descriptor. It checks that lockdown succeeds and hardens the constructor, prototype and statics. It also checks that child and grandchild compartments get the identical `SturdyRef`, that a ref made in a child is recognized and enlivened in the parent, and that statics can't be replaced.
  - `test/sturdyref-absent.test.js` checks that no `SturdyRef` appears when the shim did not run.
- A changeset for a `ses` minor bump.

**Local checks:**
- Full `packages/ses` ava run: 405 passed, 1 known failure and 2 skipped (both already there before). All 7 new tests pass.
- eslint on the touched files: 0 errors.
- The only `tsc` binary I could find (a bundled typescript 5.9.3) reports errors, but all are in files I didn't touch; none in mine.

**The PR:**
- Opened with `ensure-pr.sh` and carries this job's marker.
- Its base is a frozen snapshot of layer 1's head, `build/sturdyref-shim-first-wins-95609a7`, which I created per `skills/frozen-base-branch` § Stacked PRs.
- The body links endojs/endo-but-for-bots#695 and kriscendobot/garden#47, and lists layers 1–9 with #774, #1391 and design #1389. It follows the repo's PR template, which `ensure-pr.sh` enforces.

**Gap in layer 1 (#774):** importing the real `@endo/sturdyref/shim.js` before `lockdown()` makes lockdown throw (I reproduced this). The shim calls `@endo/harden` as soon as it is imported, and SES refuses to lock down after that has happened. Layer 1 therefore says to install after lockdown, but then `SturdyRef` isn't there at `repairIntrinsics` time. The `HandledPromise` shim avoids this by leaving hardening to lockdown.

This doesn't invalidate layer 2: the SES side already accepts that pre-lockdown shape, including layer 1's locked descriptor. So I did not halt the chain.

**Follow-ups:**
- **Posted:** fixer job `ebfb-sturdyref-layer1-prelockdown-install`. It gives #774 a pre-lockdown install path that leaves hardening to lockdown, adds a real shim → lockdown → Compartment test, and then moves #1391 onto a new frozen base.
- **Sent:** a message to the maintainer with the PR link and this gap.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer2-ses-20260930.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2653601 cached reads)
- Output: 23254 tokens
- Cost: $1.6945201999999997
- Wall-clock: 314s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
