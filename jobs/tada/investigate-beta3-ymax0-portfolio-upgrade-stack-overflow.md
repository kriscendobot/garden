Investigation complete to the limit of the provided artifacts and this host's capabilities. Final report follows.

---

## Completion report — `investigate-beta3-ymax0-portfolio-upgrade-stack-overflow`

**Role:** gardener (endolinbot), fork-scope authorization (2026-06-27). **Method:** primary-source diff of the two contract bundles + `jq` analysis of the slog + GitHub-API regression-window confirmation. Deliverable is an evidence-backed **root-cause narrowing + decisive experiment plan**, not a verified fix (see boundary).

### What I did
- Pulled `beta2.js`/`beta3.js` from the gist (byte-exact to spec) and ran the string-literal diff (rename-normalized): 414 added / 395 removed literals, ~99% pure minifier churn.
- Walked **every recursive path** on the `startVat` rehydration route and compared SES-1.14 (beta2) vs SES-2.x (beta3).
- Parsed the 152-entry slog (`gistfile1.txt`) to fix the exact crash boundary.
- Confirmed the regression window via the GitHub API (no clone).
- Pulled the SES 2.0.0 changelog to check for a documented depth regression.

### Findings (root cause)
1. **Regression window CONFIRMED.** `compare/3952deecd4...9d518832d4` → `status: ahead, ahead_by:142, merge_base = 3952deecd4`. So `3952deecd4` ("sync Endo to latest including ses 2.x") is a true ancestor of beta3 and present on the fork. ✓
2. **It is a *metered* stack overflow, not a native segfault.** Slog: `startVat → error "Stack meter exceeded"` (the fixed `xs-meter-36` xsnap stack budget), surfaced as `exited: stack overflow`.
3. **Exact crash locus.** One `upgrade-vat` crank: `bringOutYourDead` ok (reports **76 durable kinds**), then `startVat` rehydrates durable kinds **10→17 linearly and cleanly**, and overflows specifically while rehydrating **dkind 17 `"offer handler taker"`’s singleton `o+d17/1`, immediately after `invoke kd513 getBundle`**. Kinds 10–16 rehydrated fine → per-kind `harden`/`passStyleOf` over guards is healthy.
4. **Two of the brief's three candidates RULED OUT by direct evidence:**
   - **#2 harden:** classic **iterative work-list** in *both* bundles (`a()` enqueues into set `n`; `d()=Z0(n,c)` drains BFS). Cannot overflow by recursion.
   - **#3 a new cycle:** `passStyleOf` has an explicit cycle guard (`Pass-by-copy data cannot be cyclic`) + persistent memo — a real cycle *throws a clear error*, it does not silently recurse to overflow. The overflow is **depth-driven**.
   - **#1 passStyleOf/patterns over guards:** right locus *family*, but the bump did **not** deepen it — the matcher registry is identical except the new **leaf** `match:promise` (no new combinators); the `passStyleOf` core, `copyRecord`/`byteArray` helpers, and async-flow membrane markers are all structurally preserved 1.14→2.x. SES 2.0.0's documented majors (NaN side-channel plug; `overrideTaming`) add no recursion depth.
5. **The proximate regressing recursion is NOT in the provided bundles.** beta2/beta3 are the *contract* vat bundle (contract + zoe/zcf + `@endo/{marshal,pass-style,patterns,exo,harden}`); they contain **zero** `Compartment`/module-linker/`import-bundle` code. The `"offer handler taker"` + `getBundle` signature is an **orchestration async-flow guest offer handler**: the deep work is the post-`getBundle` **bundle import → module link/evaluate → membrane re-wrap → harden**, which lives in the **supervisor/lockdown bundle that was not provided**. This cleanly explains why no recursion regression is visible in the contract-bundle diff.

**Revised mechanism:** a deep (bounded, not cyclic) recursion in the **SES-2.x bundle-import / module-link / membrane-rewrap path**, triggered when the async-flow `"offer handler taker"` durable singleton is rehydrated and its guest bundle is imported. The 2.x per-level frame cost (the `@harden` indirection wrapper, pass-style's two-call `confirmCanBeValid`+`assertRestValid`, marshal's `DataView` encode path) pushes that import/rewrap depth past the **fixed** xsnap stack meter — on XS only; V8's deep stack absorbs it, so it passed review.

**Premise correction surfaced to the maintainer:** the brief's "Established #3" (the Endo bump is the *only* runtime change between the bundles) is **not exact** — beta3 also carries the Auto-Features contract change (#12761; `OpenPortfolioWithAutoFeatures`, literal counts 21→26 / 18→21; durable-kind and interfaceGuard *counts* unchanged). A "pin Endo back" bisection alone therefore can't attribute the regression.

### What changed
Nothing in any repo. This is analysis only. **No fork clone/build/repro was run** — infeasible on the bot host (agoric-sdk is multi-GB; xsnap needs a native build; this sandbox blocks node bin-shims; the fork is not checked out here). Full 162-line writeup at `/tmp/ymax0-investig/ROOT-CAUSE.md` (ephemeral — its substance is reproduced above).

### Follow-ups (for the repro session where the toolchain lives)
1. **One missing artifact:** provide the **supervisor/lockdown bundle** (or the `ses` + `@endo/import-bundle` versions) alongside the contract bundle — the regressing recursion is in there, not in the two bundles given.
2. **Capture the frame:** build `kriscendobot/agoric-sdk@9d518832d4`, drive the v320 upgrade (incarnation 70→71) under swingset+xsnap, dump the XS stack at the meter trip — the repeating cycle will sit in the import/link/membrane path and names the exact function.
3. **Attribute it:** pin only the Endo deps back to beta2 versions with contract source unchanged; controls = same upgrade on Node/V8 (should pass) and beta2 deps on XS (should pass).
4. **Fix decision tree:** if Endo-attributed → reduce the offending helper's frames-per-level (convert hot recursion to a work-list, as `harden` already is) + upstream-Endo bug with minimal XS repro (deliverable, not an upstream push). Most practical fork-side fix: **defer/flatten the guest-bundle import out of the durable-kind rehydration call stack** so import depth doesn't stack on rehydration depth. Raising the xsnap stack meter remains last-resort mitigation.

No inbox messages arrived during the work.
