---
title: Body
source: packages/ses/src/error/console.js
source_repo: endojs/endo
source_branch: master
source_commit: 1b978bfbec82786398c61b004019f83cafef3527
source_date: 2026-06-17
source_authors: [Mark S. Miller]
source_lines: "1-277 (prelude + consoleLevelMethods + consoleSpecialMethods + consoleOtherMethods + consoleOmittedProperties commented block + sanitizeFormatData)"
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

The §axiom generalizes: *any SES-internal module that wraps a host capability should operate without depending on that capability's ambient form*. The module *receives* a `feralConsole` argument (via `makeCausalConsole(feralConsole, ...)`); it does not *find* one. (As of the 2026-06-17 refresh the parameter is named `feralConsole`, and `makeCausalConsole` itself rebuilds a private `baseConsole` from it on Node — see the *makeCausalConsole* body section.)

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

The §consoleLevelMethods permit list (lines 83-101) enumerates nine methods paired with log severities. As of the 2026-06-17 refresh the element type is `readonly [ConsoleProps, LogSeverity][]` — every entry now carries a concrete severity (the prior `LogSeverity | undefined` union is gone):

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

### §consoleSpecialMethods — assert and timeLog (refreshed 2026-06-17)

The 2026-06-17 refresh split `assert` and `timeLog` out of `consoleOtherMethods` into their own exported list, `consoleSpecialMethods` (lines 104-107):

```js
export const consoleSpecialMethods = freeze([
  ['assert', 'error'], // (value, fmt?, ...args)
  ['timeLog', 'log'], // (label?, ...args) no fmt string
]);
```

The §why-special comment is explicit:

> We special case `console.assert` because it contains `fmt?, ...args` just like the `consoleLevelMethods`, but not in the same place. We special case `console.timeLog` because it contains the same kind of `...args`, but with no format string.

Both methods *do* carry a `fmt?, ...args` cluster that may hold errors — but it sits *after* a leading argument (`assert`'s boolean `value`, `timeLog`'s `label`). They cannot be wrapped by the plain level-method machinery (which assumes the cluster starts at argument 0), nor passed straight through like the truly-inert other-methods. The causal console gives each a bespoke wrapper that preserves the leading argument, then sanitizes + error-extracts the remaining args (see the *makeCausalConsole* body section).

### §consoleOtherMethods — eleven pass-through methods (refreshed 2026-06-17)

The §consoleOtherMethods permit list (lines 119-138) now enumerates eleven pass-through methods (assert + timeLog having moved to `consoleSpecialMethods`). The 2026-06-17 refresh also concretized every previously-`undefined` severity to a level, so the element type is uniformly `[ConsoleProps, LogSeverity]`:

| Method | Severity | Signature |
|---|---|---|
| `clear` | `'info'` | `()` — *level is not well defined* |
| `count` | `'info'` | `(label?)` |
| `countReset` | `'info'` | `(label?)` — *level is not well defined* |
| `dir` | `'log'` | `(item, options?)` |
| `groupEnd` | `'log'` | `()` |
| `table` | `'log'` | `(tabularData, properties?)` |
| `time` | `'info'` | `(label?)` |
| `timeEnd` | `'info'` | `(label?)` |
| `profile` | `'info'` | `(label?)` Node Inspector / MDN / TypeScript |
| `profileEnd` | `'info'` | `(label?)` |
| `timeStamp` | `'info'` | `(label?)` |

The structural distinctions:

- **These are pass-through** — *insensitive to whether any argument is an error. All arguments can pass thru to baseConsole as is.* The causal console wraps them only to mediate, not to error-extract.
- **The five formerly-`undefined` entries** (`clear`, `countReset`, `profile`, `profileEnd`, `timeStamp`) are now severity `'info'`. For `clear` and `countReset` the source candidly annotates *level is not well defined* — `'info'` is the chosen default, not a claim of cross-platform consensus. The earlier `undefined`-means-pass-through-without-formatter-inspection reading no longer holds; pass-through is now determined by *list membership* (other vs level/special), not by a null severity.
- **`table`** is flagged as a partial-detection case: *In theory tabular data may be or contain an error. However, we currently do not detect these and may never.* Same admission as the §causal-console error-detection caveat from earlier — known limit; no promise of fix.

The §three Node-Inspector-only methods (`profile`, `profileEnd`, `timeStamp`) keep the comment *Node Inspector only, MDN, and TypeScript, but not whatwg* — *non-Whatwg* extensions that nevertheless appear in enough standards to warrant inclusion.

