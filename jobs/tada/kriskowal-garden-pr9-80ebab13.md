Completion report for job `kriskowal-garden-pr9-80ebab13`:

## What the directive asked
The "attention" directive on kriskowal/garden #9 (maintainer comment): *"Patch ses … replacing flatMap with an ordinary loop and verify that this addresses the problem … be sure to restore the stack size limit."* Routed it to the right work: ran the experiment as the next step in the active ymax0 v320 XS stack-overflow investigation, and reported the result back on the issue thread (the established channel for this thread; posted as kriscendobot, the identity that owns it).

## What I did
- Found the prior on-host reproduction **survived** this redeploy (`~/.cache/garden-scratch/exp6-*`, `/tmp/xs6`, the **stock-4096 prebuilt `xsnap-worker`**, the real `bundle-ymax0` base64).
- Reproduced the **control**: real production bundle on the stock 4096-slot worker → `STACK_OVERFLOW` (exit 12); beta2 from-source bundle → `OK` (harness sound).
- Located the decisive `flatMap` precisely (corrected a prior-round attribution that rested on a shaky minified-line decode — and caught that `grep -c flatMap` lies on a single-line bundle): it is the hex-codec table builder `new Map(RI.flatMap(...))` (256×4 = 1024 pair sub-arrays materialized as live operands), at offset 554699 inside `portfolio.contract.bundle.js`.
- Built a patched bundle by surgically rewriting that one zip entry — `flatMap` → ordinary `for` loop with `Map.set` — leaving every other entry byte-identical.
- Ran the patched bundle on the **stock 4096-slot** worker (stack limit restored, no taller recompile): **`OK`**, and it imports to the **full export set** (identical to V8), read back via an error sentinel — so it genuinely completes.

## Result
**Smoking gun confirmed.** Replacing the single hex `flatMap` with a loop clears the overflow at the default stack limit.

## Key refinement reported
The decisive `flatMap` is in **`@agoric/internal/src/hex.js`**, which **is bundled into the contract bundle** — *not* in `ses` proper. So contrary to "ses is not in the contract bundle, so this needs a chain software upgrade," this fix ships as a **contract re-bundle (contract upgrade), no chain software upgrade needed**. The taller-stack lever still needs a chain upgrade; the hex-loop lever does not.

## Caveats reported
Removes a ~1,024-ref frame (comfortably clears the thin ~128-slot beta3 deficit), but the structural ~2,000-closure flat-module-scope baseline is unchanged; a future scope-widening bump could re-trip it. Durable structural fix remains a bundler sub-module split.

## Follow-up offered
Offered (on the issue) to land the one-line `hex.js` loop change as a DRAFT commit on `kriscendobot/agoric-sdk` (bot fork, in scope) for durability — awaiting maintainer go-ahead. Durable reproduction artifacts kept in `/tmp/xs6` (`patched-real.b64`, `verify-patched.mjs`); throwaway decode scratch cleaned.

Posted: https://github.com/kriskowal/garden/issues/9#issuecomment-4824902542

Self-improvement: nothing this time (the `grep -c` vs `str.count()` on single-line bundles and the ses-vs-`@agoric/internal` distinction are investigation specifics, recorded in the issue thread, not role/skill-level changes).
