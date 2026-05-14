---
title: First Steps: Introducing HardenedJS
source: docs/get-started.md
source_repo: endojs/endo
source_commit: 5fefef59b558ba6fb07aad42e3d089e49f81341a
source_date: 2025-12-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [getting-started, hardened-javascript, compartments]
status: current
---

> Abstract: Hands-on introduction to Hardened JavaScript: calling lockdown(), demonstrating frozen intrinsics, the harden() pattern, and using a Compartment to isolate guest code with explicit endowments. The most substantial section of the tutorial; intended as the first concrete encounter with SES for a new user.

## First Steps: Introducing HardenedJS

Endo includes a [shim][] implementation of HardenedJS called [SES][].
By importing `ses` and calling `lockdown()`, we can transform ordinary
JavaScript to HardenedJS.

To begin, create a Node.js project where modules are ESM format by default.

```shell
mkdir my-first-endo
cd my-first-endo
echo '{"type": "module"}' > package.json
npm init --yes
npm install ses
```

Then add a program, `index.js`.

```js
import 'ses';

lockdown();
const compartment = new Compartment();
const four = compartment.evaluate('2 + 2');
console.log(four);
```

In this program, we have frozen the _shared intrinsics_, created a
_compartment_, and evaluated a trivial program.
Compartments also support modules and hide the real global object,
so we can do a great deal more.
But, we do not ordinarilly use compartment directly.
Endo includes utilities that can load and evaluate whole Node.js-style
applications off a filesystem or out of a zip file, which in principle
be adapted to any storage medium or used to improvize different bundle formats.

To better understand what this application achieves, add some instrumentation
and experiment with what kinds of operations are possible inside
and outside a compartment.

For example, compartments are not whole realms.
The intrinsics inside and outside a compartment are the same,
but have been adjusted so that they cannot be used to escape a compartment.

```js
import 'ses';

lockdown();

console.log('intrinsics are frozen',
    Object.isFrozen(Object.prototype));
const compartment = new Compartment();
console.log('intrinsics are the same inside compartments',
    compartment.evaluate('[]') instanceof Array);
console.log('the Function constructor is different, though',
    compartment.evaluate('Function') !== Function);
console.log('the Function.prototype is the same',
    compartment.evaluate('Function') instanceof Function);
console.log('new functions are stuck in the compartment',
    compartment.evaluate(`new Function("return globalThis")()`)
    === compartment.globalThis);
console.log('the constructor on Function.prototype is not Function',
    compartment.evaluate('Function.prototype.constructor !== Function'));
console.log('the constructor on Function.prototype is not the real Function',
    compartment.evaluate('Function.prototype.constructor') !== Function);
console.log(`it throws an error so compartments can't be escaped`);
try {
  compartment.evaluate(`new Function.prototype.constructor()`);
} catch {
  console.log('true');
}
```

The global object in a compartment has only shared intrinsics and
per-compartment evaluators by default.
We can inject globals to give the compartment capabilities.
The `lockdown` function incidentally makes `console` safe to share
with compartments, but compartments do not get that capability by default.

```js
import 'ses';

lockdown();

const compartment = new Compartment({
  __options__: true,
  globals: { console },
});
compartment.evaluate('console.log("Hello")');
```

Compartments can also load modules and you can read more about
the full Compartment API in the documentation for [SES][].


Source: [docs/get-started.md](https://github.com/endojs/endo/blob/5fefef59b558ba6fb07aad42e3d089e49f81341a/docs/get-started.md) at commit `5fefef59`.
