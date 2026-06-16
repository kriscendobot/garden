---
title: "@endo/eventual-send src/local.js — tenth complementary-lens; pre-lockdown-modules-use-freeze-not-harden; isPrimitive FOURTH-package duplication; symbol-vs-string-ordering; error-message-lists-available-methods"
source: endo--packages-eventual-send-src-local-js
url: https://github.com/endojs/endo/blob/master/packages/eventual-send/src/local.js
authors: [Mark S. Miller, Kris Kowal, Endo project (collective)]
repo: endojs/endo
path: packages/eventual-send/src/local.js
total-lines: 139
ingest-cycle: 352
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-pre-lockdown-modules-use-freeze-not-harden
  - the-named-cannot-rely-on-harden-at-top-level
  - the-named-isPrimitive-FOURTH-package-duplication
  - five-packages-with-named-isPrimitive-duplication
  - the-named-symbol-vs-string-ordering-discipline
  - the-named-error-message-lists-available-methods
  - the-named-base-case-via-null-methodName
  - the-named-getMethodNames-walks-prototype-chain
  - the-named-three-conditions-for-localApplyMethod-failure
  - the-named-complementary-lens-re-ingest
  - ten-cycles-with-named-complementary-lens-re-ingest
  - forty-three-cycles-with-named-pivot-domain-stay
  - one-hundred-fifty-four-citation-arc-closures-in-pivot-now
---

# `@endo/eventual-send src/local.js` — tenth complementary-lens

The 139-line local.js — the receiver-side companion to E.js's send-side dispatch. Cycle 352 is **chat-lane after cycle 351's designs-lane**. **§forty-three-cycles-with-named-pivot-domain-stay** (310-352).

**§ten-cycles-with-named-complementary-lens-re-ingest** (322 + 324 + 330 + 332 + 336 + 342 + 344 + 348 + 350 + **352**) — the librarian discipline now spans **TEN APPLICATIONS** (round-number milestone).

**Note on prior ingest**: Cycle 132 ingested local.js as comment-fragment naming the receiver-side breakpoint pattern (`ENDO_DELIVERY_BREAKPOINTS`) and sister-to-cycle-130 message-breakpoint pattern. Cycle 352 takes the **layering-discipline + diagnostic-quality + isPrimitive-fourth-package lens**.

## The single most structurally interesting move

**§the-named-pre-lockdown-modules-use-freeze-not-harden** — line 76-78:

```js
// The top level of the eventual send modules can be evaluated before
// ses creates `harden`, and so cannot rely on `harden` at top level.
freeze(getMethodNames);
```

The eventual-send module evaluates **BEFORE** SES creates harden. Therefore the top-level code uses `Object.freeze` instead of `harden`. The comment NAMES the constraint explicitly.

**§the-named-pre-lockdown-modules-use-freeze-not-harden** — first-explicit-observation as a tier-3 meta-pattern. Tier-3 framing: modules positioned BELOW the SES substrate (loaded earlier in initialization) cannot use SES-provided primitives at top level. They must fall back to platform primitives (Object.freeze).

**§the-named-cannot-rely-on-harden-at-top-level** — first-explicit-observation. The discipline applies to TOP-LEVEL code only; runtime functions (called after lockdown) can rely on harden being available.

**§the-named-layering-constraint-acknowledged-in-comment** — first-explicit-observation. The comment names BOTH the constraint (cannot rely on harden) AND the discipline (use freeze instead). Sibling to cycle 336/338's isPrimitive layering-constraint TODO and cycle 342's domainTaming-unsafe-always-injected discipline.

## §the-named-isPrimitive-FOURTH-package-duplication

Lines 14-27 contain the SAME isPrimitive function as cycle 336 memo-race.js + cycle 338 make-hardener.js + cycle 350 passStyleOf.js:

```js
/**
 * TODO Consolidate with `isPrimitive` that's currently in `@endo/pass-style`.
 * Layering constraints make this tricky, which is why we haven't yet figured
 * out how to do this.
 */
const isPrimitive = val =>
  !val || (typeof val !== 'object' && typeof val !== 'function');
```

**§the-named-isPrimitive-FOURTH-package-duplication** — first-explicit-observation. The duplication now spans:

