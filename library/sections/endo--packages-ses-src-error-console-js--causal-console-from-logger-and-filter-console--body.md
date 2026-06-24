---
title: Body
source: packages/ses/src/error/console.js
source_repo: endojs/endo
source_branch: master
source_commit: e02b0f66eb44306c3d739e1670114ef24d4202fa
source_date: 2025-01-02
source_authors: [Mark S. Miller]
source_lines: "417-541 (defineCausalConsoleFromLogger + indentAfterAllSeps kludge + filterConsole)"
topics: [hardened-javascript, errors, testing]
status: current
parent: endo--packages-ses-src-error-console-js--causal-console-from-logger-and-filter-console
---

### §defineCausalConsoleFromLogger — adapting a single-function logger

The §subsection (lines 446-513) constructs a causal console atop a *single-function logger*:

```js
export const defineCausalConsoleFromLogger = loggedErrorHandler => {
  const makeCausalConsoleFromLogger = tlogger => {
    const indents = [];
    const logWithIndent = (...args) => {
      if (indents.length > 0) {
        args = arrayFlatMap(args, arg =>
          typeof arg === 'string' && stringIncludes(arg, '\n')
            ? indentAfterAllSeps(arg, '\n', indents)
            : [arg],
        );
        args = [...indents, ...args];
      }
      return tlogger(...args);
    };

    const baseConsole = fromEntries([
      ...arrayMap(consoleLevelMethods, ([name]) => [
        name,
        defineName(name, (...args) => logWithIndent(...args)),
      ]),
      ...arrayMap(consoleOtherMethods, ([name]) => [
        name,
        defineName(name, (...args) => logWithIndent(name, ...args)),
      ]),
    ]);
    // ... group/groupCollapsed/groupEnd handling ...
    const causalConsole = makeCausalConsole(baseConsole, loggedErrorHandler);
    return causalConsole;
  };
  return freeze(makeCausalConsoleFromLogger);
};
```

The §comment on the `makeCausalConsoleFromLogger` function names the motivating use case:

> Implement the `VirtualConsole` API badly by turning all calls into calls on `tlogger`. We need to do this to have `console` logging turn into calls to Ava's `t.log`, so these console log messages are output in the right place.

The §badly-implement-on-purpose discipline: the AVA-test-runtime's `t.log` is a single function that takes `...args` and emits to AVA's test output. SES's causal console wants to emit *its* structured output via this single function. The adapter wraps `tlogger` as a fake baseConsole with all the level-methods + other-methods routed to `tlogger`.

#### §The level-vs-other-method delegation

The §two-table construction:

- **Level methods** (`debug`/`log`/`info`/`warn`/`error`/`trace`/etc.) get wrapped as `(...args) => logWithIndent(...args)` — *no method name prefix*. The reasoning: AVA's `t.log` doesn't care which severity the original call had; all calls become test-output regardless of level.
- **Other methods** (`assert`/`timeLog`/`clear`/`dir`/etc.) get wrapped as `(...args) => logWithIndent(name, ...args)` — *with the method name as the first arg*. The reasoning: an other-method call like `console.assert(false, 'bad')` shouldn't lose its `assert`-ness; the method name appears as a string in the output so the reader can tell `assert false: bad` from `log: bad`.

The §asymmetry reflects *what information matters*: severities are de-facto erased into a unified log; method names of non-severity methods are preserved in the output.

### §The indent-stack management

The §closing block (lines 481-503) handles the group / groupCollapsed / groupEnd trio:

```js
for (const name of ['group', 'groupCollapsed']) {
  if (baseConsole[name]) {
    baseConsole[name] = defineName(name, (...args) => {
      if (args.length >= 1) {
        logWithIndent(...args);
      }
      arrayPush(indents, ' ');
    });
  } else {
    baseConsole[name] = defineName(name, () => {});
  }
}
baseConsole.groupEnd = defineName(
  'groupEnd',
  baseConsole.groupEnd
    ? (...args) => {
        arrayPop(indents);
      }
    : () => {},
);
harden(baseConsole);
```

The §structural reading:

- **`group(...args)` / `groupCollapsed(...args)`** push a `' '` (single space) onto the `indents` array. If args are passed, the group's label is logged first (with the *current* indent, not the about-to-be-pushed indent).
- **`groupEnd()`** pops one entry from `indents`.
- **Empty-args group special case**: if `group()` is called with no args, *only* the indent is pushed; nothing is emitted to the logger. The comment notes: *A single space is enough; the host console will separate them with additional spaces.*

The §indent-stack is a *string-prepending* mechanism. Each call to `logWithIndent` prepends `indents` to its args; the spaces accumulate as groups are entered. When `groupEnd` runs, the indent shrinks again.

