---
title: Pass-style's defense across host configurations (Start Compartment, guest compartment with frozen globalThis, multi-guest unsafe shared compartment); the makeTypeError belt-and-suspenders idiom for a guaranteed-realm-intrinsic TypeError instance
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
---

## Abstract

The opening JSDoc comment on `makeTypeError` (lines 23-65 of `packages/pass-style/src/error.js`) is the package's explicit statement of *what pass-style must defend against, across which host configurations, and with what assumptions about SES*. The block enumerates three configurations: (1) **Start Compartment** — the primary realm into which host module systems load pass-style; here SES provides *no assurances* about guest programs co-executing safely with the host, so the security obligation is *do not run guest code here*; (2) **Guest compartment with frozen globalThis** — the typical `importBundle` configuration where every Node.js package runs in a dedicated compartment with a *gratuitiously frozen* globalThis, so `globalThis.Error` and `globalThis.TypeError` correspond to the realm's intrinsics (either because the Compartment arranged the freeze, or because the pass-style package provides no code that mutates the compartment's globalThis); (3) **Multi-guest shared compartment with unfrozen globalThis** — *incoherent and provides no assurance of mutual safety between those guests*; *no code, much less Pass-style, should be run in such a compartment*. Even in the two safe configurations, the block notes that pass-style relies on `globalThis.Error` and `globalThis.TypeError` bindings — but then constructs `makeTypeError` to return a TypeError instance *guaranteed* to be an instance of the realm intrinsic *by dint of construction from language syntax* (via the `null.null` trick). The rationale closes with the *belt-and-suspenders* idiom — *gratuitous or redundant safety measures; in this case, we wear both belt and suspenders on our overalls*. The pre-SES boot-order disclaimer is the other load-bearing piece: *we have similar code in SES that stands on the irreducible risk that an attacker may run before SES, so the application must either ensure that SES initializes first or that all prior code is benign*.

## Body

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

## Connection to the wider library

This section is the **canonical worked example of *capability-security reasoning across multiple host configurations*** at the source-code-comment level. Three threads to highlight:

1. **The three-configuration enumeration is reusable.** Any pass-style-adjacent module (marshal, captp, harden) faces the same Start-Compartment / guest-with-frozen-globalThis / multi-guest-unsafe trichotomy. The block's *explicit negative spec for Configuration 3* is the canonical pattern for ruling out unsafe configurations.

2. **The belt-and-suspenders idiom is the literal name of a defensive-consistency discipline.** The Hardened JavaScript stack uses redundant safety mechanisms throughout — frozen intrinsics + `harden` + Compartment isolation; `passStyleOf` + `assertPassable` + `confirmRecursivelyPassable`; `harden` + `hideAndHardenFunction`. The error.js block names the discipline explicitly.

3. **The `null.null` syntax-based-construction trick generalizes.** Any time a defensively-consistent module needs an instance of a built-in type *guaranteed* to be the realm intrinsic, the pattern is *trigger the language to construct it via syntax*. This avoids any globalThis lookup. The marshal package uses similar language-level construction for built-in passable shapes.

## Translation block (comment idiom → contemporary practice)

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| Start Compartment vs guest compartment vs unsafe-shared compartment | The three regimes of SES adoption. *Run guest code only in dedicated compartments*. |
| Belt-and-suspenders idiom | Redundant defensive checks (e.g. `passStyleOf` + `assertPassable`) — neither alone is wrong, but both together close composition gaps. |
| `null.null` for syntax-constructed TypeError | The general pattern: get a realm intrinsic by triggering the language to construct it. Used elsewhere to get realm-intrinsic `%FunctionPrototype%`, `%Promise%`, etc. via syntax. |
| "we have similar code in SES" | The SES + pass-style boot-order contract: SES initializes first; thereafter pass-style and marshal rely on SES's frozen intrinsics. |
| "on our overalls" | Self-aware naming of *gratuitous* safety measures. The package author signals this is *more* than belt-and-suspenders. |

## See also

- [[hardened-javascript]] (topic) — the SES substrate this block defends across; *frozen intrinsics + lockdown* is what Configuration 2 relies on.
- [[pass-style]] (topic) — the package that owns this file; the error.js module is the error-validation surface.
- [[capability-security]] (topic) — three host-configurations is a capability-security catalog; the multi-guest-unsafe configuration is explicitly out of scope.
- [[errors]] (topic) — the broader Endo error-handling surface; this section is the *passable-error-defense* corner.
- `endo--packages-pass-style-src-error-js--v8-stack-accessor-undeniable-channel-and-repair` — the next section: the V8-specific stack accessor + capability-leakage channel + repair.
- `endo--packages-pass-style-src-error-js--error-validation-security-vs-diagnostic-tension` — the third section: isErrorLike vs assertError + the four-property allowlist.
- [[principle-of-least-authority]] — the *do not run guest code in the Start Compartment* claim is a POLA enforcement at the application architecture layer.

## Common confusions

- **"Why not just use `globalThis.TypeError` directly?"** Configuration 2 says we *can* — but the `makeTypeError` belt-and-suspenders construction is one extra layer of defense. If a future pass-style refactor accidentally introduces code that mutates globalThis (or runs in a Compartment whose creator did not freeze it), `makeTypeError` continues to return a realm-intrinsic TypeError. The redundancy has explicit value.
- **"The `null.null` line is unreachable."** From a runtime perspective, the second `throw TypeError('obligatory')` is unreachable — the `null.null` line throws first. But the static type-flow analyzer needs the second `throw` to prove the function does not return `undefined`. The comment `// To convince the type flow inferrence.` makes the apparent dead-code intentional.
- **"Configuration 1 is unsafe — pass-style is broken there."** Not quite. The block says pass-style does not *promise* safety in Configuration 1 — but pass-style's *internal* code can still be loaded and run in the Start Compartment; what is unsafe is *running guest code* in the Start Compartment. The Start Compartment is for the *host*, which has all the ambient authority anyway; pass-style is content to load there for the host's use.
- **"What about `Realm`-API-style alternatives?"** Out of scope for this block. SES + Compartment + `harden` is the contemporary realization; the block does not engage with the older Realm API proposal.
- **"`gratuitiously` is a typo for `gratuitously`."** Yes, present in the source. The library preserves it verbatim from the source.
