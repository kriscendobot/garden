---
title: "Persistence: pin is in-memory only"
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

The transient pin is in-memory only (see `graph.js`
`transientRoots`). If the daemon restarts while a Chat UI holds
a retained reference, the formula is still on disk but no longer
pinned. If nothing else retains it, the GC sweeps it on restart.
This is acceptable because a restart invalidates any pending
request in Chat anyway: the user would need to resubmit the outer
operation, at which point they will re-enter the slash command.
The alternative (persisting transient pins) would leak values
indefinitely if the Chat UI crashed before releasing.

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
