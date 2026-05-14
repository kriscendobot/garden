---
title: Loopholes for purely diagnostic information
source: packages/async-flow/README.md
source_repo: agoric/agoric-sdk
source_commit: 16095c5076043133aff0f25721131be2ca1ef5af
source_date: 2024-05-19
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security, persistence, async-flow]
status: current
notes: The exception is principled — `console` is write-only and similar to debugger observation, neither of which counts as a capability effect. The error-name-only comparison rule is a similar concession: only `error.name` is semantically meaningful, everything else (message, stack) is diagnostic and may legitimately differ between replays.
---

> Abstract: Explicit exceptions to the closed-function rule. `console` is allowed because log messages are write-only and similar to a debugger — neither counts as an "observable effect" the replay mechanism must mirror. Out-of-band `console` logging may appear again during replay, and the async function has no obligation to reproduce previous log events. Similarly, error comparison is loose: when checking sent errors against the log, only `error.name` (e.g., `TypeError` / `URIError`) must match — `error.message`, call-stack, subsidiary errors are diagnostic and may legitimately differ.

## Loopholes for purely diagnostic information

> We make an explicit exception to the closed-function requirement for `console`, since log messages sent to `console` are only for diagnostic purposes, and `console` as a whole is write-only. We consider the ability to read the console log output to be similar to the ability to view computation through a debugger. Not counting either as "observing effects", the `console` does not cause "observable effects". During replay, such out-of-band console log events may appear again. For the same reason, the async function has no obligation to reproduce previous runs of such out-of-band console logging events, since they are outside the replay mechanisms. Likewise, the guest function has no obligation to reproduce the experience of viewing it through a debugger.

> When comparing arguments sent by the guest function during replay with what the log recorded the guest function to have sent, we are extremely permissive in judging whether a sent error is the "same" as it was on a previous run. We only care that it is an error, and that the value of the `error.name` property is the same string. That string is normally the name of the error "class", such as `TypeError` or `URIError`, and is the only aspect of an error that programs may legitimately use to make a semantically significant decision. Everything else carried by an error, especially its `error.message`, call-stack information, and subsidiary errors, are only for diagnostic purposes and need not be the same on replay.

Source: [packages/async-flow/README.md](https://github.com/Agoric/agoric-sdk/blob/16095c5076043133aff0f25721131be2ca1ef5af/packages/async-flow/README.md) at commit `16095c50`.
