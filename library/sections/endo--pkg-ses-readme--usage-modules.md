---
title: Usage: Modules and Module Loading
source: packages/ses/README.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, compartments, bundles]
status: current
---

> Abstract: Module-loading details for Compartments: Modules subsection covers the module map and how Compartments resolve imports; Module Descriptors (source vs namespace), Redirects, moduleMapHook, importNowHook are the lookup hooks; Virtual Module Source explains how non-JS modules can be wired in; Compiled modules covers precompilation; Transforms covers source-rewriting hooks. Consolidates 5+ H3 sub-sections at the H2 Usage boundary.

### Modules

Any code executed within a compartment shares a set of module instances.
For modules to work within a compartment, the creator must provide
module descriptors.
A compartment can be configured with module descriptors, from highest to lowest
precedence:

* the `modules` map provided to the `Compartment` constructor,
* returned by a `moduleMapHook(specifier)` passed as an option to the
  `Compartment` constructor.
* returned by either the `importHook(specifier)` or `importNowHook(specifier)`
  option passed to the `Compartment` constructor. Calling
  `compartment.import(specifier)` falls through to the `importHook` which may
  return a promises, whereas `compartment.importNow(specifier)` falls through
  to the synchronous `importNowHook`.

The `resolveHook` determines how the compartment will infer the full module
specifier for another module from a referrer module and the import specifier.

```js
import 'ses';
import { ModuleSource } from '@endo/module-source';

const c1 = new Compartment({
  name: "first compartment",
  resolveHook: (moduleSpecifier, moduleReferrer) => {
    return resolve(moduleSpecifier, moduleReferrer);
  },
  importHook: async moduleSpecifier => {
    const moduleLocation = locate(moduleSpecifier);
    const moduleText = await retrieve(moduleLocation);
    return {
        source: new ModuleSource(moduleText, moduleLocation)
    };
  },
  __options__: true, // temporary migration affordance
});
```

> The Hardened JavaScript language specifies a global `ModuleSource`, but this
> is not provided by the shim because it entrains a full JavaScript parser that
> is an unnecessary performance penalty for the SES runtime.
> Instead, the SES shim accepts a pre-compiled module source duck-type that
> is tightly coupled to the shim implementation.

A compartment can also link a module in another compartment.

```js
const c2 = new Compartment({
  name: "second compartment",
  modules: {
    'c1': {
      source: './main.js',
      compartment: c1,
    },
  },
  resolveHook,
  importHook,
  __options__: true, // temporary migration affordance
});
```

#### Module Descriptors

Comparments can load and initialize module namespaces from module descriptors.
Like property descriptors, module descriptors are ordinary objects with various
forms.

##### Descriptors with `source` property

* If fhe value of the `source` property is a string, the parent compartment
  loads the module but the compartment itself initializes the module.

* Otherwise, if the value of the `source` property is the module source, the
  module is initialized from the module source.

