I opened layer 8 of the SturdyRef stack as draft PR endojs/endo-but-for-bots#1398. The daemon can now mint a SturdyRef for a formula without incarnating it, and enlivening the ref later incarnates the formula. The unit tests pass, but nothing tests this against a real booted daemon yet.

**What changed** (branch `build/sturdyref-daemon-formula`):
- **New module** `packages/daemon/src/formula-sturdyref.js`: `makeFormulaSturdyRefKit({ provide })` provides:
  - `sturdyRefForFormula(id)` checks the identifier's syntax and mints a ref that holds only that identifier. It does not look up or incarnate the formula.
  - `formulaIdOf(ref)` recovers the identifier, but only for refs the same kit minted.
  - Enlivening a ref calls `provide(id)` in a later turn and reuses an existing incarnation. It rejects if the formula doesn't exist.
- **Daemon core** (`manager.js`): the kit is wired to the daemon's own `provide`, and the core now exposes `sturdyRefForFormula` and `formulaIdOf`.
- **Housekeeping**:
  - `@endo/daemon` now depends on `@endo/sturdyref`.
  - Regenerating the composite tsconfigs also reordered `packages/ocapn/tsconfig.composite.json`, which layer 7 had left out of date.
  - A minor changeset for `@endo/daemon`.
  - The `yarn.lock` change is in its own `chore: Update yarn.lock` commit.
- **Tests** (`packages/daemon/test/formula-sturdyref.test.js`, 5 passing):
  - Minting a ref causes no incarnation.
  - Enlivening incarnates the formula in a later turn, and enlivening again reuses that incarnation.
  - An unknown formula rejects and a malformed identifier throws.
  - Only the minting kit can recover the identifier.

**Checks run locally:**
- The daemon's `yarn lint:types` passes.
- eslint reports 0 errors (warnings only).
- A strict JS type check of the new module is clean.

I did not run a test that boots a real daemon, and CI hasn't reported yet.

**Stacking:** I pushed a frozen snapshot of layer 7's head as `build/sturdyref-ocapn-enliven-f212191` and used it as the PR base, matching how layer 7 is based on a frozen layer 6. The PR body links #695 and the arc (kriscendobot/garden#47). It also lists the stack: #774/#1389, #1391, #1392, #1393, #1394, #1396, #1397, then this PR, with layer 9 pending. The repo's PR template check rejected a separate "Stack index" heading, so the list sits as bold text inside the Description section.

**Follow-ups:**
- An end-to-end test on a booted daemon (minting creates no controller for the id; enlivening creates one). It fits best with whichever layer exposes this to hosts or guests.
- Exporting these refs over OCapN under a swiss number (the #701–#704 prior art) is left for later layers.
- The PR stays a draft.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer8-daemon-formula-20260930.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1723406 cached reads)
- Output: 14189 tokens
- Cost: $1.1545092000000001
- Wall-clock: 232s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
