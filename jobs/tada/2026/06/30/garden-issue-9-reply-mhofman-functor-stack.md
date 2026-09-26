Done. Comment posted as kriscendobot (bot identity), inbox empty.

---

## Completion report

**Job:** Answer mhofman's esbuild-functor / XS value-stack question on garden issue #9.

**What I did:** Read the full #9 thread to ground mhofman's framing (the "value-stack width, not depth" root cause; the esbuild megafunctor; the `hex.js` `flatMap` smoking gun; the instrumented overflow trace showing frame #1 = module functor with ~1986 CLOSURE slots and frame #0 = the `flatMap` callback with ~1232 REFERENCE slots). Rather than assert the answer, I **demonstrated** it on the stock prebuilt `xsnap 0.14.2` worker (`stackCount = 4096`, the on-chain default), reusing the existing fd-3/4 netstring driver under `/tmp/xs6`.

**Repro built:** a value-stack *width* probe (a call with K arguments = K operands piled into one activation, tripping the same hard exit-12 overflow as the real `flatMap`). Measuring the largest surviving K ≈ free slots at three bases, with a 1500-lexical functor standing in for the ~2000-slot bundle baseline:
- CONTROL (top level) = 3907; DURING (inside functor, baseline resident) = 2399; **AFTER-return top level = 3907** (stack fully reclaimed); closure invoked post-return scales **exactly 1 slot per captured outer binding** (M=0→3899 ≈ full, M=1500→2399).

**Answer delivered (both parts):**
1. The functor's stack space is **not permanently lost** — it's the functor's own activation frame, resident only during the synchronous bundle eval, popped on return (proven by the AFTER-return row regaining the full budget).
2. A closure created during eval but invoked later runs from a **shallow base** (the import-time baseline is gone), so it has essentially the full stack — minus a per-call floor of ~1 slot per binding it itself captures. Grounded in the XS source (`xsRun.c`: scope/closure slots are value-stack slots reserved per `NEW_CLOSURE`, popped on `END`, re-linked per-capture on call) and cross-checked against the real trace's frame #0/#1 CLOSURE/REFERENCE split. Tied back to width-not-depth and to why the bundler (sub-module functors) is the structural lever.

**Deliverable:** top-level comment on kriskowal/garden#9 (`#issuecomment-4847516265`), bot identity, comment-only.

**Changes to repo:** none committed to `main2`. Following the thread's established pattern, the probe lives embedded in the comment (durable record) rather than as a new file; the harness/worker copy lived in the volatile worktree `.xsprobe/` and is torn down with the worktree.

**Scope:** read-only analysis plus on-host runs of the open-source XS worker; bot forks only; no upstream `agoric/agoric-sdk` interaction.

**Follow-ups:** none required. The queued real-chain inquisitor verification (Polkachu snapshot) remains in flight from earlier jobs and is unaffected by this answer.
