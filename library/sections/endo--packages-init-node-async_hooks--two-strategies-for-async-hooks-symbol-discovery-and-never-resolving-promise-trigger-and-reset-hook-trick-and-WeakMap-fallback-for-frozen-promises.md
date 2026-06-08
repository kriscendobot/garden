---
title: "@endo/init/node-async_hooks — §two-strategies-for-async-hooks-symbol-discovery + §never-resolving-promise-as-trigger + §reset-hook-trick + §WeakMap-fallback-for-frozen-promises + §debug-prints-left-as-commented-comments + §named-Node-version-specific-workarounds"
source-slug: endo--packages-init-node-async_hooks
section-id: two-strategies-for-async-hooks-symbol-discovery-and-never-resolving-promise-trigger-and-reset-hook-trick-and-WeakMap-fallback-for-frozen-promises
url: https://github.com/endojs/endo/blob/master/packages/init/src/node-async_hooks.js
authors: [Endo contributors]
repo: endojs/endo
path: packages/init/src/node-async_hooks.js
status: shipping
ingest-cycle: 225
ingest-date: 2026-06-08
lane: chat
---

# @endo/init/node-async_hooks — Make Node async_hooks coexist with SES-frozen Promise.prototype

A 240-line file in `@endo/init` that bridges Node.js's `async_hooks` machinery with SES lockdown. §The-problem: Node's async_hooks library installs per-promise tracking symbols on the Promise prototype; SES lockdown freezes Promise.prototype; the two collide unless something gives. §The-solution-installed-by-this-file: §intercept-the-symbol-setting-on-the-prototype + §fall-back-to-WeakMap-when-defineProperty-fails-on-a-frozen-promise.

## §The-three-symbols-async_hooks-needs

```js
const asyncHooksSymbols = {
  async_id_symbol: undefined,
  trigger_async_id_symbol: undefined,
  destroyed: undefined,
};
```

§Three-named-symbol-slots that must be filled before lockdown. §The-symbols-are-internal-to-Node + §their-string-descriptions-are-stable-across-versions-but-the-symbol-values-are-not. §This-file-discovers-them-at-runtime-by-description.

§Borrowable-pattern: §when-a-host-API-uses-internal-Symbols-you-need-to-reference, §discover-them-by-their-description-string. §The-description-IS-the-protocol-but-the-symbol-IS-the-key.

## §Two-strategies-for-async-hooks-symbol-discovery

The file defines §two-named-discovery-strategies with §different-cost-and-coverage:

### Strategy 1: §findAsyncSymbolsFromAsyncResource (cheap, partial)

```js
const findAsyncSymbolsFromAsyncResource = () => {
  let found = 0;
  for (const sym of Object.getOwnPropertySymbols(
    new AsyncResource('Bootstrap'),
  )) {
    const { description } = sym;
    if (description && description in asyncHooksSymbols) {
      if (setAsyncSymbol(description, sym)) {
        found += 1;
      }
    }
  }
  return found;
};
```

§Find-symbols-on-a-fresh-AsyncResource-instance. §Cheap (one allocation, no hook enable/disable). §But-only-gets-two-of-the-three: `async_id_symbol` and `trigger_async_id_symbol` (not `destroyed`).

### Strategy 2: §findAsyncSymbolsFromPromiseCreateHook (expensive, complete)

```js
const getPromiseFromCreateHook = () => {
  const bootstrapHookData = [];
  const bootstrapHook = createHook({
    init(asyncId, type, triggerAsyncId, resource) {
      if (type !== 'PROMISE') return;
      bootstrapHookData.push({ asyncId, triggerAsyncId, resource });
    },
    destroy(_asyncId) {
      // Needs to be present to trigger the addition of the destroyed symbol
    },
  });

  bootstrapHook.enable();
  // Use a never resolving promise to avoid triggering settlement hooks
  const trigger = new Promise(() => {});
  bootstrapHook.disable();
  // ...
};
```

§Enable-a-hook + §create-a-trigger-promise + §disable-the-hook + §extract-the-data. §More-expensive (a hook is enabled and disabled). §Gets-all-three-symbols including `destroyed`.

§The-honest-comment names the destroy-hook's purpose:

