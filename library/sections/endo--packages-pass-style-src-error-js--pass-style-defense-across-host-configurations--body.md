---
title: Body
source: packages/pass-style/src/error.js
source_repo: endojs/endo
source_branch: master
source_commit: ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2
source_date: 2026-04-08
source_authors: [Turadg Aleahmad and prior contributors]
source_lines: "23-77 (makeTypeError header JSDoc + makeTypeError implementation)"
topics: [hardened-javascript, pass-style, errors, capability-security]
status: current
notes: |
  The opening rationale block of `packages/pass-style/src/error.js` is a
  capability-security worked example: a single function (`makeTypeError`)
  whose existence is justified by an explicit enumeration of three
  host-configuration regimes (Start Compartment / guest compartment with
  frozen globalThis / multi-guest unsafe shared compartment) and a
  *belt-and-suspenders* construction (the `null.null` trick) that
  guarantees the returned TypeError is the realm intrinsic by dint of
  construction from language syntax rather than by reading
  `globalThis.TypeError`. Three sub-claims worth quoting verbatim
  ("we wear both belt and suspenders *on our overalls*"; "running
  multiple guests in a single compartment with an unfrozen globalThis is
  incoherent and provides no assurance of mutual safety"; "the host
  must either ensure that SES initializes first or that all prior code
  is benign") sit in this block.
parent: endo--packages-pass-style-src-error-js--pass-style-defense-across-host-configurations
---

### Three host configurations, three security claims

The `makeTypeError` JSDoc block walks the three configurations under which pass-style is loaded and explicitly states the security claim for each:

**Configuration 1: Start Compartment (the primary realm)**

> Pass-style may be loaded by the host module system into the primary realm, which the authors call the Start Compartment. SES provides no assurances that any number of guest programs can be safely executed by the host in the start compartment. Such code must be executed in a guest compartment. As such, it is irrelevant that the globalThis is mutable and also holds all of the host's authority.

The Start Compartment claim is *negative*: pass-style does not promise mutual safety between guest programs running in the Start Compartment. The *responsibility* lies with the application: do not run guest code in the Start Compartment. The mutable globalThis + ambient host authority is *irrelevant* to pass-style's correctness, because it is the host's responsibility.

**Configuration 2: Guest compartment with frozen globalThis**

> Pass-style may be loaded into a guest compartment, and the globalThis of the compartment may or may not be frozen. We typically, as with importBundle, run every Node.js package in a dedicated compartment with a gratuitiously frozen globalThis. In this configuration, we can rely on globalThis.Error and globalThis.TypeError to correspond to the realm's intrinsics, either because the Compartment arranged for a frozen globalThis or because the pass-style package provides no code that can arrange for a change to the compartment's globalThis.

The Guest Compartment claim is *positive*: pass-style can rely on `globalThis.Error` and `globalThis.TypeError` to be the realm's intrinsics. Two reasons justify the reliance: (a) the Compartment infrastructure may have already frozen globalThis at construction time; (b) pass-style itself does not contain code that mutates globalThis, so even if it is not frozen, no pass-style code can change those bindings. The two reasons together mean *either of two independent conditions* discharges the trust assumption.

The "gratuitously frozen" adjective is load-bearing: `importBundle`'s frozen-globalThis is *gratuitous* in the sense that pass-style would still be safe even if globalThis weren't frozen (because pass-style doesn't mutate it), but the freeze is one extra layer of defense.

**Configuration 3: Multi-guest shared compartment with unfrozen globalThis — explicitly out of scope**

> Running multiple guests in a single compartment with an unfrozen globalThis is incoherent and provides no assurance of mutual safety between those guests. No code, much less Pass-style, should be run in such a compartment.

This is the *negative* spec: pass-style explicitly does not promise mutual safety in this configuration; the comment names the configuration as *incoherent* and instructs applications never to run any code in it. *No code, much less Pass-style* — even minimum-trust code can't be safe here.

### The `makeTypeError` belt-and-suspenders construction

Even granting Configuration 2's positive claim, the block builds a second layer of defense: `makeTypeError` returns a TypeError instance *guaranteed to be a realm intrinsic by construction from language syntax*. The implementation:

```js
const makeTypeError = () => {
  try {
    // @ts-expect-error deliberate TypeError
    null.null;
    throw TypeError('obligatory'); // To convince the type flow inferrence.
  } catch (error) {
    return /** @type {TypeError} */ (error);
  }
};
```

The structural read:

- `null.null` is *guaranteed* by language semantics to throw a TypeError instance constructed by the runtime. The thrown TypeError's `[[Prototype]]` is *guaranteed* to be the realm's `%TypeError.prototype%` — no globalThis lookup involved.
- The `throw TypeError('obligatory')` line is dead code from a runtime perspective (the `null.null` line throws first), but TypeScript flow analysis needs it: without that throw, TypeScript would infer the function might return `undefined`. The comment `// To convince the type flow inferrence.` is the rationale.
- The `catch` returns the TypeError-from-language-syntax. The function's return type is the realm-intrinsic TypeError.

The *belt-and-suspenders* idiom is stated explicitly:

> Although we can rely on the globalThis.Error and globalThis.TypeError bindings, we can and do use `makeTypeError` to produce a TypeError instance that is guaranteed to be an instance of the realm intrinsic by dint of construction from language syntax. The idiom "belt and suspenders" is well-known among the authors and means gratuitous or redundant safety measures. In this case, we wear both belt and suspenders *on our overalls*.

The "on our overalls" extends the metaphor: not just belt-and-suspenders together, but belt + suspenders + overalls — three independent layers, any of which suffices.

### The pre-SES boot-order disclaimer

The block also names the irreducible risk that no construction can eliminate:

> We have similar code in SES that stands on the irreducible risk that an attacker may run before SES, so the application must either ensure that SES initializes first or that all prior code is benign.

The disclaimer is *not* that pass-style is unsafe pre-SES — it is that an attacker running before SES initializes could compromise the realm in ways that pass-style cannot detect. The application's responsibility is to ensure SES (and any code pass-style depends on) initializes before any untrusted code runs. This is the standard SES boot-order assumption; the pass-style block makes it explicit at the use-site.
