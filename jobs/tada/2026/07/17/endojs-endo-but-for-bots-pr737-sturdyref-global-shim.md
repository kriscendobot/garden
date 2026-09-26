The job was substantially completed by a prior (reaped) run; I verified, corrected, and finalized it.

## Completion report

**Job:** builder — implement the maintainer's SturdyRef shim on PR #737 (endojs/endo-but-for-bots), addressing review 4718500574.

**State on arrival:** A prior reaped run had already implemented and pushed the full change (head `b56b34653` on `build/sturdyref-pass-style-ocapn-single`), replied to all three review threads, and posted the top-level summary. Two things were unfinished/wrong: the review was never re-requested, and every reply + the summary referenced a **dead SHA** `d4f4e86b40` (a pre-rebase commit that does not exist in the pushed branch — the CAS push landed it as `b56b34653`).

**What I did:**
- **Verified the implementation locally** (installed the monorepo, ran under the lockdown SES config):
  - pass-style: 16/16 tests pass (incl. the required regression coverage — `passStyleOf` throws for a forged candidate with extra own properties and for an invalid prototype).
  - ocapn: 125/125 tests pass (sturdyref + client + passable).
  - `tsc` clean (exit 0) on both packages; `eslint` 0 errors (only pre-existing project-wide `jsdoc/reject-any-type` warnings).
- **Confirmed all relevant CI is green** on `b56b34653`: `test`/`cover` on 22.x+24.x ubuntu and 24.x macos, `lint`, `test-xs`, `test-ocapn-*`. The lone red check, `test (22.x, macos-15)`, is an unrelated runner infra flake (missing `node24` binary; failing package is `@endo/chat`, untouched by this PR).
- **Corrected the dead SHA** `d4f4e86b40` → `b56b34653` in all three review-thread replies and the top-level summary comment (they now link to the real addressing commit).
- **Re-requested review** from `kriskowal` now that relevant CI is green.

**Confirmed the required outcomes are all met by the pushed tree:** construction/recognition moved into `@endo/pass-style/sturdy-ref` (opaque `makeSturdyRef`, `SturdyRefHelper` shape validation); first-wins realm-global hardened `SturdyRef` shim (`installSturdyRefShim`, post-lockdown, no SES permit, non-configurable, never endowed to child compartments) retaining a global `WeakMap<SturdyRef, object-locator>` with object (not URL/URN) locators; OCapN tracker mints via `SturdyRef.fromLocation`/reveals via `toLocation`; each CapTP enlivener stays closely held; codec unchanged; package `exports` expose both subpaths.

**Follow-ups (maintainer decision, already surfaced in the summary):** the summary asks `kriskowal` to arbitrate placement — the shim embedded in `@endo/pass-style` (this PR) vs. the standalone `@endo/sturdyref` package in draft #774. No further work is pending on my side.
