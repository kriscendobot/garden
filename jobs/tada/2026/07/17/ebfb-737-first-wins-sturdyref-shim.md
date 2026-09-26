Done. PR #774 is a draft against `llm`, my inbox is empty, and #737's branch was not touched.

## Completion report

**Built `@endo/sturdyref`** — a first-wins SturdyRef shim + ponyfill — and opened **DRAFT PR endojs/endo-but-for-bots#774** against base `llm` (branch `build/sturdyref-shim-first-wins`), prepended to the SturdyRef stack. #737's branch was left untouched, as instructed.

**What the package does**
- Installs one realm-shared namespace at `globalThis.SturdyRef` with `fromLocation(locator)` / `toLocation(sturdyRef)`, backed by a globally-retained `WeakMap` from an opaque passable sturdyref to its **locator record (an object, never a string)**.
- **First-wins:** each copy races to install; only the first takes (non-configurable/non-writable); later importers adopt it. The ponyfill imports the shim and defers to the global, so eval twins of ocapn/captp converge on one mapping.
- Packaged like `@endo/immutable-arraybuffer`/`@endo/harden`: `index.js` = ponyfill, `shim.js` = eager after-lockdown entry, `src/sturdyref-shim.js` = the first-wins selector, `src/sturdyref-pony.js` = the ponyfill surface.
- Hardened by `@endo/harden`; installation is **lazy** so hardening lands after `lockdown`. Global has **no SES permit** → withheld from child compartments by construction. Sturdyrefs are opaque `Far` remotables (minimal/forward coupling to the `@endo/pass-style/sturdy-ref` residence #737 owns).

**Confinement properties, each pinned by a test**
- No location → `passStyleOf(sr) === 'remotable'`, no own key leaks the locator (`no location: sturdyref is passStyleOf-opaque and leaks no locator`).
- No identification → same locator mints distinct sturdyrefs.
- Withheld from child compartments → `new Compartment().evaluate('typeof SturdyRef') === 'undefined'`.
- First-wins convergence → two selections share one map (+ control: an un-installed namespace has its own map); pre-existing global adopted; malformed pre-existing global rejected.
- Hardened + functioning after lockdown.

**Validation (local, in the project worktree; PATH-shimmed `ava`/`eslint`/`tsc` per the endo bin-shim notes)**
- `tsc` (lint:types): clean
- `eslint .`: clean — 0 errors, 0 warnings
- `ava`: **8 passed**
- `node scripts/generate-composite-tsconfigs.mjs --check`: composite tsconfigs up to date (regenerated root + package composite after adding the workspace dep)
- Changeset `add-endo-sturdyref-shim.md` added; yarn.lock churn isolated in its own `chore: Update yarn.lock` commit.

**Follow-ups / coordination**
- #737's review-response line adds `@endo/pass-style/sturdy-ref`; when it lands, `makeSturdyRef` in this shim can be swapped from the `Far` placeholder to the real `'sturdyref'` pass-style. Kept forward-compatible.
- #737 is expected to rebase onto this branch; PR left DRAFT (no gauntlet, no restack), per the job.
