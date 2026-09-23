---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-26T11:44:33Z
---
# SturdyRef press tick — typedoc TS2339 fixed at cut 4; #702–#704 restacked (endo-sturdyref-press-20260726-112002)

Post-restack CI from the 05:05 tick came back: #698/#700/#701 fully green, #702/#703/#704 red on `lint`, #704 additionally red on `test (24.x, ubuntu-latest)`.

- **lint root cause (deterministic, fixed):** the `build API docs` step (typedoc) failed with `TS2339: Property 'SturdyRef' does not exist on type 'typeof globalThis'` at `packages/sturdyref/src/sturdyref-shim.js:146`. Same shim blob is lint-green below cut 4; cut 4's daemon imports of `@endo/ocapn/{cryptography,syrup}` pull the shim source into per-package typedoc programs that lack the ambient `shim.types.d.ts`. Fixed on `build/sturdyref-bridge-4-ocapn-singleton` (fast-forward append 9cda67148 → **137673219**): read `globalThis.SturdyRef` through an explicit cast, no runtime change. Reproduced and re-verified locally: `typedoc` went from `Found 2 errors`/exit 3 to **`Found 0 errors`/exit 0**; eslint + prettier clean; `@endo/sturdyref` ses-ava **8/8**.
- **Restack:** #703 5eef14afa → **bb3906aad**, #704 c51aca470 → **e32b01f2a**, both `--onto` conflict-free, pushed `--force-with-lease`, all DRAFT. Stack line: #774 → #737 → #541 → #698 → #700 → #701 → #702 → #703 → #704, zero skew.
- **#704 Node-24 test failure:** ava global timeout in `@endo/marshal` — rankOrder property tests at 6–9 s each on a slow runner; all completed tests passed and #703's Node-24 job (same marshal tree) was green. Treating as runner-speed flake; if the fresh run reproduces it, next tick should trim the sturdyref arbitraries' cost or raise the package timeout.
- **Local real-execution on new #704 head:** daemon `ava --serial test/three-party-roundtrip.test.js test/ocapn.test.js` → **14 passed**, incl. armed cross-peer enliven over tcp-test-only.
- **Confinement:** unchanged and re-exercised — no-location (sturdyref passStyleOf-opaque, leaks no locator), no-identification (same locator mints distinct sturdyrefs), withheld (child compartment does not see the SturdyRef global); the fix is typing-only.

**Next tick:** check CI on 137673219 / bb3906aad / e32b01f2a. Once green, bar 1 (OCapN sturdyref support) is CI-complete end to end; the frontier is bar 2 — the agent provide/accept surface (design #695, Lal/Fae/Genie + @endo/agent-tools) — best posted as a builder sub-job. Evidence comments: #702 issuecomment-5083321159, #703 issuecomment-5083321790, #704 issuecomment-5083321836.