### §The `consoleMethodPermits` union — now three lists (refreshed 2026-06-17)

The §combined permit list (lines 140-144) now spreads all three lists:

```js
const consoleMethodPermits = freeze([
  ...consoleLevelMethods,
  ...consoleSpecialMethods,
  ...consoleOtherMethods,
]);
```

The §union is the *complete* set of methods this module knows how to wrap. Any console method *not* in this list is *omitted from wrapped consoles* — the wrapped console exposes only the permitted method names.

### §consoleOmittedProperties — the false-entries discipline

The §commented-out `consoleOmittedProperties` block (lines 146-176) is structurally significant:

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

The §opening `defineName` function (lines 35-75) supports named arrow functions:

```js
const defineName = (name, fn) => defineProperty(fn, 'name', { value: name });
```

The §comment names the use case:

> Explicitly set a function's name, supporting use of arrow functions for which source text doesn't include a name and no initial name is set by NamedEvaluation https://tc39.es/ecma262/multipage/syntax-directed-operations.html#sec-runtime-semantics-namedevaluation. Instead, we hope that tooling uses only the explicit `name` property.

The §rationale: arrow functions assigned to map-entries don't get implicit names; the wrapping code uses `defineName('debug', (...args) => ...)` to ensure the wrapped function carries the right name for tooling (debuggers, stack traces, error messages). The function is used throughout the file in the wrap-method constructions.

### §sanitizeFormatData — stripping `%c` styling specifiers (added 2026-06-17)

The 2026-06-17 refresh added a new exported function `sanitizeFormatData` (lines 203-277), the last declaration in the prelude before the *Logging Console* divider. It is exported *only for testing*; in production the causal console's level/assert/timeLog wrappers call it on their args before error-extraction.

```js
export const sanitizeFormatData = ([...formatData]) => {
  freeze(formatData);
  if (formatData.length <= 1) {
    return formatData;
  }
  const [fmt, ...args] = formatData;
  if (typeof fmt !== 'string' || !stringIncludes(fmt, '%')) {
    return formatData;
  }
  // ... scan fmt for `%`-specifiers, transferring segments + args ...
};
```

The §purpose (from the doc-comment):

> If `formatData` consists of `[fmt, ...args]` and `fmt` is a string containing a `%c` specifier that acts as an `%c` specifier according to https://console.spec.whatwg.org/#formatting-specifiers then omit it and its corresponding argument. For the rest of the `fmt` string and its corresponding arguments, return them as a replacement `formatData` to be fed to the underlying console log functions.

Why strip `%c`? It is the whatwg console *CSS-styling* specifier — in a browser devtools console it applies CSS to subsequent text; its consumed argument is a style string. On a non-browser base console (Node, a test logger) it would be rendered uselessly or even mishandled, so the causal console drops both the specifier and its style argument while preserving every other specifier and its argument.

The §scan walks `fmt` from each `%` and switches on the following character:

- **`s` / `d` / `i` / `f` / `o` / `O`** (recognized value specifiers): transfer the segment including `%`+char and *transfer one arg*.
- **`c`** (CSS styling): transfer the segment *up to but not including* `%c`, and *consume one arg without emitting it* — both the specifier and its style argument vanish.
- **`%`** (an escaped percent, `%%`): transfer the segment including `%%`; consume no arg. This is why a `%c` *inside* `%%c` does not act as a specifier — the `%%` is consumed first, leaving a literal `c`.
- **default** (any other char, e.g. Node's `%j`): rewrite it as an *escaped* `%%<char>` and consume no arg — *so that `%<unspecified>` is treated as unknown even if implemented by the local platform, such as `%j` on Node*. This deliberately neutralizes platform-specific specifiers that whatwg does not define.

Two careful edge conditions in the loop guard:

- The `percentPos < fmt.length - 1` bound *leaves room for one more character after the `%`*: a trailing bare `%` is not a specifier.
- The `argI < args.length` bound encodes the doc-comment's rule that *a `%c` beyond `args` does not act as a specifier* — once the args are exhausted, the remaining `fmt` is transferred verbatim.

After the loop, any leftover `fmt` tail and any leftover args are appended, and the result `[newFmt, ...newArgs]` is frozen. The §honest-comment on the switch — *the four cases in the following switch are purposely partially redundant ... Clarity sometimes wins over DRY* — is the same *clarity-over-DRY* discipline seen elsewhere in the SES error module.