> destroy(_asyncId) { // Needs to be present to trigger the addition of the destroyed symbol }

§Just-providing-the-destroy-callback-changes-Node's-behavior — Node only installs the `destroyed` symbol if a destroy hook exists. §Borrowable-pattern: §when-the-platform's-behavior-depends-on-whether-you-passed-a-callback, §pass-the-empty-callback-to-trigger-the-behavior.

### §setup({ withDestroy }) chooses between them

```js
export const setup = ({ withDestroy = true } = {}) => {
  if (withDestroy) {
    findAsyncSymbolsFromPromiseCreateHook();
  } else {
    findAsyncSymbolsFromAsyncResource();
  }
  // ...
};
```

§Two-strategies-with-a-cost-coverage-trade-off + §a-named-option-to-pick. §Borrowable-pattern: §when-two-strategies-have-different-cost-and-coverage, §default-to-the-complete-one + §let-the-caller-opt-out-with-a-named-option.

§Sibling to cycle 218 familiar-chat-weblet-hosting's §two-CapTP-transports — both designs §two-options-with-named-trade-offs.

## §The-never-resolving-promise-as-trigger

```js
const trigger = new Promise(() => {});
```

§A-Promise-with-an-executor-that-never-calls-resolve-or-reject. §Used-purely-as-a-test-fixture — §enables-the-async-hook's-init-callback to fire + §avoids-triggering-settlement-hooks.

§Borrowable-pattern: §use-a-never-resolving-promise-as-a-test-fixture-to-observe-construction-without-settlement. §The-Promise-is-a-side-effect-machine + §the-side-effect-of-construction-is-what-we-want + §the-side-effect-of-settlement-is-what-we-don't-want.

§Sibling to cycle 152 promise-kit memo-race.js's §primitive-fake-settled-record idiom — both designs §use-degenerate-Promise-shapes-as-test-fixtures.

## §The-reset-hook-trick

```js
if (promiseData) {
  // ...
  const resetHook = createHook({});
  resetHook.enable();
  resetHook.disable();
} else if (length) {
  // process._rawDebug('No candidates matched');
}
```

§Enable-then-immediately-disable-a-no-op-hook. §The-side-effect: it disables Node's internal promise init hook that would otherwise §fire-on-promises-created-in-this-turn-even-after-the-bootstrapHook-is-disabled.

§The-honest-comment:

> Normally all promise hooks are disabled in a subsequent microtask. That means Node versions that modify promises at init will still trigger our proto hooks for promises created in this turn. The following trick will disable the internal promise init hook.

§Followed-by-a-known-exception:

> However, only do this for destroy modifying versions, since some versions only modify promises if no destroy hook is requested, and do not correctly reset the internal init promise hook in those case. (e.g. v14.16.2)

§Borrowable-pattern: §the-`enable()-then-disable()`-no-op-trick reuses §a-platform-API's-side-effect-without-the-API's-purpose. §The-trick-is-conditional + §named-Node-version-where-it-doesn't-work (v14.16.2).

§Sibling to cycle 217 @endo/errors' §two-comment-out-lines (`'bare'` + `'makeError'`) — both designs §named-tolerance-for-a-specific-runtime-version. §Cycle-225-is-the-sixth-member of §runtime-version-or-environment-compat-hacks-and-disclosures family.

§Six-different-runtime-version-or-environment-compat-hacks-and-disclosures family:
| Cycle | Source | Hack or disclosure |
| --- | --- | --- |
| 199 | @endo/nat | Apps-Script bigint-literal-workaround |
| 205 | @endo/evasive-transform | Babel-traverse default-import-workaround |
| 213 | @endo/stream-node | Node-14 unhandled-error-race-defense |
| 217 | @endo/errors | Pre-1.13.0 SES Agoric-bootstrap-vat tolerance |
| 223 | @endo/module-source | Node 14 vs 16 vs `node -r esm` babel-default-export matrix |
| 225 | @endo/init/node-async_hooks | Node v14.16.2 destroyed-hook-exception |

§Six-different-environments. §The-pattern-now-spans-bigint-literals + babel-defaults + Node-streams + SES-versions + Node-ESM + Node-async_hooks.

## §The-WeakMap-fallback-for-frozen-promises

```js
const promiseAsyncHookFallbackStates = new WeakMap();

const setAsyncIdFallback = (promise, symbol, value) => {
  const state = getAsyncHookFallbackState(promise, { create: true });

  if (state[symbol]) {
    if (state[symbol] !== value) {
      // This can happen if a frozen promise created before hooks were enabled
      // is used multiple times as a parent promise
      // It's safe to ignore subsequent values
    }
  } else {
    state[symbol] = value;
  }
};
```

§The-belt-and-suspenders-pattern: when Reflect.defineProperty on the promise fails (because the promise is frozen), §fall-back-to-a-WeakMap-keyed-by-promise.

```js
set(value) {
  if (
    !Reflect.defineProperty(this, symbol, {
      value,
      writable: disallowGet,
      configurable: false,
      enumerable: false,
    })
  ) {
    setAsyncIdFallback(this, symbol, value);
  }
},
```

§Reflect.defineProperty-returns-false-on-failure (instead of throwing). §The-falsey-return-triggers-the-fallback-path.

§Borrowable-pattern: §when-an-operation-might-fail-silently-via-return-false, §check-the-return-and-fall-back-without-throwing. §Sibling to cycle 215 @endo/hex's §native-error-rerun-polyfill-for-better-diagnostic — both designs §use-the-failure-path-to-route-to-a-fallback.

§Honest-acknowledgment-of-edge-case:

> This can happen if a frozen promise created before hooks were enabled is used multiple times as a parent promise. It's safe to ignore subsequent values.

§Borrowable-pattern: §when-an-edge-case-is-rare-and-the-ignore-policy-is-safe, §name-the-edge-case + §name-the-policy.

## §The-property-descriptor-factory with §disallowGet-variant

```js
const getAsyncHookSymbolPromiseProtoDesc = (
  symbol,
  { disallowGet = false } = {},
) => ({
  set(value) { /* ... */ },
  get() {
    if (disallowGet) {
      return undefined;
    }
    const state = getAsyncHookFallbackState(this, { create: false });
    return state && state[symbol];
  },
  enumerable: false,
  configurable: true,
});
```

§Factory-returns-a-property-descriptor + §`disallowGet`-option-changes-the-getter. §The-`destroyed`-symbol-uses-disallowGet:

```js
Object.defineProperty(
  PromiseProto,
  asyncHooksSymbols.destroyed,
  getAsyncHookSymbolPromiseProtoDesc(asyncHooksSymbols.destroyed, {
    disallowGet: true,
  }),
);
```

§The-`destroyed`-symbol-only-needs-a-setter — Node writes to it; nothing reads it. §The-disallowGet-makes-the-getter-return-undefined (and skip the WeakMap lookup).

§Borrowable-pattern: §when-a-Symbol-is-write-only-from-the-host-side, §disallow-get-to-avoid-leaking-fallback-state.

§Workaround-comment:

> Workaround a Node bug setting the destroyed sentinel multiple times

§The-writable: disallowGet line is the §double-purpose: when disallowGet is true, the property is writable so Node can re-set it. §Borrowable-pattern: §the-writable-flag-can-encode-Node-version-quirks-not-just-mutation-policy.

## §The-debug-prints-left-as-commented-comments

```js
// process._rawDebug(
//   `Found duplicate ${description}:`,
//   symbol,
//   asyncHooksSymbols[description],
// );

// process._rawDebug('Found multiple potential candidates');

// process._rawDebug('No candidates matched');

// process._rawDebug(`Async symbols not found, moving on`);

// process._rawDebug(`Couldn't find destroyed symbol to setup trap`);

// process._rawDebug('fallback set of async id', symbol, value, Error().stack);
```

§Six-named-debug-prints commented out throughout the file. §Borrowable-pattern: §debug-prints-left-as-commented-comments-for-easy-reactivation. §When-the-bug-recurs-the-developer-uncomments-them.

§process._rawDebug-not-console.log because §the-console-might-be-tamed-by-SES + §process._rawDebug-bypasses-Node's-console.

§Sibling to cycle 90 track-turns.js's §`__HIDE_`-prefix discipline — both designs §keep-debug-instrumentation-near-the-code-it-instruments without making it production noise. §Cycle-90-prefixes-functions; §cycle-225-comments-out-the-call-sites.

§Borrowable-pattern: §three-different-shapes-for-debug-instrumentation-in-production-code:
- Cycle 90: §`__HIDE_`-prefix-hides-from-stack-traces + active in production but invisible.
- Cycle 130 message-breakpoints: §env-option-gated breakpoint tester + active only when ENV var set.
- Cycle 225: §commented-out-debug-prints + inactive but easy-to-reactivate.

## §Two-named-out-of-scope cases

The file has §two-honest-acknowledgments-of-cases-it-doesn't-handle:

1. **§Frozen-promise-reused-as-parent**:
   > This can happen if a frozen promise created before hooks were enabled is used multiple times as a parent promise. It's safe to ignore subsequent values.

2. **§Node-version-not-mutating-promises**:
   > // This node version is not mutating promises
   > return -2;

§The-return-value-of-`-2` is a §named-sentinel for §this-version-doesn't-need-the-shim. §Borrowable-pattern: §return-a-specific-named-sentinel-for-a-named-platform-condition; §the-caller-can-distinguish-not-found-(0)-from-not-applicable-(-2).

## §The-setAsyncSymbol-three-case-logic

```js
const setAsyncSymbol = (description, symbol) => {
  if (!(description in asyncHooksSymbols)) {
    throw Error('Unknown symbol');
  } else if (!asyncHooksSymbols[description]) {
    if (symbol.description !== description) {
      throw Error(
        `Mismatched symbol found for ${description}: ${String(symbol)}`,
      );
    }
    asyncHooksSymbols[description] = symbol;
    return true;
  } else if (asyncHooksSymbols[description] !== symbol) {
    // process._rawDebug(
    //   `Found duplicate ${description}:`,
    //   symbol,
    //   asyncHooksSymbols[description],
    // );
    return false;
  } else {
    return true;
  }
};
```

§Three-cases-with-three-different-return-values:
1. §Unknown-symbol-description → throw.
2. §First-time-setting → validate-description-matches + assign + return true.
3. §Subsequent-setting:
   - §Same-symbol → return true (idempotent).
   - §Different-symbol → return false (duplicate; logged).

§Borrowable-pattern: §the-symbol-registration-function-distinguishes-unknown-from-first-time-from-duplicate. §The-validation-against-`symbol.description !== description` is §the-belt-and-suspenders-check on top of the allow-list check.

## §The-PromiseProto.defineProperty-on-three-symbols

```js
Object.defineProperty(
  PromiseProto,
  asyncHooksSymbols.async_id_symbol,
  getAsyncHookSymbolPromiseProtoDesc(asyncHooksSymbols.async_id_symbol),
);
Object.defineProperty(
  PromiseProto,
  asyncHooksSymbols.trigger_async_id_symbol,
  getAsyncHookSymbolPromiseProtoDesc(asyncHooksSymbols.trigger_async_id_symbol),
);

if (asyncHooksSymbols.destroyed) {
  Object.defineProperty(
    PromiseProto,
    asyncHooksSymbols.destroyed,
    getAsyncHookSymbolPromiseProtoDesc(asyncHooksSymbols.destroyed, {
      disallowGet: true,
    }),
  );
}
```

§Install-three-accessor-properties-on-Promise.prototype-before-SES-lockdown. §Two-required (async_id_symbol + trigger_async_id_symbol) + §one-conditional (destroyed, only if Strategy 2 found it).

§Borrowable-pattern: §install-prototype-properties-with-symbols-discovered-at-runtime-before-the-prototype-is-frozen. §Sibling to cycle 219 @endo/ses-ava's §registered-symbol-on-globalThis-as-cross-module-coordination — both designs §pre-lockdown-installation-of-runtime-discovered-symbols.

## §The-file-must-run-before-lockdown

§The-whole-file-is-pre-lockdown-prep. §If-it-runs-after-lockdown, §the-Promise.prototype-is-frozen + §Object.defineProperty-throws-or-returns-false. §The-file-belongs-to-`@endo/init` which §loads-before-SES-lockdown-as-the-precondition-arrange-stage.

§Sibling to cycles 132 + 146 + 154 + 199 + 219 + 223 (the §freeze-not-harden-with-named-correctness-argument family). §Cycle-225-is-different — §it's-not-just-pre-lockdown-frozen-objects, §it's-pre-lockdown-installation-of-properties-that-lockdown-would-block. §Different-load-order-discipline-but-same-load-order-substrate.

## §The-module-pattern-vs-class-pattern

§Module-pattern: §closure-state (`asyncHooksSymbols`, `promiseAsyncHookFallbackStates`) + §exported-setup-function. §No-class + §no-`new` + §single-singleton-per-module-load.

§Borrowable-pattern: §when-the-shape-is-a-singleton-with-internal-state, §use-module-closure-state + §exported-setup. §Sibling to cycle 223 @endo/module-source which uses §class-pattern for the ModuleSource value-type. §Two-different-design-choices-for-two-different-shapes (class for value-types-with-instances; module for singleton-with-internal-state).

## Related material in the library

- **cycle 90 ses/error/track-turns.js**: §causal-console-annotation sibling — both designs install side-effect machinery before lockdown.
- **cycle 132 + 146 + 154 + 199 + 219 + 223**: §freeze-not-harden-with-named-correctness-argument family (cycle 225 is the seventh member with a different shape — pre-lockdown property installation).
- **cycle 199 + 205 + 213 + 217 + 223 + 225**: §runtime-version-or-environment-compat-hacks-and-disclosures family (cycle 225 adds the sixth member with the Node v14.16.2 destroyed-hook-exception).
- **cycle 219 @endo/ses-ava**: §registered-symbol-on-globalThis-as-cross-module-coordination sibling — both designs §pre-lockdown-installation-of-runtime-discovered-symbols.
- **cycle 152 @endo/promise-kit memo-race**: §primitive-fake-settled-record idiom sibling — both designs §use-degenerate-Promise-shapes-as-fixtures.
- **cycle 215 @endo/hex**: §native-error-rerun-polyfill-for-better-diagnostic sibling — both designs §use-the-failure-path-to-route-to-a-fallback.
- **cycle 217 @endo/errors**: §two-comment-out-lines-as-load-bearing-comments sibling — both designs §named-tolerance-for-a-specific-runtime-version.
- **cycle 223 @endo/module-source**: §class-pattern-vs-module-pattern contrast.
- **cycle 130 eventual-send/message-breakpoints**: §env-option-gated-instrumentation contrast to cycle-225's commented-out-debug-prints.

## §Library-reaches-731-sections at cycle 225 (chat-lane @endo/init/node-async_hooks).

## §Fifty-ninth consecutive designs-chat alternation cycles 166-225.

## §Six-different-runtime-version-or-environment-compat-hacks-and-disclosures family

| Cycle | Source | Hack or disclosure |
| --- | --- | --- |
| 199 | @endo/nat | Apps-Script bigint-literal-workaround |
| 205 | @endo/evasive-transform | Babel-traverse default-import-workaround |
| 213 | @endo/stream-node | Node-14 unhandled-error-race-defense |
| 217 | @endo/errors | Pre-1.13.0 SES Agoric-bootstrap-vat tolerance |
| 223 | @endo/module-source | Node 14 vs 16 vs `node -r esm` babel-default-export matrix |
| 225 | @endo/init/node-async_hooks | Node v14.16.2 destroyed-hook-exception + WeakMap-fallback-for-frozen-promises |

§Six-different-environments. §The-pattern-now-spans-bigint-literals + babel-defaults + Node-streams + SES-versions + Node-ESM + Node-async_hooks-with-frozen-promises.

## §Three-different-shapes-for-debug-instrumentation-in-production-code

| Cycle | Source | Mechanism |
|-------|--------|-----------|
| 90 | track-turns.js | §`__HIDE_`-prefix on function names (hides from stack traces) |
| 130 | message-breakpoints.js | §env-option-gated breakpoint tester (active only when ENV var set) |
| 225 | node-async_hooks.js | §commented-out-debug-prints (inactive but easy to reactivate) |

§Three-different-approaches: hide-from-trace + opt-in-via-env + comment-then-uncomment.

## §Thirty-first-member of §small-files-with-large-knowledge-density family.
