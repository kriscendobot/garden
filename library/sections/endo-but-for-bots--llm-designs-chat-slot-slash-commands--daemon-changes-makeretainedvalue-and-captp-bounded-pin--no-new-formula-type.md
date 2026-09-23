---
title: No new formula type
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

The retained value is an ordinary formula (`eval`, `marshal`,
`locator`) with a real locator. The "retained" characteristic
is purely lifecycle: the transient-root pin tied to the captp
connection. It is not a persisted property. This avoids a
cross-cutting schema change and keeps the existing formulation
code paths authoritative. Crucially, because the slot value has a
real locator at all times (never an opaque "ephemeral
identifier" that lacks an addressable formula on disk), every
existing daemon affordance that takes a formula identifier
(resolve, inspect, dependency-walk) works on the retained value
without special cases.

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