### §The *horrible kludge* indentAfterAllSeps

The §indentAfterAllSeps function (lines 437-441) is the file's most candid acknowledgment of *temporary-workaround-with-TODO*:

```js
const indentAfterAllSeps = (str, sep, indents) => {
  const [firstLine, ...restLines] = stringSplit(str, sep);
  const indentedRest = arrayFlatMap(restLines, line => [sep, ...indents, line]);
  return ['', firstLine, ...indentedRest];
};
```

The §multi-paragraph comment (lines 421-436):

> This is a rather horrible kludge to indent the output to a logger in the case where some arguments are strings containing newlines. Part of the problem is that console-like loggers, including the one in ava, join the string arguments of the log message with a space. Because of this, there's an extra space at the beginning of each of the split lines. So this kludge compensated by putting an extra empty string at the beginning, so that the logger will add the same extra joiner.
> TODO: Fix this horrible kludge, and indent in a sane manner.

The §problem-statement structure:

1. **AVA's `t.log` joins string args with a space**.
2. **Multi-line strings (`\n`-containing)** need each line to be indented — but the joiner-space gets added to each split line too.
3. **The kludge**: split the string at `\n`; insert the indents between each line; *also* add an empty-string prefix-trick so the joiner adds the same extra space at the *beginning* of each line as the natural-joiner would.

The §rendering:

```
Input: "first\nsecond\nthird", indents = [' ']
Split: ['first', 'second', 'third']
First line: 'first' (no indent prefix; that comes from logWithIndent's args)
Rest lines, each prefixed with [sep, ...indents, line]:
  ['\n', ' ', 'second']
  ['\n', ' ', 'third']
Full output via flatMap:
  ['', 'first', '\n', ' ', 'second', '\n', ' ', 'third']
After t.log joins with spaces:
  ' first \n   second \n   third'  // each line begins with two spaces; second/third have an extra space from the joiner
```

The §candor-with-TODO is the *honest-workaround-with-future-work* discipline. The implementer admits the kludge is *horrible*, names *why* it exists (AVA's joining behavior), and explicitly invites a future fix.

### §filterConsole — severity-gated method dispatch

The §closing function (lines 518-541) constructs a *filtering* console:

```js
export const filterConsole = (baseConsole, filter, _topic = undefined) => {
  // TODO do something with optional topic string
  const methodPermits = arrayFilter(
    consoleMethodPermits,
    ([name, _]) => name in baseConsole,
  );
  const methods = arrayMap(methodPermits, ([name, severity]) => {
    const method = defineName(name, (...args) => {
      if (severity === undefined || filter.canLog(severity)) {
        baseConsole[name](...args);
      }
    });
    return [name, freeze(method)];
  });
  const filteringConsole = fromEntries(methods);
  return freeze(filteringConsole);
};
```

The §filter discipline:

- **Methods whose severity is `undefined`** (per the consoleOtherMethods table: `clear`, `countReset`, `profile`, `profileEnd`, `timeStamp`) pass through *unconditionally*. There's no severity to gate on.
- **Methods with a severity** are gated through `filter.canLog(severity)`. If the filter says *no, can't log this severity*, the call is dropped.

The §pattern lets *applications choose a severity threshold*: a production deployment might want only `'warn'` and `'error'`; a test environment might want everything; a debug session might want `'debug'` and up. The filter is a *capability* — a `canLog(severity) => boolean` function — that the application provides.

The §`_topic` parameter is a *TODO* future-work surface:

> TODO do something with optional topic string

The §topic is *anticipated* (the parameter is in the signature) but *not yet implemented*. A future enhancement could route calls to topic-specific filters or destinations.

### §The structural relationship between the three console wrappers

The §three wrappers in this file:

| Function | Wraps | Produces | Use case |
|---|---|---|---|
| `makeLoggingConsoleKit` (§2) | nothing | `loggingConsole` + `takeLog` | Capture-then-replay; test infrastructure. |
| `makeCausalConsole` (§2) | a `baseConsole` | a causal console | The error-aware wrapper; the SES-internal default. |
| `defineCausalConsoleFromLogger` (this section) | a single-function logger | a causal console | AVA `t.log` adapter. |
| `pumpLogToConsole` (§2) | replays log entries onto a baseConsole | nothing | Test fail-replay. |
| `filterConsole` (this section) | a baseConsole + a filter | a filtering console | Severity-gating. |

The §three-wrapper architecture is *composable*: a test might use `makeLoggingConsoleKit` to capture, `pumpLogToConsole` to replay on `filterConsole(realConsole, { canLog: s => s !== 'debug' })` for severity-gated playback. Each wrapper does one job; composition lets them stack.
