---
kind: result
who: liaison
where: endolinbot
at: 2026-06-08T10:52:28Z
dispatch_root: /home/kris/garden/dispatches/liaison--3a2183
---

# Librarian cycle 225 (chat-lane) — @endo/init/node-async_hooks ingested

Cycle 225 alternates back to chat-lane after cycle 224's designs-lane (daemon-web-gateway). §Fifty-ninth consecutive designs-chat alternation cycle.

## Source

`endojs/endo packages/init/src/node-async_hooks.js` — 240 lines (companion files: `node-async_hooks-patch.js` 4 lines + `node-async-local-storage-patch.js` 98 lines). Bridges Node.js's `async_hooks` machinery with SES lockdown — solves the §collision-between-Node's-per-promise-tracking-symbols and §SES-lockdown's-frozen-Promise.prototype.

## What landed

- **Section file**: `library/sections/endo--packages-init-node-async_hooks--two-strategies-for-async-hooks-symbol-discovery-and-never-resolving-promise-trigger-and-reset-hook-trick-and-WeakMap-fallback-for-frozen-promises.md`.
- **Source page**: `library/sources/endo--packages-init-node-async_hooks.md`.
- **Sources/README.md**: new row above cycle 224.
- **Sections/README.md**: new section + Total → "731 sections from 272 source documents".
- **keywords.md**: ~34 new keyword entries.
- **scholar inbox**: drain pointer updated to `pending-cycle-225`.

## Borrowable patterns

- §Two-strategies-for-async-hooks-symbol-discovery with §cost-coverage-trade-off + §named-option-to-pick.
- §The-never-resolving-promise-as-trigger (`new Promise(() => {})`) — observe construction without settlement.
- §The-reset-hook-enable-then-disable-trick — use a platform API's side-effect without its purpose.
- §Named-Node-v14.16.2-version-specific-workaround — §sixth-member of §runtime-version-or-environment-compat-hacks-and-disclosures family.
- §The-destroy-hook-only-needs-to-exist-to-trigger-Node-installing-the-destroyed-symbol — §when-the-platform's-behavior-depends-on-whether-you-passed-a-callback, §pass-the-empty-callback-to-trigger-the-behavior.
- §The-property-descriptor-factory with §`disallowGet`-variant.
- §The-setAsyncSymbol-three-case-logic (unknown / first-time / subsequent).
- §The-WeakMap-fallback-for-frozen-promises — §Reflect.defineProperty-returns-false-on-failure routes to fallback; §use-the-failure-path-to-route-to-a-fallback.
- §Named-sentinel-return-value (`-2`) for §this-version-doesn't-need-the-shim.
- §Two-named-out-of-scope-cases with named policy.
- §Debug-prints-left-as-commented-comments — §process._rawDebug-bypasses-SES-tamed-console; §third-shape-of-debug-instrumentation-in-production-code.
- §Pre-lockdown-installation-of-properties-that-lockdown-would-block; §pre-lockdown-installation-of-runtime-discovered-symbols.
- §Module-pattern-for-singleton-with-internal-state (vs class-pattern for value-types-with-instances).

## Meta-observations

- §Six-different-runtime-version-or-environment-compat-hacks-and-disclosures family: cycles 199 + 205 + 213 + 217 + 223 + 225. The pattern now spans bigint-literals + babel-defaults + Node-streams + SES-versions + Node-ESM + Node-async_hooks-with-frozen-promises.
- §Three-different-shapes-for-debug-instrumentation-in-production-code: cycle 90 `__HIDE_`-prefix (hides from stack traces) + cycle 130 env-option-gated breakpoint tester + cycle 225 commented-out-debug-prints (easy to reactivate).
- §Pre-lockdown-installation-of-runtime-discovered-symbols connects cycles 219 (@endo/ses-ava registered-symbol-on-globalThis) and 225 (Promise.prototype symbol installation).
- §Two-different-design-choices-for-two-different-shapes: cycle 223 @endo/module-source uses class-pattern for value-types-with-instances; cycle 225 uses module-pattern for singleton-with-internal-state.
- §Thirty-first-member of §small-files-with-large-knowledge-density family.
- §Fifty-ninth consecutive designs-chat alternation, cycles 166-225.
- §Library-reaches-731-sections at cycle 225.
- Papers-lane blocked 119+ consecutive cycles.

## Next

Cycle 226 will be designs-lane (alternating from cycle 225's chat-lane). ScheduleWakeup for ~25 min.
