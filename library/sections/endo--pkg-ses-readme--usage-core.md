---
title: Usage: Core (Lockdown, Harden, Compartment)
source: packages/ses/README.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, compartments, capability-security]
status: current
---

> Abstract: The core Usage section: lockdown() one-time setup; harden() per-value transitive freezing; Compartment for isolating guest code in its own global scope; Compartment + Lockdown showing how the two compose for typical applications. Consolidates four H3 sub-sections (Lockdown, Harden, Compartment, Compartment+Lockdown) at the H2 Usage boundary.

## Usage

The SES shim runs in most engines, either as an ESM module `ses` or as a
`<script>` tag.
For a script tag, the content encoding charset must be UTF-8, either by virtue
of `<head><meta charset="utf-8"></head>` (a general best practice for all HTML
files) or specifically `<script src="node_modules/ses/dist/ses.umd.min.js"
charset="utf-8">`.

SES can be bundled by Webpack, Browseriy, Rollup, and Parcel, but any of these
tools could be coopted with a supply-chain attack to invalidate the security
properties of SES.  We generally recommend installing SES as a separate script
tag.

### Lockdown

SES introduces the `lockdown()` function.
Calling `lockdown()` alters the surrounding execution environment, or
**realm**, such that no two programs running in the same realm can observe or
affect each other until they have been introduced, and even then can only
interact through their own exposed interfaces.

To do this, `lockdown()` tamper-proofs all of the JavaScript intrinsics, to
prevent **prototype pollution**.
After that, no program can subvert the methods of these objects (preventing
some **man in the middle attacks**).
Also, no program can use these mutable objects to pass notes to parties that
haven't been expressly introduced (preventing some **covert communication
channels**).

Lockdown freezes all objects that are effectively undeniable to programs in the
realm. The set of such objects includes but is not limited to: `globalThis`,
prototype objects of Array, Function, GeneratorFunction, and Object, and objects
accessible from those objects (such as `Object.prototype.toString`).

The `lockdown()` function also **tames** some objects including regular
expressions, locale methods, and errors.
A tamed `RegExp` does not have the deprecated `compile` method.
A tamed error does not have a V8 `stack`, but the `console` can still see the
stack.
Lockdown replaces locale methods like `String.prototype.localeCompare` with
generic versions that do not reveal the host locale.

```js
import 'ses';

lockdown();

console.log(Object.isFrozen([].__proto__));
// true
```

Lockdown does not erase any powerful objects from the initial global scope.
Instead, **Compartments** give complete control over what powerful objects
exist for client code.

See [`lockdown` options](../../docs/lockdown.md) for configuration options to
`lockdown`. However, all of these have sensible defaults that should
work for most projects out of the box.

### Harden

SES introduces the `harden` function.
*After* calling `lockdown`, the `harden` function ensures that every object in
the transitive closure over property and prototype access starting with that
object has been **frozen** by `Object.freeze`.
This means that the object can be passed among programs and none of those
programs will be able to tamper with the **surface** of that object graph.
They can only read the surface data and call the surface functions.

```js
import 'ses';

lockdown();

let counter = 0;
const capability = harden({
  inc() {
    counter++;
  },
});

console.log(Object.isFrozen(capability));
// true
console.log(Object.isFrozen(capability.inc));
// true
```

Note that although the **surface** of the capability is frozen, the capability
still closes over the mutable counter.
Hardening an object graph makes the surface immutable, but does not guarantee
that methods are free of side effects.

### Compartment

SES introduces the `Compartment` constructor.
A compartment is an evaluation and execution environment with its own
`globalThis` and wholly independent system of modules, but otherwise shares
the same batch of intrinsics like `Array` with the surrounding compartment.
The concept of a compartment implies an **initial compartment**, the initial
execution environment of a **realm**.

In the following example, we create a compartment endowed with a `print()`
function on `globalThis`.

```js
import 'ses';

lockdown();

const c = new Compartment({
  globals: {
    print: harden(console.log),
  },
  __options__: true, // temporary migration affordance
});

c.evaluate(`
  print('Hello! Hello?');
`);
```

The new compartment has a different global object than the start compartment.
The global object is initially mutable.
Locking down the realm hardened the objects in global scope.
After `lockdown`, no compartment can tamper with these **intrinsics** and
**undeniable** objects.
Many of these are identical in the new compartment.

```js
const c = new Compartment();
c.globalThis === globalThis; // false
c.globalThis.JSON === JSON; // true
```

Other pairs of compartments also share many identical intrinsics and undeniable
objects of the realm.
Each has a unique, initially mutable, global object.

```js
const c1 = new Compartment();
const c2 = new Compartment();
c1.globalThis === c2.globalThis; // false
c1.globalThis.JSON === c2.globalThis.JSON; // true
```

The global scope of every compartment includes a shallow, specialized copy of
the JavaScript intrinsics, disabling `Math.random`, `Date.now` and the
behaviors of the `Date` constructor which would reveal the current time.
Compartments leave these out since they can be used as covert communication
channels between programs.
However, a compartment may be expressly given access to these objects
through:

* the first argument to the compartment constructor or
* by assigning them to the compartment's `globalThis` after construction.

```js
const powerfulCompartment = new Compartment({
  globals: { Math },
  __options__: true, // temporary migration affordance
});
powerfulCompartment.globalThis.Date = Date;
```

### Compartment + Lockdown

Together, Compartment and lockdown isolate client code in an environment with
limited powers and communication channels.
A compartment has only the capabilities it is expressly given and cannot modify
any of the shared intrinsics.
Every compartment gets its own globals, including such objects as the
`Function` constructor.
Yet, compartment and lockdown do not break `instanceof` for any of these
intrinsics types!

All of the evaluators in one compartment are captured by that compartment's
global scope, including `Function`, indirect `eval`, dynamic `import`, and its
own `Compartment` constructor for child compartments.
For example, the `Function` constructor in one compartment creates functions
that evaluate in the global scope of that compartment.

```js
const c1 = new Compartment();
const f1 = new c.globalThis.Function('return globalThis');
f1() === c1.globalThis; // true

const c2 = new Compartment();
const f2 = new c.globalThis.Function('return globalThis');
f2() === c2.globalThis; // true

f1() === f2(); // false
```

Lockdown prepares for compartments with separate globals by freezing
their shared prototypes and replacing their prototype constructors
with powerless dummies.
So, `Function` is different in two compartments, `Function.prototype` is the
same, and `Function` is not the same as `Function.prototype.constructor`.
The `Function.prototype.constructor` can only throw exceptions.
So, a function passed between compartments does not carry access to
its compartment's globals along with it.
Yet, `f instanceof Function` works, even when `f` and `Function` are
from different compartments.

The `globalThis` in each compartment is mutable.
This can and should be frozen before running any dynamic code in that
compartment, yet is not strictly necessary if the compartment only
runs code from a single party.


Source: [packages/ses/README.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/packages/ses/README.md) at commit `fe81477b`.
