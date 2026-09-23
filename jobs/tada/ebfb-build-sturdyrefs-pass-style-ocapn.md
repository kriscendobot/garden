Worktree torn down. The build is complete. Here is my completion report.

---

## Completion report: `ebfb-build-sturdyrefs-pass-style-ocapn`

**Outcome:** Opened DRAFT PR **endojs/endo-but-for-bots#521** (`build/sturdyrefs-pass-style-ocapn` → base `llm-65b0abe`), implementing the pass-style + ocapn slice of the sturdy-refs design (#511). All work pushed; worktree torn down.

### What I built

**`@endo/pass-style`** (new first-class `'sturdyref'` category)
- New `src/sturdyref.js`: `SturdyRefHelper`, `makeSturdyRef(locator)`, `getStudyRefLocator(sturdyRef)` (typo spelling kept verbatim per the design). A SturdyRef is an opaque, hardened, payload-less tagged record; its locator lives in a module-private `WeakMap` **moved here from ocapn's `sturdyRefDetails`**, so the secret can't leak through pass-style introspection.
- `passStyleOf` returns `'sturdyref'` only for records minted by `makeSturdyRef`, and **rejects** a forged `'sturdyref'`-tagged record (absent from the off-band map). Wired the helper into the helper table; added `'sturdyref'` to the `PassStyle` union, a `SturdyRef` type, and a `passStyleOf` overload.
- New `test/sturdyref.test.js` (8 tests).

**`@endo/ocapn`**
- `ocapnPassStyleOf` now defers to `passStyleOf` for the sturdyref discriminator (dropped the `isSturdyRef` branch).
- `enlivenSturdyRef` reads via `getStudyRefLocator`, with an optional per-client `sturdyRefToEnlivened` cache kept **in ocapn, not eventual-send**. `makeSturdyRefTracker` mints via pass-style; `getSturdyRefDetails` reads through. **`OcapnSturdyRefCodec` unchanged.** Updated the api-surface snapshot and the existing sturdyref test to the new first-class behavior.

**`@endo/marshal`**
- Typed `passStylePrefixes` as not-yet-covering `'sturdyref'` (its encoding/rank-order is a deferred slice). This was a required type-level ripple from extending the `PassStyle` union.

### Design correction honored
SturdyRefs are inert opaque data boxes — **no** `E(sturdyRef)` dispatch, **no** `HandledPromise.registerSturdyRefHandler`, `@endo/eventual-send` untouched.

### Validation (all green)
pass-style full suite + 8 new; ocapn 534; marshal 82; captp 24; patterns 623; goblin-chat sturdyref interop. `tsc` clean (pass-style, marshal, ocapn, patterns); `eslint` 0 errors; `prettier` clean.

### Follow-ups
- **Gamut:** PR #521 is DRAFT, ready for the cleaner → judge → fixer → un-draft chain (the open-PR triager should pick it up; no gamut job posted manually).
- **Deferred slices:** marshal sturdyref encoding/slot, daemon ingest (`resolveToId`), and FinalizationRegistry worker retention remain out of scope per the job.
- **Design doc:** left `#511`'s status unchanged ("remains open for further review" per the job); #521 cross-references it.
- **Tooling friction:** `skills/dispatch-worktree/dispatch-prepare.sh` references the `journal` branch but the host only has `journal2` (v2), so it errored; I fell back to a plain project worktree. Worth reconciling as the v1→v2 migration proceeds.
