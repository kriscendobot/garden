---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Update the PR #774 description (endojs/endo-but-for-bots)

The gauntlet fix-2 stage on https://github.com/endojs/endo-but-for-bots/pull/774 could not edit the PR body (host oros-studio PAT gets 403 on PR writes to endojs). The round-2 panel integrator flagged a stale description as must-fix. Replace the PR body VERBATIM with the text between the markers below, via `gh api -X PATCH repos/endojs/endo-but-for-bots/pulls/774 -F body=@<file>`. Keep the title unchanged. Nothing else.

----- BODY -----
Refs: https://github.com/endojs/endo-but-for-bots/pull/695#issuecomment-5903472512
Refs: https://github.com/kriscendobot/garden/issues/47
Refs: https://github.com/endojs/endo-but-for-bots/pull/1389

## Description

Layer 1 (build) of the bottom-up SturdyRef layering stack that the maintainer asked for on [endojs/endo-but-for-bots#695](https://github.com/endojs/endo-but-for-bots/pull/695#issuecomment-5903472512). Arc: [kriscendobot/garden#47](https://github.com/kriscendobot/garden/issues/47). This PR implements the contract in the layer-1 design, [endojs/endo-but-for-bots#1389](https://github.com/endojs/endo-but-for-bots/pull/1389) (`designs/sturdyref-shim-contract.md`). It reworks the earlier `fromLocation`/`toLocation` shim in place.

`@endo/sturdyref` installs one realm-shared `SturdyRef` constructor at `globalThis.SturdyRef`, first-wins:

```js
const ref = new SturdyRef({ enliven(ref) { return revive(ref); } });
await SturdyRef.enliven(ref); // calls the hook in a later turn
SturdyRef.isSturdyRef(ref);   // brand check, no authority
```

- `new SturdyRef(handler)` requires an `enliven` method, reads it once, and returns a frozen ref with no own properties that inherits from a hardened `SturdyRef.prototype` (`[object SturdyRef]`). The handler lives only in the constructor's closely held `WeakMap`. Calling without `new` throws.
- `SturdyRef.enliven(ref)` calls `handler.enliven(ref)` in a later turn. A throwing hook, or an argument that is not a ref, gives a rejected promise, not a synchronous throw.
- The ponyfill (`index.js`) exports only `makeSturdyRef`, `enliven`, and `isSturdyRef`, each frozen. The install internals (`provideSturdyRef`, `selectSturdyRef`, `makeSturdyRefConstructor`) stay in `src/sturdyref-shim.js` for tests and the shim entry.
- `shim.js` installs eagerly and may be imported before or after `lockdown()`; before is preferred. Before `lockdown`, the shim never calls `@endo/harden` (which would make `lockdown` throw); it always freezes the constructor, prototype, and statics, and additionally hardens only when a callable harden is already installed.

Kept from the first version: the non-configurable, non-writable first-wins install (a twin's ref passes `isSturdyRef` and `enliven` in another copy) and the ponyfill/shim split.

Replaced as the design directs: `fromLocation`/`toLocation`, the locator `WeakMap`, and the `Far` minting. `@endo/pass-style` is now only a dev dependency, so `passStyleOf` rejects a ref; layer 3 owns passability. The pre-existing-global shape check now requires a function with `enliven` and `isSturdyRef` statics.

Rebased onto frozen `llm-7ff30af`, and the PR base moved there from live `llm`.

**Stack index**

| Layer | Scope | PR |
|---|---|---|
| 1 (design) | SturdyRef shim contract | #1389 |
| 1 (build) | this shim, reworked to the contract | this PR |
| 2 | SES: permit + propagate at `repairIntrinsics` | pending |
| 3 | pass-style: SturdyRefs passable, analogous to presences | pending |
| 4 | marshal: representation per layer | pending |
| 5 | CapTP: mint + carry over the wire (subsumes `ocapn-sturdyref`) | pending |
| 6 | CapTP: construct from data (peer id, object id, designator, hints) | pending |
| 7 | OCapN: enliven via bootstrap / nonce locator | pending |
| 8 | daemon: SturdyRef for a formula without incarnating | pending |
| 9 | Agent API: revisit #695 / #871 | pending |

### Security Considerations

The global no longer amplifies authority. The old `toLocation` turned any token into its locator; the new surface offers only construction around a handler the caller already has, a brand check, and dispatch to the hook of a ref the caller holds. The handler is never reachable from the ref or its prototype. The hook is read once at construction, so a later change to the handler cannot redirect enlivening.

Hardening against code that runs after import but before `lockdown`: the constructor rejects a foreign `new.target` (no caller-chosen prototype on a branded ref); `WeakMap`, its prototype methods, `Promise`, and `Promise.prototype.then` are captured at module load, so replacing them cannot expose the ref-to-handler map or the enlivened value; the constructor is frozen even when an installed harden is a no-op; and adopting an existing global locks the binding. First-wins still trusts whoever installs first: an impostor constructor installed before this shim receives every handler passed to it, so install the shim early. SES has no `SturdyRef` permit yet (layer 2), so a pre-lockdown install is a frozen start-compartment global, not an admitted intrinsic.

### Scaling Considerations

One realm-wide `WeakMap` entry per ref.

### Documentation Considerations

`packages/sturdyref/README.md` documents the constructor, `enliven`, `isSturdyRef`, the ponyfill, and the shim entry.

### Testing Considerations

The tests follow the design's disposition table. New test files cover the pre-lockdown install (`sturdyref-prelockdown`), tampering with `WeakMap.prototype` (`sturdyref-tampered-weakmap`), replacing `WeakMap` and `Promise.prototype.then` before first use (`sturdyref-tampered-intrinsics`), a no-op installed harden (`sturdyref-noop-harden`), and adopting a non-configurable enumerable global (`sturdyref-enumerable-global`). Kept: installed-after-lockdown, no location (rewritten), no identification, first-wins convergence and adoption, and malformed-global rejection. New: capture is handler-defined; the hook runs in a later turn; a throwing hook rejects; a non-ref rejects; the hook is read once; construction without `enliven` or without `new` throws; brand check. The "withheld" test is rescoped to `default: installed after lockdown without a SES permit, a child compartment does not see SturdyRef`. That is an observed default, and layer 2 flips it. Locally, `yarn lint` (0 errors), and `yarn test` (28 passing) pass. `test:xs` is a stub: nothing here is host-specific, and XS coverage is deferred to layer 2 with the SES permit.

### Compatibility Considerations

`@endo/sturdyref` is unreleased (the changeset bumps it `major` for its initial release), so replacing `fromLocation`/`toLocation` breaks nothing that has shipped. llm's `ocapn-sturdyref` in `@endo/ocapn`, and its thixotrope and goblin-chat consumers, are untouched; layer 5 subsumes them. Draft #737, which is stacked on this branch, is reference material for the stack and has not been rebased.

### Upgrade Considerations

None.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

<!-- garden-job: ebfb-sturdyref-layer1-shim-build-20260930 -->


----- END BODY -----
