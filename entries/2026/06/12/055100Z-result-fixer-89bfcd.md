---
ts: 2026-06-12T05:51:00Z
kind: result
role: fixer
host: endolinbot
project: agoric-sdk
repo: kriscendobot/agoric-sdk
dispatch_root: /home/kris/dispatches/fixer--89bfcd
short_id: 89bfcd
to: liaison
refs:
  - entries/2026/06/12/052500Z-dispatch-fixer-89bfcd.md
  - entries/2026/06/12/052101Z-result-fixer-d74faf.md
  - entries/2026/06/10/041600Z-result-fixer-c39b42.md
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4687595219
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: mirror
    state: DRAFT
next: liaison
---

# result: fixer PR kriscendobot/agoric-sdk#5 (89bfcd)

## TL;DR

Bumped `@endo/*` and `ses` to the freshly published npm releases per the maintainer's directive `4687595219`. Workspace ranges bumped via `yarn up ses '@endo/*' -R; yarn dedupe` per `MAINTAINERS.md`. Patch refresh: pass-style 1.7.0 patch dropped (substance absorbed in 1.8.1); compartment-mapper 2.0.0 patch refreshed to 2.3.0 (new `link-pattern` site added); bundle-source 4.2.0 patch kept (4.3.2 has been restructured, patch substance not absorbed). Option α (keep B) selected: ava `^7.0.0` workspaces, matches upstream master, validated by ses-ava 1.4.2's widened peer-range. **Known breakage**: the newer Endo type signatures surface 36 latent type incompatibilities across 9 workspaces; these are scope-shaped like a dedicated follow-up PR (not a fixer round). Force-with-lease pushed; comment posted on PR.

Pre-push lease anchor: `bd397628bca25d84cb8a9dcbb97dd1ddbb6d4c7b`
Post-push head: `be7c0ec4ff`

## Bumps applied

| Package | Before (workspace range) | After |
|---|---|---|
| `@endo/pass-style` | `^1.7.0` | `^1.8.1` |
| `@endo/marshal` | `^1.9.0` | `^1.10.0` |
| `@endo/compartment-mapper` | `^2.0.0` | `^2.3.0` |
| `@endo/ses-ava` | `^1.4.0` | `^1.4.2` |
| `ses` (in `packages/{cosmic-swingset, xsnap}`) | `^1.14.0` | `^2.0.0` |

47 workspace `package.json` files updated; root `package.json` resolutions and `.yarnrc.yml` catalogs.dev added.

### `.yarnrc.yml` catalogs.dev added

The newly published `@endo/{check-bundle, common, errors, lockdown, promise-kit, zip}` packages declare `devDependencies` using `catalog:dev` references. Without a `catalogs.dev` block in `.yarnrc.yml`, `yarn install` fails with `YN0082: catalog "dev" not found or empty` during transitive resolution. This was diagnosed by the prior fixer round (`entries/2026/06/10/041600Z-result-fixer-c39b42.md` § Catalog "dev" gate diagnosis). The catalog values mirror the agoric-sdk-side dev tool versions already declared in root `devDependencies` (ava `^7.0.0`, c8 `^10.1.3`, eslint `^9.39.4`, `@fast-check/ava` `^3.0.1`, etc.).

## Patch refresh

- **DROP** `.yarn/patches/@endo-pass-style-npm-1.7.0-7dc50195b4.patch`: the `PASS_STYLE` `Symbol(passStyle)` string-cast workaround (for `typescript@5.9.3` TS9006 declaration-emit on consumers) is incorporated verbatim in `@endo/pass-style@1.8.1`. Verified by tarball inspection: `src/passStyle-helpers.{js,d.ts}` and `src/types.d.ts` contain the cast and the JSDoc rationale exactly as the patch added.
- **REFRESH** `@endo-compartment-mapper-npm-2.0.0-4a851a2702.patch` -> `@endo-compartment-mapper-npm-2.3.0-29c504f4c7.patch`: the `__createdBy` property elision from `translateCompartmentMap` (3 sites in `src/digest.js`), `chooseModuleDescriptor` (1 site in `src/import-hook.js`), and `makeModuleMapHook` (1 site in `src/link.js`) is still applicable in 2.3.0. Plus a new `__createdBy: 'link-pattern'` site at `src/link.js:243` that the refreshed patch also strips. Refreshed via `corepack yarn patch '@endo/compartment-mapper@npm:2.3.0'` then sed-script removal of all `__createdBy:` lines, then `yarn patch-commit`. The patch-commit operation also added 2 redundant resolutions entries (^2.1.0 / ^2.3.0) that I removed manually so the single catch-all `^2.0.0` entry covers the range.
- **KEEP** `@endo-bundle-source-npm-4.2.0-2a20f61a7d.patch` unchanged: this Agoric-specific patch adds `AGORIC_MAX_BYTE_LIMIT` enforcement (CometBFT 1MB POST limit) and an esbuild-based fallback bundling path when the simple bundle would exceed the limit. Its substance is **not** absorbed in `@endo/bundle-source@4.3.2` (which was substantially restructured: `cache.js` no longer has esbuild plumbing, `esbuild` was removed from package deps, and `src/bundle-source.js` was split across multiple files). The resolutions block continues to pin `@endo/bundle-source` at `4.2.0+patch`, matching the upstream PR `Agoric/agoric-sdk#12527`'s conservative choice (which the prior fixer `c39b42` had also identified as the correct path; see § Per-package patch-set decision in that result). Forward-porting this patch to 4.3.2 is its own follow-up dispatch.

## Option α vs β decision

**Selected: Option α (keep B; workspace ava remains `^7.0.0`).**

Rationale:

- `@endo/ses-ava@1.4.2`'s peer-range is widened to `^6 || ^7 || ^8`, which obviates the prior 1.4.0 vs ava `^7` conflict that motivated B's original restoration. The new ses-ava is compatible with both ava 6 and ava 7.
- Workspace ava `^7.0.0` matches `upstream/master` for every `packages/*/package.json`. Verified: `git diff upstream/master..HEAD -- 'packages/*/package.json' | grep -E '^[+-].*"ava":'` is empty.
- Option β (rolling back to ava `^6.4.1`) would re-introduce divergence from upstream master that the prior round's interactive rebase of `218350dda7` -> `ed29496b2f` removed. It would also leave the branch in a state weaker than upstream w.r.t. ava version.
- The test-result-discrimination the dispatch brief named ("based on test results") doesn't favor β: with ses-ava 1.4.2 supporting both ava 6 and 7, the install / resolution test passes equivalently for both. Upstream-faithfulness is the residual tiebreaker, and α wins.

## Known breakage surfaced for maintainer review (NOT addressed in this dispatch)

The newer `@endo/*` type signatures (Passable, exoClass overloads, `Guarded<...>` shape constraints) surface **36 latent type incompatibilities** in agoric-sdk source across 9 workspaces (async-flow, ERTP, SwingSet, governance, internal, network, orchestration, vats, zone):

| Category | Count | Loci |
|---|---|---|
| TS2502 variable referenced in own type annotation | 4 | `async-flow/{bijection,log-store}.js` |
| TS2456 type alias circular self-reference | 2 | `async-flow/{bijection,log-store}.js` |
| TS2345 / TS2322 Passable -> specific subtype mismatch | ~20 | `governance/{binaryVoteCounter,question}.js`, `internal/{lib-chainStorage,storage-test-utils,callback}.js`, `network/router.js`, `vats/{bridge,vat-bank,core/chain-behaviors}.js` |
| TS2769 exoClass overload mismatch from stricter guards | ~6 | `governance/binaryVoteCounter.js`, `internal/callback.js`, `async-flow/{async-flow,endowments}.js`, `network/router.js`, `vats/{bridge,vat-bank}.js` |
| TS2556 spread argument shape | 2 | `zone/durable.js` |
| TS2352 assertion shape mismatch | 2 | `SwingSet/initializeKernel.js`, `orchestration/exo-helpers.js` |
| TS2322 Amount<K,Key> vs Amount | 1 | `ERTP/paymentLedger.js` |

These are the same shape as the prior `35c18254e4 fix(types): adapt to @endo/bundle-source load() returning unknown` commit, but substantially larger scope (36 errors / 9 packages vs that commit's 3 / 3). Each fix requires investigation of the local code and a targeted cast or explicit type annotation; the scope reads as a **dedicated follow-up PR** rather than a fixer round on this mirror.

The prior fixer round (`entries/2026/06/10/041600Z-result-fixer-c39b42.md` § Bump deferral) flagged this exact concern when it chose to defer the bump.

## Local verification

- `corepack yarn install --immutable` (after the bump): **PASS** (with the same YN0086 peer-dependency warnings that upstream master also produces; non-blocking).
- `corepack yarn dedupe`: **PASS**.
- `corepack yarn build`: **FAIL at client-utils with the 36 type errors** documented above. Cosmic-proto codegen succeeded, supervisor / lockdown bundles emitted, xsnap binaries cached; the failure is purely the lint-types phase.
- `corepack yarn lint:packages`: **FAIL** in 20+ workspaces (same 36 errors propagated by `tsc --build` through workspace references).
- `garden/skills/pre-push-gates/pre-push-gates.sh`: probes pass (filename-no-stutter, no-ascii-banners, no-inline-import-jsdoc, no-non-ascii-in-source, no-pull-citations, security-md-hash-uniform, sentence-per-line-md, test-package-no-main); `lint:packages` is the known surfaced breakage.

## Push and comment

- Pre-push head: `bd397628bca25d84cb8a9dcbb97dd1ddbb6d4c7b` (lease anchor).
- Post-push head: `be7c0ec4ff`.
- Push: `git push --force-with-lease=mirror/12527-endo-sync-refresh:bd397628bca25d84cb8a9dcbb97dd1ddbb6d4c7b origin HEAD:mirror/12527-endo-sync-refresh` -> `bd397628bc..be7c0ec4ff  HEAD -> mirror/12527-endo-sync-refresh`. Lease anchor matched remote tip at push time; no concurrent writer raced.
- Two commits on top of prior tip:
  - `03f8c5bc37 chore(deps): bump @endo/* and ses to latest npm`
  - `be7c0ec4ff chore: Update yarn.lock`
- Comment posted on PR #5 (top-level summary citing both pre/post SHAs, the patch-refresh decisions, the Option α call, the known breakage with category breakdown, and the recommended next-step options): https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4687882843

## Recommended next stage

`next: liaison`. The maintainer's directive is satisfied as to the literal scope ("bump @endo/* and ses to latest"); the type-error wave is now visible on CI for the maintainer's evaluation. Two paths forward:

1. **Dedicated type-fix follow-up PR**: a builder dispatch under a new branch addresses the 36 type errors with targeted casts and explicit annotations. Bounded scope (~10 source files), cross-cutting nature is what makes it its own PR rather than a fixer round here. This is the path that honors the maintainer's full directive (bump succeeds, CI green follows).

2. **Narrow the bump scope**: if the type-fix scope is undesirable, the cleanest narrowing is to revert `@endo/{pass-style, marshal, compartment-mapper}` to their prior versions and keep only `@endo/ses-ava` (`1.4.0 -> 1.4.2`) and `ses` (`1.14 -> 2.x`) bumped. This satisfies the directive's literal phrasing ("sort out the ses-ava range constraints") with minimum collateral. A small fixer or weaver dispatch can land the narrowing.

The PR comment surfaces both paths to the maintainer (`#issuecomment-4687882843`); the liaison receiving this report can route either when the maintainer answers.

Self-improvement: when a maintainer's directive ("bump @endo/* and ses to latest") cleanly satisfies its surface intent but cascades into a substantial latent-issue surface (36 type errors / 9 packages), the fixer's two viable outputs are (a) push the bump and explicitly surface the cascade for the maintainer to choose between fixing or narrowing, and (b) refuse to push and message back asking. I chose (a) because the dispatch brief explicitly named "Force-with-lease push only" — implying the push is part of the expected output — and because the cascade is concretely characterizable enough that the maintainer can decide without further investigation. Below threshold for a new skill (the existing skip-with-reason norm in `roles/fixer/AGENT.md` already covers the scope-creep case generally); noting here for future readers as one instance of "the bump succeeds but the wider type surface needs a separate PR" pattern.
