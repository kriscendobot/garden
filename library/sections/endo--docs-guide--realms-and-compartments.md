---
title: Realms and Compartments
source: docs/guide.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, compartments]
status: current
---

> Abstract: Conceptual material on JavaScript Realms (the underlying browser/runtime concept) and SES Compartments (the SES-specific isolation primitive built on top). Covers how Compartments share intrinsics with their host realm but have separate global scope and module map; the relationship between Compartment, Realm, and the start compartment. Foundational reading for understanding Endo's confinement model.

## Realms

Agoric deploy scripts and smart contract code run in an *immutable
realm* with *Compartments* providing just enough authority to create
useful and secure contracts. But not enough authority to do anything
unintended or harmful to the participants of the smart contract.

JavaScript code runs in the context of
a [*Realm*](https://www.ecma-international.org/ecma-262/10.0/index.html#sec-code-realms). A
realm is the set of *primordials* (objects and standard library functions
like `Array.prototype.push`) and a global object. In a web browser, an iframe is a realm.
In Node.js, a Node process is a realm.

For historical reasons, the ECMAScript specification requires primordials
be mutable (`Array.prototype.push = yourFunction` is valid ECMAScript but not
recommended). By using the Agoric SES shim and calling `lockdown()`, you can turn the
current realm into an *immutable realm*; a realm within which the primordials
are deeply frozen.

SES also lets programs create *Compartments*. These are "mini-realms".
A Compartment has its own dedicated global object and environment, but
it inherits the primordials from their parent realm. Components are described
in detail in the next section.

## Compartments

A *compartment* is an execution environment for evaluating a stranger’s code. It has
its own `globalThis` global object and wholly independent system of
modules. Otherwise it shares the same batch of intrinsics such as `Array` with its surrounding
compartment. The concept of a compartment implies an initial compartment,
the initial execution environment of a realm. After lockdown is called, all compartments share the same
frozen realm.

Here we create a compartment with a `print()` function on `globalThis`.
```js
import 'ses';

const c = new Compartment({
  print: harden(console.log),
});

c.evaluate(`
  print('Hello! Hello?');
`);
```
This new compartment has a different global object than the start compartment. We
posit that all JavaScript executes in a realm and compartment. Every realm has
distinct intrinsics, whereas every compartment shares intrinsics. The initial
realm and compartment are not constructed with `new Realm()` or `new Compartment()` but
that’s invisible to the code running; they could just as well be running within
a constructed realm or compartment.

We call the one compartment in a realm that was not expressly constructed the start
compartment. The start compartment receives some ambient authorities from the host,
often access to timers and IO that are denied to other compartments. Running lockdown
does not erase these powerful objects, but puts the program running in the start
compartment on a footing where it is possible to carefully delegate powers to child
compartments.

The global object is initially mutable. Locking down the realm hardened the objects in
global scope. After lockdown, no compartment can tamper with these intrinsics and
undeniable objects. Many of these are identical in the new compartment.

```js
const c = new Compartment();
c.globalThis === globalThis; // false
c.globalThis.JSON === JSON; // true
```

Other pairs of compartments also share many identical intrinsics and undeniable objects
of the realm. Each has a unique, initially mutable, global object.
```js
const c1 = new Compartment();
const c2 = new Compartment();
c1.globalThis === c2.globalThis; // false
c1.globalThis.JSON === c2.globalThis.JSON; // true
```
Every compartment's global scope includes a shallow, specialized copy of the JavaScript
intrinsics. These disable `Math.random()`, `Date.now()`, and the behaviors of
the `Date` constructor which would provide the current time,
since all these sources of non-determinism can enable covert inter-program
communication channels.

However, a compartment may be expressly given access to these objects through
the compartment constructor's first argument or by assigning them to the
compartment's `globalThis` after construction.
```js
const powerfulCompartment = new Compartment({ Math });
powerfulCompartment.globalThis.Date = Date;
```

When you create a new `Compartment` object, you must decide if it supports OCaps security.
If it does, run `harden(compartment.globalThis)` on it before loading any untrusted code into it.

A single compartment can run a JavaScript program in the locked-down environment.
However, most interesting programs have multiple modules. So, each compartment also has
its own module system. SES version 0.8.0 adds support for ECMAScript modules,
a relatively new system supported by many browsers, and officially released in Node.js 14.

Compartments can be linked, so one compartment can export a module that another compartment
imports. Each compartment may have its own rules for how to resolve import specifiers and
how to locate and retrieve modules. In the following example, we use the compartment constructor to
create two compartments: one for the application and another for its dependency.

The `resolveHook` is synchronous and determines how to compute the full module specifier
for a partially resolved module specifier in ESM source text, like `import "./even.js"` as
it appears in `./math/odd.js` corresponds to `./math/even.js` in a Node.js program.

The `importHook` is asynchronous and responsible for for locating, retrieving, and parsing
modules. Retrieving is getting the source text from the web, archive, or database based on
its location. Converting a module specifier to a location is an internal concern of
the `importHook` and the particular storage medium for the module texts, but should generally
be a URL and may appear in stack traces. The `importHook` may use the `ModuleStaticRecord`
constructor to create a reusable, parsed representation of the module text.

```js
const dependency = new Compartment({}, {}, {
  resolveHook: (moduleSpecifier, moduleReferrer) =>
    resolve(moduleSpecifier, moduleReferrer),
  importHook: async moduleSpecifier => {
    const moduleLocation = locate(moduleSpecifier);
    const moduleText = await retrieve(moduleLocation);
    return new ModuleStaticRecord(moduleText, moduleLocation);
  },
});
const application = new Compartment({}, {
  'dependency': dependency.module('./main.js'),
}, {
  resolveHook,
  importHook,
});
```
Compartments provide a low-level loader API for JavaScript modules.
Your code might run in compartments, but they are an implementation
detail of tools and runtimes.

Vats in the Agoric runtime use compartments to isolate contracts within a vat.
A vat can use multiple compartments.
MetaMask’s LavaMoat uses a Compartment for every module, to create
boundaries between application code and third-party dependencies.

The lifetime of a compartment is bounded by garbage collection and the
lifetime of the realm that contains them. You will not ever have to tear
down or delete one.


Source: [docs/guide.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/guide.md) at commit `fe81477b`.
