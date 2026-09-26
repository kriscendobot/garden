The builder stage is complete. PR #657 is a draft with the correct base (`feat/mount-grep`, head of PR C), matching the stack. All verification passed:

- **New JSON tests** (`mount-json.test.js`): 8/8 passed (case table, round-trip, formatting, non-serializable throw, parent-dir creation, read-only, revocation).
- **Regression** (conformance + grep): 25/25 passed.
- **Prettier**: clean after auto-format.
- **tsc**: 0 errors in any changed file (the 23 repo-wide errors are pre-existing, in untouched packages, from the incomplete workspace install).
- **eslint**: 0 errors; the 21 warnings are all pre-existing on lines I didn't touch.

The sibling PRs A/B/C (#650/#653/#655) are all still draft, so leaving PR D as a draft and handing off matches the stack — the builder's stage ends here.

<<<GARDEN-JOB-COMPLETE>>>

Completion report:

## Build: mount JSON read/write — PR D of the #127 reconstruction

**PR opened:** endojs/endo-but-for-bots#657 (draft) — `feat/mount-json` based on `feat/mount-grep` (head of PR C, #655), matching the stacked-PR convention of the reconstruction.

**Package affected:** `@endo/daemon`.

### What I did
Implemented three methods on `EndoMount` in `packages/daemon/src/mount.js`, placed after `writeText` to mirror the text-I/O surface:
- `readJson(path)` — confined text read + `JSON.parse`; throws on missing file or invalid JSON (mirrors `readText`'s gate).
- `maybeReadJson(path)` — read failure → `undefined` (mirrors `maybeReadText`'s envelope), but the `JSON.parse` sits **outside** the read's catch so a present-but-invalid file still throws (review comment 3548857836).
- `writeJson(path, value)` — writable-gated, confined, creates parent dirs, writes `JSON.stringify(value, null, 2)` + trailing newline; throws when `JSON.stringify` yields `undefined`, with the guard before any directory creation so an invalid value leaves no filesystem trace.

Covered all three across the supporting surfaces: `interfaces.js` (interface shapes, `writeJson` value = `M.any()`), `types.d.ts`, `help-text-data.js`, `help.md`, and the `ENDOMOUNT_EXTENSIONS` conformance allowlist.

### Tests (load-bearing, executed)
- `test/mount-json-cases.json` — cross-language read parity table over the shared `mount-fixture-manifest.json` (readJson of `data.json`/`package.json`, nested fidelity, `maybeReadJson` missing→undefined, invalid-JSON-throws divergence). Consumable by the future Rust/XS runner.
- `test/mount-json.test.js` — Node runner: case table + writeJson/readJson round-trip, exact 2-space-indent+newline serialization, non-serializable throw (with proof nothing is written), parent-dir creation via path segments, read-only rejection, revocation.

Ran locally: `yarn ava test/mount-json.test.js` → 8 passed; `yarn ava test/mount-platform-fs-conformance.test.js test/mount-grep.test.js` → 25 passed. Prettier clean; tsc/eslint clean for all changed files (remaining errors/warnings are pre-existing in untouched files, artifacts of the incomplete workspace `yarn install`, in which `better-sqlite3`'s native build failed offline).

No dependency changes, so no separate `chore: Update yarn.lock` commit.

### Follow-ups
- Standard for this reconstruction: PR D remains draft, like siblings A/B/C. The panel/fix/un-draft gauntlet runs later over the stack (or via `run the gauntlet #657`); the builder does not run it.
- Named in the design (not this PR): wiring the second, Rust/XS-side runner that consumes the shared JSON case tables into the Rust workspace.
