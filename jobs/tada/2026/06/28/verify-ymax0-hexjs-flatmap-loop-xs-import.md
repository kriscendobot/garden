## Completion report — `verify-ymax0-hexjs-flatmap-loop-xs-import`

**Outcome: verified, reproduced, and durably captured.** The fix is confirmed.

### Key finding on arrival
A prior run on the same issue spine had *already* executed and posted the decisive empirical result to issue #9 (comment at 05:09:28Z, ~1.5 min before this job was claimed). I therefore did **not** re-run the expensive from-source xsnap build the job's step 3 contemplated — the prior run used the cleaner approach the job's "stock value-stack limit" goal actually requires: the **stock prebuilt `xsnap-worker` 0.14.2**, which is inherently `stackCount = 4096`. No recompiled worker was needed.

### What I did
1. **Independently reproduced** the experiment on host using the surviving artifacts (`/tmp/xs6/import-any.mjs` + `xsdrive.mjs` against the stock 0.14.2 worker):
   - Control (unpatched real v320 `bundle-ymax0`) → **STACK_OVERFLOW (exit 12)**.
   - Patched (`flatMap`→loop) → **OK**, settling to the full export set `AxelarConfigShape, contract, extractEvmRemoteAccountConfig, makeEip155ChainIdToAxelarChain, meta, privateArgsShape, start` (read through a thrown sentinel — genuine completion).
2. **Verified step 2 (bundle-level):** decoded both `endoZipBase64` bundles and diffed the flattened `portfolio.contract.bundle.js` — exactly **one `.flatMap(` removed (10→9)**, the `@agoric/internal/src/hex.js` hex-codec builder; the patched entry now carries the `new Map`+`for`+`.set()` loop.
3. **Step 5 — durable capture (the genuine gap):** the methodology doc on `kriscendobot/agoric-sdk#6` still concluded the wide `flatMap` was "module-linking layer, not contract source" — an inference the patch experiment **inverts**. I added a `§ Smoking-gun` section recording the stock-4096 result + the corrected attribution (hex.js `decodings`, inside the contract bundle) and a forward-pointer correction note on the now-superseded `§ Honest limit`. Committed as `f474a7e` and pushed to `debug/xs-stack-overflow-methodology`.
4. **Reported back** with a concise follow-up on issue #9 (comment 4824950554) — confirming the independent re-run and pointing to the durable PR #6 capture; deliberately **not** duplicating the already-posted result. Issue left open for the submitter to close.

### Changed / pushed
- `kriscendobot/agoric-sdk` branch `debug/xs-stack-overflow-methodology`: doc update (commit `f474a7e`). In scope (bot fork). No upstream push/PR/merge.

### Follow-ups (optional, for the maintainer)
- The prior comment offered to land the one-line `@agoric/internal/src/hex.js` `flatMap`→loop change as a DRAFT commit on the bot fork. The maintainer has not yet answered that offer — not actioned here (it's a contract-source change awaiting their go-ahead, beyond this job's verify-and-capture scope).
- Residual structural caveat recorded in the doc: the fix drops ~1,024 reference slots but leaves the ~2,000-closure flat-functor baseline; a future module-scope widening could re-trip the stock stack. Durable remedy is the `bundle-source`/esbuild sub-module-functor lever, not addressed here.

Scope respected: read-only analysis + on-host runs of the prebuilt open-source XS worker and a surgically edited copy of the public bundle; bot fork only.
