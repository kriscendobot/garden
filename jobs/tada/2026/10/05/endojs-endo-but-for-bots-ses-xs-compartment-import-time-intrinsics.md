I opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1425, which fixes the XS hole where compartments created after `lockdown()` got globals as they stood at `import 'ses'`. CI on the PR had not been checked when this session ended. Locally, the XS smoke test passes, and lint and typecheck are clean.

**Defect:** The reproducer behaved as the job described: after deleting `TextEncoder` before `lockdown()`, a new compartment still saw it as an unfrozen `function` with an unfrozen prototype. With the fix it is `undefined`, and a replaced global (`TextDecoder`) is shared with the start compartment and frozen. Node gives the same results.

**Changes** (in `packages/ses`, branch `fix/ses-xs-lockdown-compartment-intrinsics`, one commit, base `master-6ee3fda`, which equals `master`):
- **`src-xs/compartment.js`:** the code that builds the shim compartment constructor is now a function, `makeShimStartCompartment()`, which reads the globals when it is called. The constructor built at import is kept for the pre-lockdown `Compartment` that `compartment-shim.js` installs.
- **`src-xs/lockdown-shim.js`:** `lockdown()` now builds a fresh constructor after the intrinsics are hardened, so new compartments get the hardened globals, as on Node. The shim methods come from the shared `CompartmentPrototype`, so they work unchanged with the new constructor.
- **`test/_xs.js`:** before `lockdown()` it deletes `TextEncoder` and replaces `TextDecoder`, then checks that a new compartment sees `TextEncoder` as `undefined` and gets the same, frozen replacement `TextDecoder` (prototype included).
- **Changeset:** `.changeset/ses-xs-lockdown-compartment-intrinsics.md` (`ses` patch).

**Verification:**
- `node scripts/generate-test-xs.js && xst tmp/test-xs.js` prints `ok`. With the `lockdown-shim.js` change reverted, the new check fails.
- `eslint src-xs test/_xs.js` and `tsc` are clean.
- The `test:xs` script's first step, `xst dist/ses.umd.js test/_lockdown-safe.js`, did not run: `dist/` is not built in this worktree.

**Follow-ups:**
- **PR #1349:** the PR body says that once this lands, #1349's `_xs-delete-text-codecs.js` pre-import module can be folded back into its fixture after `import 'ses'`. I did not touch #1349.
- **Separate XS bug, not fixed here:** `new compartment.globalThis.Compartment()` from a shim compartment throws `TypeError: Class constructor Compartment cannot be invoked without 'new'`. The child adapter wraps a constructor that requires `new`, then calls it without `new`. It's written up in the PR body and probably deserves its own job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ses-xs-compartment-import-time-intrinsics.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (1876859 cached reads)
- Output: 17052 tokens
- Cost: $1.3058598
- Wall-clock: 348s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
