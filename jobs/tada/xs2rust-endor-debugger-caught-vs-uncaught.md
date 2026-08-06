Investigation complete. Issue filed: **https://github.com/endojs/endo-but-for-bots/issues/940**

## What I did

Read the pinned C-XS sources (`xsDebug.c`, `xsRun.c`, `xsAPI.c`, `xsPromise.c`, `xsAll.h` at Moddable `23b4d6b0a6`, fetched by API since the `c/moddable` submodule is uninitialized), the current `ironhorse-vm`/`ironhorse-compile` sources on PR 600's head, the `endor-debug` crate recovered from unreachable objects, the endo client stack (`debug-session.js`, `debugger.js`, tests), and the existing `designs/daemon-xs-worker-debugger.md` augmentation section. Ran two executed probes from a scratch crate outside the repo (path-linking `ironhorse-compile` and `ironhorse-vm`); no engine file was modified and no PR opened.

## Findings that matter most

- **The debugger row is not on PR 600's head.** All three slices (`2b6a8d707`, `6bac90c22`, `8024ee3f5`) are unreachable objects; `git branch -a --contains` finds no ref, merge-base is `00a04f5b4`. `rust/engine` has no debug crate and no `DebugHook`. Nothing proposed can land until that work is back on a ref. I did not establish why it left.
- **The brief's premise about slice 2 is inverted.** Its commit message names break-on-uncaught firing as deferred remainder, not delivered.
- **The stack does answer it, and in Ironhorse more cheaply than in XS.** `Interp.jumps: Vec<CatchJump>` has no host entries, so the predicate is `!jumps.is_empty()`: O(1), no walk, exact against what `unwind_to_jump` will do.
- **`finally` without `catch` defeats the naive predicate, and I found a fix that needs no bytecode change.** Verified by probe that `try { throw 7 } finally {}` still escapes to the host while the chain is non-empty; and that peeking one byte at the handler's `target_pc` separates the cases (`XS_CODE_CATCH*` = real catch, `XS_CODE_EXCEPTION` = finally-only transit). This beats the existing design's `flag == 2` compiler change, which would break the byte-identity bar.
- **The client stack already ships a three-way mode that neither engine implements**, and on today's C-XS `setExceptionBreakMode('uncaught')` silently disables exception breaking entirely (read from source, not executed). Worth fixing independently.
- **Prerequisite gap, executed:** Ironhorse's engine-raised errors bypass the jump chain; `try { var f; f() } catch (e) {}` still halts `Throw("call: not a function")`. Until native errors unwind through the chain, an uncaught mode cannot see a single `TypeError`.
- **Protocol recommendation: the `uncaughtExceptions` pseudo-path.** The wire grammar recognizes only `path`/`line`/`id`, so a mode *attribute* is silently discarded by both parsers, while a new path needs no parser change and degrades harmlessly. Unmodified xsbug is unaffected. The four-way ask is honestly three-way today (`none`/`uncaught`/`all`); `caughtExceptions` is one more string compare when someone wants it.
- **Cost when disarmed** stays a single dormant branch, at throw sites rather than `line` sites, so strictly cheaper than the stepping seam already accepted. Stated as a design argument, not a measurement, with the equal-computron property recommended as a required test.

## Follow-ups

1. Recover the debugger row onto PR 600 (blocks everything else).
2. Fix or gate `setExceptionBreakMode('uncaught')`, which is a live silent no-op.
3. Make Ironhorse's engine-raised errors unwind through the jump chain.
4. Three `BreakpointTable` parity nits: missing `line == 0 && id == 0` guard, un-ported `start` pseudo-breakpoint, and a doc reference to a `"unhandled"` pseudo-breakpoint that does not exist at this pin.

Not verified: xsbug GUI tolerance for an unknown `<break>` attribute or pseudo-path (the app is absent from the Moddable tree at this pin).

Self-improvement: a job brief can assert code state that has since left the branch; verifying the brief's named paths against the actual head before starting turned a dead end into the report's most load-bearing finding.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/xs2rust-endor-debugger-caught-vs-uncaught.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 145 tokens (9367255 cached reads)
- Output: 58311 tokens
- Cost: $7.9808875
- Wall-clock: 950s

<!-- garden-usage-end -->
