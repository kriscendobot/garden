The job is complete. Summary report follows.

---

## Weaver report: rebase PR #700 (bridge cut 2) onto the restacked #698

**Result:** #700's branch `build/sturdyref-bridge-2-ocapn-promotions` rebased onto the moved #698 head and force-pushed with lease. New head `0a2d989961`. PR stays **DRAFT**; base unchanged (`build/sturdyref-bridge-1-bytes-wire-read`, #698 — a clean ancestor). Predecessor #698's restack was confirmed landed first.

**What I did**
- Verified live state: #700 OPEN/DRAFT, #698 MERGEABLE and restacked. Identified the old-merge-base as `948aec29ac` (the old bridge-1 tip #700's own commits sat on) via a range-diff against the restacked `d57221c43b`.
- `git rebase --onto origin/build/sturdyref-bridge-1-bytes-wire-read 948aec29ac build/sturdyref-bridge-2-ocapn-promotions` — carried **only** #700's four own commits (feat, yarn.lock, import-harden fix, prettier). Commits 2–4 applied cleanly; commit 1 conflicted.
- **Conflict resolution toward the arbitrated shapes.** #698 had already absorbed the closely-held-reveal machinery via the `@endo/sturdyref` shim, so cut 2's original (old local-details-map) design collided. Re-expressed #700's contribution on the shim:
  - `sturdyrefs.js` — `makeSturdyRef` mints via `fromLocation(harden({location,secret,type}))` + records in the per-tracker `ownRefs` WeakSet; `reveal` reads via `getSturdyRefLocator` (→ `toLocation`), scoped to own refs. Dropped `makeSturdyRefInstance`/module-level `sturdyRefDetails`.
  - `types.js`, `client/index.js` — `reveal` returns `SturdyRefLocator | undefined` (was the removed `SturdyRefDetails`); fixed the auto-merge's orphan references.
  - `passable.test.js` — codec assertion uses `getSturdyRefLocator`; kept the wire-materialized `reveal` identity check.
  - `api-surface` snapshot (`.md`+`.snap`) — **regenerated** from the real surface: `reveal → [SturdyRef, SturdyRefLocator]`, `SturdyRefLocator` type block, reachable types 10.
- Posted the required top-level summary comment on #700 (job authorized "comment the new head").

**Tests (real execution, `ava` under the endo lockdown config)**
- `sturdyref-uri.test.js` + `sturdyref.test.js` — **17 passed**, including the confinement surface: closely-held reveal absent from the SturdyRef surface / no toString URI leak; SturdyRef opaque (no location/secret property); off-band locator reachable only through the closely-held mapping; foreign-instance mints reveal `undefined`.
- `codecs/passable.test.js` — sturdyRef URI codec + closely-held reveal round-trips green.
- Full `@endo/ocapn` suite — **546 passed**.
- `@endo/goblin-chat` (URI delegation) — **4 passed** (incl. the remote-resolvable sturdyref URI + JS-interop exchange).
- `tsc` clean for all #700-touched files; `prettier --check` clean; `eslint` 0 errors.

**Follow-ups / notes**
- An isolated `tsc` in `packages/ocapn` reports one error in `packages/sturdyref/src/sturdyref-shim.js` (`globalThis.SturdyRef`). It is **not** from #700 (which never touches `packages/sturdyref`) — an isolated-invocation artifact: the shim's `shim.types.d.ts` global augmentation isn't pulled into a bare per-package `tsc` run, but the monorepo project-reference build resolves it. Inherited from the base #698, unchanged by this rebase.
- Env note for peers: the pnpm-linker install didn't materialize `node_modules/.bin`, so `yarn`/`ses-ava` bin spawns fail "permission denied"; ran suites via `node <ava>/entrypoints/cli.js` directly (with the lockdown config for ocapn, and goblin-chat's own config since it self-locks-down).
