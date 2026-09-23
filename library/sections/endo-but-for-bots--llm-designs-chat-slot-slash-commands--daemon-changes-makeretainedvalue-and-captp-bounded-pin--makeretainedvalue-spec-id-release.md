---
title: "`makeRetainedValue(spec) -> { id, release }`"
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

A new method on `EndoHost` and `EndoGuest`. `spec` is a tagged
union. Initial variants:

```ts
type RetainedValueSpec =
  | { type: 'eval';
      source: string;
      codeNames: string[];
      endowments: (PetNamePath | FormulaIdentifier)[];
      workerName?: Name;
    }
  | { type: 'marshal'; value: Passable }
  | { type: 'locator'; locator: string };
```

For `type: 'eval'`, the implementation is exactly the existing
transient-pin path in `host.js` and `guest.js`: call
`formulateEval` with `pinTransient` supplied, **but do not**
`await value` and do **not** `unpinTransient` in a `finally`
before returning. Instead, return `{ id, release }` where
`release` wraps `unpinTransient(id)` and drains any resulting
collection.

For `type: 'marshal'`, delegate to `formulateMarshalValue` with
`pinTransient`. For `type: 'locator'`, delegate to
`provideLocator` (or whatever locator formula type exists under
`daemon-locator-terminology`) with a transient pin.

The `release` capability is an exo with a single `release()`
method, returned as a capability (not a thunk) so it survives
serialization. It is itself transient: its own formula inputs
retain the target, but it only lives until `release()` is called
or until the captp connection that holds the reference severs.

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
