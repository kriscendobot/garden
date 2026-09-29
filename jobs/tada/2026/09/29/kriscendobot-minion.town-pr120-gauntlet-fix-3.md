Fix round 3 for kriscendobot/minion.town#120 (gauntlet `kriscendobot-minion.town-pr120-gauntlet`) is pushed and CI is green: all 3 checks passed at `eaebbf9`. The panel's draft/evidence gate (item 1) still blocks, and no code change can clear it. I pushed two follow-up commits on top of `b0ae3f4` using `safe-push-pr-head.sh`.

**Must-fix items from panel round 3:**
1. **Draft/evidence gate:** no code change can clear it. The PR stays draft until endojs/endo-but-for-bots#1015 lands and the root, confinement, delegation and restart canaries run.
2. **Stale `ClaudeAgent.infer` came back to life when a name was reused** (saboteur): fixed. `makeClaudeAgent` now takes the `ChildRecord` and checks liveness by identity (`byId.get(id) === childRecord`), not by whether the id is present.
3. **Delegated children are orphaned after a restart** (engine-realist): documented as a limitation, not fixed in code. Without the in-memory ledger the root has no way to list the `#delegation/` namespaces, and that needs the persisted grant index on the #1015 substrate. The module doc no longer claims every lost child is still torn down. It now records this case as an open item for the restart canary.
4. **`removeChild` ran twice when `create` raced `dismiss`/`revoke`** (corner-prober): fixed.
   - `tree.dismissing` is now a `Map` from key to a promise that settles when that key's teardown ends (new helper `claimTeardown`).
   - `teardownNamespace` now takes that claim too; `dismiss` already did.
   - `create`'s race branches wait out any teardown of the key still in flight, then clean up under their own claim through `teardownUnrecordedChild`. That path only removes a child the directory still lists, so the child is never removed twice.
5. **`ChildScope.max`** (stylist): renamed to `maxChildren`.

**Should-fix items also done:**
- In `never-reject.ts`, the wrapped parameter `fn` is renamed to `method`.
- The catch in `inbox-watch.ts`'s `deliver` now has a comment explaining it is defense in depth.
- A test for `maxChildren: 0` already existed, so nothing was added for it.

**Tests:**
- Four new tests, all run against `makeStrictChildHost`:
  - a dismiss racing a create removes the child once;
  - a revoke racing a delegated create removes the child once and returns `needs-auth`;
  - a revoke still in flight when the create resumes is waited out;
  - a stale handle stays inert after dismissing and re-creating the same name.
- All four fail against the old `agents.ts`/`quota.ts` and pass with the fix.
- Locally, `tsc --noEmit` is clean and `npm test` passes: 516 passed, 7 skipped.

**Commits:**
- `5cd384a` fix(claude): stale agents stay inert on name reuse; create converges raced teardown once
- `eaebbf9` style(claude): ChildScope.maxChildren, never-reject `method`, inbox catch comment

**Follow-ups (not done here):**
- The restart canary and a persisted grant index on #1015, which is what actually fixes item 3.
- Three more should-fix items: malformed-argument tests for the `RootClaudeAccount`/`ClaudeAccountStatus` guards under lockdown, a completion-summary comment, and fast-check property tests.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr120-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1650265 cached reads)
- Output: 16492 tokens
- Cost: $1.3995570000000002
- Wall-clock: 472s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
