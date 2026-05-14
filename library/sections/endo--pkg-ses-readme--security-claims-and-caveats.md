---
title: Security claims and caveats
source: packages/ses/README.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, capability-security, compartments]
status: current
---

> Abstract: Five sub-sections analyzing SES's security posture: Single-guest Compartment Isolation (what one Compartment can do to itself), Multi-guest Compartment Isolation (cross-Compartment effects), Endowment Protection (what powers cross the boundary), Caveats (known weaknesses), Trusted Compute Base (what must be trusted for SES to hold its guarantees). The substantive security-properties section of the SES README; consolidated as one section with H3 sub-sections inline.

## Security claims and caveats

The `ses` shim concerns boundaries between programs in the same process and
JavaScript realm.
In terms of the [Taxonomy of Security Issues](https://papers.agoric.com/taxonomy-of-security-issues/),
the `ses` shim creates a boundary that is finer than an operating system
process or thread and facilitates boundaries as fine as individual objects.
While `ses` can interpose at granularities where process isolation is not a
viable boundary, as between an application and its dependencies or between a
platform and a plugin, `ses` combines well with coarser boundaries for defense
in depth.

For the purposes of these claims and caveats, a "host program" is a program
that arranges `ses`, calls `lockdown`, and orchestrates one or more "guest
programs", providing limited access to its resources.

### Single-guest Compartment Isolation

Provided that the `ses` implementation and its
[trusted compute base](#trusted-compute-base) are correct, we claim that a host
program can evaluate a guest program (`program`) in a compartment after
`lockdown` and that the guest program:

* will initially only have access to one mutable object, the compartment's
  `globalThis`,
* specifically cannot modify any shared primordial objects, which are part of
  the default execution environment,
* cannot initially perform any I/O (except I/O necessarily performed by the
  trusted compute base like paging virtual memory),
* and specifically cannot measure the passage of time at any resolution.

However, such a program can:

* execute for an indefinite amount of time,
* allocate arbitrary amounts of memory,
* detect the platform endianness,
* in some JavaScript engines, observe the contents of the stack.
  This may include sensitive information about the layout of files on the host
  disk.
  In cases where the stack is data-dependent, a guest can infer the data.
  `ses` occludes the stack on V8 and SpiderMonkey, but cannot on
  JavaScriptCore.

```js
lockdown();
const compartment = new Compartment();
compartment.evaluate(program);
```

### Multi-guest Compartment Isolation

If the host program arranges for the compartment's `globalThis` to
be frozen, we additionally claim that the host can evaluate any two guest
programs (`program1` and `program2`) in that compartment such that neither
guest program will:

* initially share *any* mutable objects.
* be able to observe the relative passage of time of the other program,
  as they would had they been given a reference to a working `Date.now()`.
* be able to communicate, as they would if they had shared access to mutable
  state like an unfrozen object, a hardened collection like a `Map`, or even
  `Math.random()`.

```js
lockdown();
const compartment = new Compartment();
harden(compartment.globaThis);
compartment.evaluate(program1);
compartment.evaluate(program2);
```

### Endowment Protection

The above `program`, `program1`, and `program2` guest programs are only useful
as glorified calculators.
When going beyond that by "endowing" a compartment with extra objects, a host
program is responsible for maintaining any of the invariants above that it
considers necessary.

For example, a host program may run two guest programs in separate
compartments, giving one the ability to resolve a promise and the other
the ability to observe the settlement (fulfillment or rejection) of
that promise.
The host program is responsible for hardening the objects implementing such
abilities.

```js
lockdown();

const promise = new Promise(resolve => {
  const compartmentA = new Compartment({
    globals: harden({ resolve }),
  __options__: true, // temporary migration affordance
  });
  compartmentA.evaluate(programA);
});

const compartmentB = new Compartment({
  globals: harden({ promise }),
  __options__: true, // temporary migration affordance
});
compartmentB.evaluate(programB);
```

With `ses`, guest programs are initially powerless.
A host can explicitly share limited powers with guest programs
and provide intentional communication channels between them.

### Caveats

Host programs must maintain the `ses` boundary with care in what they present
as endowments.
A host program should take care not to share mutable state with guests,
or distribute mutable state to multiple guests, such as an object that has not
been frozen with `harden` or a collection like a `Map` or `Set` or typed array
(collections retain some mutability even if hardened).

For the purposes of sharing state, pseudo-random number generators (PRNG) like
`Math.random()` are equivalent to read and write access to shared state, and
any guest can use one to eavesdrop on other guests or the host that share one.

If a guest program needs a high resolution timer to function, the host should
only invite one guest to a single operating system process and limit the
activity of the host program in the same process.

Hosts must avoid exposing `SharedArrayBuffer` to guests.
Any two JavaScript programs sharing a `SharedArrayBuffer` can use the shared
buffer to construct a high resolution timer.

The `ses` shim does not in itself isolate the stack of guest programs, even
when evaluated in separate compartments.
This is relevant when objects are shared between guest programs.

When a program interacts with an object introduced by another program (as
through the per-compartment `globalThis`, function arguments or returned
values), there are potential risks due to the synchronous nature of object
access.
Even interactions that are not explicit function calls may cause code from
another program, like property accessors or proxy traps, to execute on the same
stack, which may be able to detect the stack height, throw an exception, or call
back into the program in pursuit of a reentrancy attack.

A host object can defend itself from reentrancy attacks by ensuring that it
interacts with guest objects on a clean stack through the use of promises.

Within these constraints, a host program can provide objects that grant limited
I/O capabilities to guest programs, and even revoke or suspend those
capabilities at runtime.

### Trusted Compute Base

The trusted compute base (TCB) for `ses` includes:

* the host hardware,
* the host operating system,
* any intermediate virtual operating systems or hypervisors,
* the process memory manager,
* an implementation of JavaScript conforming to ECMAScript 262 as of
  2021, providing no unspecified embedding host behavior like the introduction of syntax
  that when evaluated reveals a mutable object.
  `ses` accounts for one such host behavior provided by Node.js, namely the `domain`
  property on promises, by preventing the use of `ses` in concert with the
  `domain` module.
* Also, any attached debugger, and
* any JavaScript that has executed in the same realm before the host program calls
  `lockdown`, including JavaScript that executes after `ses` initializes.


Source: [packages/ses/README.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/packages/ses/README.md) at commit `fe81477b`.
