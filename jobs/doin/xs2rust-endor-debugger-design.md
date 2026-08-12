---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: endojs/endo-but-for-bots
role: designer

# Design: xs2rust-endor debugger, following on #600

`https://github.com/endojs/endo-but-for-bots/pull/600` ("feat(ironhorse):
JavaScript engine in Rust, based on XS") merged 2026-08-06. Before it merged,
the researcher report `xs2rust-endor-debugger-caught-vs-uncaught` found that
the debugger row it was briefed against was no longer on the branch, and
named four follow-ups, the first blocking the other three:

1. **Recover the debugger row** — it left the `xs2rust-endor` branch for
   unknown reasons before merge. Since #600 is now merged, "recover onto
   #600" no longer literally applies — figure out where this work should
   land now (a fresh PR/branch off current `main`/`llm` is the likely shape)
   and design that path explicitly as part of this document, don't just
   restate the stale instruction.
2. `setExceptionBreakMode('uncaught')` is reportedly a **live silent no-op**.
3. Ironhorse's engine-raised errors reportedly **do not unwind through the
   jump chain**.
4. Three `BreakpointTable` parity nits versus the XS oracle: a missing
   `line == 0 && id == 0` guard, an un-ported `start` pseudo-breakpoint, and
   a doc reference to a nonexistent `"unhandled"` pseudo-breakpoint.

Verify each of 2-4 against the CURRENT state of the merged Ironhorse engine
(`rust/engine/`, the `ironhorse-vm`/`ironhorse-262` crates) before designing
a fix — the code has moved since that report was written, so confirm each
claim still holds rather than designing against stale findings.

## Deliverable

A design doc (`designs/<slug>.md` in this repo's own convention) proposing:
the recovery path for the debugger row, and fixes for whichever of 2-4 are
still live, oracle-locked to the XS debugger's actual behavior the way the
rest of Ironhorse is oracle-locked (per `PR #600`'s own diameter-tape
verification discipline — byte-for-byte/behavior-for-behavior parity against
Moddable XS, not a best-effort reimplementation). Land it as a draft PR
against the roadmap branch (`llm`) per the designer role's standing
convention. Name who should build it (weaver recovering the row vs. a fresh
builder slice) as an explicit recommendation, not left open if the evidence
supports a clear answer.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-12T20:23:15Z
