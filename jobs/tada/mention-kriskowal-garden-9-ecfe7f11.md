All deliverables are complete. The 8.3.0-256k run was my own `pkill` (exit 143 at 73s, before reaching the ~262k overflow point) — no loss, since the reply frames the 262k-default claim as proportional and anchored on the *observed* 7.0.0-256k nested overflow (N=200000, confirmed).

## Completion report

**Job:** attention directive from @mhofman on kriskowal/garden#9 (comment 4907678857) — verify the XS flat/flatMap stack overflow using standalone `xst` (not the xsnap worker), with **release** builds before and after Moddable commit `73aad47b`, and if the "pop at the end of the block" is the more correct placement, produce a test case Moddable can run against the latest release.

**Preflight:** `pr-feedback-preflight.sh` exit 0 (proceed) — no peer had resolved it. Inbox empty throughout.

**What I did**
- Established the commit/release timeline: `73aad47b` (2026-01-20) is bracketed by release **7.0.0** (before, XS 16.9.1) and **7.1.0** (after, XS 17.9.1); **8.3.0** is latest and still carries only the leaf-branch pop. Confirmed ancestry via `gh api compare` and by source-diffing `fx_Array_prototype_flatAux`.
- Built release `xst` from source at 7.0.0 / 7.1.0 / 8.3.0, plus `stackCount=4096` variants (matching on-chain xsnap) and an 8.3.0+PR#1 (end-of-block pop) variant.
- **Ask 1 — reproduce/confirm the fix:** leaf-dominated (the `hex.js` shape that tripped ymax0) overflows on 7.0.0 and is clean on 7.1.0/8.3.0 → `73aad47b` fixes the #9 case. Same crossover on the stock 262144-slot release binaries at ~64× N (7.0.0 overflows at N=60000; 7.1.0 clean past 100000).
- **Ask 2 — is end-of-block more correct:** nested-heavy `.flat(1)` — 7.0.0 leaks ~2 slots/elem, `73aad47b` pops only the leaf (~1 slot/elem, threshold doubles but not eliminated), **8.3.0 latest still overflows**, and the end-of-block pop (kriscendobot/moddable#1) clears every N with correct results. So the end-of-block placement is strictly the more complete fix for `flatAux`.
- **Test case for Moddable:** `moddable-flat-overflow.js` — a self-contained nested-heavy `.flat()` that overflows on stock `xst` at `73aad47b..HEAD` and passes with the end-of-block pop.

**What changed**
- New reproduction harness committed to the garden library and pushed to `main2` (996411558): `skills/agoric-chain-snapshot/repro/xst-flat-release-ab/` with `build-xst.sh`, `build-pr1-variant.sh`, `flat-ab.sh`, `moddable-flat-overflow.js`, and a `README.md` carrying the full methodology and result tables. All scripts re-verified to reproduce the documented results from a clean tree.
- Posted the findings as a reply on issue #9 (comment 4907975897) and added a 🚀 reactji to mhofman's mention.

**Scope/safety:** read-only analysis of `Moddable-OpenSource/moddable` upstream plus on-host builds/runs of the open-source XS engine at release tags; no upstream `agoric/agoric-sdk` or `Moddable-OpenSource/moddable` interaction. Bot identity throughout.

**Follow-ups (maintainer's call):** if pursued upstream, the ideal engine change is `73aad47b` **with** its `flatAux` `mxPop()` moved to the end-of-block position (keeps the sort/`xsDelete` fixes in the same commit while also bounding nested-heavy `.flat()`); that's a candidate to fold into kriscendobot/moddable#1.
