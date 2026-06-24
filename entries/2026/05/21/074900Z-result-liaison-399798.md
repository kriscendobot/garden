---
ts: 2026-05-21T07:49:00Z
kind: result
role: liaison
project: endo-but-for-bots
to: maintainer
dispatch: 074053Z-dispatch-liaison-399798
---

# Result: gauntlet on endo-but-for-bots#336 (mirror of #59 fix) — MUST-FIX-LOOP surfaced, holding for maintainer call

The autonomous-loop gauntlet for [PR endo-but-for-bots#336](https://github.com/endojs/endo-but-for-bots/pull/336) (mirror of the issue #59 fix) reached a **must-fix-loop** disposition on round 1. The PR remains DRAFT. **Liaison is holding the fixer dispatch for maintainer input on which of three fix shapes to pursue.**

## What the gauntlet found

The cleaner (af2865) probed the fix's commit-message claim that *"Genuine missing exports still raise SyntaxError"* and found it does NOT hold: a genuinely missing reexport now imports cleanly with `alias === undefined` because the deferred forwarder queues forever for a never-arriving upstream. **Trades cycle-time `TypeError` for silent `undefined` on typos** — a real correctness regression on top of the cycle win.

The judge (399798) re-probed empirically (saw `raised: null; captured: undefined` for both acyclic and cyclic missing-renamed-reexport cases) and dispatched the 23-seat code panel. **7 of 23 seats requested changes**, all converging on this regression: saboteur, prover, spec-keeper, engine-realist, breaker, assessor, changeset-auditor. 10 seats approved on the cycle-handling substance. Judge submitted a formal `gh pr review` with explicit "Must-fix before merge" heading.

CI: 18/18 SUCCESS at head `f6c2f2815`. The fix's regression test passes; the *new* regression test (cyclic missing renamed reexport raises SyntaxError) does not yet exist.

## Three fix shapes the panel surfaced

The fixer would pick from:

- **A**. **Resolve-on-import-completion** — wire the deferred forwarder to a callback that fires when its importing instance's candidate-all walk finishes; if the upstream notifier is still absent at that point, raise `SyntaxError` from the queued subscribers.
- **B**. **Synchronous fallback raise** — at the deferred path's invocation, if a lookup at `mapGet(importedInstances, specifier).notifiers[localName]` returns `undefined` AND the instance is past candidate-all, raise `SyntaxError` directly.
- **C**. **Post-resolve sweep** — after every candidate-all walk completes, sweep any still-pending deferred forwarders and raise `SyntaxError` on those whose upstream remained absent.

A and C are roughly equivalent in effect; B is local but requires a candidate-all-completion bit on the instance. The panel didn't strongly prefer one shape.

## Why I'm holding the fixer

The fix-shape choice is a real design decision on load-bearing module-linking code. The autonomous loop has been authorized for the mirror-and-gauntlet pattern, but this particular branch needs your judgment on shape before the fixer dispatches. Three options:

- **(i)** You pick a shape; I dispatch a fixer with that shape pinned.
- **(ii)** You authorize me to let the fixer pick (likely **A** for cleanest semantics).
- **(iii)** You take the PR over directly — the upstream PR doesn't exist (kriscendobot cross-fork block); #336 is the substantive artifact and the followup ledger has the cleaner-flagged regression parked.

## Async work already queued

- `followups/endo-but-for-bots--336.md` with 2 items (state-machine design note for module-linking hot paths; drain-order test).
- Proposed-rule message from judge → gardener: "linker hot paths warrant a state-machine design note" at `entries/2026/05/21/074716Z-message-judge-399798.md`.

## Teardown

Dispatch roots `dispatches/builder--570bb5/`, `dispatches/cleaner--af2865/`, `dispatches/judge--399798/` all torn down.
