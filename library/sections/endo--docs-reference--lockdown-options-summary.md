---
title: lockdown Options (summary)
source: docs/reference.md
source_repo: endojs/endo
source_commit: bffadcab8a39be8529406b22574e25cf64dec755
source_date: 2026-04-26
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript]
status: current
notes: Overlaps with docs/lockdown.md sections (endo--docs-lockdown--regexp-taming, endo--docs-lockdown--locale-taming, endo--docs-lockdown--console-taming, endo--docs-lockdown--error-taming, endo--docs-lockdown--stack-filtering, endo--docs-lockdown--override-taming). Treat docs/lockdown.md as canonical for full detail; this section is the reference-shaped summary.
---

> Abstract: A summary of the lockdown options: default-safe settings table, a quick reference table, and per-option detail for regExpTaming, localeTaming, consoleTaming, errorTaming, stackFiltering, overrideTaming. Overlaps with docs/lockdown.md's per-option H2 sections. The reference here is shorter and reference-shaped; docs/lockdown.md has the full background, examples, and rationale per option.

## `lockdown` Options

### Default `'safe'` settings

All three of these safety-relevant options default to `'safe'` if omitted
from a call to `lockdown()`. Their other possible value is `'unsafe'`.
- `regExpTaming`
- `localeTaming`
- `consoleTaming`

