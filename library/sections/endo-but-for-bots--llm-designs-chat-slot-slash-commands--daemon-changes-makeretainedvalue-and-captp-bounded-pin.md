---
title: Daemon changes — makeRetainedValue, release exo, and the captp-bounded transient pin
source: designs/chat-slot-slash-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: f3bf100cec6e0480536b3256ce0280de9487cd0c
source_date: 2026-05-06
source_authors: [Kris Kowal]
topics: [daemon, eventual-send, captp, persistence]
status: current
notes: Third of five sections for chat-slot-slash-commands. The load-bearing daemon-side mechanism. Introduces `makeRetainedValue(spec) -> { id, release }` on `EndoHost` / `EndoGuest`, a tagged-union spec covering `eval` / `marshal` / `locator` variants, a release Exo with a single `release()` method, and the captp-partition handler that fires release intrinsically when the connection severs. The transient pin is in-memory only; a restart invalidates pending Chat requests anyway. *No new formula type* — the retained value is an ordinary `eval` / `marshal` / `locator` formula with a real locator; "retained" is purely a lifecycle property (the transient-root pin), not a persisted property. The "disk before graph" rule (the daemon's own invariant for `formulateEval` / `formulateMarshalValue` ordering) is what makes release-ordering safe.
kind: index
section_count: 5
---

The daemon-side machinery is one new method on the agent
capability, one release-exo class, and a captp-partition wire-up
that bounds the pin's lifetime to the connection. The retained
value is an ordinary `eval` / `marshal` / `locator` formula with
a real locator at all times. "Retained" is a property of the
daemon's transient-pin set, not of a different identifier kind,
so every existing daemon affordance (resolve, inspect,
dependency-walk) works on the retained value without special
cases.

Sections:

- [`makeRetainedValue(spec) -> { id, release }`](endo-but-for-bots--llm-designs-chat-slot-slash-commands--daemon-changes-makeretainedvalue-and-captp-bounded-pin--makeretainedvalue-spec-id-release.md)
- [Release Exo lifetime and captp partition](endo-but-for-bots--llm-designs-chat-slot-slash-commands--daemon-changes-makeretainedvalue-and-captp-bounded-pin--release-exo-lifetime-and-captp-partition.md)
- [Persistence: pin is in-memory only](endo-but-for-bots--llm-designs-chat-slot-slash-commands--daemon-changes-makeretainedvalue-and-captp-bounded-pin--persistence-pin-is-in-memory-only.md)
- [Release ordering: disk before graph](endo-but-for-bots--llm-designs-chat-slot-slash-commands--daemon-changes-makeretainedvalue-and-captp-bounded-pin--release-ordering-disk-before-graph.md)
- [No new formula type](endo-but-for-bots--llm-designs-chat-slot-slash-commands--daemon-changes-makeretainedvalue-and-captp-bounded-pin--no-new-formula-type.md)

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
