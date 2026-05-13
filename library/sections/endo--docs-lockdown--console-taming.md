---
title: consoleTaming Options
source: docs/lockdown.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-13
ingested_by: scholar
topics: [hardened-javascript, errors]
status: current
---

> Abstract: Controls whether the global console is virtualized during lockdown. Safe (default): replace with a tamed console that has a special relationship with errors and the assert package, revealing redacted details to the original console without exposing them to in-band code. Unsafe: leave the platform console in place; combine with overrideTaming: 'min' until issue #636 is fixed. Examples show the deep-stack-style log output under each setting.

## `consoleTaming` Options

**Background**: Most JavaScript environments provide a `console` object on the
global object with interesting information hiding properties. JavaScript code
can use the `console` to send information to the console's logging output, but
cannot see that output. The `console` is a *write-only device*. The logging
output is normally placed where a human programmer, who is in a controlling
position over that computation, can see the output. This output is, accordingly,
formatted mostly for human consumption; typically for diagnosing problems.

Given these constraints, it is both safe and helpful for the `console` to reveal
to the human programmer information that it would not reveal to the objects it
interacts with. SES amplifies this special relationship to reveal
to the programmer much more information than would be revealed by the normal
`console`. To do so, by default during `lockdown` SES virtualizes the builtin
`console`, by replacing it with a wrapper. The wrapper is a virtual `console`
that implements the standard `console` API mostly by forwarding to the original
wrapped `console`.
In addition, the virtual `console` has a special relationship with
error objects and with the SES `assert` package, so that errors can report yet
more diagnostic information that should remain hidden from other objects. See
the [errors](errors.md) for an in depth explanation of this
relationship between errors, `assert` and the virtual `console`.

```js
lockdown(); // consoleTaming defaults to 'safe'
// or
lockdown({ consoleTaming: 'safe' }); // Wrap start console to show deep stacks
// vs
lockdown({ consoleTaming: 'unsafe' }); // Leave original start console in place
// or
lockdown({
  consoleTaming: 'unsafe', // Leave original start console in place
  overrideTaming: 'min', // Until https://github.com/endojs/endo/issues/636
});
```

If `lockdown` does not receive a `consoleTaming` option, it will respect
`process.env.LOCKDOWN_CONSOLE_TAMING`.

```console
LOCKDOWN_CONSOLE_TAMING=safe
LOCKDOWN_CONSOLE_TAMING=unsafe
```

The `consoleTaming: 'safe'` setting replaces the global console with a tamed
console, and that tamed console is safe to endow to a guest `Compartment`.
Additionally, any errors created with the `assert` function or methods on its
namespace may have [redacted details](./errors.md): information
included in the error message that is informative to a debugger and made
invisible to an attacker.
The tamed console removes redactions and shows these details to the original
console.

The `consoleTaming: 'unsafe'` setting leaves the original console in place.
The `assert` package and error objects will continue to work, but the `console`
logging output will not show any of this extra information.

The risk is that the original platform-provided `console` object often has
additional methods beyond the de facto `console` "standards" and may be unsafe
to endow to a guest `Compartment`.
Under the `'unsafe'` setting we do not remove them.
We do not know whether any of these additional methods violate ocap security.
Until we know otherwise, we should assume these are unsafe. Such a raw
`console` object should only be handled by very trustworthy code.

Until the bug
[Node console gets confused if .constructor is an accessor (#636)](https://github.com/endojs/endo/issues/636)
is fixed, if you use the `consoleTaming: 'unsafe'` setting and might be running
with the Node `console`, we advise you to also set `overrideTaming: 'min'` so
that no builtin `constructor` properties are turned into accessors.

Examples from
[deep-send.test.js](https://github.com/endojs/endo/blob/master/packages/errors/test/deep-send.test.js)
of the eventual-send shim:

<details>
  <summary>Expand for { consoleTaming: 'safe' } log output</summary>

    THROWN to top of event loop (Error#1)
        ✔ deep-send demo test
          ℹ possibly redacted message: "blue" is not (a number)
          ℹ possibly redacted stack: ""
          ℹ expected failure: Error {
              message: '"blue" is not (a number)',
            }
      Error#1: blue is not 42

        at Object.bar (packages/errors/test/deep-send.test.js:22:18)

      Error#1 ERROR_NOTE: Thrown from: (Error#2) : 2 . 0
      Nested error under Error#1
        Error#2: Event: 1.1

          at Object.foo (packages/errors/test/deep-send.test.js:26:28)

        Error#2 ERROR_NOTE: Caused by: (Error#3)
        Nested error under Error#2
          Error#3: Event: 0.1

            at Object.test (packages/errors/test/deep-send.test.js:30:22)
            at packages/errors/test/deep-send.test.js:37:13
</details>

<details>
  <summary>Expand for { consoleTaming: 'unsafe' } log output</summary>

    THROWN to top of event loop [Error: "blue" is not (a number)]
      ✔ deep-send demo test
        ℹ possibly redacted message: "blue" is not (a number)
        ℹ possibly redacted stack: ""
        ℹ expected failure: Error {
            message: '"blue" is not (a number)',
          }
</details>


Source: [docs/lockdown.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/lockdown.md) at commit `fe81477b`.
