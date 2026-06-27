All findings are in hand and the inbox is empty. Here is my completion report.

---

# Completion report — `investigate-beta3-ymax0-xs-repro-and-fix`

## Headline
The XS toolchain **builds and runs on this host (endolinbot)** — "toolchain infeasible" is refuted. I named the overflowing recursive function, quantified the XS-vs-V8 env-dependence, and **empirically ruled out Endo** as the cause via a clean beta2/beta3 bisection. The regression is attributable to the contract side (#12761), but pinpointing the exact over-deep structure requires the chain's swing-store state, which is **not** in the provided artifacts (bundle + slog only). Details below.

## What I did
1. **Provisioned the fork.** Used the existing `/home/kris/agoric-sdk` clone, already at `9d518832d4` (tag `ymax-v0.3.2606-beta3`). Defensively re-pointed `origin` to `git@github.com:kriscendobot/agoric-sdk` and set the push URL to `DISABLED-NO-PUSH` (no upstream interaction occurred — no PRs/pushes/merges).
2. **Built the XS toolchain.** `corepack yarn@4.12.0 install`. Hit the documented host hazard (`permission denied: prebuild-install / node-gyp` — yarn's build-script subprocess gets EACCES on bin-shims even with the sandbox disabled). **Workaround:** bypass yarn's build runner and run the native builds directly — `node_modules/.bin/prebuild-install` for `better-sqlite3` (downloaded prebuilt `better_sqlite3.node`), and the prebuilt `xsnap-worker` for `packages/xsnap`. Result: **`xsnap-worker` XS v0.14.2 runs.** Also built `@agoric/xsnap-lockdown` (`node scripts/build-bundle.js`).
3. **Named the overflowing frame** (under V8 with the repo's actual Endo 2.x, raw untamed stack): all three rehydration entry paths bottom out in the **same cycle in `@endo/pass-style`**:
   `passStyleOfRecur` (`passStyleOf.js:138`) → `passStyleOfInternal` (`passStyleOf.js:193`) → `assertRestValid` (`copyRecord.js:67`) → recurse — **~3 non-tail frames per nesting level**. `marshal` unserialize and patterns `mustMatch`/`checkMatches` both reach the overflow through this `passStyleOf` descent.
4. **Quantified the env-dependence** by running depth probes inside a real `xsnap` worker (fresh worker per trial; **in XS a stack overflow is uncatchable and aborts the worker** — `"exited: stack overflow"` — exactly the production signature, and why the slog has *no error entry*, it just dies mid-rehydration):
   - **XS native budget ≈ 350 non-tail frames** (raw recursion and nested-record walk both 350; XS does proper tail-call elimination, so tail cycles don't count).
   - Derived XS limits: passStyleOf **≈115–127 levels**, marshal **≈110**, **mustMatch/checkMatches ≈15 levels** (checkMatches is ~23 frames/level).
   - V8 limits on this host: passStyleOf **2047**, marshal **1790**, mustMatch **511**. → XS is ~15–30× shallower.
5. **Attribution bisection (Endo) — ruled out.** Installed the **beta2** Endo set (from the parent of regression commit `3952deecd4`: `ses@1.15.0`, `@endo/pass-style@1.6.3`, `@endo/patterns@1.7.0`, `@endo/marshal@1.8.0`) and ran the identical V8 depth probe vs beta3 (`ses@2.2.0`, `pass-style@1.8.1`, `patterns@1.9.1`, `marshal@1.10.0`). **Results are identical:** passStyleOf 2047=2047, marshal 1790≈1791, mustMatch 511=511. The Endo/ses bump did **not** change frames-per-level for any rehydration path. (The 1.6.3→1.8.1 pass-style diff is a Checker→Rejector rename; the recursion shape is preserved.) **Endo per-level-frame increase (hypothesis "a") is empirically eliminated.**

## Deliverable findings
- **Overflowing function:** `passStyleOf`'s copyRecord/copyArray recursive descent (`passStyleOfRecur → passStyleOfInternal → assertRestValid`), reached via `marshal` unserialize and patterns `checkMatches` during v320 `startVat` durable-kind rehydration.
- **Attribution:** **NOT Endo** (bisection above). By elimination → the contract change (#12761 Auto-Features). The overflow is real on XS because XS's native stack (~350 frames) is ~30× shallower than V8's and the overflow aborts the vat uncatchably.
- **Open gap (honest):** the contract's *static* interface guards are shallow (~5–6 levels) and durable state is flat `mapStore`s (grow in width, not depth) — neither reaches XS's ~15/~116 limits. So pure structural depth does **not** by itself explain the crash; the real over-deep value must be **accumulated runtime durable data** (depth grown over 70 incarnations, plausibly stored under the `M.any()`/`recordOf` fields the contract carries), which **cannot be reproduced without the chain's swing-store snapshot for v320 @ incarnation 70**. The slog is a delivery log, not a state snapshot, and no swingset+XS portfolio-upgrade test exists in the tree to drive real rehydration synthetically.

## What's needed to close it (the one genuine blocker)
To capture the **real** overflowing structure and ship a targeted fix, one of:
- **(fastest)** a swing-store export (kvstore + heap snapshot) for **v320 at incarnation 70** — then I replay the upgrade under the built `xsnap` here and dump the real frame/depth; or
- **(multi-hour, no existing harness)** a synthetic swingset bootstrap test that builds up portfolio state, then null-upgrades v320 under XS.

Once the over-deep field is identified: the fix is to bound/flatten that accumulated durable structure in `packages/portfolio-contract` below ~15 levels (the mustMatch/XS limit); raising the XS stack is last-resort.

## Artifacts left on host (reusable; no commits, all untracked/scratch)
- Built fork + XS engine: `/home/kris/agoric-sdk` (xsnap-worker v0.14.2 at `packages/xsnap/xsnap-native/xsnap/build/bin/lin/release/`).
- Minimal XS/V8 repro probes: `/home/kris/agoric-sdk/scratch-xs-repro/{probe-v8,probe-raw}.mjs`, `/home/kris/agoric-sdk/packages/xsnap/scratch-xs-depth.mjs`, `/tmp/endo-beta2/probe.mjs` (beta2 bisection).

## Follow-ups
- Post a job (or ask the maintainer) for a **v320 swing-store export** — the missing artifact gating the real-data trace and the targeted fix.
- The minimal XS repro (nested-record `passStyleOf`/`checkMatches` overflow, uncatchable vat abort at ~15/~116 levels) is a clean basis for an upstream-Endo note **if** desired, but note this is an XS native-stack-depth property, not an Endo regression (frames/level unchanged) — so the actionable fix is contract-side depth-bounding, not Endo.
