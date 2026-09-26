Inbox empty. Work complete.

---

## Completion report

**Job:** `kriskowal-garden-pr9-47af0da6` — attention directive on kriskowal/garden#9: *"investigate whether simply recompiling XS with a taller stack limit would resolve the issue."*

**What I did:** Ran the actual experiment (nobody had — prior comments only listed an engine bump as a "last resort"). Using the on-host artifacts that survived the last redeploy (instrumented `xsnap-worker` build tree under `~/.cache/garden-scratch/exp6-ymax0`, the production ymax0 bundle `b.zip.b64`, and the fd-3/4 netstring driver in `/tmp/xs6`):

1. **Baseline** — confirmed the production ymax0 import overflows at exactly `4096/4096` value-stack slots on the stock worker.
2. **Recompiled** `xsnap-worker.c:365` `stackCount` 4096 → 65536, rebuilt, re-ran: import **completes cleanly to the full contract export set** (identical to V8), verified via a thrown-sentinel readback (not just "didn't crash").
3. **Bisected the threshold** across rebuilds: fails at 4096, passes at **4224** — the fresh import clears with only **+128 slots (≈3%)**.
4. **Measured cost:** `sizeof(txSlot)=32` bytes → 128 KiB/worker at 4096; a 4× bump adds ~384 KiB/worker.

**Answer delivered (issue comment 4824474963):** Yes, mechanically — a taller `stackCount` resolves the import overflow. But it's the emergency lever, not the fix, for three reasons surfaced in the reply: (a) the default misses by a hair, and the *real* incarnation-70→71 upgrade adds depth on top of the fresh import, so generous (4–8×) headroom is needed; (b) `stackCount` is a **consensus parameter** — a coordinated chain upgrade, which is the true reason it's a last resort; (c) it treats the symptom, leaving the root cause (the ~2,588-slot `flatMap` module-link frame) intact. Recommended keeping the layer-correct bundler/`hex.js` fix as primary, with the engine bump as the coordinated-upgrade fallback.

**State:** Restored the scratch source to the upstream default (4096). Saved both `worker-4096-instrumented` and `worker-65536-instrumented` under `/tmp/xs6`. Issue left **OPEN** for the submitter to close (per issue-inbox skill). No agoric-sdk push/PR/merge — read-only analysis plus on-host build of open-source XS.

**Follow-up offered (not yet acted):** fold the `stackCount` lever + consensus caveat into the durable bot-fork methodology doc (kriscendobot/agoric-sdk#6) so it survives a redeploy; offered in the reply, pending maintainer go-ahead.

**Self-improvement:** nothing this time — the "run the experiment, don't just reason about it" pattern and the issue-inbox reply discipline both already held.