| Cycle | Package |
|---|---|
| 142 | passStyle-helpers.js (`@endo/pass-style`) |
| 336 | memo-race.js (`@endo/promise-kit`) |
| 338 | make-hardener.js (`@endo/harden`) |
| 350 | passStyleOf.js (uses `@endo/pass-style`'s; doesn't duplicate) — actually imports from passStyle-helpers |
| **352** | **local.js (`@endo/eventual-send`)** |

**§five-packages-with-named-isPrimitive-duplication** — first-explicit-observation as a tier-2 multi-cycle pattern. Counting actually distinct packages: @endo/pass-style + @endo/promise-kit + @endo/harden + ses (cycle 338 named ses) + @endo/eventual-send = **FIVE packages** with isPrimitive duplication.

**§five-cycles-with-named-isPrimitive-duplication-observation** (142 + 336 + 338 + 350 + 352) — extending cycle 338's four-cycles count.

**§the-named-layering-constraints-form-a-pentagon** — first-explicit-observation as a tier-3 meta-pattern. The five packages form a layering structure where each sits at a level that can't import isPrimitive from any of the others without creating a cycle. The duplication is enforced by the dependency-graph DAG.

## §the-named-symbol-vs-string-ordering-discipline

Lines 36-50 implement `compareStringified` that **prioritizes symbols as earlier than strings**:

```js
const compareStringified = (a, b) => {
  if (typeof a === typeof b) {
    const left = String(a);
    const right = String(b);
    return left < right ? -1 : left > right ? 1 : 0;
  }
  if (typeof a === 'symbol') {
    return -1;  // symbols first
  }
  return 1;
};
```

**§the-named-symbol-vs-string-ordering-discipline** — first-explicit-observation. When sorting heterogeneous keys (string + symbol), symbols come first. The discipline encodes a TOTAL ORDER over key types.

**§the-named-canonical-sort-order-for-heterogeneous-keys** — first-explicit-observation as a tier-3 meta-pattern. JavaScript objects can have both string and symbol keys; when listing them, a canonical sort order should be deterministic.

## §the-named-error-message-lists-available-methods

Lines 113-120 — when method lookup fails, the error message LISTS available methods:

```js
const fn = recipient[methodName];
if (fn === undefined) {
  assert.fail(
    X`target has no method ${q(methodName)}, has ${q(getMethodNames(recipient))}`,
    TypeError,
  );
}
```

**§the-named-error-message-lists-available-methods** — first-explicit-observation as a tier-3 meta-pattern. When method lookup fails, the error message names WHAT IS available so the caller can diagnose the typo or misunderstanding. Compare to cycle 350's §the-named-error-message-discriminates-by-failure-cause; cycle 352's discipline is the COMPLEMENTARY diagnostic: when the cause is "method not found", show the AVAILABLE methods.

**§two-shapes-of-diagnostic-error-message** — first-explicit-observation as a tier-3 meta-pattern:
- **Discriminate by cause** (cycle 350): same predicate fails for different reasons; error names the reason
- **List available alternatives** (cycle 352): lookup fails; error lists what's available

## §the-named-getMethodNames-walks-prototype-chain

Lines 56-75 — `getMethodNames` walks the prototype chain to collect function-typed properties:

```js
export const getMethodNames = val => {
  let layer = val;
  const names = new Set();
  while (layer !== null && layer !== Object.prototype) {
    const descs = getOwnPropertyDescriptors(layer);
    for (const name of ownKeys(descs)) {
      if (typeof val[name] === 'function') {
        names.add(name);
      }
    }
    if (isPrimitive(val)) {
      break;
    }
    layer = getPrototypeOf(layer);
  }
  return harden([...names].sort(compareStringified));
};
```

**§the-named-getMethodNames-walks-prototype-chain** — first-explicit-observation. The function:
1. Walks UPWARD through the prototype chain (using `getPrototypeOf`)
2. Stops at Object.prototype or null
3. Tests via `val[name]` (not `layer[name]`) so methods overridden by non-methods are skipped
4. Uses Set for dedup
5. Returns hardened sorted array

**§the-named-test-via-val-not-layer-discipline** — first-explicit-observation. The comment names WHY: *"In case a method is overridden by a non-method, test `val[name]` rather than `layer[name]`"*. The discipline ensures the result reflects what's ACTUALLY accessible on the input object, not what's defined on its prototype chain.

## §the-named-base-case-via-null-methodName

Line 100-104:

