Draft PR [#1375](https://github.com/endojs/endo-but-for-bots/pull/1375) is open: when a debugger is attached, a panic now sends a distinct `<panic kind="...">` wire message and the worker stops at the panic site before teardown, even under `setExceptionBreakMode('none')`. The `build-xsnap` CI job passes, including the new step that runs the debugger protocol tests (14 passed, 1 ignored).

**Scope.** Ironhorse has no debugger on `llm` yet, so the only place a panic can actually happen is the C-XS worker. The mentat's answers (draft #1370) had landed and I followed them. My C-XS panic classification matches the one in #1374. Earlier legs #1372/#1373/#1374 are unmerged, and this leg doesn't depend on their code, so I based it on the frozen base `llm-1706e63` rather than stacking.

**What was built:**
- **C side.** `fxAbort` now calls a new `fxDebugPanic` for the panic exits when a debugger is connected. It sends `<panic kind path line>` first, then the frame, local and global listings, then waits in the same loop a `<break>` uses. The kinds are stack-overflow (JS and native), meter-abort, heap-exhausted and keys-exhausted. A second abort raised during the stop goes straight to teardown instead of stopping again.
- **Where it lives.** `fxDebugPanic` is in a new wrapper file, `xsnap-debug.c`, which compiles XS's `xsDebug.c` in place. That lets it reuse XS's private helpers without patching the `c/moddable` submodule.
- **Unhandled exceptions and rejections** get no `<panic>`: they are uncaught throws, not panics.
- **JS consumer.** `DebugSession` turns `<panic>` into a `PanicEvent` and adds `onPanic`, `isPanicked` and `getLastPanic`. A `step()` that runs into a panic now rejects instead of hanging. The Debugger exo exposes `isPanicked` and `getLastPanic`. A parser that predates `<panic>` ignores the element and never reads it as a break.
- **Existing tests fixed.** The existing debugger protocol tests had never been able to run: every one hung before its first assertion. `fxRunDebugger` now waits for commands only when one is ready, and the tests queue their replies so only a stopped VM reads them. I updated three stale `<local>` assertions and ignored the `<script>` eval test with its reason. CI now runs the suite.
- **Build fix.** `build.rs` now rebuilds when the `.c` files change; before, edits to them could be silently skipped.
- **Docs.** I added the `<panic>` row and a new known limitation to `designs/daemon-xs-worker-debugger.md`, and a short C-XS implementation section to `designs/ironhorse-panic.md`.

**Verification.**
- **New Rust cases (4):**
  - A stack overflow under mode `none` stops at the panic site.
  - A meter abort stops at the loop line with its locals listed.
  - Under mode `all`, a caught throw still produces `<break>` and a panic produces only `<panic>`.
  - With no debugger attached, teardown happens immediately.
- **Other tests.** 7 new daemon tests plus the existing CapTP debugger tests pass (23 in total). The non-debug `xsnap --lib` suite passes 142 tests. One test, `archive_text_endowments_provide_codecs`, crashes locally only because the bundle it needs failed to generate here and is a placeholder.

**Still open (listed as review items in the PR):**
- **Live stops can't be released yet.** A stopped in-process worker can't receive the `go` that releases it, because the debug message would be read on the same blocked thread. This affects ordinary `<break>` stops too, and this PR doesn't change it. Reading debug messages from the transport while stopped is the follow-up.
- **FFI panics (`engine-fault`) don't stop yet.** The guard returns to the guest, so the panic site is gone before anything can stop there. That needs a design decision (probe Gap 1).
- **`reference-error`** waits for the Coda leg.
- **Extra kind names.** The design lists four kinds. On C-XS I added `heap-exhausted` and `keys-exhausted`, and native stack overflow reports as `stack-overflow`. These need confirming.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-debugger-panic-break.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 236 tokens (15684268 cached reads)
- Output: 68129 tokens
- Cost: $6.160953600000001
- Wall-clock: 2888s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
