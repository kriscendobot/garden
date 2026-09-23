---
title: "@endo/trampoline (59 lines) — §classic-uncurry-this + §sync/async two-color sharing"
source: endo packages/{trampoline,memoize,nat}/{src/*.js,README.md,docs/memoize.md}
source-slug: endo--packages-trampoline-memoize-nat-trio
ingest-cycle: 199
ingest-date: 2026-06-06
lane: chat
authors: [Mark Miller, Kris Kowal, Endo contributors]
related:
  - endo--packages-base64 (cycle 181: §three-tier-dispatch + §Reflect.apply capture sibling)
  - endo--packages-cli-src-utility-cluster (cycle 195: §six-tight-utilities-with-no-internal-dependencies sibling)
  - endo--packages-panic (cycle 197: §Eval-Twin-Problem cross-reference; memoize.md cites endojs/endo#1583)
  - endo--packages-pass-style (cycle 71+: passStyleOf is the §canonical-memoize-user named in memoize.md)
keywords:
  - three-tight-utilities cluster
  - classic-uncurry-this via bind.bind(bind.call)
  - encapsulated-pumpkin sentinel for recursion-protection
  - contingent-safety framing
  - four-tier safety hierarchy (defensiveness / unobservable / preserves-isolation / not-communications-channel)
  - sync/async two-color sharing via generator trampoline
  - generator-throw send-error-into-generator
  - Apps-Script-bigint-literal-workaround
  - two-different-error-types (TypeError type / RangeError range)
  - safely-representable IEEE-754 integer discipline
  - freeze-as-harden-substitute pending PR #3008
parent: endo--packages-trampoline-memoize-nat-trio--three-tight-utilities-with-classic-uncurry-this-and-encapsulated-pumpkin-and-apps-script-bigint-literal-workaround
---

```js
const { getPrototypeOf } = Object;
const { bind } = Function.prototype;
const uncurryThis = bind.bind(bind.call);
export const { prototype: generatorPrototype } = getPrototypeOf(function* () {});
const generatorNext = uncurryThis(generatorPrototype.next);
const generatorThrow = uncurryThis(generatorPrototype.throw);
```

§The-classic-uncurry-this-idiom: `bind.bind(bind.call)` is the §Mark-Miller-canonical-form. Applied to a method, it produces a function that takes the receiver as the first argument: `generatorNext(iterator)` instead of `iterator.next()`. The §rationale is §protect-against-prototype-tampering — once the original `Function.prototype.bind` is captured pre-lockdown, the uncurried form survives even if the prototype is later replaced.

§Two-step capture:
1. `bind.bind(bind.call)` — produces a function `f` such that `f(method)(receiver, ...args) === method.call(receiver, ...args)`.
2. `uncurryThis(generatorPrototype.next)` returns `generatorNext` such that `generatorNext(iterator, value) === iterator.next(value)`.

§Why-via-the-generator-prototype-not-via-the-iterator-instance: §the-prototype-is-captured-once-at-module-load; §iterator-instances-may-have-been-tampered-with (their `.next` could be overridden per-instance). §The-prototype's-original-`.next`-is-what-the-uncurry-locks-in.

§The-sync/async pair:

```js
export function syncTrampoline(generatorFn, ...args) {
  const iterator = generatorFn(...args);
  let result = generatorNext(iterator);
  while (!result.done) {
    try {
      result = generatorNext(iterator, result.value);
    } catch (err) {
      result = generatorThrow(iterator, err);
    }
  }
  return result.value;
}

export async function asyncTrampoline(generatorFn, ...args) {
  const iterator = generatorFn(...args);
  let result = generatorNext(iterator);
  while (!result.done) {
    try {
      const val = await result.value;
      result = generatorNext(iterator, val);
    } catch (err) {
      result = generatorThrow(iterator, err);
    }
  }
  return result.value;
}
```

§Two-color-sharing: the same generator function body can be driven §synchronously (yielded values used directly) or §asynchronously (yielded values awaited). §The-author-writes-one-generator-function-and-picks-the-trampoline-at-the-call-site. Sibling pattern to Haskell's `IO` monad or Rust's async-trait — §abstract-the-effect-color.

§generator-throw-send-error-into-generator: when `generatorNext` (or the `await` in async case) throws, `generatorThrow(iterator, err)` resumes the generator §at-the-`yield`-with-`throw` rather than `next`. §The-generator-can-catch-the-error-in-a-try/catch-around-the-yield and continue. §Without-this the trampoline would have no way to send errors back into the generator's control flow.

§Two-eslint-discipline-exceptions named:
- `// eslint-disable @endo/no-polymorphic-call` on the `uncurryThis = bind.bind(bind.call)` line.
- `// eslint-disable @jessie.js/safe-await-separator` at file head (for the `const val = await result.value` line; Jessie's rule requires `await` to be a statement-level operation, not embedded in a const-init).

§Both-rules-are-discipline-aware-exceptions — the package's specific need overrides the general rule with the linter exception local to the file.

§JSDoc-generics-and-type-inference: `TrampolineResult<TFn>` extracts the `Generator<any, infer TResult>` return type; `SyncTrampolineResult<TFn>` further narrows by §rejecting if the result is a Promise (sync trampoline can't await). §Type-system-encodes-the-color-asymmetry.
