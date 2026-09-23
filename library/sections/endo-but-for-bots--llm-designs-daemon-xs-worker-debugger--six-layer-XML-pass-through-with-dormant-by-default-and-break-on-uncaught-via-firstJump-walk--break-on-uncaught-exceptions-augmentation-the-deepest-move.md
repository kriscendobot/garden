---
source: designs/daemon-xs-worker-debugger.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-xs-worker-debugger.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
  - hardened-javascript
status_at_ingest: In Progress
genre: §endo-but-for-bots-design §sibling-design-trio
cycle: 182
lane: designs
status: current
title: §Break-on-uncaught-exceptions augmentation (the deepest move)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk
---

§The-augmentation-section is 240 lines (lines 922-1166) and
contains the §single-deepest-architectural-insight in the
design. §The-problem:

> The xsbug protocol supports a single exception breakpoint
> mode: `path="exceptions" line="0"` sets
> `breakOnExceptionsFlag`, which causes the debugger to break
> on **every** `throw` — including exceptions that will be
> caught by a `try/catch` block.

§This-is-noisy-and-unusable-in-practice because Endo code
"throws and catches exceptions constantly as part of normal
control flow."

§The-insight: `fxDebugThrow` is called **before** `fxJump`:

```c
mxCase(XS_CODE_THROW)
    mxException = *mxStack;
#ifdef mxDebug
    fxDebugThrow(the, C_NULL, 0, "throw");
#endif
    fxJump(the);
```

§At-the-moment-fxDebugThrow-is-called, the VM has not yet
longjmp'd to the catch handler. §All-relevant-state-is-still-
live:

- `the->firstJump` is the head of a linked list of active
  exception handlers (`txJump` structs).
- Each `txJump` has a `flag` field:
  - `flag == 0` → C-level `mxTry/mxCatch` (host boundary)
  - `flag == 1` → JS-level `XS_CODE_CATCH` (JS `try/catch`)

§The-augmentation: walk the linked list at throw time.

```c
if (the->breakOnUncaughtExceptionsFlag) {
    txJump* jump = the->firstJump;
    while (jump) {
        if (jump->flag) {
            goto report;  // JS try/catch will catch this
        }
        jump = jump->nextJump;
    }
    // No JS catch found — this exception is uncaught.
    fxDebugLoop(the, path, line, message);
    return;
}
```

§The-architectural-property-that-makes-this-zero-cost is
explicit in the design:

> XS calls `fxDebugThrow` **before** `fxJump`, not after. The
> decision to break or not can be made at throw time with zero
> cost if the answer is "don't break."

§Compare-to-the-pre-design-state: a debugger that breaks after
the jump would have to §backtrack-from-the-handler-to-figure-out
which throw site it came from; the design-time-state allows the
decision to be made at the throw site with full stack + locals
available.

§The-design-names-the-architectural-advantage-explicitly: "There
is no need to 'undo' anything because execution has not left the
throw site yet."

§This-is-§exploit-the-pre-jump-window-as-the-decision-point. §A-
seemingly-small-protocol-change (new pseudo-breakpoint path
`"uncaughtExceptions"`) is enabled by a deep architectural fact
about XS's exception machinery.

§The-protocol-extension is backwards-compatible:

```xml
<set-breakpoint path="uncaughtExceptions" line="0"/>
```

§Older-xsbug-clients that don't send this pseudo-breakpoint see
no change in behavior. §Forward-compatible-protocol-extension.
