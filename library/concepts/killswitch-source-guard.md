---
id: killswitch-source-guard
aliases: [killswitch source guard, source-gated auto-clear, OperatorReset, reboot-watcher killswitch, breadcrumb before killswitch, durable write ordering, recovery precondition first, session resume model guard, session_model, context-exhaustion roll-forward, keep claimed recap, fail toward safe state]
topics: [agent-fleet-durability]
---

# killswitch-source-guard

The family of **crash-safe guards on automated lifecycle transitions** in an autonomous agent fleet, unified by one rule: *fail toward the safe state, and prove ownership before reversing a deliberate human act.* Four composable guards: (1) **durable-write ordering** — write the recovery breadcrumb *before* the killswitch, so a crash in the window leaves a benign breadcrumb-without-killswitch rather than a bricked killswitch-without-breadcrumb (and add a source-gated self-heal for state already written in the bad order); (2) **source-gated auto-clear** — every killswitch write stamps a `source` tag, and an *automated* clear fires only when the live source matches the tag it itself stamped, so an operator's deliberate pause is never silently un-paused (an operator `/resume` clears regardless — the human is the authority the guard protects); (3) **model-guarded session resume** — record `session_model` at creation, compare on resume, auto-clear-and-start-fresh on mismatch, treating a missing legacy record as a mismatch and *not* conflating an empty-string default with absence; (4) **context-exhaustion roll-forward** — near the limit, write a recap stanza and keep the task *claimed*, never re-ready (a re-ready with no findings spawns an unbounded re-claim loop). From jcorbin's unum LORE; the garden's own "keep the job claimed + hand off, don't emit the completion signal" on turn exhaustion is the same instinct.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [unum--lore-crash-safe-guards](../sections/unum--lore-crash-safe-guards.md) | The full cluster: breadcrumb-before-killswitch ordering, source-gated auto-clear, model-guarded resume, and context-exhaustion recap-and-keep-claimed. |

## See also

- [[claim-state-triple]] — context-exhaustion roll-forward keeps the claim (the triple) intact rather than re-readying it.
- [[log-and-swallow]] — the runtime-safety sibling: fail loud rather than silently corrupt.
- [[model-routing]] — the model-guarded-resume guard interacts with which model a session/persona runs under.
