---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Update the PR #1398 description (endojs/endo-but-for-bots)

The gauntlet fix-1 stage (ebfb-sturdyref-layer8-daemon-formula-20260930-gauntlet-fix-1) on https://github.com/endojs/endo-but-for-bots/pull/1398 could not edit the PR body: the host oros-studio PAT gets a 403 on PR writes to endojs. The round-1 panel's must-fix items include three body edits: integrator wants the #695 reconciliation, benchmarker wants the benchmark-decline note, and pruner wants the Stack index dropped. The body also has to say the changeset was held (curator; head 289b48d44 removes it). Replace the PR body VERBATIM with the text between the markers below, using `gh api -X PATCH repos/endojs/endo-but-for-bots/pulls/1398 -F body=@<file>`. Keep the title unchanged. Change nothing else.

----- BODY -----
Refs: #695
Refs: https://github.com/kriscendobot/garden/issues/47

## Description

Layer 8 of 9 in the SturdyRef layering stack (orchestration `ebfb-sturdyref-layering-20260930`), requested by kriskowal on #695. Arc: https://github.com/kriscendobot/garden/issues/47. Parked design: https://github.com/endojs/endo-but-for-bots/pull/695.

The daemon can mint a **SturdyRef for a formula without incarnating it**, and enlivening that ref later incarnates the formula.

- New `packages/daemon/src/formula-sturdyref.js`: `makeFormulaSturdyRefKit({ provide })` returns
  - `sturdyRefForFormula(id)`: checks the identifier's syntax, then mints a ref (with `@endo/sturdyref`'s `makeSturdyRef`) whose handler closes over `id`. It does **not** consult the formula graph or incarnate anything.
  - `formulaIdOf(ref)`: a closely held reverse map (a WeakMap). It returns the identifier only for refs this kit minted. Other SturdyRefs, other kits' refs, and non-refs all return `undefined`. The daemon keeps it so it can persist a ref or export it under a swiss number (layer 9 / #701–#704 territory).
  - `enliven(ref)` calls `provide(id)` in a later turn, reusing an existing incarnation. It rejects if the formula doesn't exist.
- `makeDaemonCore` (`manager.js`) wires the kit to its own `provide` and returns `sturdyRefForFormula` and `formulaIdOf` on the core.
- `@endo/daemon` now depends on `@endo/sturdyref` (regenerated composite tsconfigs; the lockfile change is in a separate `chore: Update yarn.lock` commit).

Prior art I drew on but did not rebase: #541 (keeping the formula identity on the read side, behind the facet boundary) and #701–#704 (mint/export over a swiss-num store). The OCapN export surface stays out of this layer.

Base: `build/sturdyref-ocapn-enliven-f212191`, a frozen snapshot of layer 7's head.

### Security Considerations

A minted ref carries the formula identifier only inside its handler closure. The identifier is recoverable only through the minting kit's `formulaIdOf`, which `makeDaemonCore` keeps rather than handing to guests. Holding a ref grants exactly the authority to incarnate and obtain that one formula's value, the same as holding the live reference. That authority is deferred, not widened.

This layer stays clear of #695's outstanding changes-requested concern (whether a confined worker should be able to locate or enliven an arbitrary SturdyRef, and the retention/GC-revocation lifecycle a SturdyRef-as-pet-name scheme needs). It mints refs for daemon-core-internal use only: `sturdyRefForFormula` and `formulaIdOf` stay on `makeDaemonCore`'s return value, are not forwarded through `provideEndoBootstrap` or `makeDaemon`, and are not in the package's `exports` map, so no guest gains locate or enliven authority over an arbitrary formula through this change. Any layer that exposes minting to a guest or an OCapN peer must answer #695's confinement and retention questions first.

### Scaling Considerations

Scaling improves: a ref can be handed out without starting a worker or opening a store. Each ref costs one WeakMap entry. Not pursuing a quantitative benchmark: the claim is structural (minting touches no worker, store, or formula graph until `enliven`, which the tests check by observing zero incarnations), not a throughput claim.

### Documentation Considerations

The API is internal to the daemon core and is not reachable from any published entry point of `@endo/daemon`, so this PR carries no changeset. The changeset belongs with the layer that wires these functions to a published surface.

### Testing Considerations

`packages/daemon/test/formula-sturdyref.test.js` (5 tests, passing locally):
- minting creates no incarnation (the observed formula graph records no incarnations), and the ref is frozen and reveals nothing
- `enliven` incarnates on a later turn; enlivening again, or through a second ref, reuses the incarnation
- an unknown formula rejects on enliven; an invalid identifier throws on mint
- `formulaIdOf` works only for the kit that minted the ref

Local verify: the ava suite passes, `yarn lint:types` (daemon) passes, eslint reports 0 errors, and a checkJs pass over the new module is clean. No end-to-end test boots a real daemon yet (see follow-ups).

Follow-up: an end-to-end test against a booted daemon, where minting observes no controller for the id and enlivening creates one. It belongs with the layer that exposes this to a host/guest surface.

### Compatibility Considerations

This change only adds API. The existing `@endo/ocapn` sturdyref and the daemon's OCapN network are untouched.

### Upgrade Considerations

There is no persisted state. Refs are in-memory and do not survive a restart.

<!-- garden-job: ebfb-sturdyref-layer8-daemon-formula-20260930 -->

🤖 Generated with [Claude Code](https://claude.com/claude-code)


----- END BODY -----
