---
title: errorTaming Options
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

> Abstract: Controls Error.stack visibility and the Error constructor taming. Safe (default): hide error stacks from in-band code (routed to side tables for the causal console). Unsafe: preserve original error.stack access in-band. unsafe-debug: maintain in-band stack access for debugging while keeping other taming. This is the longest option section, with detailed discussion of stack-trace policy, redaction, and how the assert/console/error triple interacts.

## `errorTaming` Options

**Background**: The error system of JavaScript has several safety problems.
In most JavaScript engines running normal JavaScript, if `err` is an
Error instance, the expression `err.stack` will produce a string
revealing the stack trace. This is an
[overt information leak, a confidentiality
violation](https://papers.agoric.com/taxonomy-of-security-issues/).
This `stack` property reveals information about the call stack that violates
the encapsulation of the callers.

This `stack` is part of de facto JavaScript, is not yet part
of the official standard, and is proposed at
[Error Stacks proposal](https://github.com/tc39/proposal-error-stacks).
Because it is unsafe, we propose that the `stack` property be "normative
optional", meaning that a conforming implementation may omit it. Further,
if present, it should be present only as a deletable accessor property
inherited from `Error.prototype` so that it can be deleted. The actual
stack information would be available by other means, the `getStack` and
`getStackString` functions&mdash;special powers available only in the start
compartment&mdash;so the SES console can still operate as described above.

On v8&mdash;the JavaScript engine powering Chrome, Brave, and Node&mdash;the
default error behavior is much more dangerous. The v8 `Error` constructor
provides a set of
[static methods for accessing the raw stack
information](https://v8.dev/docs/stack-trace-api) that are used to create
error stack strings. Some of this information is consistent with the level
of disclosure provided by the proposed `getStack` special power above.
Some go well beyond it.

Neither the `'safe'` or `'unsafe'` settings of the `errorTaming`
affect the safety of the `Error`
constructor. In those cases, after calling `lockdown`, the tamed `Error`
constructor in the start compartment follows ocap rules.
Under v8 it emulates most of the
magic powers of the v8 `Error` constructor&mdash;those consistent with the
level of disclosure of the proposed `getStack`. In all cases, the `Error`
constructor shared by all other compartments is both safe and powerless.

See the [errors guide](errors.md) for an in depth explanation of
the relationship between errors, `assert` and the virtual `console`.

When running TypeScript tests on Node without SES,
you'll see accurate line numbers into the original TypeScript source.
However, with SES with the `'safe'` or `'unsafe'` settings of
`errorTaming` the stacks will show all TypeScript positions as line 1,
which is the one line of JavaScript the TypeScript compiled to.
We would like to fix this while preserving safety, but have not yet done so.

Instead, we introduce the `'unsafe-debug'` setting, which sacrifices
more security to restore this pleasant Node behavior.
Where `'safe'` and `'unsafe'` endangers only confidentiality, `'unsafe-debug'` also
endangers intergrity. For development and debugging purposes ***only***,
this is usually the right tradeoff. But please don't use this setting in a
production environment.

On non-v8 platforms, `'unsafe'` and `'unsafe-debug'` do the same thing, since
[the problem](https://github.com/endojs/endo/issues/1798) is specific to
Node on v8.

```js
lockdown(); // errorTaming defaults to 'safe'
// or
lockdown({ errorTaming: 'safe' }); // Deny unprivileged access to stacks, if possible
// vs
lockdown({ errorTaming: 'unsafe' }); // stacks also available by errorInstance.stack
// vs
lockdown({ errorTaming: 'unsafe-debug' }); // sacrifice more safety for source-mapped line numbers.
```

If `lockdown` does not receive an `errorTaming` option, it will respect
`process.env.LOCKDOWN_ERROR_TAMING`.

```console
LOCKDOWN_ERROR_TAMING=safe
LOCKDOWN_ERROR_TAMING=unsafe
```

The `errorTaming` default `'safe'` setting makes the stack trace inaccessible
from error instances alone, when possible. It currently does this only on
v8 (Chrome, Brave, Node). It will also do so on SpiderMonkey (Firefox).
Currently is it not possible for the SES-shim to hide it on other
engines, leaving this information leak available. Note that it is only an
information leak. It reveals the magic information only as a powerless
string. This leak threatens
[confidentiality but not integrity](https://papers.agoric.com/taxonomy-of-security-issues/).

Since the current JavaScript de facto reality is that the stack is only
available by saying `err.stack`, a number of development tools assume they
can find it there. When the information leak is tolerable, the `'unsafe'`
setting will preserve the filtered stack information on the `err.stack`.

Like hiding the stack, the purpose of the `details` template literal tag (often
spelled `X`) together with the `quote` function (often spelled `q`) is
to redact data from the error messages carried by error instances. The same
`{errorTaming: 'unsafe'}` suppresses that redaction as well, so that all
substitution values would act like they've been quoted. With this setting

```js
assert(false, X`literal part ${secretData} with ${q(publicData)}.`);
```

acts like

```js
assert(false, X`literal part ${q(secretData)} with ${q(publicData)}.`);
```

The `lockdown({ errorTaming: 'unsafe' })` call has this effect by replacing
the global `assert` object with one whose `assert.details` does not redact.
So be sure to sample `assert` and `assert.details` only after such a call to
lockdown:

```js
lockdown({ errorTaming: 'unsafe' });

// Grab `details` only after lockdown
const { details: X, quote: q } = assert;
```

Like with the stack, the SES shim `console` object always
shows the unredacted detailed error message independent of the setting of
`errorTaming`.

Examples from
[deep-send.test.js](https://github.com/endojs/endo/blob/master/packages/errors/test/deep-send.test.js)
of the eventual-send shim:

<details>
  <summary>Expand for { errorTaming: 'safe' } log output</summary>

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
  <summary>Expand for { errorTaming: 'unsafe' } log output</summary>

    THROWN to top of event loop (Error#1)
      ✔ deep-send demo test
        ℹ possibly redacted message: "blue" is not 42
        ℹ possibly redacted stack: "Error: \"blue\" is not 42\n  at Object.bar (packages/errors/test/deep-send.test.js:22:18)"
        ℹ expected failure: Error {
            message: '"blue" is not 42',
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


Source: [docs/lockdown.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/lockdown.md) at commit `fe81477b`.
