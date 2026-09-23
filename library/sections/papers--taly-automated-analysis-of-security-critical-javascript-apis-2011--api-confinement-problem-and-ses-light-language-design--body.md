---
title: Body
source: "Automated Analysis of Security-Critical JavaScript APIs (Taly, Erlingsson, Mitchell, Miller, Nagra, IEEE S&P 2011)"
source_kind: paper
source_authors: [Ankur Taly, Úlfar Erlingsson, John C. Mitchell, Mark S. Miller, Jasvir Nagra]
source_year: 2011
source_venue: "IEEE Symposium on Security and Privacy 2011"
source_url: https://papers.agoric.com/papers/automated-analysis-of-security-critical-javascript-apis/
source_pdf_sha256: 4457eafac35c129dac26fdf163710a1f89b63b0d9a4ba1bc6378fa318c4bec95
source_paper_pages: "1-3 (§1 Introduction + §2 From JavaScript to ES5-strict to SES_light)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory, hardened-javascript]
status: current
parent: papers--taly-automated-analysis-of-security-critical-javascript-apis-2011--api-confinement-problem-and-ses-light-language-design
---

### §1 The API+Sandbox approach and the reference-monitor-as-API thesis

The §1 paper's structural picture:

> Many contemporary websites incorporate untrusted third-party JavaScript code into their pages in order to provide advertisements, Google Maps, so-called gadgets, and applications on social networking websites. Since JavaScript code has the ability to manipulate the page Document Object Model (DOM), steal cookies, and navigate the page, untrusted third-party JavaScript code may pose a significant security threat to the hosting page.

The naïve isolation answer (`<iframe>`) has two costs: (a) *performance* — iframes are heavyweight; (b) *interaction* — code in an iframe cannot directly call functions in the hosting page. The contemporary alternative:

> Instead, Facebook and other sites rely on language-based techniques to embed untrusted applications directly into the hosting page.

The structural pattern is the **API+Sandbox approach**:

> A widely used approach combines a language-based sandbox to restrict the power of untrusted JavaScript with trusted code that exports an API to untrusted code. In the *API+Sandbox* approach, used in Facebook FBJS, Yahoo! ADSafe, and Google Caja, the trusted code must encapsulate all security-critical resources behind an API that provides JavaScript methods to safely access those resources.

The trusted code is the *reference monitor*; the API is the *interface to the reference monitor*; the sandbox ensures untrusted code can reach the reference monitor *only* through the API.

The §1 motivating example — write-only logging:

```js
var priv = criticalLogArray;
var api = {push: function(x){priv.push(x)}}
```

The intent: *untrusted code can `api.push(value)` but cannot read the array or any of its elements*. The implementation looks correct: neither `priv` nor `criticalLogArray` is exposed to untrusted code; only `api` is.

The §1 *trick* shows the trap:

> The addition of the following store method to the API may suggest otherwise:
> ```js
> api.store = function(i, x){priv[i] = x}
> ```
> While a cursory reading shows that neither API method returns a reference to the array, the API fails to confine the array. A client may gain direct access to the criticalLogArray by calling methods of the API and mutating external state, as in the following code:
> ```js
> var result;
> api.store('push', function(){result = this[0]});
> api.push();
> ```

The §1 attack mechanism walk:

1. **`api.store('push', function(){result = this[0]})`** — the attacker stores a *function* at key `'push'` of `priv`. The function's body reads `this[0]`. The store call uses `priv[i] = x` so `priv['push'] = function(){...}`.
2. **`api.push()`** — the API's `push` method calls `priv.push(...)`. But `priv['push']` is now the attacker's function (the original `Array.prototype.push` was overridden). So calling `priv.push()` invokes the attacker's function with `this = priv = criticalLogArray`.
3. **`result = this[0]`** — the attacker's function, now running with `this` as the criticalLogArray, reads element 0. `result` is now the array's first element.

The attack is *not* through API misuse; it is through *exploiting that one API method can write to property names the other API method reads*. The API's confinement guarantee is undone by *aliasing between method call paths*.

The §1 paper's framing claim:

> The foundations of the API+Sandbox approach lie in the *object-capability* theory of securing systems. In the context of capabilities, the methods of the API are *capabilities* supplied to untrusted code and the sandbox is the *loader* that loads untrusted code only with a given set of capabilities. If API methods are viewed as capabilities, then the *API Confinement Problem* is also known as the *Overt Confinement Problem for Capabilities*.

This is the §1 connection to the broader capability-theory literature — the Confinement-Problem framing from Lampson 1973 (cited as [19] in this paper, the same paper Tyler Close cited in cycle 88's *ACLs Don't*).

### §2 From full JavaScript to ES5S — the three properties that fail

The §2 paper identifies *three properties that hold for ES5-strict but fail for full JavaScript*:

#### Lexical Scoping

> Even though variable bindings in ES3 are almost lexically scoped, the presence of prototype chains on scope objects (or activation records) and the ability to delete variable names makes a static scope analysis of variable names impossible.

Worked example:

```js
Object.prototype[<e>] = 24;
var x = 42;
var f = function foo(){return x;}; f();
```

