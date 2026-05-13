---
title: stackFiltering Options
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

> Abstract: Controls signal-to-noise filtering of stack traces in the causal console. Default: concise (omit frames from SES infrastructure to reduce noise). Options: omit-frames, shorten-paths, verbose (show everything). The longest option section, with detailed discussion of which frames are noise versus signal, how the filtering interacts with source-map resolution, and the trade-off between debugging completeness and visual focus.

## `stackFiltering` Options

**Background**: The error stacks shown by many JavaScript engines are
voluminous.
They contain many stack frames of functions in the infrastructure, that is
usually irrelevant to the programmer trying to diagnose a bug. The SES-shim's
`console`, under the default `consoleTaming` option of `'safe'`, is even more
voluminous&mdash;displaying "deep stack" traces, tracing back through the
[eventually sent messages](https://github.com/tc39/proposal-eventual-send)
from other turns of the event loop. (Eventually we hope these deep
stacks will even cross vat/process and machine boundaries, to help debug
distributed bugs, as in [Causeway](https://github.com/cocoonfx/causeway).)

```js
lockdown(); // stackFiltering defaults to 'concise'
// or
lockdown({ stackFiltering: 'concise' }); // Preserve important deep stack info. Omit likely uninteresting frames. Shorten paths to likely clickable strings in an IDE
// vs
lockdown({ stackFiltering: 'omit-frames' }); // Only omit likely uninteresting frames. Preserve original paths
// vs
lockdown({ stackFiltering: 'shorten-paths' }); // Preserve original frames. shorten their paths to likely clickable strings in an IDE.
// vs
lockdown({ stackFiltering: 'verbose' }); // Console shows full deep stacks
```

If `lockdown` does not receive a `stackFiltering` option, it will respect
`process.env.LOCKDOWN_STACK_FILTERING`.

```console
LOCKDOWN_STACK_FILTERING=concise
LOCKDOWN_STACK_FILTERING=omit-frames
LOCKDOWN_STACK_FILTERING=shorten-paths
LOCKDOWN_STACK_FILTERING=verbose
```

When looking at deep stacks, in order to debug asynchronous
computation, seeing the full stacks is overwhelmingly noisy. The error stack
proposal leaves it to the host what stack trace info to show. SES virtualizes
elements of the host. With this freedom in mind, under the `concise` setting,
the SES-shim
filters and transforms the stack trace information it shows to be more useful,
by removing information that is more an artifact of low level infrastructure.
The SES-shim currently does so only on v8.

However, sometimes your bug might be in that infrastrusture, in which case
that information is no longer an extraneous distraction. Sometimes the noise
you filter out actually contains the signal you're looking for. The
`'verbose'` setting shows, on the console, the full raw stack information
for each level of the deep stacks.
Any setting of `stackFiltering` is safe. Stack information will
or will not be available from error objects according to the `errorTaming`
option and the platform error behavior.

Examples from
[deep-send.test.js](https://github.com/endojs/endo/blob/master/packages/errors/test/deep-send.test.js)
of the eventual-send shim:
<details>
  <summary>Expand for { stackFiltering: 'concise' } log output</summary>

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

          at Object.foo (packages/errors/test/deep-send.test.js:26:30)

        Error#2 ERROR_NOTE: Caused by: (Error#3)
        Nested error under Error#2
          Error#3: Event: 0.1

            at Object.test (packages/errors/test/deep-send.test.js:30:22)
            at packages/errors/test/deep-send.test.js:37:13
</details>

<details>
  <summary>Expand for { stackFiltering: 'omit-frames' } log output</summary>

      THROWN to top of event loop (Error#1)
        ✔ deep-send demo test
          ℹ possibly redacted message: "blue" is not (a number)
          ℹ possibly redacted stack: ""
          ℹ expected failure: Error {
              message: '"blue" is not (a number)',
            }
      Error#1: blue is not 42

        at Object.bar (file:///Users/markmiller/src/ongithub/endojs/endo/packages/errors/test/deep-send.test.js:22:18)

      Error#1 ERROR_NOTE: Thrown from: (Error#2) : 2 . 0
      Nested error under Error#1
        Error#2: Event: 1.1

          at Object.foo (file:///Users/markmiller/src/ongithub/endojs/endo/packages/errors/test/deep-send.test.js:26:30)

        Error#2 ERROR_NOTE: Caused by: (Error#3)
        Nested error under Error#2
          Error#3: Event: 0.1

            at Object.test (file:///Users/markmiller/src/ongithub/endojs/endo/packages/errors/test/deep-send.test.js:30:22)
            at file:///Users/markmiller/src/ongithub/endojs/endo/packages/errors/test/deep-send.test.js:37:13
</details>

<details>
  <summary>Expand for { stackFiltering: 'shorten-paths' } log output</summary>

      THROWN to top of event loop (Error#1)
        ✔ deep-send demo test
          ℹ possibly redacted message: "blue" is not (a number)
          ℹ possibly redacted stack: ""
          ℹ expected failure: Error {
              message: '"blue" is not (a number)',
            }
      Error#1: blue is not 42

        at makeError (packages/ses/src/error/assert.js:350:61)
        at fail (packages/ses/src/error/assert.js:482:20)
        at Fail (packages/ses/src/error/assert.js:492:39)
        at Object.bar (packages/errors/test/deep-send.test.js:22:18)
        at localApplyMethod (packages/eventual-send/src/local.js:134:18)
        at Object.applyMethod (packages/eventual-send/src/handled-promise.js:463:16)
        at dispatchToHandler (packages/eventual-send/src/handled-promise.js:159:22)
        at doDispatch (packages/eventual-send/src/handled-promise.js:494:7)
        at packages/eventual-send/src/track-turns.js:56:18
        at win (packages/eventual-send/src/handled-promise.js:514:26)
        at packages/eventual-send/src/handled-promise.js:533:20
        at process.processTicksAndRejections (node:internal/process/task_queues:105:5)

      Error#1 ERROR_NOTE: Thrown from: (Error#2) : 2 . 0
      Nested error under Error#1
        Error#2: Event: 1.1

          at trackTurns (packages/eventual-send/src/track-turns.js:100:24)
          at handle (packages/eventual-send/src/handled-promise.js:503:33)
          at Function.applyMethod (packages/eventual-send/src/handled-promise.js:426:14)
          at Proxy.bar (packages/eventual-send/src/E.js:76:35)
          at Object.foo (packages/errors/test/deep-send.test.js:26:30)
          at localApplyMethod (packages/eventual-send/src/local.js:134:18)
          at Object.applyMethod (packages/eventual-send/src/handled-promise.js:463:16)
          at dispatchToHandler (packages/eventual-send/src/handled-promise.js:159:22)
          at doDispatch (packages/eventual-send/src/handled-promise.js:494:7)
          at packages/eventual-send/src/track-turns.js:56:18
          at win (packages/eventual-send/src/handled-promise.js:514:26)
          at packages/eventual-send/src/handled-promise.js:533:20
          at process.processTicksAndRejections (node:internal/process/task_queues:105:5)

        Error#2 ERROR_NOTE: Caused by: (Error#3)
        Nested error under Error#2
          Error#3: Event: 0.1

            at trackTurns (packages/eventual-send/src/track-turns.js:100:24)
            at handle (packages/eventual-send/src/handled-promise.js:503:33)
            at Function.applyMethod (packages/eventual-send/src/handled-promise.js:426:14)
            at Proxy.foo (packages/eventual-send/src/E.js:76:35)
            at Object.test (packages/errors/test/deep-send.test.js:30:22)
            at __HIDE_goAskAlice (packages/errors/test/deep-send.test.js:33:32)
            at packages/errors/test/deep-send.test.js:37:13
            at Test.callFn (file:///Users/markmiller/src/ongithub/endojs/endo/node_modules/ava/lib/test.js:525:26)
            at Test.run (file:///Users/markmiller/src/ongithub/endojs/endo/node_modules/ava/lib/test.js:534:33)
            at Runner.runSingle (file:///Users/markmiller/src/ongithub/endojs/endo/node_modules/ava/lib/runner.js:280:33)
            at Runner.runTest (file:///Users/markmiller/src/ongithub/endojs/endo/node_modules/ava/lib/runner.js:362:30)
            at process.processTicksAndRejections (node:internal/process/task_queues:105:5)
            at async Promise.all (index 0)
            at async file:///Users/markmiller/src/ongithub/endojs/endo/node_modules/ava/lib/runner.js:515:21
            at async Runner.start (file:///Users/markmiller/src/ongithub/endojs/endo/node_modules/ava/lib/runner.js:523:15)
</details>

<details>
  <summary>Expand for { stackFiltering: 'verbose' } log output</summary>

      THROWN to top of event loop (Error#1)
        ✔ deep-send demo test
          ℹ possibly redacted message: "blue" is not (a number)
          ℹ possibly redacted stack: ""
          ℹ expected failure Error {
              message: '"blue" is not (a number)',
            }
      Error#1: blue is not 42

        at makeError (file:///Users/markmiller/src/ongithub/endojs/endo/packages/ses/src/error/assert.js:350:61)
        at fail (file:///Users/markmiller/src/ongithub/endojs/endo/packages/ses/src/error/assert.js:482:20)
        at Fail (file:///Users/markmiller/src/ongithub/endojs/endo/packages/ses/src/error/assert.js:492:39)
        at Object.bar (file:///Users/markmiller/src/ongithub/endojs/endo/packages/errors/test/deep-send.test.js:22:18)
        at localApplyMethod (file:///Users/markmiller/src/ongithub/endojs/endo/packages/eventual-send/src/local.js:134:18)
        at Object.applyMethod (file:///Users/markmiller/src/ongithub/endojs/endo/packages/eventual-send/src/handled-promise.js:463:16)
        at dispatchToHandler (file:///Users/markmiller/src/ongithub/endojs/endo/packages/eventual-send/src/handled-promise.js:159:22)
        at doDispatch (file:///Users/markmiller/src/ongithub/endojs/endo/packages/eventual-send/src/handled-promise.js:494:7)
        at file:///Users/markmiller/src/ongithub/endojs/endo/packages/eventual-send/src/track-turns.js:56:18
        at win (file:///Users/markmiller/src/ongithub/endojs/endo/packages/eventual-send/src/handled-promise.js:514:26)
        at file:///Users/markmiller/src/ongithub/endojs/endo/packages/eventual-send/src/handled-promise.js:533:20
        at process.processTicksAndRejections (node:internal/process/task_queues:105:5)

      Error#1 ERROR_NOTE: Thrown from: (Error#2) : 2 . 0
      Nested error under Error#1
        Error#2: Event: 1.1

          at trackTurns (file:///Users/markmiller/src/ongithub/endojs/endo/packages/eventual-send/src/track-turns.js:100:24)
          at handle (file:///Users/markmiller/src/ongithub/endojs/endo/packages/eventual-send/src/handled-promise.js:503:33)
          at Function.applyMethod (file:///Users/markmiller/src/ongithub/endojs/endo/packages/eventual-send/src/handled-promise.js:426:14)
          at Proxy.bar (file:///Users/markmiller/src/ongithub/endojs/endo/packages/eventual-send/src/E.js:76:35)
          at Object.foo (file:///Users/markmiller/src/ongithub/endojs/endo/packages/errors/test/deep-send.test.js:26:30)
          at localApplyMethod (file:///Users/markmiller/src/ongithub/endojs/endo/packages/eventual-send/src/local.js:134:18)
          at Object.applyMethod (file:///Users/markmiller/src/ongithub/endojs/endo/packages/eventual-send/src/handled-promise.js:463:16)
          at dispatchToHandler (file:///Users/markmiller/src/ongithub/endojs/endo/packages/eventual-send/src/handled-promise.js:159:22)
          at doDispatch (file:///Users/markmiller/src/ongithub/endojs/endo/packages/eventual-send/src/handled-promise.js:494:7)
          at file:///Users/markmiller/src/ongithub/endojs/endo/packages/eventual-send/src/track-turns.js:56:18
          at win (file:///Users/markmiller/src/ongithub/endojs/endo/packages/eventual-send/src/handled-promise.js:514:26)
          at file:///Users/markmiller/src/ongithub/endojs/endo/packages/eventual-send/src/handled-promise.js:533:20
          at process.processTicksAndRejections (node:internal/process/task_queues:105:5)

        Error#2 ERROR_NOTE: Caused by: (Error#3)
        Nested error under Error#2
          Error#3: Event: 0.1

            at trackTurns (file:///Users/markmiller/src/ongithub/endojs/endo/packages/eventual-send/src/track-turns.js:100:24)
            at handle (file:///Users/markmiller/src/ongithub/endojs/endo/packages/eventual-send/src/handled-promise.js:503:33)
            at Function.applyMethod (file:///Users/markmiller/src/ongithub/endojs/endo/packages/eventual-send/src/handled-promise.js:426:14)
            at Proxy.foo (file:///Users/markmiller/src/ongithub/endojs/endo/packages/eventual-send/src/E.js:76:35)
            at Object.test (file:///Users/markmiller/src/ongithub/endojs/endo/packages/errors/test/deep-send.test.js:30:22)
            at __HIDE_goAskAlice (file:///Users/markmiller/src/ongithub/endojs/endo/packages/errors/test/deep-send.test.js:33:32)
            at file:///Users/markmiller/src/ongithub/endojs/endo/packages/errors/test/deep-send.test.js:37:13
            at Test.callFn (file:///Users/markmiller/src/ongithub/endojs/endo/node_modules/ava/lib/test.js:525:26)
            at Test.run (file:///Users/markmiller/src/ongithub/endojs/endo/node_modules/ava/lib/test.js:534:33)
            at Runner.runSingle (file:///Users/markmiller/src/ongithub/endojs/endo/node_modules/ava/lib/runner.js:280:33)
            at Runner.runTest (file:///Users/markmiller/src/ongithub/endojs/endo/node_modules/ava/lib/runner.js:362:30)
            at process.processTicksAndRejections (node:internal/process/task_queues:105:5)
            at async Promise.all (index 0)
            at async file:///Users/markmiller/src/ongithub/endojs/endo/node_modules/ava/lib/runner.js:515:21
            at async Runner.start (file:///Users/markmiller/src/ongithub/endojs/endo/node_modules/ava/lib/runner.js:523:15)
</details>


Source: [docs/lockdown.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/lockdown.md) at commit `fe81477b`.
