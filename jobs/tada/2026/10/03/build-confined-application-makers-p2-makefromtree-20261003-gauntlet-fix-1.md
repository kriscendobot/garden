## Fix round 1 for endojs/endo-but-for-bots PR #1419: fixes pushed, CI green

I applied the panel's must-fix items as three new commits on top of the PR head, which moved from `b36394cda7` to `45c6d8cd73`. CI finished green: all 33 checks, 0 failed (`ci-wait-merge` returned 0). That run also covers the daemon integration tests (`endo.test.js`), which I couldn't run locally (see Verification).

**Changes:**
- **`fix(daemon): address makeFromTree panel review`** (`eed5c72820`):
  - **`harden()` calls:** restored `harden(ChannelInvitationInterface)` and `harden(AttenuatorInterface)`. Removing them was an unrelated edit folded into the feature commit. The lint rule `@endo/no-harden-pattern-maker` warns that both calls are redundant, which is why they were dropped. If they should go, that belongs in a separate change.
  - **Root containment:** `capture-node-modules.js` now adds a missing trailing slash to `root`. Without it, a root of `file:///app` would accept a sibling like `file:///app-other/` as "under root".
  - **One type declaration:** `TreeLayout` and `RequestedTreeLayout` are now declared only in `types.d.ts`, and the other files import them. The host guard builds its `layout` pattern from the `requestedTreeLayouts` list and shares the option shapes used by `makeUnconfined` and `makeArchive`.
  - **Pet inspector:** reverted the `make-from-tree` branch to its base shape. The new `tree-kind` and `running-as` keys could never be reached because of an existing type allowlist. Reading `running-as` would also have started the application just by inspecting it. `getFormula` is still where these diagnostics appear.
  - **JSDoc:** added types to the `cancelWithWorker` and `nodeNumber` params, and shortened the `detectTreeLayout` comment.
- **`test(daemon): cover compartment map containment rejections`** (`d376e0378a`):
  - New tests check that a pre-generated map is rejected when a location is outside the root, uses `..`, shares the root's prefix, or is missing.
  - They also cover the trailing-slash fix for both `node_modules` layouts.
  - The out-of-tree integration test now matches the exact error ("`../outside.js` must not traverse behind an empty path") instead of a loose regex.
- **`chore(daemon)`** (`45c6d8cd73`): added `@endo/spaces-util: minor` to the changeset.
- **PR body:** cut from 666 to 485 words, replacing the per-test lists with a summary plus the known gap.
- **PR comment:** posted a summary of what changed and why.

**Verification:** I pushed with `safe-push-pr-head.sh`; it reported a clean advance. Locally:
- 25 of 25 unit tests passed (capture-node-modules and tree-layout).
- `lint:types` passed; eslint reported 0 errors; the repo-root `tsc -p tsconfig.json` showed no errors in the daemon or spaces-util packages.
- The XS bundle build (`bundle:xs`, `build:xs-bundles`) succeeded.
- The `endo.test.js` integration tests can't start a daemon on this host: better-sqlite3 was built for a different Node.js version. CI ran them instead.

**Follow-ups (not done here):**
- **Dead inspector branches:** the pet inspector's allowlist still excludes `make-from-tree` and `peer`, so both branches never run. This predates the PR.
- **Comment-only panel notes left alone:**
  - Property-based tests (fast-check) for layout detection.
  - Narrowing what the mount records store, which the locksmith seat raised.
  - Testing `entry: ''`.
  - `compartment-map.json` being read twice for one incarnation.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-confined-application-makers-p2-makefromtree-20261003-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 90 tokens (4835800 cached reads)
- Output: 19570 tokens
- Cost: $2.3698560000000004
- Wall-clock: 2332s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