If `<e>` (some expression) evaluates to the string `"x"`, then `f()` returns *24* (because the scope-chain's prototype lookup finds it via Object.prototype). If `<e>` returns something else, `f()` returns *42* (the lexically-scoped binding).

The §2 paper's structural conclusion:

> This makes ordinary renaming of bound variables (α-renaming) unsound and significantly reduces the feasibility of static analysis.

ES5S forbids `delete` on variable names and the `with` construct. The semantics of ES5S model activation records using the standard store data structure and therefore *without* prototype inheritance. Bound-variable renaming is now sound.

#### Safe Closure-Based Encapsulation

> JavaScript implementations in most browsers support the `arguments.caller` construct that provides callee code with a mechanism to access properties of the activation object of its caller function. This breaks closure-based encapsulation, as illustrated by the following example: a trusted function takes an untrusted function as argument and checks possession of a secret before performing certain operations.

```js
function trusted(untrusted, secret) {
  if (untrusted() === secret) {
    // process secretObj
  }
}
```

The attack:

```js
function untrusted() { return arguments.caller.arguments[1]; }
```

The untrusted function reads the *caller's* `arguments[1]` — the `secret` argument — without ever being passed it. ES5S forbids `.callee`/`.caller` on arguments objects and `.caller`/`.arguments` on function objects, closing the channel.

#### No Ambient Access to Global Object

> JavaScript provides multiple (and surprising) ways for code to obtain a reference to the global or `window` object, which is the root of the entire DOM tree and hence security-critical in most setups.

Worked example:

```js
var o = {foo: function(){return this;}}
g = o.foo; g();
```

The function reference `g` is called *without a receiver*; the `this` value coerces to the global object (full-JavaScript sloppy-mode semantics). The attacker reads `g()` and obtains the global object.

ES5S prevents this: in strict mode, `this` of a function called *as a function* (not as a method) is `undefined`, not the global object. ES5S also forbids built-in methods like `sort`/`concat`/`reverse` of `Array.prototype` and `valueOf` of `Object.prototype` from returning a global-object reference when invoked with ill-formed arguments. ES5S only allows access to the global object by using the keyword `this` in global scope and any host-provided aliases (like the global variable `window`).

#### Figure 1's full restriction list

| Restriction | Rationale |
|---|---|
| No `delete` on variable names | Lexical Scoping |
| No prototypes for scope objects | Lexical Scoping |
| No `with` | Lexical Scoping |
| No `this` coercion | Isolating Global Object |
| Safe built-in functions | Isolating Global Object |
| No `.callee`, `.caller` on arguments objects | Safe Encapsulation |
| No `.caller`, `.arguments` on function objects | Safe Encapsulation |
| No arguments and formal parameters aliasing | Safe Encapsulation |

The three property categories correspond to the three sections of Figure 1. ES5S gives a programming language with these properties by static restriction (the parser rejects code that uses them).

### §2.B — ES5S to SES_light: closing the remaining two gaps

The §2.B paper names the *two* remaining limitations of ES5S:

> ES5S, however, has two remaining limitations for confinement and static analysis: (1) ambient access to built-in objects may be used to subvert some of the checks in API implementations, and (2) eval allows dynamic code execution.

**SES_light's first addition: transitively-immutable built-in objects.**

> The first problem is solved by making all built-in objects, except the global object, *transitively immutable*, which means that all their properties are immutable and the objects cannot be extended with additional properties. Further, all built-in properties of the global object are made immutable.

The *transitive-immutability* is the key property: not just the built-in objects themselves, but *all properties they contain, and the objects those properties point to, recursively*. After the SES_light initialization script runs, `Object.prototype`, `Array.prototype`, etc. are deeply frozen — no method override, no property addition, no property deletion.

This matches the *transitively-immutable built-in objects* claim in cycle 87's `pass-style/src/error.js` host-configuration-defense section: the contemporary Hardened JavaScript stack realizes this property via `lockdown()` from `@endo/lockdown`. The 2011 SES_light paper is the original specification of the transitively-immutable property.

**SES_light's second addition: variable-restricted eval.**

> The second problem is addressed by imposing the restriction that all calls to eval must specify an upper bound on the set of free variables of the code being eval-ed.

Worked syntax:

> For example: the call `eval('var x = y + z')` is written out as `eval('var x = y + z', 'y', 'z')` where `{"y", "z"}` is the set of free variables.

The runtime check:

> At run-time, the code is evaluated only if its free variables are within the set specified by the arguments.

The static-analysis benefit:

> This restriction makes it possible to conservatively analyze eval calls by assuming a worst-case behavior based on the free variables specified.

The §2.B paper compares SES_light to other JavaScript sandbox sublanguages (FBJS [36] and the languages devised in previous sandboxing studies [23, 24]):

> Like FBJS [36] and the JavaScript subsets devised in previous sandboxing studies, SES_light does not support setters/getters. However, SES_light is a more permissive language subset. For example, SES_light allows a form of eval, while the other languages do not.

The §2.B comparison's structural claim:

> While SES_light has a restricted semantics to support isolation, the corresponding restrictions in FBJS are enforced using a combination of filtering, rewriting and wrapping that is not clearly documented in a public standard. ... [SES_light is] essentially ES5S without setters/getters, with the variable-restriction on eval and transitively immutable built-in objects.

The §2.B paper's design preference: *a clean language design with standardized semantics is more attractive to programmers and developers than previous languages designed to support similar forms of sandoxing and confinement via code rewriting and wrapping*. This is the *standardize-the-restriction-rather-than-rewriting* discipline — SES_light is a *language subset*, not a *code transformation*.
