All CI checks are green (17 pass, 15 skipping, 0 pending, 0 failing) on my pushed head commit `69943c50ae`. The fix stage is complete.

## Completion report

**Job:** endojs/endo-but-for-bots PR #1304 gauntlet — FIX round 5.

**Panel-5 must-fix items applied** (commit `69943c50ae`, pushed to PR head `bot/build/1125-readonly-directory-attenuation`):

1. **Revocation gate not synchronous with cancellation** (purist, wire-watcher, engine-realist, saboteur) — re-keyed all three read-only-view liveness gates (`directory.js`, `manager.js` mailHub + messageHub) off `void context.cancelled.catch(() => { cancelled = true; })` instead of a `context.onCancel` hook. The old hook-driven flag flipped only behind every later-registered peer hook in the serial `hooks.reverse()` drain, so a slow/never-settling peer kept a revoked directory forwarding reads; `.catch` on `cancelled` trips one microtask after synchronous rejection regardless of drain order.
2. **`context.js` late-hook widening swallows failures / escapes disposal** (engine-realist, saboteur) — reverted the round-4 `onCancel`-after-`done` change (detached `Promise.resolve().then(hook).catch(()=>{})`) back to the original no-op, and reverted its two `context.test.js` test changes. No gate needs the widening now that they read `cancelled`.
3. **Help text overstates the revocation guarantee** (saboteur, wire-watcher) — reworded the `readOnly` entry in `help.md` (source) + regenerated `help-text-data.js`: the gate stops further reads after revocation, but a capability already returned by an earlier lookup is unaffected (and may itself be writable per the shallow caveat). Dropped "grants no authority the daemon believes it revoked".
4. **Capability-escape note names wrong vector** (breaker summary-fix) — corrected both manager.js comments: `@slots` is registered as *data* (array of strings), not a capability; enumerated the authority-bearing `@resolver`/`@promise`/`@value`/`@from`/`@to`/package-edge names (each registered with an `id`).

**Deliberately not applied — must-fix #3 (integrator, stacked-consumer seam for #1306):** this asks to restore the deleted formula-backed view / `isReadOnlyDirectoryFormula`, a design-scope reversal. The maintainer (kriskowal) **APPROVED** the current no-formula shape and commented "Please conduct" after the panel began this loop, so the scope is maintainer-endorsed; a gardener does not revert an approved design on the automated panel's word. Left for the driver's panel-6 / maintainer to reconcile with #1306.

**Verification:** `yarn lint:types` clean; `eslint` on the four changed source + test files = 0 errors (only pre-existing warnings); prettier clean; excluded stray `packages/floot/package.json` warm-cache noise from the commit. Local `context.test.js` (11 pass) and `directory-read-only-view.test.js` (6 pass) green.

**CI:** all checks terminal green — 17 pass, 15 skipping, 0 pending, 0 failing (the four `test` matrix cells: 24.x/22.x × ubuntu/macos all pass).

**Follow-ups:** panel-6 (re-posted by the driver) will re-evaluate; the #1306 formula-scope question (#3) and remaining should-fix nits (types.d.ts JSDoc trim, per-round completion-summary comment) remain for that round or the maintainer.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1304-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 134 tokens (6215071 cached reads)
- Output: 25368 tokens
- Cost: $4.908349499999998
- Wall-clock: 1036s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
