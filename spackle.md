
Prototype.js pioneered extending JavaScript from within JavaScript and
added many methods to Object.prototype and Array.prototype.
We learned a lot from this early experiment and the language and browsers
eventually implemented many of these features.
We learned a lot about the interplay between the community and the standard
to evolve the language.

Considerations like enumerability and the introduction of symbols were shaped
by this interplay.
For example, well-known-symbols exist to give the language designers an
inimitable symbol category, that no shim can emulate.

There is not wide consensus in the JavaScript community about shim and polyfill.
Polyfill was (I believe, please cite) coined by Remmy Sharp.
I don't recall the origin of shim, but I (Kris Kowal) used the term for es5-shim.
We understand polyfill and shim to be synonymous: JavaScript that runs early in order to
modify the global environment so it more closely resembles a more recent standard.

When implementing a shim, there is a risk that the emerging standard will not
be the same as the shim.
For shims, assuming high confidence that the shim provides a good approximation
of the behavior the language will eventually expose, the shim should not overwrite
the native behavior.

```js
if (!Array.prototype.map) {
  Array.prototype.map = function () {
    // ...
  };
}
```

If there is any chance of drift, then the applications that use this library risk
breaking when the native implementation is revealed.
Whereas, unconditionally overwriting the property risks composition hazards
with other shims.

A ponyfill is a function exported by a module that falls through to the native behavior if 
it is present, and provides a user code fallback if it is not.
This allows a library to anticipate a new feature and begin using it, functioning
during the migration, without altering the shared global context.
This obviates coordination problems among ponyfills. There is no race to install
the global.
There is still a risk that the native behavior will not match the expected
behavior and dependent code will break.

A piece of code that gets instantiated more than once in a realm has “eval twins”.
Eval twins often interact poorly.
For example, if a library provides a class, eval twins will not recognize instances
of the same purported class with `instanceof`.
They need to use structural equivalence or duck typing, often with a distinguished method,
to handle their twins.
This is how the promise ecosystem converged on `then` methods for promises.
A less aggressive way to duck-type eval twins is the use of registered symbols.
Eval twins of registered symbols are equal to each other.
Eval twins of unique symbols, however, are not.
Similarly, eval twins of the same class don't recognize each other's private fields.

Endo provides a number of pre-standard features that require a great degree of coordination
and must be resilient against eval twins.
We have converged on a new pattern that we are tentatively calling "spackle".
Spackle is a module that *races* to install a behavior in global scope.
Spackle uses both polyfill and ponyfill techniques.
The first of eval twins will install a behavior in global scope using a registered symbol.
The registered symbol would be awkward ergonomically.

```js
Object[Symbol.for('harden')](object)
```

So, the spackle module *also* exports a ponyfill that makes usage convenient.

```js
import harden from '@endo/harden';
harden(object);
```

This is important for `harden` for a couple reasons.
The only downside of `harden` meeting an eval twin of itself is that the eval twins
will replicate work. Each instance will have its own weak set to track objects
that have already been hardened.
This is load-bearing for performance rasons, so best avoided.

The other motive for a spackled `harden`, in particular, is that we want “hardened modules”
to work regardless of whether the application is running under Hardened JavaScript.
For that reason, if the spackle module wins the race to install `Object[Symbol.for('harden')]`,
it installs a surface harden, one that does not harden up the prototype chain.
Hardening up the prototype chain would have similar effects to calling `lockdown`, but
without any of the modifications to shared intrinsics that are necessary for making a realm
safe for multiple tenants.
And, doing so largely obviates the reasons why one might use that library
without `lockdown`, particularly dealing with the most pernicious challenge for
Hardened JavaScript: the property override mistake [citation needed].

If `lockdown` runs first, it adds a volumetric `harden` to `Object[Symbol.for('harden')]`.
In this environment, the spackle `harden` does not install its version and the exported `harden`
calls through to the lockdown version.

This creates an obligation for hardened modules to always be initialized after `lockdown`.
If the spackle module's polfill behavior runs first, it will create a
non-configurable property on a shared intrinsic, and `lockdown` will throw, because the environment
was corrupted before it could run.

Defining the property for `Object.for('harden')` on `Object` also ensures that the polyfilled
method gets carried into child compartments, because `Object` is a shared intrinsic.

We expect to use the spackle pattern for `@endo/eventual-send`.
Unlike Harden, Eventual Send does not need different behaviors depending on whether it is running
in a HardenedJS environment, but it relies on realm-wide state for correctness, not merely performance.
Eventual Send needs to be able to recognize and forward messages through native promises that have
been marked.
It will likely in the future need to be able to mark non-native promises.
Eventual send cannot tolerate eval twins.
Promises and precences in compartments in any realm must be able to recognize their eval twins.

These are just two examples where the spackle pattern will be useful to Endo.
Watch for more, and whether this pattern is useful for your library.

Notably, for the purposes of language evolution, using a registered symbol for
the name of a property on an intrinsic gives the language designers some liberty.
We would hope that `Object.harden` would replace `Object[Object.for('harden')]`.
But, the language can also introduce a well-known symbol, like Symbol.harden,
such that `Symbol.harden` is not equal to `Symbol.for('harden')`, and with enough
lead time, we can ensure any application running in front of the specification
knows the difference.

