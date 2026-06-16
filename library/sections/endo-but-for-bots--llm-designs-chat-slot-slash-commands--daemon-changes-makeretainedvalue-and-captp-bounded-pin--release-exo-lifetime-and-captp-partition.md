---
title: Release Exo lifetime and captp partition
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

The release Exo is held by the Chat UI across the captp
connection to the daemon. If that connection severs (network
failure, daemon restart, Chat process termination), the Exo on
the daemon side is partitioned: its export is dropped from the
captp's export table and any outstanding eventual sends to it
reject with a bounded reason (typically a "remote disconnected"
error). The holder, while the connection was live, can obtain a
**cancellation promise** for the Exo via the standard CapTP
partition-handler mechanism (see `@endo/captp`'s connection-level
abort signal). That promise resolves (or rejects) when the captp
slot for the Exo is partitioned, allowing the holder to react to
the loss without polling.

The daemon side wires the partition signal to the Exo's intrinsic
behavior: when the captp connection severs, the daemon invokes
`release()` on the Exo's behalf, draining the transient pin. The
retained value's lifetime is therefore bounded by the captp
connection: at worst, the value remains pinned until the
connection closes, at which point it is released and (if no
other formula retains it) collected.

If the underlying captp partition-handler API is not yet exposed
in the form this design needs (per-Exo cancellation promise,
disconnection-triggered intrinsic release), the implementation
should add the minimum surface required and note the addition in
the Daemon changes phase. Pinning the value's lifetime to the
captp connection is what makes this design's leak surface
bounded; if the daemon cannot detect the disconnect, the design
degrades to "leak until daemon restart", which is unacceptable.

```
┌─────────────────────────────────────────────────────────────┐
│ Chat                                                        │
│   retainedSlot := { id, release }                           │
│   on submit success → await E(release).release()            │
│   on submit failure → keep                                  │
│   on cancel         → await E(release).release()            │
│   on captp severance → daemon releases automatically        │
└─────────────────────────────────────────────────────────────┘
            │
            ▼
┌─────────────────────────────────────────────────────────────┐
│ Daemon                                                      │
│   formulateEval(…, pinTransient)                            │
│     • persists eval formula to disk                         │
│     • pinTransient(id) inside formula-graph lock            │
│   returns { id, value: Promise<…> }                         │
│                                                             │
│   release exo                                               │
│     • release() → unpinTransient(id) + maybeCollect         │
│     • partition signal → release() invoked automatically    │
└─────────────────────────────────────────────────────────────┘
```

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
