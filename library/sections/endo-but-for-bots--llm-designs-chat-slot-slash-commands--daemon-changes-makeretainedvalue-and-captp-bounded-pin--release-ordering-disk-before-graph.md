---
title: "Release ordering: disk before graph"
source: designs/chat-slot-slash-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: f3bf100cec6e0480536b3256ce0280de9487cd0c
source_date: 2026-05-06
source_authors: [Kris Kowal]
topics: [daemon, eventual-send, captp, persistence]
status: current
notes: Third of five sections for chat-slot-slash-commands. The load-bearing daemon-side mechanism. Introduces `makeRetainedValue(spec) -> { id, release }` on `EndoHost` / `EndoGuest`, a tagged-union spec covering `eval` / `marshal` / `locator` variants, a release Exo with a single `release()` method, and the captp-partition handler that fires release intrinsically when the connection severs. The transient pin is in-memory only; a restart invalidates pending Chat requests anyway. *No new formula type* — the retained value is an ordinary `eval` / `marshal` / `locator` formula with a real locator; "retained" is purely a lifecycle property (the transient-root pin), not a persisted property. The "disk before graph" rule (the daemon's own invariant for `formulateEval` / `formulateMarshalValue` ordering) is what makes release-ordering safe.
parent: endo-but-for-bots--llm-designs-chat-slot-slash-commands--daemon-changes-makeretainedvalue-and-captp-bounded-pin
---

Chat must not call `release()` before the daemon has committed
the outer formula. The submit methods (`endow`, `submit`, ...)
return a promise that resolves when the outer formula is fully
persisted and its graph edges are in place. Chat awaits that
promise before calling `release()`. This matches the daemon's
**"disk before graph"** invariant: once `formulateEval` or
`formulateMarshalValue` has returned, the new retention edge is
live, so unpinning the previously-retained root will not collect
the value.

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
