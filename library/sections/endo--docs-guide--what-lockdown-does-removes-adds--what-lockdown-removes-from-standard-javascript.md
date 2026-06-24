---
title: What Lockdown removes from standard JavaScript
source: docs/guide.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript]
status: current
notes: Overlaps with endo--docs-reference--removed-by-hardened-js and endo--docs-reference--added-changed-by-hardened-js. Guide-shaped vs reference-shaped; kept both.
parent: endo--docs-guide--what-lockdown-does-removes-adds
---

Almost all existing JavaScript code runs under Node.js or inside a browser, so
it's easy to conflate environment features with JavaScript. For example, you may
be surprised that `Buffer` and `require` are Node.js additions. Also `setTimeout()`,
`setInterval()`, `URL`, `atob()`, `btoa()`, `TextEncoder`, and `TextDecoder` are additions
to the programming environment standardized by the web, and are not intrinsic
to JavaScript.

Most Node.js-specific [global objects](https://nodejs.org/dist/latest-v14.x/docs/api/globals.html) are
**unavailable** including:

* `queueMicrotask`
* `URL` and `URLSearchParams`
* `WebAssembly`
* `TextEncoder` and `TextDecoder`
* `global`
  * Use `globalThis` instead.
* `process`
  * No `process.env` to access the process's environment variables.
  * No `process.argv` for the argument array.
* `Buffer` (consider using `TypedArray` instead, but see below)
* `setImmediate`/`clearImmediate`
  * You can generally replace `setImmediate(fn)`
    with `Promise.resolve().then(_ => fn())` to defer execution of `fn` until after the current event/callback
    finishes processing. But it won't run until after all *other* ready Promise callbacks execute.

    There are two queues: the *IO queue* (accessed by `setImmediate`), and the *Promise queue* (accessed by
    Promise resolution). HardenedJS code can add to the Promise queue, but needs to be given a
    capability to be able to add to the I/O queue. Note that the Promise queue is
    higher-priority than the IO queue, so the Promise queue must be empty for any IO or timers to be handled.
* `setInterval` and `setTimeout` (and `clearInterval`/`clearTimeout`)
  * Any notion of time must come from
    exchanging messages with external timer services (the SwingSet environment provides a `TimerService` object
    to the bootstrap vat, which can share it with other vats)

None of the huge list of [other Browser environment features](https://developer.mozilla.org/en-US/docs/Web/API)
presented as names in the global scope (some also added to Node.js) are available in a
hardened environment. The most surprising removals include `atob`, `TextEncoder`, and `URL`.

`debugger` is a first-class JavaScript statement, and behaves as expected.

Source: [docs/guide.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/guide.md) at commit `fe81477b`.
