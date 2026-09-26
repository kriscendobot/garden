## Completion report — endo-npm-cas-registry-press-20260724-225004

**Outcome: pressed two increments — merged the stalled #821, then landed the next design gap (CJS named-export synthesis) as draft PR #854 with real-execution evidence and a gauntlet job posted.**

**Peer check.** Two older press ticks (105003, 165003) sit in `jobs/doin/` but their gardeners (18, 19) are back in claim loops — orphaned dead claims awaiting the reaper, not live workers. I was the sole live press-driver, so I pressed.

**Merged #821.** `fix(endor): carry the entry rejection message in the archive error value` had passed its gauntlet on 07-22 (un-drafted, all 22 CI checks green) and then sat unmerged for three days. Rebase-merged into `llm` (linear history) at 2026-07-25T03:05Z.

**Pressed the next unblocked gap — ESM named imports of CJS (PR endojs/endo-but-for-bots#854, DRAFT, base `llm`).** The design's Known gaps called `import { named } from 'cjsPkg'` binding only `default` "deliberate but significant, the dominant ESM-consumes-CJS pattern." Landed:

- **`rust/endo/src/cjs_lexer.rs` (new):** cjs-module-lexer-style static scanner over raw CJS text — `exports.name =`, `module.exports.name =`, `exports["name"] =`, `Object.defineProperty(exports, "name", …)`, and top-level `module.exports = { … }` literal keys — with comments, strings, templates, and regex literals skipped so quoted text never yields a name; reserved/invalid names and `default`/`__esModule` excluded.
- **`normalize_to_esm` (`execute.rs`):** the CJS facade now emits `export const <name> = …` per detected name beside the default export; no-name facades stay byte-identical to before.
- **Design doc:** gap bullet updated; the recorded remaining sub-gap is re-export chasing (`module.exports = require(…)` / `__exportStar`), unsynthesized by design this tick.

**Real-execution evidence.** `cargo test -p endo` 163/163 (14 new lexer tests + an XS end-to-end test importing `{ alpha, sum, phantom }` from a mock-registry CJS package, including a dead-branch phantom binding `undefined`); `cargo test -p xsnap` 120/120. Against the real registry: `endor run main.js` with `import semver, { satisfies, valid, clean, major } from 'semver'` fetched **semver@7.8.5**, CAS-ingested it (`28e493d4…`), and printed `named imports OK: valid=1.2.3 satisfies=true major=7` in XS; `endor run --offline main.js` replayed identically from the CAS with no network.

**Follow-ups.**
- Posted `gauntlet-endo-but-for-bots-pr854-cjs-named-exports` to the board (clean → panel → fix-loop → un-draft → rebase-merge), with a note that verification needs the Moddable submodule plus the gitignored xsnap bootstrap JS (the worker bundler is absent from the tree — a standing repo gap per `rust/endo/README.md`; I copied the bundles from a sibling scratch worktree).
- Next design sub-gaps after this: re-export name chasing, then `peerDependencies`/`optionalDependencies`, workspace protocol, private-registry auth.
- The two orphaned doin entries (105003, 165003) will be reaped and may re-run as duplicate press ticks; their assessors should find this report and complete as observations.
- Standing note unchanged: repo CI never compiles `rust/endo` (recorded in #821's body for a maintainer decision).