* Otherwise, the value of the `source` property must be an object. The module
  is loaded and initialized from the object according to the [virtual module
  source](#VirtualModuleSource) pattern.

If the `importMeta` property is present, its value must be an object. The
default `importMeta` object is an empty object.

Compartments copy the `importMeta` object properties into the module
`import.meta` object like `Object.assign`.

If the `specifier` property is present, its value is coerced into a string and
becomes the referrer specifier of the module, on which all import specifiers
are resolved using the `resolveHook`.

##### Descriptors with `namespace` property

* If fhe value of the `namespace` property is a string, the descriptor shares a
  module to be loaded and initialized by the compartment referred by the
  `compartment` property.

  * If the `compartment` property is present, its value must be a
      compartment.
  * If absent, the `compartment` property defaults to the compartment being
      constructed in the `modules` option, or being hooked in the `loadHook`
      and `loadNowHook` options.

* Otherwise, if the value of the `namespace` property is a module namepace, the
  descriptor shares a module that is already available.

* Otherwise, the value of `namespace` property must be an object. The module is
  loaded and initialized from the object according to the [virtual module
  namespace](#VirtualModuleNamespace) pattern.

#### Redirects

If a compartment imports a module specified as `"./utility"` but actually
implemented by an alias like `"./utility/index.js"`, the `importHook` may
follow redirects, symbolic links, or search for candidates using its own logic
and return a module that has a different "response specifier" than the original
"request specifier".
The `importHook` may return an "alias" object with `source`, `compartment`,
and `specifier` properties.

* `source` must be a module source, either a virtual module source
  or a compiled module source.
* `compartment` is optional, to be specified if the alias transits to a
  the specified different compartment, and
* `specifier` is the full module specifier of the module in its compartment.
  This defaults to the request specifier, which is only useful if the
  compartment is different.

In the following example, the importHook searches for a file and returns an
alias.

```js
const importHook = async specifier => {
  const candidates = [specifier, `${specifier}.js`, `${specifier}/index.js`];
  for (const candidate of candidates) {
    const source = await maybeImportSource(candidate);
    if (source !== undefined) {
      return {
        source,
        specifier: candidate,
        compartment,
      };
    }
  }
  throw new Error(`Cannot find module ${specifier}`);
};

const compartment = new Compartment({
  resolveHook,
  importHook,
  __options__: true, // temporary migration affordance
});
```

#### moduleMapHook

The module map above allows modules to be introduced to a compartment up-front.
Some modules cannot be known that early.
For example, in Node.js, a package might have a dependency that brings in an
entire subtree of modules.
Also, a pair of compartments with cyclic dependencies between modules they each
contain cannot use `compartment.module` to link the second compartment
constructed to the first.
For these cases, the `Compartment` constructor accepts a `moduleMapHook` option
that is like the dynamic version of the static `moduleMap` argument.
This is a function that accepts a module specifier and returns the module
namespace for that module specifier, or `undefined`.
If the `moduleMapHook` returns `undefined`, the compartment proceeds to the
`importHook` to attempt to asynchronously obtain the module's source.

```js
const moduleMapHook = moduleSpecifier => {
  if (moduleSpecifier === 'even') {
    return {
      source: './index.js',
      compartment: even,
    };
  } else if (moduleSpecifier === 'odd') {
    return {
      source: './index.js',
      compartment: odd,
    };
  }
};

const even = new Compartment({
  resolveHook: nodeResolveHook,
  importHook: makeImportHook('https://example.com/even'),
  moduleMapHook,
  __options__: true, // temporary migration affordance
});

const odd = new Compartment({
  resolveHook: nodeResolveHook,
  importHook: makeImportHook('https://example.com/odd'),
  moduleMapHook,
  __options__: true, // temporary migration affordance
});
```

#### importNowHook

Additionally, an `importNowHook` may be provided that the compartment will use
as means to synchronously load modules not seen before in situations where
calling out to asynchronous `importHook` is not possible.
Specifically, when `compartmentInstance.importNow('specifier')` is called, the
compartment will first look up module records it's already aware of and call
`moduleMapHook` and if none of that is successful in finding a module record
matching the specifier, it will call `importNowHook` expecting to synchronously
receive the same record type as from `importHook` or throw if it cannot.

```js
import 'ses';
import { ModuleSource } from '@endo/module-source';

const compartment = new Compartment({
  name: "first compartment",
  modules: {
    c: {
      source: new ModuleSource(''),
    },
  },
  resolveHook: (moduleSpecifier, moduleReferrer) => {
    return resolve(moduleSpecifier, moduleReferrer);
  },
  importHook: async moduleSpecifier => {
    const moduleLocation = locate(moduleSpecifier);
    const moduleText = await retrieve(moduleLocation);
    return {
      source: new ModuleSource(moduleText, moduleLocation),
    };
  },
  importNowHook: moduleSpecifier => {
    const moduleLocation = locate(moduleSpecifier);
    // Platform-specific synchronous read API can be used
    const moduleText = fs.readFileSync(moduleLocation);
    return {
      source: new ModuleSource(moduleText, moduleLocation),
    };
  },
  __options__: true, // temporary migration affordance
});
//...                   | importHook | importNowHook
await compartment.import('a'); //| called     | not called
compartment.importNow('b');    //| not called | called
compartment.importNow('a');    //| not called | not called
compartment.importNow('c');    //| not called | not called
```

### <a name="VirtualModuleSource"></a> Virtual Module Source

To incorporate modules not implemented as JavaScript modules, third-parties may
implement a `VirtualModuleSource` interface.
The object must have an `imports` array and an `execute` method.
The compartment will call `execute` with:

1. the proxied `exports` namespace object,
2. a `resolvedImports` object that maps import names (from `imports`) to their
   corresponding resolved specifiers (through the compartment's `resolveHook`),
   and
3. the `compartment`, such that `importNow` can obtain any of the module's
   specified `imports`.

:warning: A future breaking version may allow the `importNow` and the `execute`
method of virtual module sources to return promises, to support
top-level await.

:warning: The virtual module source interface does not yet agree with the
[XS](https://www.moddable.com/hardening-xs) implementation of [Hardened
JavaScript](https://hardenedjs.org/).

### Compiled modules

Instead of the `ModuleSource` constructor specified for the SES language,
the SES shim uses compiled module source records as a stand-in.
These can be created with a `ModuleSource` constructor from a package
like `@endo/module-source`.
We omitted `ModuleSource` from the SES shim because it entrains a heavy
dependency on a JavaScript parser.
The shim depends upon a `ModuleSource` constructor to analyze and
transform the source of a JavaScript module (known as an ESM or a `.mjs` file)
into a JavaScript program suitable for evaluation with `compartment.evaluate`
using a particular calling convention to initialize a module instance.

A compiled module source record has the following shape:

* `imports` is a record that maps partial module specifiers to a list of
  names imported from the corresponding module.
* `exports` is an array of all the names that the module will export.
* `reexports` is an array of partial module specifier for which this
  module exports all imported names.
  This field is optional.
* `__syncModuleProgram__` is a string that evaluates to a function that accepts
  an initialization record and initializes the module.
  This property distinguishes this type of module record.
  The name implies a future record type that supports top-level await.
  * An initialization record has the properties `imports`, `liveVar`, `importMeta` and
    `onceVar`.
    * `imports` is a function that accepts a map from partial import
      module specifiers to maps from names that the corresponding module
      exports to notifier functions.
      A notifier function accepts an update function and registers
      to receive updates for the value exported by the other module.
    * `importMeta` is a null-prototype object with keys transferred from `importMeta`
      property in the envelope returned by importHook and/or mutated by
      calling `importMetaHook(moduleSpecifier, importMeta)`
    * `liveVar` is a record that maps names exported by this module
      to a function that may be called to initialize or update
      the corresponding value in another module.
    * `onceVar` is a record that maps constants exported by this
      module to a function that may be called to initialize the
      corresponding value in another module.
* `__syncModuleFunctor__` is an optional function that if present is used
  instead of the evaluation of the `__syncModuleProgram__` string. It will be
  called with the initialization record described above. It is intended to be
  used in environments where eval is not available. Sandboxing of the functor is
  the responsibility of the author of the ModuleSource.
* `__liveExportsMap__` is a record that maps import names or names in the lexical
  scope of the module to export names, for variables that may change after
  initialization. Any reexported name is assumed to possibly change.
  The exported name is wrapped in a duple array like `["exportedName", true]`.
  The second value, a boolean, indicates that the variable has a temporal
  dead-zone (a time between creation and initialization) when access to that
  name should throw a `ReferenceError`.
* `__fixedExportsMap__` is a record that maps import names to export names
  for constants exported by this module.
  The fixed exports map is an aesthetic subtype of the live exports map,
  so the value is wrapped in a simple array like `["exportedName"]`

### Transforms

The `Compartment` constructor accepts a `transforms` option.
This is an array of JavaScript source to source translation functions,
in the order they should be applied.
Passing the source to the first function's input, then from each function's
output to the next's input, the final function's output must be a valid
JavaScript "Program" grammar construction, code that is valid in a `<script>`,
not a module.

```js
const transforms = [addCodeCoverageInstrumentation];
const c = new Compartment({
  globals: { console, coverage },
  transforms,
  __options__: true, // temporary migration affordance
});
c.evaluate('console.log("Hello");');
```

The `evaluate` method of a compartment also accepts a `transforms` option.
These apply before and in addition to the compartment-scoped transforms.

```js
const transform = source => source.replace(/Farewell/g, 'Hello');
const transforms = [transform];
c.evaluate('console.log("Farewell, World!")', { transforms });
// Hello, World!
```

These transforms do not apply to modules.
To transform the source of a JavaScript module, the `importHook` must
intercept the source and transform it before passing it to the
`ModuleSource` constructor.
These are distinct because programs and modules have distinct grammar
productions.

An **internal implementation detail** of the SES-shim is that it
converts modules to programs and evaluates them as programs.
So, only for this implementation of `Compartment`, it is possible for a program
transform to be equally applicable for modules, but that transform will
have a window into the internal translation, will be sensitive to changes to
that translation between any pair of releases, even those that do not disclose
any breaking changes, and will only work on SES-shim, not any other
implementation of `Compartment` like the one provided by XS.

The SES-shim `Compartment` constructor accepts a `__shimTransforms__`
option for this purpose.
For the `Compartment` to use the same transforms for both evaluated strings
and modules converted to programs, pass them as `__shimTransforms__`
instead of `transforms`.

```js
const __shimTransforms__ = [addCoverage];
const c = new Compartment({
  globals: { console, coverage },
  __shimTransforms__,
  __options__: true, // temporary migration affordance
});
c.evaluate('console.log("Hello");');
```

The `__shimTransforms__` feature is designed to uphold the security properties
of compartments, since an attacker may use all available features, whether they
are standard or not.


Source: [packages/ses/README.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/packages/ses/README.md) at commit `fe81477b`.
