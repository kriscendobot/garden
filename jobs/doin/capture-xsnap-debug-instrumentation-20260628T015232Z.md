# Capture the xsnap stack-overflow debug instrumentation in bot forks

Make the xsnap stack-overflow trace instrumentation (developed live on garden
issue #9 and twice lost to redeploy wipes) **durable** by landing it as a
committed branch + DRAFT PR in the bot-owned forks of the relevant repositories.
The maintainer's directive (kriskowal, issue #9, 2026-06-28): "Please also post a
job to capture the debug instrumentation improvements to xsnap in forks of the
relevant repositories."

Two artifacts have already been wiped by redeploys (`bundle-ymax0.json` and the
built fork under `/home/kris/agoric-sdk`). The point of this job is so the
**instrumentation patch itself** never has to be re-derived from the issue thread
again — commit it where a redeploy cannot reach it.

## Scope (hard constraints)

- **Bot-owned forks ONLY.** Touch only `kriscendobot/xsnap-pub` and
  `kriscendobot/agoric-sdk`. Both are bot forks (verified) and in scope.
- **Never** push to, PR against, or merge into `agoric-labs/xsnap-pub`,
  `agoric-labs/moddable`, `Agoric/agoric-sdk`, `endojs/endo`, or any upstream.
  agoric-sdk upstream is off-limits unconditionally; this work lives entirely on
  bot forks.
- Open PRs **DRAFT** and leave them draft — this is artifact preservation, not a
  merge candidate. Do not run the un-draft / judge / conductor chain.

## Relevant repos (verified)

| Repo | Role | Default branch |
| --- | --- | --- |
| `kriscendobot/xsnap-pub` (fork of `agoric-labs/xsnap-pub`) | holds `xsnap/sources/xsnapPlatform.c` — the C engine source the patch edits | `Agoric` |
| `kriscendobot/agoric-sdk` (bot fork) | holds `packages/xsnap` (the JS fd-3/4 netstring driver + worker build invocation) and the `packages/xsnap-native` submodule pointer | (its default) |

`xsnapPlatform.c` is confirmed present at `xsnap/sources/xsnapPlatform.c` in
`kriscendobot/xsnap-pub`.

## Deliverable A — `kriscendobot/xsnap-pub`: commit the engine instrumentation

On a clearly named branch (e.g. `debug/xs-stack-overflow-trace`), apply the
stack-overflow trace dump to the `XS_STACK_OVERFLOW_EXIT` arm of `fxAbort()` in
`xsnap/sources/xsnapPlatform.c`, plus the `#include <execinfo.h>` near the top
includes. The patch walks the XS frame chain (per-frame value-stack slot span),
prints the value-stack fill level, and emits a native C backtrace
(`backtrace_symbols_fd`); it is allocation-free so it is safe at exhaustion. The
exact patch (from the issue thread, reproduce verbatim):

```c
#include <execinfo.h>   // near the top includes
// ... replace the XS_STACK_OVERFLOW_EXIT arm of fxAbort() with:
case XS_STACK_OVERFLOW_EXIT: {
    txSlot* aFrame = the->frame;
    txInteger aDepth = 0;
    txInteger aTotalSlots = (txInteger)(the->stackTop - the->stackBottom);
    txInteger aUsedSlots  = (txInteger)(the->stackTop - the->stack);
    fprintf(stderr, "=== XS STACK OVERFLOW TRACE (innermost first) ===\n");
    fprintf(stderr, "value stack: %ld of %ld slots used (%ld free)\n",
        (long)aUsedSlots, (long)aTotalSlots, (long)(aTotalSlots - aUsedSlots));
    fprintf(stderr, "depth\tslots_in_frame\tfunction:line\n");
    while (aFrame) {
        if (aDepth < 600) {
            txSlot* anEnv = mxFrameToEnvironment(aFrame);
            char* aName = (anEnv->ID != XS_NO_ID) ? fxGetKeyName(the, anEnv->ID) : (char*)0;
            txInteger aSpan = aFrame->next ? (txInteger)(aFrame->next - aFrame)
                                           : (txInteger)(the->stackTop - aFrame);
            fprintf(stderr, "#%ld\t%ld\t%s:%ld\n", (long)aDepth, (long)aSpan,
                aName ? aName : "(anonymous)", (long)anEnv->value.environment.line);
        }
        aDepth++; aFrame = aFrame->next;
    }
    fprintf(stderr, "=== XS STACK OVERFLOW: total %ld frames ===\n", (long)aDepth);
    fflush(stderr);
    { static void* bt[1024]; int n = backtrace(bt, 1024);
      fprintf(stderr, "=== NATIVE C BACKTRACE (%d frames) ===\n", n);
      fflush(stderr); backtrace_symbols_fd(bt, n, 2); }
    fxReport(the, "stack overflow\n");
#ifdef mxDebug
    fxDebugger(the, (char *)__FILE__, __LINE__);
#endif
    the->abortStatus = status; fxExitToHost(the); break;
}
```

Adapt only as needed to match the exact text of the current
`XS_STACK_OVERFLOW_EXIT` arm in the fork (the surrounding `fxAbort` body may
differ slightly); the instrumentation block above is the substance to preserve.
The commit message should explain *what* it instruments and *why* (the ymax0 v320
value-stack-exhaustion investigation), and note it is debug-only output on
inherited stderr (the worker's `fxReport`/console path is compiled out by
`mxNoConsole`, hence the direct `fprintf(stderr, …)`).

Open a DRAFT PR on `kriscendobot/xsnap-pub` (head = your branch, base = the bot
fork's own `Agoric`, **not** agoric-labs) so the patch is a reviewable,
permanent object.

## Deliverable B — `kriscendobot/agoric-sdk`: capture the build + run harness

On a branch in the bot fork, add a short durable methodology doc (e.g. under
`packages/xsnap/` or a `docs/`/`notes/` location consistent with the fork) that
records, so it never has to be reconstructed from the issue thread:

1. **Build just the instrumented worker:**
   `make MODDABLE=<pkg>/moddable GOAL=release XSNAP_VERSION=0.15.0 'CC=cc "-D__has_builtin(x)=1"' EXTRA_DEPS=<pkg>/build.config.env -f xsnap-worker.mk`
   from `xsnap-native/xsnap/makefiles/lin` (gcc 13; `-rdynamic` already in
   `LINK_OPTIONS`). Remove the `build/bin/lin/release/xsnap-worker` symlink to the
   cached prebuilt first so the build writes a fresh real binary rather than
   clobbering the cache.
2. **Run** the existing fd-3/4 netstring driver with `XSNAP_WORKER=<fresh worker>`
   and `importBundle(<bundle>)`; the trace lands on inherited stderr. Controls:
   trivial bundle → OK; deep-recursion probe (`function f(n){return n>0?1+f(n-1):0;} f(100000)`)
   → ~394 frames at 4093/4096 slots (validates the frame walker and matches the
   prebuilt 0.14.2 budget).
3. **Key calibration result to record** (so the conclusion survives too): the real
   ymax0 import overflows at **9 frames, value stack 4096/4096**, with one
   anonymous activation holding ~2,588 slots and its callee ~1,238 — i.e. **wide
   value-stack exhaustion, not deep recursion**. XS value stack is fixed at
   `stackCount = 4096` in `xsnap-worker.c` with no CLI override.

If the fork's `packages/xsnap-native` submodule pointer can be advanced to the
instrumented `kriscendobot/xsnap-pub` commit from Deliverable A without touching
upstream, do so on this branch so the two artifacts are wired together; if that is
awkward, just reference the xsnap-pub branch/commit in the doc. Open a DRAFT PR on
`kriscendobot/agoric-sdk` (base = the bot fork's own default branch).

## Definition of done

- A committed branch + DRAFT PR on `kriscendobot/xsnap-pub` carrying the
  `xsnapPlatform.c` instrumentation.
- A committed branch + DRAFT PR (or at minimum a pushed branch) on
  `kriscendobot/agoric-sdk` carrying the build/run methodology doc and, if
  feasible, the submodule pin.
- A comment back on garden issue #9 (URL below) reporting both PR URLs and a
  one-paragraph summary, so the maintainer sees the instrumentation is now durable.
  **Never close the issue** — the submitter does that.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriskowal-garden-9
issue_url: https://github.com/kriskowal/garden/issues/9#issuecomment-4823971284
submitter: kriskowal
----- END ISSUE NOTE -----

---
claim:
  host: endolinbot
  gardener: 68
  claimed_at: 2026-06-28T01:53:29Z
