# beta3 ymax0 stack-overflow: build the fork on this host and run the XS repro (continuation)

Map: **build/investigate** on OUR FORK `kriscendobot/agoric-sdk` ONLY. No upstream
interaction (no PRs/pushes/merges to Agoric/agoric-sdk). Maintainer reaffirmed
2026-06-27: **use kriscendobot's fork; there is no scope hesitation — investigate
empirically on the fork, including checking it out and building it ON THIS BOT HOST.**

This continues `investigate-beta3-ymax0-portfolio-upgrade-stack-overflow` (analysis
complete, in jobs/tada). DO NOT redo the bundle diff or regression-window work — it's
done and summarized below. Your job is the **decisive experiment the analysis could
not run**: build the fork's XS toolchain here, capture the overflowing frame, attribute
it, and land a fork-side fix.

## Carried-forward findings (verified by the prior gardener — do not repeat)
- Regression window CONFIRMED via GitHub API: `3952deecd4` ("sync Endo to latest incl
  ses 2.x") is a true ancestor of beta3 `9d518832d4` on the fork (ahead_by 142,
  merge_base = 3952deecd4).
- Bundle string-literal diff (beta2.js vs beta3.js, gist): ~99% minifier-rename churn.
- **Candidate #2 (harden recursion): RULED OUT** — `harden` is an iterative work-list
  (BFS drain) in BOTH bundles; cannot overflow the native stack by recursion.
- **Candidate #3 (a new SES-2.x cycle): RULED OUT for pass-by-copy** — `passStyleOf`
  keeps its explicit cycle guard and THROWS `Pass-by-copy data cannot be cyclic`; it
  does not silently recurse. (A non-copy/remotable cycle no guard walks isn't excluded.)
- **Candidate #1 (passStyleOf/patterns over interface guards): right LOCUS, but the
  Endo bump did NOT deepen any recursive shape** (passStyleOf core, the 27→28 pattern
  kinds — the only add is the LEAF `match:promise` — and copyRecord/byteArray helpers
  are all structurally preserved 1.14→2.x).
- **PREMISE CORRECTION:** beta3 is NOT "Endo-only" vs beta2 — it also carries the
  `OpenPortfolioWithAutoFeatures` contract change (#12761; Auto-Features literals 21→26,
  OpenPortfolio 18→21; durable-kind count 12 and interfaceGuard count 13 unchanged, so
  guard CONTENTS moved, not new kinds). So a "pin Endo back" bisection ALONE cannot
  attribute the regression — the contract guards/data also changed.
- **Leading mechanism:** depth-driven native-stack exhaustion in `passStyleOf` /
  patterns `checkMatches` (or marshal `unserialize`) while rehydrating the portfolio
  contract's interface guards + durable data at v320 `startVat` (last syscalls
  `vom.dkind.15/16/17` → `getBundle`). Overflows XS's shallow native stack, not V8's —
  the env-dependence the brief notes. Likely the Auto-Features guard/data depth (b),
  possibly plus an Endo per-level frame increase (a).

## Artifacts (maintainer's gist)
- beta2.js: https://gist.githubusercontent.com/kriskowal/dac81e95eeecb4ad024e6278f8bed212/raw/ef847278f5a87bb62a7cf50cc77e7fa3878858a4/beta2.js
- beta3.js: https://gist.githubusercontent.com/kriskowal/dac81e95eeecb4ad024e6278f8bed212/raw/79a341122452f138ce9e06cfe0b1110db099a344/beta3.js
- slog (152-entry swingset crash log): https://gist.githubusercontent.com/kriskowal/dac81e95eeecb4ad024e6278f8bed212/raw/73cbba56249536e52b2818913694acdf516478f7/gistfile1.txt

## Do this (empirical; report concrete obstacles, do NOT declare infeasible a priori)
1. **Provision the fork here.** Clone `git@github.com:kriscendobot/agoric-sdk` into a
   worktree/scratch dir on this host and check out `9d518832d4` (tag
   `ymax-v0.3.2606-beta3`); confirm the commit is present (it is, per the prior
   GitHub-API check). Branch off it for any fix.
2. **Build the XS toolchain.** `yarn install` + the agoric build, including
   `packages/xsnap` (native moddable/XS build) and `packages/swingset`. KNOWN HOST
   HAZARD (see memory env_sandbox_blocks_bin_shims_use_node_directly): the sandbox can
   block node-gyp/prebuild bin-shims with "permission denied", and xsnap is a native
   build. Mitigations available on this host: **passwordless sudo**
   (passwordless_sudo_systemd_debug) and the ability to run a Bash step with the
   sandbox disabled. Try the build; if a step fails, capture the EXACT command + error
   and work around it (run the real binary under `node <store-path>`, sudo, or a
   sandbox-disabled step) — only report "toolchain infeasible on this host" with the
   specific failing command + error if you genuinely cannot get xsnap to build after
   trying these.
3. **Step 1 experiment — name the frame.** Drive the v320 portfolio-vat upgrade
   (incarnation 70→71) under swingset+xsnap with an XS stack dump on overflow. The
   repeating frame cycle names the exact recursive function — the one fact the minified
   bundles cannot give. Use the slog (gistfile1.txt) to align the failing delivery.
4. **Step 2 — attribute (clean bisection).** From the same fork commit, pin ONLY the
   Endo deps (`ses`, `@endo/pass-style`, `@endo/patterns`, `@endo/marshal`, `@endo/exo`)
   back to beta2's versions with the CONTRACT SOURCE UNCHANGED, re-run:
   still overflows → **contract/Auto-Features depth**; stops → **Endo** (step-1 trace
   names the helper).
5. **Step 3 — controls.** Same upgrade on Node/V8 should pass (deep stack); beta2 deps
   on XS should pass.
6. **Fix on the fork** per the decision tree: contract-attributed → flatten the
   portfolio interface-guard/durable-schema nesting in `packages/portfolio-contract`
   (collapse nested `M.splitRecord`/`M.and`/`M.arrayOf` chains; shorten the deepest
   durable key/record path) below XS's limit. Endo-attributed → reduce the named
   helper's frames-per-level (convert the hot recursive walk to an explicit work-list,
   as harden already is) and write an upstream-Endo bug report with a minimal XS repro
   (DELIVERABLE, not an upstream push). Raising the XS stack limit is last-resort
   mitigation only. Re-verify: the upgrade repro now passes + the portfolio test suite.

## Deliverable
The exact overflowing recursive function (from the XS trace), the attribution
(contract depth vs Endo frames, from the bisection), and a verified fork-side fix (or
an upstream-Endo bug report + minimal repro) with the XS upgrade repro confirmed green.
If the toolchain truly cannot build here, the deliverable is the specific failing
build command + error so the maintainer can decide on a provisioned fork-CI host.

---
claim:
  host: endolinbot
  gardener: 62
  claimed_at: 2026-06-27T16:28:20Z