In addition, `errorTaming` defaults to `'safe'` but can be set to `'unsafe'`
or `'unsafe-debug'`, as explained at
[`errorTaming` Options](./lockdown.md#errortaming-options).
- `errorTaming`

The tradeoff is safety vs compatibility with existing code. However, much legacy
JavaScript code does run under HardenedJS, even if both not written to
do so and with all the options set to `'safe'`. Only consider an `'unsafe'`
value if you both need it and can evaluate its risks.

### Options quick reference

This section provides a quick usage reference for `lockdown()`'s options, their possible
values, and their usage. Each is described in more detail in their individual sections
below.

<table>
  <tbody>
  <tr>
    <td><center><b>Option</b></center></td>
    <td><center><b>Values</b></center></td>
    <td><center><b>Functionality</b></center></td>
  </tr>
  <tr>
    <td><code>regExpTaming</code></td>
    <td><code>'safe'</code> (default) or <code>'unsafe'</code></td>
    <td><code>'safe'</code> disables all <code>RegExp.*</code> methods,<br>
        <code>'unsafe'</code> disables all but <code>RegExp.prototype.compile()</code></td>
  </tr>
    <tr>
    <td><code>localeTaming</code></td>
    <td><code>'safe'</code> (default) or <code>'unsafe'</code></td>
    <td><code>'safe'</code> aliases <code>toLocaleString()</code> to <code>toString()</code>, etc.,<br>
        <code>'unsafe'</code> keeps JavaScript locale methods as is</td>
  </tr>
  <tr>
    <td><code>consoleTaming</code></td>
    <td><code>'safe'</code> (default) or <code>'unsafe'</code></td>
    <td><code>'safe'</code> wraps start console to show deep stacks,<br>
        <code>'unsafe'</code> uses the original start console.</td>
  </tr>
  <tr>
    <td><code>errorTaming</code></td>
    <td><code>'safe'</code> (default) or <code>'unsafe'</code> or <code>'unsafe-debug'</code></td>
    <td><code>'safe'</code> denies unprivileged stacks access,<br>
        <code>'unsafe'</code> makes stacks also available by <code>errorInstance.stack</code>,<br>
        <code>'unsafe-debug'</code> sacrifices more safety for better TypeScript line-numbers.</td>
  </tr>
  <tr>
    <td><code>stackFiltering</code></td>
    <td><code>'concise'</code> (default) or <code>'omit-frames'</code>  or <code>'shorten-paths'</code> or <code>'verbose'</code></td>
    <td><code>'concise'</code> preserves important deep stack info, omitting likely unimportant frames and shortening paths<br>
        <code>'omit-frames'</code> omits likely unimportant frames<br>
        <code>'shorten-paths'</code> shortens paths to text likely clickable in an IDE<br>
        <code>'verbose'</code> console shows full deep stacks</td>
  </tr>
  <tr>
    <td><code>overrideTaming</code></td>
    <td><code>'moderate'</code> (default) or <code>'min'</code> or <code>'severe'</code></td>
    <td><code>'moderate'</code> moderates mitigations for legacy compatibility,<br>
        <code>'min'</code> minimal mitigations for purely modern code, <br>
        <code>'severe'</code> when moderate mitigations are inadequate</td>
  </tr>
  </tbody>
</table>

### `regExpTaming` Option

With its default `'safe'` value, regExpTaming prevents using `RegExp.*()` methods in the locked down code.

With its `'unsafe'` value, `RegExp.prototype.compile()` can be used in locked down code.
All other `RegExp.*()` methods are disabled.

```js
lockdown(); // regExpTaming defaults to 'safe'
// or
lockdown({ regExpTaming: 'safe' }); // Disables all RegExp.*() methods.
// vs
lockdown({ regExpTaming: 'unsafe' }); // Disables all RegExp.*() methods except RegExp.prototype.compile()
```

### `localeTaming` Option

The default `'safe'` setting replaces each method listed below with their
corresponding non-locale-specific method. For example, `Object.prototype.toLocaleString()`
becomes another name for `Object.prototype.toString()`.
- `toLocaleString`
- `toLocaleDateString`
- `toLocaleTimeString`
- `toLocaleLowerCase`
- `toLocaleUpperCase`
- `localeCompare`

The `'unsafe'` setting keeps the original behavior for compatibility at the price
of reproducibility and fingerprinting.

```js
lockdown(); // localeTaming defaults to 'safe'
// or
lockdown({ localeTaming: 'safe' }); // Alias toLocaleString to toString, etc
// vs
lockdown({ localeTaming: 'unsafe' }); // Allow locale-specific behavior
```

### `consoleTaming` Options

The default `'safe'` option actually expands what you would expect from `console`'s logging
output. It will show information from the `assert` package and error objects.
Errors can report more diagnostic information that should be hidden from other objects. See
[errors](errors.md)
for an in depth explanation of this.

The `'unsafe'` setting leaves the original `console` in place. The `assert` package
and error objects continue to work, but the `console` logging output will not
show this extra information. `'unsafe'` does **not** remove any additional `console`
methods beyond its de facto "standards". Since we do not know if these
methods violate OCap security, we should assume they are unsafe. A raw `console`
object should only be handled by very trustworthy code.

```js
lockdown(); // consoleTaming defaults to 'safe'
// or
lockdown({ consoleTaming: 'safe' }); // Wrap start console to show deep stacks
// vs
lockdown({ consoleTaming: 'unsafe' }); // Leave original start console in place
```

### `errorTaming` Options

The `errorTaming` default `'safe'` setting makes the stack trace inaccessible
from error instances alone. It does this on v8 engines (Chrome, Brave, Node).
Note that it is **not** hidden on other engines, leaving an information
leak available. It reveals information only as a powerless string.

In JavaScript the stack is only available via `err.stack`, so some
development tools assume it is there. When the information leak is tolerable,
the `'unsafe'` setting preserves `err.stack`'s filtered stack information.

The `'safe'` or `'unsafe'` settings of `errorTaming` do not affect the `Error`
constructor's safety, beyond the confidentiality hazards mentioned above.
After calling `lockdown`, the tamed `Error` constructor in the
start compartment follows OCap rules. Under v8 it emulates most of the
magic powers of the v8 `Error` constructor&mdash;those consistent with the
discourse level of the proposed `getStack`. In all cases, the `Error`
constructor shared by all other compartments is both safe and powerless.

However, with the `'safe'` and `'unsafe'` settings, you'll often see
line-numbers into TypeScript sources are always 1, since the TypeScript compiler
compiles into a single line of JavaScript. For TypeScript on Node on v8,
the setting `'unsafe-debug'` sacrifices more security to restore the
normal Node behavior of providing accurate positions into the TypeScript source.
The `'unsafe-debug'` setting should be used ***for development only***, when
this is usually the right tradeoff. Please do not use it in production.

```js
lockdown(); // errorTaming defaults to 'safe'
// or
lockdown({ errorTaming: 'safe' }); // Deny unprivileged access to stacks, if possible
// vs
lockdown({ errorTaming: 'unsafe' }); // Stacks also available by errorInstance.stack
// vs
lockdown({ errorTaming: 'unsafe-debug' }); // sacrifice more safety for source-mapped line numbers.
```

### `stackFiltering` Options

`stackFiltering` trades off stronger stack traceback filtering to
minimize distractions vs completeness for tracking down bugs in
obscure places.

The default `'concise'` setting removes "noise" from the full distributed
stack traces, in particularly artifacts from low level infrastructure. It
only works on v8 engines.

With the `'verbose'` setting, the `console` displays the full raw stack
information for each level of the "deep stack", tracing back through the
[eventually sent messages](https://github.com/tc39/proposal-eventual-send)
from other turns of the event loop. This makes JavaScript's already voluminous
error stacks even more so. However, this is sometimes useful for finding bugs
in low level infrastructure.

Both settings are safe. Stack information will
or will not be available from error objects according to the `errorTaming`
option and the platform error behavior.

```js
lockdown(); // stackFiltering defaults to 'concise'
// or
lockdown({ stackFiltering: 'concise' }); // Preserve important deep stack info, omitting likely unimportant frames and shortening paths
// vs
lockdown({ stackFiltering: 'omit-frames' }); // Omit likely uninteresting frames
// vs
lockdown({ stackFiltering: 'shorten-paths' }); // Shorten paths to text likely clickable in an IDE
// vs
lockdown({ stackFiltering: 'verbose' }); // Console shows full deep stacks
```

See [`stackFiltering` Options](./lockdown.md#stackfiltering-options) for more.

### `overrideTaming` Options

The `overrideTaming` option trades off better code
compatibility vs better tool compatibility.

When starting a project, we recommend using the non-default `'min'` option to make
debugging more pleasant. You may need to reset it to the `'moderate'` default if
third-party shimming code interferes with `lockdown()`.

`'moderate'` option is intended to be fairly minimal. Expand it when you
encounter code which should run under HardenedJS but can't due to
the [override mistake](https://web.archive.org/web/20141230041441/http://wiki.ecmascript.org/doku.php?id=strawman:fixing_override_mistake),

The `'min'` setting serves two purposes:
- It enables a pleasant VSCode debugging experience.
- It helps ensure new code does not depend on anything more than enabled legacy code.

All Agoric-authored code is compatible with both settings, but
Agoric currently still pulls in some third party dependencies only compatible
with the `'moderate'` setting.

 ```js
lockdown(); // overrideTaming defaults to 'moderate'
// or
lockdown({ overrideTaming: 'moderate' }); // Moderate mitigations for legacy compat
// vs
lockdown({ overrideTaming: 'min' }); // Minimal mitigations for purely modern code
```

Source: [docs/reference.md](https://github.com/endojs/endo/blob/bffadcab8a39be8529406b22574e25cf64dec755/docs/reference.md) at commit `bffadcab`.
