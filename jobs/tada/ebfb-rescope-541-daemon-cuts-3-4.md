All work is complete and verified. Final state: PR #541 is DRAFT, base `build/sturdyrefs-pass-style-ocapn`, head at the pushed rebase tip `42b9f46e5`, retitled to the re-scope.

---

## Completion report

**Job:** Re-scope PR #541 (`endojs/endo-but-for-bots`) to daemon cuts 3–4 of the settled *enlivened-on-demand* design, rebased onto shape-only #521, endor-syscall retention stripped. PR kept **DRAFT**.

### Rebase
Rebased `build/sturdyrefs-endor-syscall-retention` from old base `0ad8d1b02` onto the realigned `build/sturdyrefs-pass-style-ocapn` @ `d3c68897b`. Force-pushed with `--force-with-lease` (remote tip was unchanged at `da44ba385`). **5 commits → 2.**

- **Dropped** `0e7047909` (formula-graph retention edges + `test/retention-edges.test.js`) and `903f8ec27` (retain/release control-verb doc). Confirmed no residue in `graph.js` or `designs/` (the daemon's pre-existing agent→formula retention line is on the base, unrelated).
- **Folded** the tsconfig regen (`da44ba385`) into cut 4.

### Cut 3 — read-side guards (`interfaces.js`)
Kept the widened guards (`lookup`/`maybeLookup`/`list`/`identify`/`locate`/`listIdentifiers`/`listLocators`/evaluate slots). Resolved the `M.sturdyRef()` question deliberately: it's a deferred `@endo/patterns` follow-up (blocked on the `@endo/marshal` rank-order), so the guard uses the **structural recognizer `M.kind('sturdyref')`** — which already admits the realigned pass-style category and rejects every other passable, so no `@endo/patterns` change and **no `M.any()` widening**. Documented the substitution in code; updated the design reference to `sturdy-refs-ocapn-enlivenment.md`.

### Cut 4 — closely-held resolution (`sturdyref-resolution.js` + host/guest/directory facets)
Rewrote the resolution module for the realigned API. The old cut 4 imported a now-removed `getStudyRefLocator` and read an off-band string from pass-style; the realigned pass-style makes `location` a **readable accessor** and holds no locator map. So the daemon now holds its **own module-private off-band binding** (`sturdyRefToId` WeakMap) — `mintSturdyRef` binds a SturdyRef to a local formula id; `resolveSturdyRefToId` reads that closely-held binding — mirroring `@endo/ocapn`'s `sturdyRefDetails`. On demand, no enlivenment cache, no retention. Existing pet-name-path callers unaffected (purely additive). A SturdyRef minted by an OCapN peer rejects cleanly (the OCapN↔daemon `internalizeLocator` bridge is a tracked follow-up).

### Confinement statement (binding invariants preserved by each artifact)
- **no-identification / no-secret** — the formula id (the daemon-side secret analog of a swiss number) lives only in the module-private WeakMap; the SturdyRef carries **no own properties**, exposing only a readable trusted-tier `location` and optional `type`. Nothing a facet returns/throws yields the id.
- **no-location leak into a confined guest** — the location-bearing SturdyRef is the trusted tier; the guest-scoped **opaque token** representation is an open question in #539 and was deliberately **not invented** here.
- **opaque-and-unforgeable** — resolution is keyed on **minted identity**, not structure, so a forged structurally-valid look-alike has no binding and is rejected; the resolution capability is module-private and never handed to a guest. No artifact widens sturdyref reach while leaking identity or location.

### Verification (observed)
- `corepack yarn install` (had to seed the prebuilt `better-sqlite3` binary — sandbox blocks native builds).
- `packages/daemon` `tsc -p tsconfig.json` → **exit 0**.
- eslint on all changed files → **0 errors** (only pre-existing `any`/`safe-await` warnings).
- `test/sturdyref-resolution.test.js` → **10/10 passing** (recognition, resolution, and the confinement invariants).
- Daemon **boots cleanly** with the changes (`START OK`, gateway ready).
- The heavy `endo.test.js` integration suite fails uniformly at **pre-boot unix-socket creation** (`fork` + `endo.sock` bind) for every test — an environmental sandbox limitation, proven not a logic regression (standalone boot succeeds; a guard/facet regression would fail assertions after boot, not prevent socket creation). Documented in the PR body.

### PR housekeeping
Retitled to `feat(daemon): SturdyRef read-side threading at the facet boundary (design #539, cuts 3–4)`, rewrote the body for the re-scope (linking design sections + deferred follow-ups), posted a summary comment, kept **DRAFT**.

### Follow-ups
- `M.sturdyRef()` in `@endo/patterns` (blocked on `@endo/marshal` rank-order).
- OCapN-peer SturdyRef → daemon `internalizeLocator` bridge (remote enliven) + the sturdyref wire codec (boxing/unboxing) for end-to-end client→CapTP→facet coverage.
- Notified `endo-sturdyref-press-20260711-190501`; its instance had cycled, so the message was dead-lettered and will be promoted to a fresh job (intent preserved).
