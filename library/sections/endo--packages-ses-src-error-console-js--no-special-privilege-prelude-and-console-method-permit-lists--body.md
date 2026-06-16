---
title: Body
source: packages/ses/src/error/console.js
source_repo: endojs/endo
source_branch: master
source_commit: e02b0f66eb44306c3d739e1670114ef24d4202fa
source_date: 2025-01-02
source_authors: [Mark S. Miller]
source_lines: "1-157 (prelude + consoleLevelMethods + consoleOtherMethods + consoleOmittedProperties commented block)"
topics: [hardened-javascript, errors]
status: current
notes: |
  The module's opening discipline: *to ensure that this module
  operates without special privilege, it should not reference the
  free variable `console` except for its own internal debugging
  purposes in the declaration of `internalDebugConsole`, which is
  normally commented out*. This is the *no-special-privilege* design
  axiom that lets the module be loaded into hardened compartments
  without inheriting any ambient logging authority. The permit lists
  enumerate the console methods this module knows how to wrap, paired
  with log severities sourced from cross-platform agreement (Whatwg
  spec + Node + MDN + TypeScript + Chrome). The
  consoleOmittedProperties commented block records the *false-entries*
  discipline: properties expected on the original console but not
  permitted on the wrapped console — *seeing these on the original
  console is expected, but seeing anything else that's outside the
  permits is surprising and should provide a diagnostic*.
parent: endo--packages-ses-src-error-console-js--no-special-privilege-prelude-and-console-method-permit-lists
---

### §The no-special-privilege design axiom

The §opening comment (lines 3-6) names the module's central design constraint:

> To ensure that this module operates without special privilege, it should not reference the free variable `console` except for its own internal debugging purposes in the declaration of `internalDebugConsole`, which is normally commented out.

The structural reading:

- **The module is *loadable into hardened compartments***. A SES Compartment may or may not have `globalThis.console` available. Code in this module must work regardless.
- **The exception is `internalDebugConsole`**: a commented-out line that lets a maintainer enable internal debugging by uncommenting:
  ```
  // const internalDebugConsole = console;
  ```
- **The exception is *visible but inactive***. Reading the source code reveals the debug hook exists; production semantics never invoke it.

The §axiom generalizes: *any SES-internal module that wraps a host capability should operate without depending on that capability's ambient form*. The module *receives* a `baseConsole` argument (via `makeCausalConsole(baseConsole, ...)`); it does not *find* one.

### §The four-standard permit-list lineage

The §next comment block (lines 48-66) enumerates the four cross-platform standards consulted for the console-method permit lists:

