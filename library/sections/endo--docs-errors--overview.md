---
title: Logging Errors (overview)
source: docs/errors.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-13
ingested_by: liaison
topics: [errors, hardened-javascript, agent-conventions]
status: current
notes: Single commit in git log; content references issues from 2020 era, so material likely predates a docs reorg. Treat content age with care.
---

> Abstract: Summary of how SES handles error-related diagnostic information: an `assert` global adds hidden-from-callers annotations, the global `Error` is tamed to hide stacks, and the global `console` (the "causal console") reveals annotations and stacks back to the real console. Both `assert` and `console` are powerful globals that must be explicitly endowed into child compartments. The `TRACK_TURNS=enabled` + `DEBUG=track-turns` env vars enable deep asynchronous stacks via `@endo/eventual-send`.

# Logging Errors

Summary:

* Writing defensive programs under SES requires carefully considering what an error reveals to code positioned to catch those errors up the call chain.
* To that end, SES introduces an `assert` global with functions that add to errors annotations that will be hidden from callers. SES also tames the `Error` constructor to hide the `stack` to parent callers when possible (currently: v8, SpiderMonkey, XS).
* SES tames the global `console` and grants it the ability to reveal error annotations and stacks to the actual console.
* Both `assert` and `console` are powerful globals that SES does not implicitly carry into child compartments. When creating a child compartment, add `assert` to the compartment's globals. Either add `console` too, or add a wrapper that annotates the console with a topic.
* SES hides annotations and stack traces by default. To reveal them, SES uses mechanisms like `process.on("uncaughtException")` in Node.js to catch the error and log it back to the `console` tamed by `lockdown`.

We refer to the enhanced `console`, installed by default by the ses shim, as the *causal console*, because the annotations it reveals are often used to show causality information. For example, with the [`TRACK_TURNS=enabled`](https://github.com/Agoric/agoric-sdk/blob/master/docs/env.md#track_turns) and [`DEBUG=track-turns`](https://github.com/Agoric/agoric-sdk/blob/master/docs/env.md#debug) environment options set:

```sh
# in bash syntax
export DEBUG=track-turns
export TRACK_TURNS=enabled
```

the `@endo/eventual-send` package will use annotations to show where previous `E` operations (either eventual sends or `E.when`) in previous turns *locally in the same vat* caused the turn with the current error. This is sometimes called "deep asynchronous stacks".

* In the scope of the Agoric software ecosystem, this architecture will allow us to eventually introduce a more powerful distributed causal `console` that can meaningfully capture stack traces for a distributed debugger, based on the design of [Causeway](https://github.com/Agoric/agoric-sdk/issues/1318#issuecomment-662127549).

Source: [docs/errors.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/errors.md) at commit `fe81477b`.
