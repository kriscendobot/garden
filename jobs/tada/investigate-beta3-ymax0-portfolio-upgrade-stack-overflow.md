Root-cause writeup delivered to the maintainer (`inbox/maintainer 20260627T160307Z-0bd3f9`).

---

## Completion report

**Job:** `investigate-beta3-ymax0-portfolio-upgrade-stack-overflow` (resumed after reaper requeue). The spec was re-scoped by the liaison to authorized **fork** work on `kriscendobot/agoric-sdk` with bundles supplied via gist — resolving my prior session's scope decline. I continued and completed an evidence-backed investigation.

**What I did**
- Pulled both contract bundles from the gist; verified byte-exact to spec (beta2 1,129,924 B/35,131 ln; beta3 1,139,323 B/35,447 ln).
- Ran the string-literal diff (rename-normalized) and walked every recursive path on the `startVat` durable-exo rehydration route in both bundles.
- Confirmed the regression window via GitHub API (no clone): `3952deecd4` is a true ancestor of beta3 `9d518832d4` (`ahead_by:142, behind_by:0, merge_base=3952deecd4`).
- Wrote a full root-cause analysis (`ROOT-CAUSE.md`) and delivered it to the maintainer.

**Findings (primary-source, from the bundles)**
- **harden — RULED OUT** (brief candidate #2): iterative work-list in *both* bundles; SES 2.x only adds the `@harden` symbol wrapper. Cannot overflow by recursion.
- **True new cycle — RULED OUT** (brief candidate #3) for pass-by-copy data: `passStyleOf` has explicit cycle detection (throws `Pass-by-copy data cannot be cyclic`) + persistent memo — a cycle errors, it doesn't overflow. So the overflow is **depth-driven**.
- **passStyleOf / patterns** (brief candidate #1): correct *locus*, but the Endo bump did **not** deepen it — the dispatcher, memo, cycle guard, copyRecord/byteArray helpers and the entire matcher-combinator registry are structurally identical 1.14→2.x. The only patterns addition is the **leaf** `match:promise` (no sub-pattern recursion).
- **Premise correction (most actionable):** beta3 is **not** a pure Endo-bump over beta2 — it also carries the `OpenPortfolioWithAutoFeatures` contract change (#12761; Auto-Features 21→26, OpenPortfolio 18→21). So "the Endo bump is the only runtime change" is false for this pair, and a pin-Endo-back bisection alone cannot attribute the regression.
- Likely mechanism: native-stack exhaustion in passStyleOf/`checkMatches`/marshal-unserialize over the contract's interface guards/durable data at `startVat`, depth already near XS's shallow-stack margin and pushed over by the Auto-Features guard/data depth and/or a sub-minification per-level frame change — overflowing XS but not V8.

**What changed:** no code on the fork (no verified fix to push). Deliverable is the analysis. Scratch artifacts in `/tmp/ymax0-investig/` (bundles, literal diffs, `ROOT-CAUSE.md`); no commits to any shared tree.

**Honest boundary / follow-ups**
- Naming the single exact recursive frame and shipping a verified fix both require the XS stack trace from a live repro (build fork@`9d518832d4`, drive the v320 upgrade under `swingset`+`xsnap`). That toolchain/checkout is **not available on the bot host**, so I could not run it.
- Handoff to a repro session (maintainer's machine or fork CI) with a precise plan: (1) capture the XS stack dump → names the function; (2) clean bisection pinning **only** Endo deps back with the contract unchanged → attributes Endo vs Auto-Features; (3) Node/V8 + beta2-deps controls. Fix decision tree included (flatten contract guard/durable nesting if contract-attributed; reduce frames-per-level + upstream-Endo bug report if Endo-attributed; raise XS stack limit only as last resort).

Sources: [Agoric/agoric-sdk#2224 (xsnap security properties)](https://github.com/Agoric/agoric-sdk/issues/2224), [endojs/endo ses package](https://github.com/endojs/endo/tree/master/packages/ses).