- **Whatwg living standard** — `https://console.spec.whatwg.org/` (the canonical web-platform spec).
- **Node** — `https://nodejs.org/dist/latest-v14.x/docs/api/console.html`.
- **MDN** — `https://developer.mozilla.org/en-US/docs/Web/API/Console_API`.
- **TypeScript** — the `_types_node_globals_d_.console` type definitions.
- **Chrome** — `https://developers.google.com/web/tools/chrome-devtools/console/api` (Chrome's devtools-specific extensions).

The §discipline: **only the methods documented across multiple standards are permitted**. A method that exists in one engine but not the standard or other engines is *not* permitted unless it has clear cross-platform support.

The §formatter-discipline comment (lines 55-60):

> All console level methods have parameters (fmt?, ...args) where the argument sequence `fmt?, ...args` formats args according to fmt if fmt is a format string. Otherwise, it just renders them all as values separated by spaces.

The formatter is the *standard sprintf-ish* behavior across console implementations. The first argument *may* be a format string (with `%s`, `%d`, `%o`, etc.); if not, all arguments are rendered as values separated by spaces.

The §causal-console error-detection caveat (lines 62-66):

> For the causal console, all occurrences of `fmt, ...args` or `...args` by itself must check for the presence of an error to ask the `loggedErrorHandler` to handle.
> In theory we should do a deep inspection to detect for example an array containing an error. We currently do not detect these and may never.

The §caveat names a *known limitation*: the causal-console inspects *direct* arguments for Error instances (`isError(arg)`), but does *not* recurse into arrays or objects. An array containing an error gets passed through as an opaque array; the error inside is not specially handled. The *we currently do not detect these and may never* admission is the *honest-future-work-but-not-promised* discipline — the limitation is documented; no commitment is made to fix it.

### §consoleLevelMethods — nine methods with severities

The §consoleLevelMethods permit list (lines 80-91) enumerates nine methods paired with log severities:

```js
export const consoleLevelMethods = freeze([
  ['debug', 'debug'], // (fmt?, ...args) verbose level on Chrome
  ['log', 'log'], // (fmt?, ...args) info level on Chrome
  ['info', 'info'], // (fmt?, ...args)
  ['warn', 'warn'], // (fmt?, ...args)
  ['error', 'error'], // (fmt?, ...args)

  ['trace', 'log'], // (fmt?, ...args)
  ['dirxml', 'log'], // (fmt?, ...args)          but TS typed (...data)
  ['group', 'log'], // (fmt?, ...args)           but TS typed (...label)
  ['groupCollapsed', 'log'], // (fmt?, ...args)  but TS typed (...label)
]);
```

The structural pairing:

| Method | Severity | Note |
|---|---|---|
| `debug` | `'debug'` | Verbose level on Chrome. |
| `log` | `'log'` | Info level on Chrome. |
| `info` | `'info'` | |
| `warn` | `'warn'` | |
| `error` | `'error'` | |
| `trace` | `'log'` | Includes stack trace. |
| `dirxml` | `'log'` | TypeScript types as `(...data)` but actual runtime is `(fmt?, ...args)`. |
| `group` | `'log'` | TS-typed as `(...label)` but actual runtime is `(fmt?, ...args)`. |
| `groupCollapsed` | `'log'` | Same. |

The §pairing-rationale: *each is paired with what we consider to be their log severity level. This is the same as the log severity of these on other platform console implementations when they all agree.*

The five canonical-severity methods (debug/log/info/warn/error) map 1:1 to severities. The four trace-family methods (trace/dirxml/group/groupCollapsed) are all severity `'log'` because their semantic is *informational structure*, not *error reporting*.

The §TypeScript-vs-runtime note (`but TS typed (...data)` on `dirxml`, `group`, `groupCollapsed`) is the *runtime-truth-over-static-type* discipline: the actual JavaScript-runtime behavior of these methods is `(fmt?, ...args)`-style; TypeScript's types are wrong but the wrapping code follows the runtime behavior.

### §consoleOtherMethods — ten methods without fmt+args

The §consoleOtherMethods permit list (lines 103-124) enumerates ten additional methods:

| Method | Severity | Signature |
|---|---|---|
| `assert` | `'error'` | `(value, fmt?, ...args)` |
| `timeLog` | `'log'` | `(label?, ...args)` no fmt string |
| `clear` | `undefined` | `()` |
| `count` | `'info'` | `(label?)` |
| `countReset` | `undefined` | `(label?)` |
| `dir` | `'log'` | `(item, options?)` |
| `groupEnd` | `'log'` | `()` |
| `table` | `'log'` | `(tabularData, properties?)` |
| `time` | `'info'` | `(label?)` |
| `timeEnd` | `'info'` | `(label?)` |
| `profile` | `undefined` | `(label?)` Node Inspector / MDN / TypeScript |
| `profileEnd` | `undefined` | `(label?)` |
| `timeStamp` | `undefined` | `(label?)` |

The structural distinctions:

- **`assert`** is *special* — its first argument is a value (not a format string), and the rest is `(fmt?, ...args)`. The causal console handles it carefully.
- **`undefined` severities** mean *pass-through-without-formatter-inspection*. These methods take no arguments that could legitimately be an error, so the causal console just passes them to the baseConsole without error-extraction.
- **`table`** is flagged as a partial-detection case: *In theory tabular data may be or contain an error. However, we currently do not detect these and may never.* Same admission as the §causal-console error-detection caveat from earlier — known limit; no promise of fix.

The §three Node-Inspector-only methods (`profile`, `profileEnd`, `timeStamp`) are paired with `undefined` severity. The comment notes *Node Inspector only, MDN, and TypeScript, but not whatwg* — these are *non-Whatwg* extensions that nevertheless appear in enough standards to warrant inclusion.

### §The `consoleMethodPermits` union

The §combined permit list (lines 126-130):

```js
const consoleMethodPermits = freeze([
  ...consoleLevelMethods,
  ...consoleOtherMethods,
]);
```

The §union is the *complete* set of methods this module knows how to wrap. Any console method *not* in this list is *omitted from wrapped consoles* — the wrapped console exposes only the permitted method names.

### §consoleOmittedProperties — the false-entries discipline

The §commented-out `consoleOmittedProperties` block (lines 132-157) is structurally significant:

```js
/**
 * consoleOmittedProperties is currently unused. I record and maintain it here
 * with the intention that it be treated like the `false` entries in the main
 * SES permits: that seeing these on the original console is expected, but
 * seeing anything else that's outside the permits is surprising and should
 * provide a diagnostic.
 *
 * const consoleOmittedProperties = freeze([
 *   'memory', // Chrome
 *   'exception', // FF, MDN
 *   '_ignoreErrors', // Node
 *   '_stderr', // Node
 *   '_stderrErrorHandler', // Node
 *   '_stdout', // Node
 *   '_stdoutErrorHandler', // Node
 *   '_times', // Node
 *   'context', // Chrome, Node
 *   'record', // Safari
 *   'recordEnd', // Safari
 *
 *   'screenshot', // Safari
 *   // Symbols
 *   '@@toStringTag', // Chrome: "Object", Safari: "Console"
 *   // A variety of other symbols also seen on Node
 * ]);
 */
```

The §framing is the *false-entries-in-SES-permits* discipline:

> seeing these on the original console is expected, but seeing anything else that's outside the permits is surprising and should provide a diagnostic.

The structural picture: **SES permits have three implicit categories**:
- **`true` entries** — methods/properties *permitted* (in the wrapped form).
- **`false` entries** — methods/properties *expected on the original but not permitted* (this is the `consoleOmittedProperties` list).
- **Implicit-unlisted** — methods/properties *not expected on the original*. Seeing one would be *surprising* and should trigger a diagnostic.

The 14 false-entries are *engine-specific extensions* (Chrome / FF / Node / Safari) that the wrapping code intentionally hides from the wrapped console. Their *expected* presence on the original console means the wrapping logic doesn't need to emit a diagnostic when it encounters them — they are *known-but-omitted*.

The §current-unused note (`consoleOmittedProperties is currently unused`) explains why the list is commented out: it is *aspirational documentation* of what *would* be the false-entries if the wrapping logic ever needed to differentiate *known-omitted* from *surprising-extra*. As of cycle 96, the wrapping logic just skips anything not in the permit list without distinguishing categories.

### §The defineName utility

The §opening `defineName` function (lines 31-43) supports named arrow functions:

```js
const defineName = (name, fn) => defineProperty(fn, 'name', { value: name });
```

The §comment names the use case:

> Explicitly set a function's name, supporting use of arrow functions for which source text doesn't include a name and no initial name is set by NamedEvaluation https://tc39.es/ecma262/multipage/syntax-directed-operations.html#sec-runtime-semantics-namedevaluation. Instead, we hope that tooling uses only the explicit `name` property.

The §rationale: arrow functions assigned to map-entries don't get implicit names; the wrapping code uses `defineName('debug', (...args) => ...)` to ensure the wrapped function carries the right name for tooling (debuggers, stack traces, error messages). The function is used throughout the file in the wrap-method constructions.