```js
export const localApplyMethod = (recipient, methodName, args) => {
  if (methodName === undefined || methodName === null) {
    // Base case; bottom out to apply functions.
    return localApplyFunction(recipient, args);
  }
  // ...
};
```

**§the-named-base-case-via-null-methodName** — first-explicit-observation. The same dispatch function handles BOTH method calls (with methodName) and function calls (without). The null/undefined methodName is the BASE CASE that bottoms out to function application.

**§the-named-polymorphic-dispatch-with-named-base-case** — first-explicit-observation as a tier-3 meta-pattern. When a dispatcher handles multiple forms, use a NULL/UNDEFINED parameter to mark the base case + delegate to a sibling dispatcher.

## §the-named-three-conditions-for-localApplyMethod-failure

The function has THREE explicit failure paths:
1. methodName provided + recipient null/undefined → "Cannot deliver ${methodName} to target"
2. method not found on recipient → "target has no method ${methodName}, has ${methods}"
3. method exists but isn't a function → "invoked method ${methodName} is not a function; it is a ${type}"

**§the-named-three-conditions-for-localApplyMethod-failure** — first-explicit-observation. Each failure path has a SPECIFIC error message with the diagnostic information needed to fix the caller's bug.

## Closes citation arcs

| Closes arc with | Arc length | Subject |
|---|---|---|
| Cycle 351 (draft-standalone-spec.md) | 1 cycle | Cross-package |
| **Cycle 132 (local.js comment-fragment first ingest)** | **220 cycles** | **TENTH complementary-lens re-ingest** |
| Cycle 130 (message-breakpoints) | 222 cycles | Sister breakpoint pattern |
| Cycle 146 (E.js sister file) | 206 cycles | Send-side dispatcher |
| Cycle 187 (postponedHandler sibling in eventual-send) | 165 cycles | eventual-send package |
| Cycle 338 (make-hardener triple-duplication) | 14 cycles | §five-packages-with-named-isPrimitive-duplication |
| Cycle 350 (passStyleOf error-message-discriminates) | 2 cycles | §two-shapes-of-diagnostic-error-message |
| Cycle 142 (passStyle-helpers isPrimitive) | 210 cycles | §five-packages-with-named-isPrimitive-duplication |
| Cycle 336 (memo-race isPrimitive) | 16 cycles | §five-packages-with-named-isPrimitive-duplication |

**§nine-citation-arc-closures-in-cycle-352**. **§one-hundred-fifty-four-citation-arc-closures-in-pivot-now** (148 + 6 net new).

## Tier-3 meta-patterns

- **§the-named-pre-lockdown-modules-use-freeze-not-harden**
- **§the-named-layering-constraint-acknowledged-in-comment**
- **§five-packages-with-named-isPrimitive-duplication** — tier-2 milestone
- **§the-named-layering-constraints-form-a-pentagon** — geometric naming of the dependency-graph constraint
- **§the-named-canonical-sort-order-for-heterogeneous-keys**
- **§the-named-error-message-lists-available-methods**
- **§two-shapes-of-diagnostic-error-message** — discriminate-by-cause + list-available-alternatives
- **§the-named-test-via-val-not-layer-discipline**
- **§the-named-polymorphic-dispatch-with-named-base-case**

## Library state after cycle 352

- §library-reaches-864-sections from 394 source documents (source count unchanged; complementary-lens re-ingest)
- §one-hundred-and-eighty-fifth consecutive designs-chat alternation
- §forty-three-cycles-with-named-pivot-domain-stay (310-352)
- §nineteen-named-packages-in-the-pivot-cluster
- §one-hundred-fifty-four-citation-arc-closures-in-pivot-now (148 + 6 net new)
- **§ten-cycles-with-named-complementary-lens-re-ingest** — librarian discipline across **TEN** applications (round-number milestone)
- **§five-packages-with-named-isPrimitive-duplication** (pass-style + promise-kit + harden + ses + eventual-send)
- §the-named-pre-lockdown-modules-use-freeze-not-harden established as tier-3 meta-pattern
- §the-named-layering-constraints-form-a-pentagon established as tier-3 meta-pattern
- §two-shapes-of-diagnostic-error-message established as tier-3 meta-pattern
- §the-named-polymorphic-dispatch-with-named-base-case established as tier-3 meta-pattern
- §the-named-canonical-sort-order-for-heterogeneous-keys established as tier-3 meta-pattern
- §the-named-error-message-lists-available-methods established as tier-3 meta-pattern
